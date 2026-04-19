###############################################################################
# 03_rebuild_paper_fidelity.R
# Rebuilds analysis/paper_fidelity.csv from per-paper paper_audit.md files
# (the only race-safe source of truth — concurrent skeptic runs trampled
# each other's appends to the CSV).
###############################################################################
suppressPackageStartupMessages({ library(jsonlite) })

base_dir <- getwd()
audit_root <- file.path(base_dir, "results", "by_article")
fid_file   <- file.path(base_dir, "analysis", "paper_fidelity.csv")

# Helper: extract verdict + key fields from one paper_audit.md
parse_audit <- function(id) {
  f <- file.path(audit_root, id, "paper_audit.md")
  if (!file.exists(f)) return(NULL)
  txt <- readLines(f, warn = FALSE)

  # Verdict
  vline <- grep("Verdict[:\\*]", txt, value = TRUE)[1]
  verdict <- if (is.na(vline)) NA_character_ else {
    if (grepl("EXACT",            vline)) "EXACT"
    else if (grepl("WITHIN_TOLERANCE", vline)) "WITHIN_TOLERANCE"
    else if (grepl("FAIL",             vline)) "FAIL"
    else if (grepl("WARN",             vline)) "WARN"
    else if (grepl("NOT_APPLICABLE",   vline)) "NOT_APPLICABLE"
    else NA_character_
  }

  # Try to find selected spec line
  spec_line <- grep("Selected.[Ss]pecification|Selected spec", txt, value = TRUE)[1]
  spec <- if (is.na(spec_line)) NA_character_ else
    sub("^.*\\*\\*\\s*[Ss]elected.*?\\*\\*\\s*", "", spec_line)

  # author label from title line "# Paper fidelity audit: {id} — {label}"
  hline <- grep("^# .*[Pp]aper.*fidelity", txt, value = TRUE)[1]
  if (is.na(hline)) hline <- grep("^# ", txt, value = TRUE)[1]
  label <- if (is.na(hline)) NA_character_ else
    sub("^# .*?[—-]\\s*", "", hline)

  data.frame(
    id = id, author_label = label, verdict = verdict, selected_spec = spec,
    stringsAsFactors = FALSE)
}

# Iterate all per-article folders
all_dirs <- list.dirs(audit_root, recursive = FALSE, full.names = TRUE)
ids <- sort(as.integer(basename(all_dirs)[grepl("^[0-9]+$", basename(all_dirs))]))

# Load metadata to detect excluded papers
read_excl <- function(id) {
  m <- file.path(audit_root, id, "metadata.json")
  if (!file.exists(m)) return(FALSE)
  meta <- tryCatch(fromJSON(m), error = function(e) NULL)
  isTRUE(meta$excluded_from_sample)
}

rows <- list()
for (id in ids) {
  if (read_excl(id)) {
    cat(sprintf("  EXCLUDED %d\n", id)); next
  }
  r <- parse_audit(id)
  if (!is.null(r)) rows[[length(rows) + 1]] <- r
}

fid <- do.call(rbind, rows)
write.csv(fid, fid_file, row.names = FALSE)
cat(sprintf("Saved: %s (%d rows)\n", fid_file, nrow(fid)))

cat("\n=== Verdict distribution ===\n")
print(table(fid$verdict, useNA = "ifany"))
