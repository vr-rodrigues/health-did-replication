###############################################################################
# 01_consolidate_results.R — Build consolidated_results.csv from per-article
# results.csv and metadata.json files.
#
# Input:  results/by_article/{id}/metadata.json, results/by_article/{id}/results.csv
# Output: analysis/consolidated_results.csv
###############################################################################
suppressPackageStartupMessages({ library(jsonlite); library(dplyr) })

base_dir    <- getwd()
results_dir <- file.path(base_dir, "results", "by_article")
analysis_dir <- file.path(base_dir, "analysis")

ids <- c(9, 21, 25, 44, 47, 60, 61, 65, 68, 76, 79, 80, 97, 125, 133,
         147, 201, 210, 213, 228, 233, 234, 241, 242, 253, 254,
         262, 263, 267, 271, 281, 290, 304, 305, 309, 311, 321, 323,
         333, 335, 337, 347, 358, 359, 380, 395, 401,
         419, 420, 432, 433, 437, 525, 744, 1094, 2303)

# Papers excluded from comparable subsample (set excluded_from_sample=true in metadata).
# As of 2026-04-19: 234 (Myers), 242 (Moorthy-Shaloka), 380 (Kuziemko et al.) — see paper-auditor reports.
EXCLUDED_FILE <- file.path(base_dir, "analysis", "excluded_papers.csv")

