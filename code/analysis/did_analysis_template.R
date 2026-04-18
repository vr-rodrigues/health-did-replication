# ============================================================================
# did_analysis_template.R
# Deterministic DiD reanalysis — driven entirely by metadata.json
# DO NOT MODIFY THIS SCRIPT PER ARTICLE — only metadata.json changes.
# ============================================================================
# Usage: Rscript did_analysis_template.R [id]
# Example: Rscript did_analysis_template.R 6
# ============================================================================

suppressPackageStartupMessages({
  library(jsonlite)
  library(haven)
  library(dplyr)
  library(fixest)
  library(did)
  library(did2s)
  library(bacondecomp)
  library(ggplot2)
  library(tidyr)
})

# Deterministic seed: did::aggte() and did::att_gt() use multiplier bootstrap.
# Without a fixed seed, SEs (and occasionally point estimates via influence-function
# reweighting) vary across runs. Set here so every article produces bit-identical
# results for bootstrap-dependent quantities.
set.seed(42)

# ─────────────────────────────────────────────────────────────────────────────
# 0. LOAD METADATA
# ─────────────────────────────────────────────────────────────────────────────
args <- commandArgs(trailingOnly = TRUE)
if (length(args) == 0) stop("Usage: Rscript did_analysis_template.R [id]")
id <- args[1]

# Run from replication package root. Paths are resolved relative to getwd().
base_dir <- getwd()
meta_path <- file.path(base_dir, "results", "by_article", id, "metadata.json")
if (!file.exists(meta_path)) stop("metadata.json not found: ", meta_path)
meta <- fromJSON(meta_path)

cat("==========================================================\n")
cat("=== DiD Reanalysis:", meta$author_label, "===\n")
cat("==========================================================\n\n")

out_dir <- file.path(base_dir, "results", "by_article", id)
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# Skip articles that require custom preprocessing beyond what the template supports
# (e.g. multi-file Stata pipelines, complex week→quarter aggregation). These keep
# their pre-computed results.csv bundled with the package.
if (isTRUE(meta$analysis$legacy_analysis)) {
  .reason <- if (is.null(meta$analysis$legacy_reason))
    "(see metadata notes)" else meta$analysis$legacy_reason
  cat("[LEGACY] This article requires custom preprocessing outside the template.\n")
  cat("         Keeping bundled results.csv.\n")
  cat("         Reason: ", .reason, "\n", sep = "")
  quit(status = 0)
}

# ─────────────────────────────────────────────────────────────────────────────
# 1. LOAD DATA
# ─────────────────────────────────────────────────────────────────────────────
cat("[1] Loading data:", meta$data$file, "\n")
df_raw <- tryCatch(
  read_dta(meta$data$file),
  error = function(e) {
    tryCatch(read.csv(meta$data$file),
             error = function(e2) stop("Cannot load data: ", meta$data$file))
  }
)
cat("    Rows loaded:", nrow(df_raw), "\n")
df <- df_raw
rm(df_raw)

# Time recode for non-contiguous years (e.g. Clemens 2015: 1988→1, ..., 1997→6).
# Guard against JSON empty object ({}) which parses to a zero-length named list;
# without this, match() would return all NA and silently destroy the time column.
if (!is.null(meta$preprocessing$time_recode) && length(meta$preprocessing$time_recode) > 0) {
  recode_list <- meta$preprocessing$time_recode
  old_vals    <- as.numeric(names(recode_list))
  new_vals    <- as.numeric(unlist(recode_list))
  tvar        <- meta$variables$time
  df[[tvar]]  <- new_vals[match(df[[tvar]], old_vals)]
  cat("    Time recoded:", paste(old_vals, "→", new_vals, collapse = ", "), "\n")
}

# Construct variables — runs BEFORE sample_filter so filter can reference constructed vars
if (!is.null(meta$preprocessing$construct_vars) && length(meta$preprocessing$construct_vars) > 0) {
  cat("    Constructing variables...\n")
  for (expr in meta$preprocessing$construct_vars) {
    tryCatch(
      eval(parse(text = expr)),
      error = function(e) cat("    [construct error]:", conditionMessage(e), "| expr:", substr(expr,1,80), "\n")
    )
  }
  cat("    Vars constructed:", length(meta$preprocessing$construct_vars), "expressions\n")
}

# Snapshot the fully-constructed data BEFORE applying the TWFE sample filter.
# This is the starting point for an optional CS-specific pipeline (see below)
# when the paper requires a different sample for TWFE vs CS-DID (Pattern 49).
df_full <- df

# Apply sample filter (after construct_vars — can reference constructed variables).
# This filter is used for TWFE / SA / Gardner (the "displayed" paper estimand).
if (!is.null(meta$data$sample_filter) && nchar(trimws(meta$data$sample_filter)) > 0) {
  df <- df %>% filter(!!rlang::parse_expr(meta$data$sample_filter))
  cat("    After filter:", nrow(df), "rows\n")
}

# ─────────────────────────────────────────────────────────────────────────────
# 2. VARIABLE SETUP
# ─────────────────────────────────────────────────────────────────────────────
cat("\n[2] Setting up variables\n")

yname    <- meta$variables$outcome
idname   <- meta$variables$unit_id
tname    <- meta$variables$time
cname    <- meta$variables$cluster
# Optional separate cluster for CS estimator (e.g. FIPS when TWFE clusters at stfips)
# Use "none" to disable clustering entirely (multiplier bootstrap without cluster resampling)
cs_cname <- if (!is.null(meta$variables$cs_cluster) &&
               nchar(trimws(as.character(meta$variables$cs_cluster))) > 0)
              meta$variables$cs_cluster else cname
