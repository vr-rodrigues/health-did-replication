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

rows <- list()
for (id in ids) {
  meta_file <- file.path(results_dir, id, "metadata.json")
  res_file  <- file.path(results_dir, id, "results.csv")
  if (!file.exists(meta_file) || !file.exists(res_file)) {
    cat(sprintf("  Skipping ID %s (missing files)\n", id)); next
  }
  meta <- fromJSON(meta_file)
  res  <- read.csv(res_file, stringsAsFactors = FALSE)

  gcol <- function(name) {
    if (name %in% names(res)) as.numeric(res[[name]][1]) else NA_real_
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
      att_csdid_nt = ant, se_csdid_nt = snt,
      att_csdid_nyt = anyt, se_csdid_nyt = snyt,
      att_nt_simple = ant, se_nt_simple = snt,
      att_nyt_simple = anyt, se_nyt_simple = snyt,
      att_nt_dynamic = ant, se_nt_dynamic = snt,
      att_nyt_dynamic = anyt, se_nyt_dynamic = snyt,
      has_event_study = isTRUE(meta$analysis$has_event_study),
      treatment_timing = meta$panel_setup$treatment_timing,
      data_structure = meta$panel_setup$data_structure,
      stringsAsFactors = FALSE)
  } else {
    rows[[length(rows) + 1]] <- data.frame(
      id = id, author_label = meta$author_label, group_label = meta$group_label,
      beta_twfe = gcol("beta_twfe"), se_twfe = gcol("se_twfe"),
      att_csdid_nt = gcol("att_csdid_nt"), se_csdid_nt = gcol("se_csdid_nt"),
      att_csdid_nyt = gcol("att_csdid_nyt"), se_csdid_nyt = gcol("se_csdid_nyt"),
      att_nt_simple = gcol("att_nt_simple"), se_nt_simple = gcol("se_nt_simple"),
      att_nyt_simple = gcol("att_nyt_simple"), se_nyt_simple = gcol("se_nyt_simple"),
      att_nt_dynamic = gcol("att_nt_dynamic"), se_nt_dynamic = gcol("se_nt_dynamic"),
      att_nyt_dynamic = gcol("att_nyt_dynamic"), se_nyt_dynamic = gcol("se_nyt_dynamic"),
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