rows <- list()
excluded_log <- list()
for (id in ids) {
  meta_file <- file.path(results_dir, id, "metadata.json")
  res_file  <- file.path(results_dir, id, "results.csv")
  if (!file.exists(meta_file) || !file.exists(res_file)) {
    cat(sprintf("  Skipping ID %s (missing files)\n", id)); next
  }
  meta <- fromJSON(meta_file)
  if (isTRUE(meta$excluded_from_sample)) {
    cat(sprintf("  EXCLUDED ID %s — %s (reason logged)\n", id,
                if (!is.null(meta$author_label)) meta$author_label else ""))
    excluded_log[[length(excluded_log) + 1]] <- data.frame(
      id = id,
      author_label = if (!is.null(meta$author_label)) meta$author_label else NA_character_,
      exclusion_reason = if (!is.null(meta$exclusion_reason)) meta$exclusion_reason else NA_character_,
      stringsAsFactors = FALSE)
    next
  }
  res  <- read.csv(res_file, stringsAsFactors = FALSE)

  gcol <- function(name) {
    if (name %in% names(res)) as.numeric(res[[name]][1]) else NA_real_
  }

  # Helper to pull a character column (for status fields)
  gchr <- function(name) {
    if (name %in% names(res)) as.character(res[[name]][1]) else NA_character_
  }

  # Handle multi-row estimator format
  if ("estimator" %in% names(res)) {
    tw <- res[res$estimator == "TWFE", ]
    cn <- res[res$estimator == "CS-NT", ]
    cy <- res[res$estimator == "CS-NYT", ]
    bt <- if (nrow(tw) > 0) as.numeric(tw$att[1]) else NA_real_
    st <- if (nrow(tw) > 0) as.numeric(tw$se[1])  else NA_real_
    ant <- if (nrow(cn) > 0) as.numeric(cn$att[1]) else NA_real_
    snt <- if (nrow(cn) > 0) as.numeric(cn$se[1])  else NA_real_
    anyt <- if (nrow(cy) > 0) as.numeric(cy$att[1]) else NA_real_
    snyt <- if (nrow(cy) > 0) as.numeric(cy$se[1])  else NA_real_
    rows[[length(rows) + 1]] <- data.frame(
      id = id, author_label = meta$author_label, group_label = meta$group_label,
      beta_twfe = bt, se_twfe = st,
      beta_twfe_no_ctrls = NA_real_, se_twfe_no_ctrls = NA_real_,
      att_csdid_nt = ant, se_csdid_nt = snt,
      att_csdid_nyt = anyt, se_csdid_nyt = snyt,
      att_nt_simple = ant, se_nt_simple = snt,
      att_nyt_simple = anyt, se_nyt_simple = snyt,
      att_nt_dynamic = ant, se_nt_dynamic = snt,
      att_nyt_dynamic = anyt, se_nyt_dynamic = snyt,
      att_cs_nt_with_ctrls = NA_real_, se_cs_nt_with_ctrls = NA_real_,
      att_cs_nt_with_ctrls_dyn = NA_real_, se_cs_nt_with_ctrls_dyn = NA_real_,
      cs_nt_with_ctrls_status = NA_character_,
      att_cs_nyt_with_ctrls = NA_real_, se_cs_nyt_with_ctrls = NA_real_,
      att_cs_nyt_with_ctrls_dyn = NA_real_, se_cs_nyt_with_ctrls_dyn = NA_real_,
      cs_nyt_with_ctrls_status = NA_character_,
      has_event_study = isTRUE(meta$analysis$has_event_study),
      treatment_timing = meta$panel_setup$treatment_timing,
      data_structure = meta$panel_setup$data_structure,
      stringsAsFactors = FALSE)
  } else {
    rows[[length(rows) + 1]] <- data.frame(
      id = id, author_label = meta$author_label, group_label = meta$group_label,
      beta_twfe = gcol("beta_twfe"), se_twfe = gcol("se_twfe"),
      beta_twfe_no_ctrls = gcol("beta_twfe_no_ctrls"),
      se_twfe_no_ctrls   = gcol("se_twfe_no_ctrls"),
      att_csdid_nt = gcol("att_csdid_nt"), se_csdid_nt = gcol("se_csdid_nt"),
      att_csdid_nyt = gcol("att_csdid_nyt"), se_csdid_nyt = gcol("se_csdid_nyt"),
      att_nt_simple = gcol("att_nt_simple"), se_nt_simple = gcol("se_nt_simple"),
      att_nyt_simple = gcol("att_nyt_simple"), se_nyt_simple = gcol("se_nyt_simple"),
      att_nt_dynamic = gcol("att_nt_dynamic"), se_nt_dynamic = gcol("se_nt_dynamic"),
      att_nyt_dynamic = gcol("att_nyt_dynamic"), se_nyt_dynamic = gcol("se_nyt_dynamic"),
      att_cs_nt_with_ctrls      = gcol("att_cs_nt_with_ctrls"),
      se_cs_nt_with_ctrls       = gcol("se_cs_nt_with_ctrls"),
      att_cs_nt_with_ctrls_dyn  = gcol("att_cs_nt_with_ctrls_dyn"),
      se_cs_nt_with_ctrls_dyn   = gcol("se_cs_nt_with_ctrls_dyn"),
      cs_nt_with_ctrls_status   = gchr("cs_nt_with_ctrls_status"),
      att_cs_nyt_with_ctrls     = gcol("att_cs_nyt_with_ctrls"),
      se_cs_nyt_with_ctrls      = gcol("se_cs_nyt_with_ctrls"),
      att_cs_nyt_with_ctrls_dyn = gcol("att_cs_nyt_with_ctrls_dyn"),
      se_cs_nyt_with_ctrls_dyn  = gcol("se_cs_nyt_with_ctrls_dyn"),
      cs_nyt_with_ctrls_status  = gchr("cs_nyt_with_ctrls_status"),
      has_event_study = isTRUE(meta$analysis$has_event_study),
      treatment_timing = meta$panel_setup$treatment_timing,
      data_structure = meta$panel_setup$data_structure,
      stringsAsFactors = FALSE)
  }
}

consolidated <- bind_rows(rows)
out_file <- file.path(analysis_dir, "consolidated_results.csv")
write.csv(consolidated, out_file, row.names = FALSE)
cat(sprintf("Saved: %s (%d articles)\n", out_file, nrow(consolidated)))

# Log excluded papers separately
if (length(excluded_log) > 0) {
  excluded_df <- bind_rows(excluded_log)
  write.csv(excluded_df, EXCLUDED_FILE, row.names = FALSE)
  cat(sprintf("Saved: %s (%d excluded papers)\n", EXCLUDED_FILE, nrow(excluded_df)))
}