if (identical(cs_cname, "none")) cs_cname <- NULL
# weight can be: NULL, "null"/"" (string sentinels), empty JSON object {} → list(),
# or a valid column name (character of length >= 1). Any non-character value is treated as NULL.
.w <- meta$variables$weight
wname <- if (is.null(.w) || (is.list(.w) && length(.w) == 0) ||
             !is.character(.w) || length(.w) == 0 ||
             identical(as.character(.w), "null") ||
             identical(as.character(.w), ""))
          NULL else as.character(.w)[1]
treat    <- meta$variables$treatment_twfe
gcsname  <- meta$variables$gvar_cs
tw_ctrls <- meta$variables$twfe_controls     # character vector, may be empty
cs_ctrls <- meta$variables$cs_controls       # character vector, may be empty
add_fes  <- meta$variables$additional_fes    # character vector, may be empty
if (is.null(tw_ctrls)) tw_ctrls <- character(0)
if (is.null(cs_ctrls)) cs_ctrls <- character(0)
if (is.null(add_fes))  add_fes  <- character(0)

# Optional event-study-specific controls (overrides twfe_controls for ES only)
# Use case: Bhalotra (ID 97) has treatment-interaction vars in twfe_controls that
# must NOT appear in the event study formula (cause collinearity with event dummies).
tw_es_ctrls <- { tmp <- meta$variables$twfe_es_controls; if (!is.null(tmp)) tmp else tw_ctrls }
if (is.null(tw_es_ctrls)) tw_es_ctrls <- character(0)

# Optional event-study-specific clustering (overrides cname for TWFE ES only)
# Use case: disease-level DiD where diseaseyear cluster maps 1:1 with event dummies → VCOV degeneracy
es_cname <- if (!is.null(meta$variables$es_cluster) &&
               nchar(trimws(as.character(meta$variables$es_cluster))) > 0)
              meta$variables$es_cluster else cname

is_staggered <- meta$panel_setup$treatment_timing == "staggered"
is_panel     <- meta$panel_setup$data_structure == "panel"
run_nt       <- if (!is.null(meta$analysis$run_csdid_nt)) isTRUE(meta$analysis$run_csdid_nt) else TRUE
run_nyt      <- isTRUE(meta$analysis$run_csdid_nyt)
run_bacon    <- isTRUE(meta$analysis$run_bacon)
run_sa       <- if (!is.null(meta$analysis$run_sa)) isTRUE(meta$analysis$run_sa) else TRUE
run_gardner  <- if (!is.null(meta$analysis$run_gardner)) isTRUE(meta$analysis$run_gardner) else TRUE
allow_unbal  <- if (!is.null(meta$panel_setup$allow_unbalanced)) isTRUE(meta$panel_setup$allow_unbalanced) else TRUE
# CS-specific overrides (Pattern 49) — fall back to the corresponding default
# field when not set. These let the template reproduce the custom per-article
# fixes that used to live in standalone scripts (fix_201.R, fix_234_241.R,
# fix_dynamic_outliers.R, update_419_744_balanced.R, etc.).
cs_allow_unbal <- if (!is.null(meta$panel_setup$cs_allow_unbalanced))
                    isTRUE(meta$panel_setup$cs_allow_unbalanced) else allow_unbal
# Pattern 49: some articles transform the data (e.g. yearly collapse of a
# repeated-cross-section) such that the CS pipeline should treat the result as
# a panel even if the paper's primary TWFE sample is RCS. This override only
# affects the CS section; TWFE / SA / Gardner still see the paper's design.
cs_is_panel <- if (!is.null(meta$panel_setup$cs_data_structure))
                 meta$panel_setup$cs_data_structure == "panel" else is_panel
cs_max_e <- { v <- meta$analysis$cs_max_e
              if (is.null(v) || length(v) == 0 || !is.numeric(v) && !suppressWarnings(!is.na(as.integer(v)))) NULL
              else as.integer(v)[1] }
cs_min_e <- { v <- meta$analysis$cs_min_e
              if (is.null(v) || length(v) == 0 || !is.numeric(v) && !suppressWarnings(!is.na(as.integer(v)))) NULL
              else as.integer(v)[1] }
gardner_ctrls <- meta$analysis$gardner_controls  # optional: override controls for Gardner first stage
sa_ref_p     <- meta$analysis$sa_ref_p   # optional: vector of reference periods for sunab
has_es       <- isTRUE(meta$analysis$has_event_study)
ev_pre       <- if (has_es) as.integer(meta$analysis$event_pre)  else NA_integer_
ev_post      <- if (has_es) as.integer(meta$analysis$event_post) else NA_integer_

cat("    Outcome:", yname, "| Treatment:", treat, "| Unit:", idname, "| Time:", tname, "\n")
cat("    Staggered:", is_staggered, "| Panel:", is_panel, "| Event study:", has_es, "\n")
if (!is.null(wname)) cat("    Weight:", wname, "\n")
if (length(tw_ctrls) > 0) cat("    TWFE controls:", paste(tw_ctrls, collapse=", "), "\n")

# Numeric coercion for key panel variables
df <- df %>%
  mutate(
    across(all_of(c(idname, tname, gcsname)), as.numeric)
  )

# ─────────────────────────────────────────────────────────────────────────────
# 3. TWFE
# ─────────────────────────────────────────────────────────────────────────────
cat("\n[3] TWFE\n")

