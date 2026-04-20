###############################################################################
# 00_master.R — Master reproduction script
#
# Runs every script in this replication package in the correct order.
# Must be executed from the replication package root directory:
#     cd "Replication Package"
#     Rscript code/00_master.R
#
# -----------------------------------------------------------------------------
# TIERS
# -----------------------------------------------------------------------------
# TIER 1 — Self-contained (uses bundled per-article CSVs in results/by_article/
#          and aggregate CSVs in analysis/)
#   00_setup.R                        — install packages
#   code/aggregation/01_consolidate_results.R
#   code/tables/01_chapter_statistics.R
#   code/tables/02_article_cards.R
#   code/tables/03_margin_attribution.R (D7: joint margin decomposition)
#   code/figures/01_aggregate_scatter.R
#   code/figures/02_density_z.R
#   code/figures/03_panel_event_study.R
#   code/figures/06_graduated_sensitivity.R
#   code/figures/07_density_covariates.R
#   code/figures/08_headline_composite.R
#
# TIER 2 — Requires original papers' raw data (see data_availability_statement.md)
#   code/analysis/01_run_all_did.R    — TWFE/CS/SA/BJS for all 56 articles
#   code/analysis/02_event_study_weights.R
#   code/analysis/03_honest_did.R
#   code/analysis/04_bacon_all.R
#   code/figures/04_panel_binning_76.R
#   code/figures/05_panel_controls_133.R
#
# By default 00_master.R runs TIER 1 only. Set RUN_TIER2 = TRUE below to run
# the per-article re-estimation pipeline (requires downloading each paper's
# replication package first — see data_availability_statement.md).
###############################################################################

RUN_TIER2 <- TRUE

base_dir <- getwd()
required_dirs <- c("code", "data", "analysis", "results")
missing_dirs <- required_dirs[!vapply(required_dirs,
  function(d) dir.exists(file.path(base_dir, d)), logical(1))]
if (length(missing_dirs) > 0) {
  stop("Please run from the replication package root: missing directories: ",
       paste(missing_dirs, collapse = ", "))
}

run_script <- function(rel_path) {
  cat(sprintf("\n\n################################################\n"))
  cat(sprintf("#  RUNNING: %s\n", rel_path))
  cat(sprintf("################################################\n"))
  src <- file.path(base_dir, rel_path)
  if (!file.exists(src)) {
    cat(sprintf("  [SKIP] file not found: %s\n", src))
    return(invisible(FALSE))
  }
  t0 <- Sys.time()
  ok <- tryCatch({ source(src, local = new.env()); TRUE },
                 error = function(e) {
                   cat("  ERROR:", conditionMessage(e), "\n"); FALSE
                 })
  cat(sprintf("  Elapsed: %.1fs  Status: %s\n",
              as.numeric(difftime(Sys.time(), t0, units = "secs")),
              if (isTRUE(ok)) "OK" else "FAIL"))
  invisible(ok)
}

# ---------------- TIER 1: self-contained ----------------

# Install packages (safe to re-run; idempotent)
run_script("00_setup.R")

# Rebuild consolidated_results.csv from per-article results
run_script("code/aggregation/01_consolidate_results.R")

# Rebuild paper_fidelity.csv from per-article paper_audit.md files
# (race-safe — the concurrent paper-auditor runs can trample each other's
# appends to the CSV; this re-derives it from the individual audit reports).
run_script("code/aggregation/03_rebuild_paper_fidelity.R")

# Rebuild skeptic_ratings.csv applying the 3-axis rubric
# (Fidelity × Implementation) with the corrected fidelity column from
# the paper-auditor rerun (2026-04-19). Drops papers excluded from the
# comparable subsample (excluded_from_sample=true in metadata).
run_script("code/aggregation/02_rebuild_skeptic_ratings.R")

# Sync excluded_from_sample flag from metadata into article_cards.csv
# (must run before 02_article_cards.R so the cards reflect the exclusion).
run_script("code/aggregation/04_flag_excluded_in_cards.R")

# Tables
run_script("code/tables/01_chapter_statistics.R")
run_script("code/tables/02_article_cards.R")
run_script("code/tables/03_margin_attribution.R")

# Aggregate figures
run_script("code/figures/01_aggregate_scatter.R")
run_script("code/figures/02_density_z.R")
run_script("code/figures/03_panel_event_study.R")
run_script("code/figures/06_graduated_sensitivity.R")
run_script("code/figures/07_density_covariates.R")
run_script("code/figures/08_headline_composite.R")

# ---------------- TIER 2: requires raw data ----------------

if (isTRUE(RUN_TIER2)) {
  run_script("code/analysis/01_run_all_did.R")
  run_script("code/analysis/02_event_study_weights.R")
  run_script("code/analysis/03_honest_did.R")
  run_script("code/analysis/04_bacon_all.R")
  run_script("code/figures/04_panel_binning_76.R")
  run_script("code/figures/05_panel_controls_133.R")
} else {
  cat("\n\nTIER 2 skipped (RUN_TIER2 = FALSE).\n")
  cat("To regenerate per-article outputs from the original data, ")
  cat("set RUN_TIER2 <- TRUE in this file and follow ")
  cat("data_availability_statement.md to download each paper's data.\n")
}

# Close any lingering graphics devices (e.g., silent PDF opened by ggplotGrob)
# and remove the stray Rplots.pdf it leaves behind. This must happen BEFORE
# R's implicit dev.off() on process exit, otherwise the device is flushed
# to disk and a new Rplots.pdf reappears after our file.remove().
while (!is.null(grDevices::dev.list())) try(grDevices::dev.off(), silent = TRUE)
stray <- file.path(base_dir, "Rplots.pdf")
if (file.exists(stray)) invisible(file.remove(stray))

cat("\n\n=== 00_master.R finished ===\n")
