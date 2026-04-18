###############################################################################
# 01_run_all_did.R
# Wrapper that runs did_analysis_template.R for every article in the sample.
#
# For each article id in results/by_article/, the template reads metadata.json,
# loads the paper's data, and writes results to results/by_article/{id}/:
#   - results.csv, event_study.pdf, event_study_data.csv
#
# WARNING: This script REQUIRES each article's raw data to be available at the
# path listed in metadata$data$file (typically under data/raw/{id}/...).
# Download each paper's replication package from the links in
# data_availability_statement.md before running.
#
# Usage (from replication package root):
#   Rscript code/analysis/01_run_all_did.R            # all articles
#   Rscript code/analysis/01_run_all_did.R 9 21 76    # subset
###############################################################################

suppressPackageStartupMessages({
  library(jsonlite)
})

base_dir <- getwd()
meta_root <- file.path(base_dir, "results", "by_article")
template  <- file.path(base_dir, "code", "analysis", "did_analysis_template.R")
canon_meta <- file.path(base_dir, "data", "metadata")

# Sync canonical metadata (data/metadata/{id}.json) into per-article working
# directory (results/by_article/{id}/metadata.json). The data/metadata/ copy is
# the single source of truth that the user maintains; the by_article copy is a
# frozen snapshot preserved alongside each article's results for traceability.
sync_meta <- function(id) {
  src <- file.path(canon_meta, paste0(id, ".json"))
  dst_dir <- file.path(meta_root, id)
  dst <- file.path(dst_dir, "metadata.json")
  if (!file.exists(src)) return(FALSE)
  dir.create(dst_dir, recursive = TRUE, showWarnings = FALSE)
  file.copy(src, dst, overwrite = TRUE)
}

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 0) {
  ids <- args
} else {
  # Authoritative article list comes from data/metadata/ (canonical), not from
  # results/by_article/ which is an output directory.
  meta_files <- list.files(canon_meta, pattern = "\\.json$")
  ids <- sub("\\.json$", "", meta_files)
  ids <- ids[grepl("^[0-9]+$", ids)]
  ids <- as.character(sort(as.integer(ids)))
}

# Sync metadata for each selected article before running
invisible(vapply(ids, sync_meta, logical(1)))

cat(sprintf("Running DiD template for %d article(s)\n\n", length(ids)))

log <- data.frame(id = character(), status = character(),
                  stringsAsFactors = FALSE)

for (id in ids) {
  cat(sprintf("\n######## ARTICLE %s ########\n", id))
  ok <- tryCatch({
    sys <- system2("Rscript", c(shQuote(template), id), stdout = "", stderr = "")
    sys == 0
  }, error = function(e) {
    cat("  FATAL:", conditionMessage(e), "\n"); FALSE
  })
  log <- rbind(log, data.frame(
    id = id, status = if (isTRUE(ok)) "OK" else "FAIL",
    stringsAsFactors = FALSE
  ))
}

cat("\n\n==========================================================\n")
cat("DiD Batch Summary\n")
cat("==========================================================\n")
print(log)
cat(sprintf("OK: %d | FAIL: %d\n",
            sum(log$status == "OK"), sum(log$status == "FAIL")))