# twfe_fe_override: when set, replaces standard unit_id + time FEs for TWFE PE only
# Use case: paper uses non-standard FE (e.g. statepost instead of unit+year)
twfe_fe_override <- meta$variables$twfe_fe_override
if (!is.null(twfe_fe_override) && nchar(trimws(twfe_fe_override)) > 0) {
  fe_str <- twfe_fe_override
  cat("    FE override:", fe_str, "\n")
} else {
  fe_vars <- unique(c(idname, tname, add_fes))
  fe_str  <- paste(fe_vars, collapse = " + ")
}
rhs_vars <- c(treat, tw_ctrls)
rhs_str  <- paste(rhs_vars, collapse = " + ")
fml_twfe <- as.formula(paste0(yname, " ~ ", rhs_str, " | ", fe_str))

fit_twfe_args <- list(
  fml     = fml_twfe,
  data    = df,
  cluster = as.formula(paste0("~", cname))
)
if (!is.null(wname)) fit_twfe_args$weights <- as.formula(paste0("~", wname))

fit_twfe <- tryCatch(
  do.call(feols, fit_twfe_args),
  error = function(e) stop("TWFE failed: ", conditionMessage(e))
)

# Composite TWFE: β = β₁ + 2×β₂ (e.g. Bhalotra 2021: treated_post + 2*treated_post_year).
# Guard against JSON {} which parses to list() in R (length 0, not NULL).
comp_type <- meta$preprocessing$composite_twfe
comp_vars <- meta$preprocessing$composite_vars
if (!is.character(comp_type) || length(comp_type) == 0) comp_type <- NULL
if (is.list(comp_vars) && length(comp_vars) == 0) comp_vars <- NULL

if (!is.null(comp_type) && comp_type == "additive_2" && !is.null(comp_vars)) {
  v1 <- comp_vars[1]; v2 <- comp_vars[2]
  beta_twfe <- coef(fit_twfe)[v1] + 2 * coef(fit_twfe)[v2]
  se_twfe   <- se(fit_twfe)[v1]   + 2 * se(fit_twfe)[v2]
  cat("    Composite TWFE (β₁ + 2β₂):", v1, "+", v2, "\n")
} else {
  beta_twfe <- coef(fit_twfe)[treat]
  se_twfe   <- se(fit_twfe)[treat]
}
cat("    β_TWFE =", round(beta_twfe, 5), "| SE =", round(se_twfe, 5),
    "| t =", round(beta_twfe / se_twfe, 2), "\n")

# ─────────────────────────────────────────────────────────────────────────────
# 4. Helper: run att_gt with automatic retry
# ─────────────────────────────────────────────────────────────────────────────
run_att_gt <- function(df_cs, the_id, the_panel, control_group) {
  args_cs <- list(
    yname               = yname,
    tname               = tname,
    idname              = the_id,
    gname               = gcsname,
    xformla             = if (length(cs_ctrls) > 0)
                            as.formula(paste0("~", paste(cs_ctrls, collapse=" + ")))
                          else ~1,
    weightsname         = if (!is.null(wname)) wname else NULL,
    clustervars         = cs_cname,   # may differ from TWFE cluster (see cs_cluster metadata field)
    control_group       = control_group,
    panel               = the_panel,
    allow_unbalanced_panel = cs_allow_unbal,  # Pattern 49: may override the TWFE allow_unbal
    # Pattern 26: ALWAYS use base_period="universal". No exceptions.
    base_period         = "universal",
    data                = as.data.frame(df_cs)
  )
  tryCatch(
    do.call(att_gt, args_cs),
    error = function(e1) {
      cat("    Retrying with faster_mode=FALSE:", conditionMessage(e1), "\n")
      args_cs$faster_mode <- FALSE
      tryCatch(
        do.call(att_gt, args_cs),
        error = function(e2) {
          cat("    att_gt failed:", conditionMessage(e2), "\n")
          NULL
        }
      )
    }
  )
}

# ─────────────────────────────────────────────────────────────────────────────
# 5. CSDID — Never-Treated
# ─────────────────────────────────────────────────────────────────────────────
att_nt <- NA_real_; se_nt <- NA_real_
cs_nt  <- NULL; df_cs <- NULL; the_id <- NULL

