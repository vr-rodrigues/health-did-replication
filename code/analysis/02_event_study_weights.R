###############################################################################
# esw_all.R — Event Study Weights (Sun & Abraham 2021) for all articles
# Metadata-driven: reads metadata.json, constructs bins, calls esw_compute()
# Outputs: esw_weights_{last_bin}.pdf + esw_progressive_binning.pdf per article
#
# Usage: Rscript code/analysis/02_event_study_weights.R
# Run from the replication package root (working directory = package root)
###############################################################################

suppressPackageStartupMessages({
  library(jsonlite)
  library(haven)
  library(dplyr)
  library(fixest)
  library(ggplot2)
})

# WARNING: Requires original data from each article's replication package.
# Run from replication package root.
base_dir <- getwd()
source(file.path(base_dir, "code", "utils", "eventstudyweights.R"))

# IDs already done (regenerated 2026-03-17 with unbinned Expected benchmark:
# Expected = 1.0 at l=ev_post, 0 elsewhere — shows cost of binning)
already_done <- c(9, 21, 25, 60, 65, 76, 79, 80, 97, 125, 133, 147,
                  201, 210, 213, 219, 228, 233, 234, 241, 253, 262,
                  263, 267, 271, 281, 309, 321)

# IDs to skip (no event study or infeasible)
skip_ids <- c(
  44,   # has_event_study: false (all-eventually-treated, distributed lag only)
  47,   # event study collinear (3 treated states, single adoption timing)
  61,   # has_event_study: false (composite DiD variable, no FEs)
  68,   # only 2 periods (1993, 1998)
  254,  # CSV has only 5 columns — lacks treatment variables (high_mcaid_il, treat_yq)
  263,  # 1.1M rows × 32 rel_times → R segfault (memory). Run separately with gc.
  314,  # has_event_study: false (all-eventually-treated, 4 years, no ES in paper)
  337   # has_event_study: false (2 periods only, single cross-section)
)

# All article IDs in the sample
all_ids <- c(9, 21, 25, 44, 47, 60, 61, 65, 68, 76, 79, 80, 91, 97, 125,
             133, 147, 201, 210, 213, 219, 228, 233, 234, 241,
             253, 254, 262, 263, 267, 271, 281, 290,
             309, 314, 321, 333, 337)

# IDs to process
run_ids <- setdiff(all_ids, c(already_done, skip_ids))

cat("ESW batch: processing", length(run_ids), "articles\n")
cat("  Already done:", paste(already_done, collapse=", "), "\n")
cat("  Skipping:", paste(skip_ids, collapse=", "), "\n")
cat("  Running:", paste(run_ids, collapse=", "), "\n\n")

