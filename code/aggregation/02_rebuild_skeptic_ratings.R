###############################################################################
# 02_rebuild_skeptic_ratings.R
# Rebuilds analysis/skeptic_ratings.csv:
#   1) drops papers with metadata$excluded_from_sample == TRUE (234, 242, 380)
#   2) replaces the F-NA blanket with real fidelity verdicts extracted from
#      results/by_article/{id}/paper_audit.md (paper-auditor fix 2026-04-19)
#   3) recomputes the combined rating using the 3-axis rubric
#
# Outputs:
#   analysis/skeptic_ratings.csv (overwritten)
#   analysis/skeptic_summary.md  (overwritten)
###############################################################################
suppressPackageStartupMessages({ library(jsonlite) })

base_dir <- getwd()
ratings_file <- file.path(base_dir, "analysis", "skeptic_ratings.csv")
audit_root   <- file.path(base_dir, "results", "by_article")

# ─── 1. Read existing ratings (CSV with quoted commas) ────────────────────
old <- read.csv(ratings_file, stringsAsFactors = FALSE, check.names = FALSE)
cat(sprintf("Loaded %d rows from old skeptic_ratings.csv\n", nrow(old)))

# Dedupe: keep the last-appended row per id (agents append rather than replace,
# so the most recent audit result is at the bottom).
if (anyDuplicated(old$id) > 0) {
  n_before <- nrow(old)
  old <- old[!duplicated(old$id, fromLast = TRUE), ]
  cat(sprintf("Deduped: %d → %d rows (kept last occurrence per id)\n",
              n_before, nrow(old)))
}

# Save the original rating to use as fallback for malformed rows where
# the per-axis fields aren't parseable (legacy rows where author_label has
# internal commas predating the 3-axis schema).
old$legacy_rating <- old$rating

# ─── 2. Extract real fidelity verdict from each paper_audit.md ────────────
extract_verdict <- function(id) {
  f <- file.path(audit_root, id, "paper_audit.md")
  if (!file.exists(f)) return(NA_character_)
  txt <- readLines(f, warn = FALSE, n = 30)
  # Find first line starting with "Verdict:" or "**Verdict:" or **Verdict
  m <- grep("Verdict[:\\*]", txt, value = TRUE)
  if (length(m) == 0) return(NA_character_)
  first <- m[1]
  if (grepl("EXACT",            first)) return("EXACT")
  if (grepl("WITHIN_TOLERANCE", first)) return("WITHIN_TOLERANCE")
  if (grepl("FAIL",             first)) return("FAIL")
  if (grepl("WARN",             first)) return("WARN")
  if (grepl("NOT_APPLICABLE",   first)) return("NOT_APPLICABLE")
  NA_character_
}

old$fidelity_verdict <- sapply(as.character(old$id), extract_verdict)

# Map paper-auditor verdict to fidelity axis
verdict_to_fidelity <- function(v) {
  switch(as.character(v),
         EXACT            = "F-HIGH",
         WITHIN_TOLERANCE = "F-HIGH",
         WARN             = "F-MOD",
         FAIL             = "F-LOW",
         NOT_APPLICABLE   = "F-NA",
         "F-?")
}
old$fidelity <- sapply(old$fidelity_verdict, verdict_to_fidelity)

# ─── 3. Drop papers excluded from sample ───────────────────────────────────
exclude_ids <- c(234, 242, 380)
old <- old[!old$id %in% exclude_ids, ]
cat(sprintf("After dropping %d excluded papers: %d rows\n",
            length(exclude_ids), nrow(old)))

# ─── 4. Recompute combined rating using 3-axis rubric ─────────────────────
# Implementation axis is in column "implementation"; some legacy rows may
# have a malformed value — fall back to the original "rating" if so.
classify_impl <- function(impl) {
  if (is.na(impl) || impl == "") return("?")
  s <- toupper(impl)
  if (grepl("HIGH", s)) return("HIGH")
  if (grepl("MOD",  s)) return("MOD")
  if (grepl("LOW",  s)) return("LOW")
  return("?")
}
old$impl_axis <- sapply(old$implementation, classify_impl)

combined_rating <- function(impl, fid) {
  i <- impl
  f <- substr(fid, 3, 99)
  if (i == "?") return(NA_character_)
  if (i == "LOW") return("LOW")
  if (i == "HIGH" && f == "HIGH") return("HIGH")
  if (i == "HIGH" && f == "NA")   return("HIGH")
  if (i == "HIGH" && f == "MOD")  return("MODERATE")
  if (i == "HIGH" && f == "LOW")  return("LOW")
  if (i == "MOD"  && f == "LOW")  return("LOW")
  if (i == "MOD")                 return("MODERATE")
  return(NA_character_)
}
old$rating <- mapply(combined_rating, old$impl_axis, old$fidelity)

# Fallback for malformed legacy rows: keep original rating + flag
malformed <- is.na(old$rating)
if (any(malformed)) {
  cat(sprintf("\n%d malformed rows; falling back to legacy rating:\n", sum(malformed)))
  cat(sprintf("  ids: %s\n", paste(old$id[malformed], collapse=",")))
  old$rating[malformed] <- old$legacy_rating[malformed]
}

# ─── 5. Write back ─────────────────────────────────────────────────────────
write.csv(old, ratings_file, row.names = FALSE)
cat(sprintf("Saved: %s (%d rows)\n", ratings_file, nrow(old)))

# ─── 6. Print distribution ────────────────────────────────────────────────
cat("\n=== Final rating distribution (3-axis, N=53) ===\n")
print(table(old$rating, useNA = "ifany"))
cat("\n=== Fidelity verdict distribution ===\n")
print(table(old$fidelity_verdict, useNA = "ifany"))