if (run_nt) {
  cat("\n[4] CSDID — Never-Treated\n")

  # --- Pattern 49: if the metadata asks for a different CS sample (e.g. Brodeur's
  # balanced no-aroundms sample, or Maclean's yearly-collapsed panel), build
  # df_cs from df_full instead of the TWFE-filtered df.
  #
  # cs_sample_filter is treated as "present in metadata" (even if the value is
  # "") rather than "non-empty string", because "" semantically means "CS uses
  # the full post-construct_vars data, SKIPPING the TWFE sample filter".
  cs_sample_filter  <- meta$data$cs_sample_filter
  cs_construct_vars <- meta$preprocessing$cs_construct_vars
  has_cs_filter     <- !is.null(cs_sample_filter) && length(cs_sample_filter) > 0
  has_cs_construct  <- !is.null(cs_construct_vars) && length(cs_construct_vars) > 0

  if (has_cs_filter || has_cs_construct) {
    # Starting point depends on whether the metadata explicitly overrides the
    # filter. If cs_sample_filter is present, start from df_full (no filter
    # applied yet) and let the cs_sample_filter take over. If it isn't present,
    # inherit the TWFE sample_filter (so cs_construct_vars sees the same sample
    # the paper uses for its headline estimate).
    if (has_cs_filter) {
      df_base <- df_full
      filt_str <- as.character(cs_sample_filter)[1]
      if (nchar(trimws(filt_str)) > 0) {
        df_base <- df_base %>% filter(!!rlang::parse_expr(filt_str))
        cat(sprintf("    [CS sample_filter] %s -> %d rows\n", filt_str, nrow(df_base)))
      } else {
        cat(sprintf("    [CS sample_filter] (empty — skipping TWFE filter, using %d rows)\n",
                    nrow(df_base)))
      }
    } else {
      df_base <- df  # inherits the TWFE sample_filter
    }
    # Apply CS-specific construct_vars. The expressions see df_base as `df`.
    if (has_cs_construct) {
      df <- df_base  # exposing under the conventional name
      for (expr in cs_construct_vars) {
        tryCatch(eval(parse(text = expr)),
                 error = function(e) cat("    [cs_construct error]:", conditionMessage(e), "\n"))
      }
      df_base <- df
      # Restore df to the TWFE sample so later code that uses df is unaffected
      df <- df_full
      if (!is.null(meta$data$sample_filter) && nchar(trimws(meta$data$sample_filter)) > 0)
        df <- df %>% filter(!!rlang::parse_expr(meta$data$sample_filter))
      cat(sprintf("    [CS construct_vars] %d expression(s) applied -> %d rows\n",
                  length(cs_construct_vars), nrow(df_base)))
    }
    # Numeric coercion on the new sample
    df_base <- df_base %>%
      mutate(across(all_of(intersect(c(idname, tname, gcsname), names(df_base))),
                    as.numeric))
  } else {
    df_base <- df
  }

  # ─── Pattern 50 invariant: CS sample must match TWFE sample ───────────
  # unless metadata explicitly overrides via cs_sample_filter or
  # cs_construct_vars. Silent divergence = Kresch-class bug (id 233,
  # 2026-04-17). See knowledge/failure_patterns.md Pattern 50.
  has_cs_override <- (has_cs_filter || has_cs_construct)
  n_units_twfe <- n_distinct(df[[idname]])
  n_units_cs   <- n_distinct(df_base[[idname]])
  if (n_units_twfe != n_units_cs && !has_cs_override) {
    stop(sprintf(
      "[Pattern 50] CS sample has %d units but TWFE sample has %d units, yet no cs_sample_filter or cs_construct_vars is declared in metadata. This is a silent-sample-mismatch bug (see knowledge/failure_patterns.md Pattern 50; Kresch 2020 / id 233 was the discovery case). Either (a) add cs_sample_filter to metadata to justify the difference, or (b) fix the upstream pipeline so df_base inherits df correctly.",
      n_units_cs, n_units_twfe))
  }
  if (n_units_twfe != n_units_cs && has_cs_override) {
    cat(sprintf("    [Pattern 50 OK] CS sample differs from TWFE (cs: %d, twfe: %d) — justified by cs_sample_filter/cs_construct_vars\n",
                n_units_cs, n_units_twfe))
  }

  if (cs_is_panel) {
    df_cs  <- df_base
    the_id <- idname
    # We do NOT pre-filter to a balanced panel here — att_gt honours
    # `allow_unbalanced_panel = cs_allow_unbal` internally and its balancing
    # rule may be less aggressive than a naive "keep only ids with all
    # periods" filter. Pre-filtering here was a historical workaround that
    # diverged from `fix_*.R` behaviour (Pattern 40 superseded by 49).
  } else {
    df_cs <- df_base %>% mutate(row_id__ = row_number())
    the_id <- "row_id__"
  }

  # Fix (Pattern 25): att_gt converts gvar > max(time) to Inf (never-treated),
  # contaminating the NT control group. Filter them out for NT only.
  # Metadata can disable this with analysis.cs_drop_late_treated = false —
  # useful when the article's canonical bundled run did not apply the fix
  # (Pattern 49 compatibility).
  drop_late <- if (!is.null(meta$analysis$cs_drop_late_treated))
                 isTRUE(meta$analysis$cs_drop_late_treated) else TRUE
  max_time_cs <- max(df_cs[[tname]], na.rm = TRUE)
  late_treated <- df_cs[[gcsname]] > max_time_cs & df_cs[[gcsname]] > 0
  if (drop_late && any(late_treated, na.rm = TRUE)) {
    n_late <- sum(late_treated, na.rm = TRUE)
    cat(sprintf("    [NT fix] Dropping %d obs with gvar > %d (late-treated, would be misclassified as NT)\n",
                n_late, max_time_cs))
    df_cs_nt <- df_cs[!late_treated, ]
    if (!cs_is_panel) df_cs_nt$row_id__ <- seq_len(nrow(df_cs_nt))
  } else {
    if (!drop_late && any(late_treated, na.rm = TRUE))
      cat(sprintf("    [NT fix DISABLED] Keeping %d late-treated obs (cs_drop_late_treated=false)\n",
                  sum(late_treated, na.rm = TRUE)))
    df_cs_nt <- df_cs
  }
  cs_nt  <- run_att_gt(df_cs_nt, the_id, cs_is_panel, "nevertreated")
  # CS (2021, JoE §3.2): aggte("group") = θ_sel^O is the recommended overall summary.
  # For the dynamic aggregate, optionally clip to min_e/max_e declared in the
  # metadata (analysis.cs_min_e / analysis.cs_max_e, Pattern 49). Without
  # clipping, very-long-horizon egt values (beyond the displayed event study)
  # can include cohorts with only 1-2 groups contributing, producing noisy
  # estimates that dominate the unweighted "overall.att". Default = no clip.
  agg_dyn_args <- list(type = "dynamic")
  if (!is.null(cs_min_e)) agg_dyn_args$min_e <- cs_min_e
  if (!is.null(cs_max_e)) agg_dyn_args$max_e <- cs_max_e
  agg_nt   <- if (!is.null(cs_nt)) tryCatch(aggte(cs_nt, type="group"),   error=function(e) NULL) else NULL
  agg_nt_s <- if (!is.null(cs_nt)) tryCatch(aggte(cs_nt, type="simple"),  error=function(e) NULL) else NULL
  agg_nt_d <- if (!is.null(cs_nt)) tryCatch(
    do.call(aggte, c(list(MP = cs_nt), agg_dyn_args)),
    error=function(e) NULL) else NULL
  if (!is.null(cs_max_e) || !is.null(cs_min_e))
    cat(sprintf("    [CS dynamic clip] min_e=%s  max_e=%s\n",
                ifelse(is.null(cs_min_e), "-", cs_min_e),
                ifelse(is.null(cs_max_e), "-", cs_max_e)))
  att_nt   <- if (!is.null(agg_nt))   agg_nt$overall.att   else NA_real_
  se_nt    <- if (!is.null(agg_nt))   agg_nt$overall.se    else NA_real_
  att_nt_s <- if (!is.null(agg_nt_s)) agg_nt_s$overall.att else NA_real_
  se_nt_s  <- if (!is.null(agg_nt_s)) agg_nt_s$overall.se  else NA_real_
  att_nt_d <- if (!is.null(agg_nt_d)) agg_nt_d$overall.att else NA_real_
  se_nt_d  <- if (!is.null(agg_nt_d)) agg_nt_d$overall.se  else NA_real_
  cat("    ATT_NT =", round(att_nt, 5), "| SE =", round(se_nt, 5), "\n")
} else {
  cat("\n[4] CSDID — Skipped (run_csdid_nt = false)\n")
}