###############################################################################
# Main function: run ESW for one article
###############################################################################
run_esw <- function(id) {

  cat("\n##########################################################\n")
  cat("## ESW: ID", id, "\n")
  cat("##########################################################\n")

  meta_dir  <- file.path(base_dir, "results", "by_article", id)
  out_dir   <- file.path(base_dir, "results", "by_article", id)
  dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
  meta_path <- file.path(meta_dir, "metadata.json")
  if (!file.exists(meta_path)) {
    cat("  SKIP: metadata.json not found\n")
    return(FALSE)
  }

  meta <- fromJSON(meta_path)
  cat("  Article:", meta$author_label, "\n")

  # --- Check event study feasibility ---
  has_es  <- isTRUE(meta$analysis$has_event_study)
  if (!has_es) {
    cat("  SKIP: no event study (has_event_study=false)\n")
    return(FALSE)
  }
  ev_pre  <- as.integer(meta$analysis$event_pre)
  ev_post <- as.integer(meta$analysis$event_post)
  if (is.na(ev_pre) || is.na(ev_post)) {
    cat("  SKIP: event_pre or event_post not set\n")
    return(FALSE)
  }
  cat("  Event window: [", -ev_pre, ",", ev_post, "]\n")

  # --- Load data ---
  cat("  Loading data:", meta$data$file, "\n")
  df <- tryCatch({
    if (!is.null(meta$data$format) && meta$data$format == "csv") {
      read.csv(meta$data$file, stringsAsFactors = FALSE)
    } else {
      haven::read_dta(meta$data$file)
    }
  }, error = function(e) {
    cat("  ERROR loading data:", conditionMessage(e), "\n")
    return(NULL)
  })
  if (is.null(df)) return(FALSE)
  cat("  Rows loaded:", nrow(df), "\n")

  # --- Time recode ---
  if (!is.null(meta$preprocessing$time_recode)) {
    recode_list <- meta$preprocessing$time_recode
    old_vals    <- as.numeric(names(recode_list))
    new_vals    <- as.numeric(unlist(recode_list))
    tvar        <- meta$variables$time
    df[[tvar]]  <- new_vals[match(df[[tvar]], old_vals)]
    cat("  Time recoded\n")
  }

  # --- Construct variables ---
  if (!is.null(meta$preprocessing$construct_vars) &&
      length(meta$preprocessing$construct_vars) > 0) {
    for (expr in meta$preprocessing$construct_vars) {
      tryCatch(
        eval(parse(text = expr)),
        error = function(e) cat("  [construct error]:", conditionMessage(e),
                                "| expr:", substr(expr, 1, 80), "\n")
      )
    }
    cat("  Vars constructed:", length(meta$preprocessing$construct_vars), "\n")
  }

  # --- Per-ID special pre-processing ---
  if (id == 201) {
    # gvar_CS not in raw data; construct from first treatment time per fips
    tr_rows <- df$pslm_state_lag2 == 1 & !is.na(df$pslm_state_lag2)
    gvar_tab <- tapply(df$time[tr_rows], df$fips[tr_rows], min)
    df$gvar_CS <- as.numeric(gvar_tab[as.character(df$fips)])
    df$gvar_CS[is.na(df$gvar_CS)] <- 0
    cat("  [ID 201] Constructed gvar_CS for", length(gvar_tab), "treated fips\n")
  }

  # --- Sample filter ---
  if (!is.null(meta$data$sample_filter) &&
      nchar(trimws(meta$data$sample_filter)) > 0) {
    df <- tryCatch(
      df %>% filter(!!rlang::parse_expr(meta$data$sample_filter)),
      error = function(e) {
        cat("  ERROR in sample_filter:", conditionMessage(e), "\n")
        return(df)
      }
    )
    cat("  After filter:", nrow(df), "\n")
  }

  # --- ES-specific sample filter ---
  es_filter <- meta$data$es_sample_filter
  if (!is.null(es_filter) && nchar(trimws(es_filter)) > 0) {
    df <- tryCatch(
      df %>% filter(!!rlang::parse_expr(es_filter)),
      error = function(e) {
        cat("  ERROR in es_sample_filter:", conditionMessage(e), "\n")
        return(df)
      }
    )
    cat("  After ES filter:", nrow(df), "\n")
  }

  # --- Variable setup ---
  yname   <- meta$variables$outcome
  idname  <- meta$variables$unit_id
  tname   <- meta$variables$time
  cname   <- meta$variables$cluster
  # Defensive weight parsing: JSON {} → list() not NULL (Pattern 44)
  .w <- meta$variables$weight
  wname <- if (is.null(.w) || (is.list(.w) && length(.w) == 0) ||
               !is.character(.w) || length(.w) == 0 ||
               identical(as.character(.w), "null") ||
               identical(as.character(.w), ""))
            NULL else as.character(.w)[1]
  gcsname <- meta$variables$gvar_cs
  add_fes <- meta$variables$additional_fes
  if (is.null(add_fes) || identical(add_fes, list())) add_fes <- character(0)
  add_fes <- as.character(add_fes)

  # --- Per-ID: ID 97 composite unit fix ---
  if (id == 97) {
    # mun_reg appears 2x per year (treated2=1 and treated2=2).
    # Need treated2 as extra FE to match the event study spec.
    if (!("treated2" %in% add_fes)) {
      add_fes <- c(add_fes, "treated2")
      cat("  [ID 97] Added treated2 to extra_fes\n")
    }
  }

  # ES controls: override if twfe_es_controls exists
  tw_es_ctrls <- meta$variables$twfe_es_controls
  if (is.null(tw_es_ctrls) || identical(tw_es_ctrls, list()))
    tw_es_ctrls <- meta$variables$twfe_controls
  if (is.null(tw_es_ctrls) || identical(tw_es_ctrls, list()))
    tw_es_ctrls <- character(0)
  tw_es_ctrls <- as.character(tw_es_ctrls)

  # Numeric coercion
  df <- tryCatch({
    df %>% mutate(across(all_of(c(idname, tname, gcsname)), as.numeric))
  }, error = function(e) {
    cat("  WARNING: numeric coercion error:", conditionMessage(e), "\n")
    df
  })

  # --- Build relative time and bins ---
  df$gvar_num_esw <- as.numeric(df[[gcsname]])
  df$raw_rel_esw  <- as.numeric(df[[tname]]) - df$gvar_num_esw

  # rel_time_esw: only for treated units (gvar > 0)
  df$rel_time_esw <- ifelse(
    !is.na(df$gvar_num_esw) & df$gvar_num_esw > 0,
    df$raw_rel_esw,
    NA_real_
  )

  # --- Per-ID: restrict ESW cell range for memory ---
  if (id == 210) {
    # 13 cohorts x 79 rel times = 1027 cells → OOM.
    # Restrict rel_time_esw to event window; cells outside are bundled in tail bins.
    esw_lo <- -(ev_pre + 1L)   # include far_pre bin
    esw_hi <-   ev_post
    n_before <- sum(!is.na(df$rel_time_esw))
    df$rel_time_esw[!is.na(df$rel_time_esw) &
                      (df$rel_time_esw < esw_lo | df$rel_time_esw > esw_hi)] <- NA
    n_after <- sum(!is.na(df$rel_time_esw))
    cat(sprintf("  [ID 210] Restricted rel_time_esw to [%d,%d]: %d → %d treated obs with ESW\n",
                esw_lo, esw_hi, n_before, n_after))
  }

  # Binning (same scheme as template)
  never_bin   <- -(ev_pre + 2L)
  far_pre_bin <- -(ev_pre + 1L)

  df$rel_time_binned_esw <- as.integer(
    dplyr::case_when(
      is.na(df$gvar_num_esw) | df$gvar_num_esw == 0 ~ never_bin,
      df$raw_rel_esw < -ev_pre   ~ far_pre_bin,
      df$raw_rel_esw >= ev_post  ~ as.integer(ev_post),
      TRUE                       ~ as.integer(df$raw_rel_esw)
    )
  )

  # Create explicit dummy columns (bin_vars)
  bin_values <- c(far_pre_bin, seq(-ev_pre, ev_post))
  bin_values <- bin_values[bin_values != -1L]  # exclude reference period
  bin_names  <- character(length(bin_values))

  for (i in seq_along(bin_values)) {
    v  <- bin_values[i]
    nm <- if (v == far_pre_bin) paste0("F_", ev_pre + 1L)
          else if (v < 0)      paste0("F_", abs(v))
          else                 paste0("L_", v)
    bin_names[i] <- nm
    df[[nm]] <- as.integer(df$rel_time_binned_esw == v)
  }

  last_bin <- paste0("L_", ev_post)
  cat("  Bins:", paste(bin_names, collapse=", "), "\n")
  cat("  Reference: t=-1 (omitted)\n")
  cat("  Target (last post): ", last_bin, "\n")

  # --- Run TWFE event study with explicit dummies ---
  fe_vars <- unique(c(idname, tname, add_fes))
  fe_str  <- paste(fe_vars, collapse = " + ")
  rhs     <- paste(c(bin_names, tw_es_ctrls), collapse = " + ")
  fml     <- as.formula(paste(yname, "~", rhs, "|", fe_str))

  fit_args <- list(
    fml     = fml,
    data    = df,
    cluster = as.formula(paste0("~", cname))
  )
  if (!is.null(wname)) fit_args$weights <- as.formula(paste0("~", wname))

  fit <- tryCatch(do.call(feols, fit_args), error = function(e) {
    cat("  ERROR feols:", conditionMessage(e), "\n")
    return(NULL)
  })
  if (is.null(fit)) return(FALSE)

  # Verify last bin coefficient exists
  cfs <- coef(fit)
  if (!(last_bin %in% names(cfs))) {
    cat("  WARNING:", last_bin, "not in coefs. Available:", paste(names(cfs)[1:5], collapse=", "), "...\n")
    # Try to find the actual last available bin
    available_L <- grep("^L_", names(cfs), value = TRUE)
    if (length(available_L) > 0) {
      last_bin <- tail(available_L, 1)
      cat("  Using", last_bin, "as target bin instead\n")
    } else {
      cat("  ERROR: no L_ bins in coefficients\n")
      return(FALSE)
    }
  }

  cat("  TWFE ES coefs (", last_bin, "=", round(cfs[last_bin], 5), ")\n")

  # --- ESW computation ---
  cat("  Computing ESW...\n")

  # extra_fes = FEs beyond unit_fe + time_fe
  extra_fes_esw <- if (length(add_fes) > 0) add_fes else NULL

  w <- tryCatch(
    esw_compute(
      data        = df,
      bin_vars    = bin_names,
      unit_fe     = idname,
      time_fe     = tname,
      cohort_var  = "gvar_num_esw",
      reltime_var = "rel_time_esw",
      covariates  = if (length(tw_es_ctrls) > 0) tw_es_ctrls else NULL,
      extra_fes   = extra_fes_esw,
      weights_var = wname
    ),
    error = function(e) {
      cat("  ERROR esw_compute:", conditionMessage(e), "\n")
      return(NULL)
    }
  )
  if (is.null(w)) return(FALSE)

  # Verify weights
  bin_map <- list()
  for (i in seq_along(bin_values)) {
    v  <- bin_values[i]
    nm <- bin_names[i]
    if (v == far_pre_bin) {
      bin_map[[nm]] <- seq(-200L, as.integer(-ev_pre - 1L))
    } else if (v == ev_post) {
      bin_map[[nm]] <- seq(as.integer(ev_post), 200L)
    } else {
      bin_map[[nm]] <- as.integer(v)
    }
  }
  esw_verify(w, bin_names, bin_map)

  # --- Plot 1: Expected vs Binned weights on last bin ---
  cat("  Plotting weights for", last_bin, "\n")

  agg <- esw_aggregate(w, last_bin)
  agg$spec <- "Binned"

  # Expected: unbinned benchmark — what the weight would be if l=ev_post
  # had its own exact dummy (no tail binning). In a well-identified unbinned
  # model, the coefficient on l=ev_post concentrates all weight at l'=ev_post
  # (own-period = 1.0, cross-period = 0). This makes the cost of binning
  # visible: the Binned line spreads weight across many CATTs (l=ev_post,
  # ev_post+1, ...), while Expected shows the ideal single-period target.
  agg_exp <- data.frame(
    rel_time = agg$rel_time,
    weight   = ifelse(agg$rel_time == ev_post, 1.0, 0.0),
    n_obs    = 0L,
    spec     = "Expected"
  )

  combined <- rbind(agg, agg_exp)
  combined$spec <- factor(combined$spec, levels = c("Expected", "Binned"))

  # Determine expression for y-axis label
  post_num <- as.integer(sub("L_", "", last_bin))
  y_expr <- bquote("Weight on " * hat(beta)[t + .(post_num)])

  p1 <- ggplot(combined, aes(x = rel_time, y = weight,
                               color = spec, linetype = spec)) +
    geom_line(linewidth = 0.7) +
    geom_point(data = subset(combined, spec == "Binned"),
               size = 0.8, alpha = 0.6) +
    geom_hline(yintercept = 0, color = "grey70", linetype = "dashed",
               linewidth = 0.3) +
    geom_vline(xintercept = -0.5, color = "grey70", linetype = "dotted",
               linewidth = 0.3) +
    scale_color_manual(values = c("Expected" = "grey50", "Binned" = "black")) +
    scale_linetype_manual(values = c("Expected" = "dashed", "Binned" = "solid")) +
    labs(
      x     = "Relative Time",
      y     = y_expr,
      title = meta$author_label
    ) +
    theme_classic(base_size = 11) +
    theme(legend.position = "bottom", legend.title = element_blank())

  out_pdf1 <- file.path(out_dir, paste0("esw_weights_", last_bin, ".pdf"))
  ggsave(out_pdf1, p1, width = 8, height = 5)
  cat("  Saved:", out_pdf1, "\n")

  # --- Plot 2: Progressive binning ---
  cat("  Progressive binning\n")

  rt_range <- range(df$rel_time_esw, na.rm = TRUE)
  max_k <- min(20L,
               as.integer(floor(-rt_range[1])) - ev_pre,
               as.integer(floor(rt_range[2]))  - ev_post)
  max_k <- max(max_k, 0L)
  cat("  Max k:", max_k, "(rel_time range:", rt_range, ")\n")

  prog_results <- data.frame(k = integer(), coef = numeric(),
                              se = numeric(), ci_lo = numeric(),
                              ci_hi = numeric())

  for (k in 0:max_k) {
    lo <- -ev_pre - k
    hi <-  ev_post + k

    # Drop treated obs outside [lo, hi]
    dft <- df %>%
      filter(gvar_num_esw == 0 | is.na(gvar_num_esw) |
               (rel_time_esw >= lo & rel_time_esw <= hi))

    # Also restrict controls to the calendar time range of remaining treated
    treated_times <- dft[[tname]][!is.na(dft$rel_time_esw)]
    if (length(treated_times) > 0) {
      min_t <- min(treated_times, na.rm = TRUE)
      max_t <- max(treated_times, na.rm = TRUE)
      dft <- dft %>% filter(.data[[tname]] >= min_t & .data[[tname]] <= max_t)
    }

    fit_k <- tryCatch(do.call(feols, list(
      fml = fml, data = dft, cluster = as.formula(paste0("~", cname)),
      weights = if (!is.null(wname)) as.formula(paste0("~", wname)) else NULL
    )), error = function(e) NULL)

    if (!is.null(fit_k) && last_bin %in% names(coef(fit_k))) {
      b <- coef(fit_k)[last_bin]
      s <- sqrt(vcov(fit_k)[last_bin, last_bin])
      # Sanity check: skip if SE is anomalously large (collinearity artifact)
      se_ratio <- if (nrow(prog_results) > 0) s / median(prog_results$se) else 1
      if (se_ratio > 100) {
        cat(sprintf("  k=%2d  n=%6d  SKIPPED (SE=%.1f, ratio=%.0fx — collinearity)\n",
                    k, nrow(dft), s, se_ratio))
      } else {
        prog_results <- rbind(prog_results, data.frame(
          k = k, coef = b, se = s,
          ci_lo = b - 1.96 * s, ci_hi = b + 1.96 * s
        ))
        cat(sprintf("  k=%2d  n=%6d  b(%s)=%+.5f  SE=%.5f\n",
                    k, nrow(dft), last_bin, b, s))
      }
    } else {
      cat(sprintf("  k=%2d  FAILED\n", k))
    }
  }

  if (nrow(prog_results) > 0) {
    y_expr2 <- bquote(hat(beta)[t + .(post_num)])

    p2 <- ggplot(prog_results, aes(x = k, y = coef)) +
      geom_hline(yintercept = 0, color = "grey70", linetype = "dashed",
                 linewidth = 0.3) +
      geom_errorbar(aes(ymin = ci_lo, ymax = ci_hi),
                    width = 0.15, linewidth = 0.35) +
      geom_point(size = 1.8) +
      scale_x_continuous(breaks = 0:max(prog_results$k)) +
      labs(
        x     = expression("Additional periods binned (" * pm * "t)"),
        y     = y_expr2,
        title = paste0(meta$author_label, " \u2014 Progressive binning on ", last_bin)
      ) +
      theme_classic(base_size = 11)

    out_pdf2 <- file.path(out_dir, "esw_progressive_binning.pdf")
    ggsave(out_pdf2, p2, width = 7, height = 4.5)
    cat("  Saved:", out_pdf2, "\n")
  }

  cat("  DONE: ID", id, "\n")
  return(TRUE)
}

###############################################################################
# Run all
###############################################################################
results_log <- data.frame(id = integer(), status = character(),
                           stringsAsFactors = FALSE)

for (id in run_ids) {
  ok <- tryCatch(
    run_esw(id),
    error = function(e) {
      cat("\n  FATAL ERROR ID", id, ":", conditionMessage(e), "\n")
      return(FALSE)
    }
  )
  results_log <- rbind(results_log, data.frame(
    id = id, status = if (isTRUE(ok)) "OK" else "FAIL"
  ))
}

cat("\n\n==========================================================\n")
cat("ESW Batch Summary\n")
cat("==========================================================\n")
cat("Already done:", paste(already_done, collapse=", "), "\n")
cat("Skipped:", paste(skip_ids, collapse=", "), "\n")
print(results_log)
cat("OK:", sum(results_log$status == "OK"),
    "| FAIL:", sum(results_log$status == "FAIL"), "\n")