# ─────────────────────────────────────────────────────────────────────────────
# 6. CSDID — Not-Yet-Treated (staggered only)
# ─────────────────────────────────────────────────────────────────────────────
att_nyt <- NA_real_; se_nyt <- NA_real_
cs_nyt  <- NULL   # initialise here so it's available in event study section

if (is_staggered && run_nyt) {
  cat("\n[5] CSDID — Not-Yet-Treated\n")
  # Ensure df_cs/the_id exist if NT was skipped
  if (is.null(df_cs)) {
    if (cs_is_panel) { df_cs <- df; the_id <- idname }
    else { df_cs <- df %>% mutate(row_id__ = row_number()); the_id <- "row_id__" }
  }
  cs_nyt   <- run_att_gt(df_cs, the_id, cs_is_panel, "notyettreated")
  # Same cs_min_e / cs_max_e clipping for NYT (see NT section above).
  agg_dyn_args <- list(type = "dynamic")
  if (!is.null(cs_min_e)) agg_dyn_args$min_e <- cs_min_e
  if (!is.null(cs_max_e)) agg_dyn_args$max_e <- cs_max_e
  agg_nyt   <- if (!is.null(cs_nyt)) tryCatch(aggte(cs_nyt, type="group"),   error=function(e) NULL) else NULL
  agg_nyt_s <- if (!is.null(cs_nyt)) tryCatch(aggte(cs_nyt, type="simple"),  error=function(e) NULL) else NULL
  agg_nyt_d <- if (!is.null(cs_nyt)) tryCatch(
    do.call(aggte, c(list(MP = cs_nyt), agg_dyn_args)),
    error=function(e) NULL) else NULL
  att_nyt   <- if (!is.null(agg_nyt))   agg_nyt$overall.att   else NA_real_
  se_nyt    <- if (!is.null(agg_nyt))   agg_nyt$overall.se    else NA_real_
  att_nyt_s <- if (!is.null(agg_nyt_s)) agg_nyt_s$overall.att else NA_real_
  se_nyt_s  <- if (!is.null(agg_nyt_s)) agg_nyt_s$overall.se  else NA_real_
  att_nyt_d <- if (!is.null(agg_nyt_d)) agg_nyt_d$overall.att else NA_real_
  se_nyt_d  <- if (!is.null(agg_nyt_d)) agg_nyt_d$overall.se  else NA_real_
  cat("    ATT_NYT =", round(att_nyt, 5), "| SE =", round(se_nyt, 5), "\n")
}

# ─────────────────────────────────────────────────────────────────────────────
# 7. BACON DECOMPOSITION (staggered only)
# ─────────────────────────────────────────────────────────────────────────────
if (is_staggered && run_bacon) {
  cat("\n[6] Bacon Decomposition\n")
  tryCatch({
    df_bacon   <- df %>% mutate(across(all_of(c(idname, tname)), as.integer))
    bacon_fml  <- as.formula(paste0(yname, " ~ ", treat))
    bacon_out  <- if (!is.null(wname))
      bacon(bacon_fml, data=df_bacon, id_var=idname, time_var=tname, weights_name=wname)
    else
      bacon(bacon_fml, data=df_bacon, id_var=idname, time_var=tname)
    cat("    Bacon weighted avg:", round(sum(bacon_out$estimate * bacon_out$weight), 5), "\n")
    write.csv(bacon_out, file.path(out_dir, "bacon.csv"), row.names=FALSE)
    cat("    Bacon saved: bacon.csv\n")
  }, error = function(e) cat("    Bacon error:", conditionMessage(e), "\n"))
}

# ─────────────────────────────────────────────────────────────────────────────
# 8. SAVE POINT ESTIMATES
# ─────────────────────────────────────────────────────────────────────────────
cat("\n[7] Saving results.csv\n")
# Initialize aggregation vars if they don't exist (CS sections were skipped)
if (!exists("att_nt_s")) { att_nt_s <- NA_real_; se_nt_s <- NA_real_ }
if (!exists("att_nt_d")) { att_nt_d <- NA_real_; se_nt_d <- NA_real_ }
if (!exists("att_nyt_s")) { att_nyt_s <- NA_real_; se_nyt_s <- NA_real_ }
if (!exists("att_nyt_d")) { att_nyt_d <- NA_real_; se_nyt_d <- NA_real_ }

results <- data.frame(
  id_artigo       = meta$author_label,
  grupo           = meta$group_label,
  beta_twfe       = beta_twfe,
  se_twfe         = se_twfe,
  # Main CS columns = GROUP (CS-recommended, θ_sel^O)
  att_csdid_nt    = att_nt,
  se_csdid_nt     = se_nt,
  att_csdid_nyt   = att_nyt,
  se_csdid_nyt    = se_nyt,
  # SIMPLE (θ_W^O)
  att_nt_simple   = att_nt_s,
  se_nt_simple    = se_nt_s,
  # DYNAMIC (θ_es^O)
  att_nt_dynamic  = att_nt_d,
  se_nt_dynamic   = se_nt_d,
  att_nyt_simple  = att_nyt_s,
  se_nyt_simple   = se_nyt_s,
  att_nyt_dynamic = att_nyt_d,
  se_nyt_dynamic  = se_nyt_d
)
write.csv(results, file.path(out_dir, "results.csv"), row.names=FALSE)
cat("    Saved: results.csv\n")

# ─────────────────────────────────────────────────────────────────────────────
# 9. EVENT STUDY (only if requested)
# ─────────────────────────────────────────────────────────────────────────────
if (!has_es) {
  cat("\nNo event study requested.\n")
  cat("\n==========================================================\n")
  cat("DONE:", meta$author_label, "\n")
  cat("==========================================================\n")
  quit(save="no")
}

cat("\n[8] Event Study (pre=", ev_pre, ", post=", ev_post, ")\n", sep="")

# Optional ES-only sample filter: applied to TWFE, SA, BJS (not CS, already fitted)
# Use case: Buchmueller (ID 21) excludes NV/LA/NY/TN from event study only.
es_filter   <- meta$data$es_sample_filter
df_es_base  <- if (!is.null(es_filter) && nchar(trimws(es_filter)) > 0) {
  cat("  [ES filter]:", es_filter, "\n")
  df %>% filter(!!rlang::parse_expr(es_filter))
} else df
cat("  ES base rows:", nrow(df_es_base), "(full df:", nrow(df), ")\n")

# ─── 9a. TWFE Event Study ─────────────────────────────────────────────────
# Include ALL units (treated + control) via a binned rel_time — mirrors the Stata approach
# of pre-creating dummies that equal 0 for control units.
#
# Binning scheme:
#   never_bin   = -(ev_pre+2) : never-treated units → placed in reference bin (no coef)
#   far_pre_bin = -(ev_pre+1) : rel_time < -ev_pre  → single "far pre" coef
#   [window]    = -ev_pre .. ev_post-1 : exact periods
#   far_post    = ev_post     : rel_time >= ev_post  → single "long run" coef
#   ref = c(-1, never_bin) : both excluded from coefficients
cat("  [8a] TWFE Event Study\n")

never_bin   <- -(as.integer(ev_pre) + 2L)
far_pre_bin <- -(as.integer(ev_pre) + 1L)

df_es <- df_es_base %>%
  mutate(
    gvar_num = as.numeric(.data[[gcsname]]),
    raw_rel  = as.numeric(.data[[tname]]) - gvar_num,
    rel_time_binned = case_when(
      gvar_num == 0 | is.na(gvar_num)  ~ as.integer(never_bin),   # never-treated → ref
      raw_rel < -as.integer(ev_pre)    ~ as.integer(far_pre_bin),  # far pre bin
      raw_rel >= as.integer(ev_post)   ~ as.integer(ev_post),      # far post bin
      TRUE                             ~ as.integer(raw_rel)        # exact period
    )
  )

fe_str_twfe <- paste(unique(c(idname, tname, add_fes)), collapse=" + ")
ref_vals    <- c(-1L, as.integer(never_bin))
fml_twfe_es_rhs <- paste0(
  "i(rel_time_binned, ref=c(", paste(ref_vals, collapse=","), "))",
  if (length(tw_es_ctrls) > 0) paste0(" + ", paste(tw_es_ctrls, collapse=" + ")) else ""
)
fml_twfe_es <- as.formula(paste0(yname, " ~ ", fml_twfe_es_rhs, " | ", fe_str_twfe))

fit_twfe_es_args <- list(
  fml     = fml_twfe_es,
  data    = df_es,           # ALL data — control units contribute via FEs, not interaction coefs
  cluster = as.formula(paste0("~", es_cname))
)
if (!is.null(wname)) fit_twfe_es_args$weights <- as.formula(paste0("~", wname))

fit_twfe_es <- tryCatch(
  do.call(feols, fit_twfe_es_args),
  error = function(e) { cat("    TWFE ES error:", conditionMessage(e), "\n"); NULL }
)

extract_twfe_es <- function(fit) {
  if (is.null(fit)) return(NULL)
  cfs <- coef(fit); ses <- se(fit)
  nms <- names(cfs)
  idx <- grepl("^rel_time_binned::", nms)
  if (!any(idx)) return(NULL)
  times <- as.numeric(sub("rel_time_binned::", "", nms[idx]))
  rbind(
    data.frame(time=times, att=cfs[idx], se=ses[idx], estimator="TWFE"),
    data.frame(time=-1L,   att=0,        se=0,         estimator="TWFE")
  ) %>% arrange(time)
}
twfe_es_df <- extract_twfe_es(fit_twfe_es)
if (!is.null(twfe_es_df)) cat("    TWFE ES: OK (", nrow(twfe_es_df), "periods)\n")

# ─── 9b. CS-NT Event Study ────────────────────────────────────────────────
cat("  [8b] CS-NT Event Study\n")
cs_nt_es_df <- if (!is.null(cs_nt)) {
  tryCatch({
    agg_dyn <- aggte(cs_nt, type="dynamic")
    data.frame(
      time      = agg_dyn$egt,
      att       = agg_dyn$att.egt,
      se        = agg_dyn$se.egt,
      estimator = "CS-NT"
    )
  }, error = function(e) { cat("    CS-NT ES error:", conditionMessage(e), "\n"); NULL })
} else NULL
if (!is.null(cs_nt_es_df)) {
  cs_nt_es_df <- cs_nt_es_df %>% filter(time >= -(as.integer(ev_pre)+1L) & time <= as.integer(ev_post))
  cat("    CS-NT ES: OK (", nrow(cs_nt_es_df), "periods)\n")
}

# ─── 9b2. CS-NYT Event Study ──────────────────────────────────────────────
cs_nyt_es_df <- NULL
if (is_staggered && run_nyt && !is.null(cs_nyt)) {
  cat("  [8b2] CS-NYT Event Study\n")
  cs_nyt_es_df <- tryCatch({
    agg_dyn_nyt <- aggte(cs_nyt, type="dynamic")
    data.frame(
      time      = agg_dyn_nyt$egt,
      att       = agg_dyn_nyt$att.egt,
      se        = agg_dyn_nyt$se.egt,
      estimator = "CS-NYT"
    )
  }, error = function(e) { cat("    CS-NYT ES error:", conditionMessage(e), "\n"); NULL })
  if (!is.null(cs_nyt_es_df)) {
    cs_nyt_es_df <- cs_nyt_es_df %>% filter(time >= -(as.integer(ev_pre)+1L) & time <= as.integer(ev_post))
    cat("    CS-NYT ES: OK (", nrow(cs_nyt_es_df), "periods)\n")
  }
}

# ─── 9c. SA Event Study (Sun-Abraham) ─────────────────────────────────────
cat("  [8c] SA Event Study\n")
sa_es_df <- NULL
if (!run_sa) {
  cat("    SA skipped (run_sa: false)\n")
} else {
df_sa <- df_es_base %>%
  mutate(
    cohort_sa = as.numeric(.data[[gcsname]]),  # 0 = never-treated
    time_sa   = as.numeric(.data[[tname]])
  )
sa_ref_p_str <- if (!is.null(sa_ref_p) && length(sa_ref_p) > 0) {
  paste0(", ref.p = c(", paste(sa_ref_p, collapse=","), ")")
} else ""
# SA: no controls (only unit+time+additional FEs). Controls reserved for TWFE only.
fml_sa_rhs <- paste0("sunab(cohort_sa, time_sa", sa_ref_p_str, ")")
fml_sa <- as.formula(paste0(yname, " ~ ", fml_sa_rhs, " | ", fe_str_twfe))

fit_sa_args <- list(fml=fml_sa, data=df_sa, cluster=as.formula(paste0("~", es_cname)))
if (!is.null(wname)) fit_sa_args$weights <- as.formula(paste0("~", wname))

fit_sa <- tryCatch(do.call(feols, fit_sa_args),
                   error = function(e) { cat("    SA error:", conditionMessage(e), "\n"); NULL })

extract_sa_es <- function(fit) {
  if (is.null(fit)) return(NULL)
  tryCatch({
    ip   <- iplot(fit, only.params=TRUE)
    prms <- ip$prms[!ip$prms$is_ref, ]
    if (nrow(prms) == 0) return(NULL)
    data.frame(
      time      = prms$x,
      att       = prms$y,
      se        = (prms$ci_high - prms$ci_low) / (2 * 1.96),  # iplot has no 'se' column
      estimator = "SA"
    )
  }, error = function(e) { cat("    SA extract error:", conditionMessage(e), "\n"); NULL })
}
sa_es_df <- extract_sa_es(fit_sa)
if (!is.null(sa_es_df)) {
  sa_es_df <- sa_es_df %>% filter(time >= -(as.integer(ev_pre)+1L) & time <= as.integer(ev_post))
  cat("    SA ES: OK (", nrow(sa_es_df), "periods)\n")
}
}  # end if (run_sa)

# ─── 9d. Gardner Event Study (did2s) ─────────────────────────────────────
# Gardner works on ANY data structure (panel or RCS) without aggregation.
# Equivalent to BJS on panel without controls, but runs on both panel and RCS.
cat("  [8d] Gardner Event Study\n")
gardner_es_df <- NULL
if (!run_gardner) {
  cat("    Gardner skipped (run_gardner: false)\n")
} else if (!has_es) {
  cat("    Gardner skipped: no event study\n")
} else {
  tryCatch({
    library(did2s)

    # Create post_treat variable
    df_es$post_treat <- as.integer(
      df_es$gvar_num > 0 & as.numeric(df_es[[tname]]) >= df_es$gvar_num
    )

    # Gardner: no controls in first stage (only FEs). Controls reserved for TWFE only.
    fs_rhs <- paste0("~ 0 | ", fe_str_twfe)

    # Second stage: event study dummies
    ss_rhs <- paste0("~ i(rel_time_binned, ref = c(", paste(ref_vals, collapse = ","), "))")

    gardner_args <- list(
      data         = df_es,
      yname        = yname,
      first_stage  = as.formula(fs_rhs),
      second_stage = as.formula(ss_rhs),
      treatment    = "post_treat",
      cluster_var  = es_cname
    )
    if (!is.null(wname)) gardner_args$weights <- wname

    fit_g <- do.call(did2s, gardner_args)

    # Extract coefficients (did2s returns fixest object)
    cfs <- coef(fit_g); ses <- se(fit_g); nms <- names(cfs)
    idx <- grepl("rel_time_binned::", nms)
    if (any(idx)) {
      times <- as.numeric(sub("rel_time_binned::", "", nms[idx]))
      gardner_es_df <- data.frame(
        time = times, att = cfs[idx], se = ses[idx], estimator = "Gardner"
      )
      cat("    Gardner ES: OK (", nrow(gardner_es_df), "periods)\n")
    }
  }, error = function(e) {
    cat("    Gardner error:", conditionMessage(e), "\n")
  })
}

# ─── 9e. Combine & Plot ────────────────────────────────────────────────────
cat("  [8e] Plotting\n")

all_es_raw <- bind_rows(twfe_es_df, cs_nt_es_df, cs_nyt_es_df, sa_es_df, gardner_es_df)

if (nrow(all_es_raw) == 0 || !"att" %in% names(all_es_raw)) {
  cat("    No event study estimates to plot.\n")
} else {
  all_es <- all_es_raw %>%
    filter(!is.na(att), !is.nan(se)) %>%
    filter(time >= -(as.integer(ev_pre) + 1L),    # include far-pre bin
           time <=  as.integer(ev_post)) %>%       # clip post to window
    mutate(
      ci_low    = att - 1.96 * se,
      ci_high   = att + 1.96 * se,
      estimator = factor(estimator, levels = c("TWFE", "CS-NT", "CS-NYT", "SA", "Gardner"))
    )

  # Dynamic jitter: equidistant based on number of estimators actually present
  est_present <- levels(droplevels(all_es$estimator))
  n_est <- length(est_present)
  if (n_est == 1) {
    jitter_map <- setNames(0, est_present)
  } else {
    jitter_map <- setNames(seq(-0.20, 0.20, length.out = n_est), est_present)
  }
  all_es <- all_es %>%
    mutate(time_adj = time + jitter_map[as.character(estimator)],
           estimator = droplevels(estimator))
  if (nrow(all_es) == 0) { cat("    No valid estimates after filtering.\n") } else {
  es_colors <- c("TWFE"="black", "CS-NT"="forestgreen", "CS-NYT"="darkorange", "SA"="steelblue", "Gardner"="grey50")
  es_shapes <- c("TWFE"=3,       "CS-NT"=4,             "CS-NYT"=5,            "SA"=2,          "Gardner"=0)

  n_breaks <- as.integer(ev_pre) + as.integer(ev_post) + 2L
  if (n_breaks > 20) {
    by_val <- max(2L, ceiling(n_breaks / 15))
    brk_seq <- seq(-ev_pre, ev_post, by = by_val)
    if (!(-ev_pre %in% brk_seq)) brk_seq <- c(-ev_pre, brk_seq)
    if (!(ev_post %in% brk_seq)) brk_seq <- c(brk_seq, ev_post)
    es_breaks <- sort(unique(c(-(as.integer(ev_pre)+1L), brk_seq)))
    es_labels <- ifelse(es_breaks == -(as.integer(ev_pre)+1L),
                        paste0("\u2264", -(as.integer(ev_pre)+1L)),
                        as.character(es_breaks))
  } else {
    es_breaks <- c(-(as.integer(ev_pre)+1L), seq(-ev_pre, ev_post, by=1))
    es_labels <- c(paste0("\u2264", -(as.integer(ev_pre)+1L)), seq(-ev_pre, ev_post, by=1))
  }

  p <- ggplot(all_es, aes(x=time_adj, y=att, color=estimator, shape=estimator)) +
    geom_hline(yintercept=0, color="grey70", linetype="dashed", linewidth=0.3) +
    geom_vline(xintercept=-0.5, color="grey70", linetype="dashed", linewidth=0.3) +
    geom_point(size=1.5) +
    geom_errorbar(aes(ymin=ci_low, ymax=ci_high), width=0.08, linewidth=0.35) +
    scale_color_manual(values=es_colors) +
    scale_shape_manual(values=es_shapes) +
    scale_x_continuous(breaks = es_breaks, labels = es_labels) +
    labs(
      x     = "Relative Time to Treatment",
      y     = "ATT",
      color = "Estimador",
      shape = "Estimador",
      title = meta$author_label
    ) +
    theme_classic(base_size=11) +
    theme(
      legend.position = "bottom",
      legend.title    = element_blank(),
      axis.text.x     = if (n_breaks > 20) element_text(angle=45, hjust=1) else element_text()
    )

  pdf_path <- file.path(out_dir, "event_study.pdf")
  tryCatch(
    ggsave(pdf_path, plot=p, width=7, height=4.5),
    error = function(e) {
      alt <- sub("\\.pdf$", "_v2.pdf", pdf_path)
      tryCatch(
        { ggsave(alt, plot=p, width=7, height=4.5)
          cat("    Saved (alt):", basename(alt), "\n") },
        error = function(e2) cat("    Plot save error:", conditionMessage(e2), "\n")
      )
    }
  )
  cat("    Event study saved:", pdf_path, "\n")
  } # end if nrow(all_es) > 0
} # end if has estimates

# ─── 9f. Save event study data CSV ──────────────────────────────────────────
if (exists("all_es_raw") && nrow(all_es_raw) > 0) {
  es_export <- all_es_raw
  if ("att" %in% names(es_export)) names(es_export)[names(es_export) == "att"] <- "coef"
  es_export <- es_export[, c("estimator", "time", "coef", "se")]
  es_csv_path <- file.path(out_dir, "event_study_data.csv")
  write.csv(es_export, es_csv_path, row.names = FALSE)
  cat("    Event study data saved:", es_csv_path, "(", nrow(es_export), "rows )\n")
}

# ─────────────────────────────────────────────────────────────────────────────
# DONE
# ─────────────────────────────────────────────────────────────────────────────
cat("\n==========================================================\n")
cat("DONE:", meta$author_label, "\n")
cat("  results.csv:", file.path(out_dir, "results.csv"), "\n")
if (has_es) cat("  event_study.pdf:", file.path(out_dir, "event_study.pdf"), "\n")
cat("==========================================================\n")
