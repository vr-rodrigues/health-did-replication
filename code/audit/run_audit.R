###############################################################################
# run_audit.R — Automated audit of the replication package
#
# Checks:
#   Axis 1 — Path portability (no absolute paths, proper getwd() usage)
#   Axis 2 — File hygiene (no orphan/log/credential/oversized files)
#   Axis 4 — Metadata integrity (56 JSONs, well-formed, match DAS)
#   Axis 5 — Claim<->output traceability (scripts produce documented outputs)
#
# Usage (from replication package root):
#   Rscript code/audit/run_audit.R
#
# Exits 0 if all checks pass, 1 if any fail.
###############################################################################

suppressPackageStartupMessages({ library(jsonlite) })

base_dir <- getwd()
if (!dir.exists(file.path(base_dir, "code")) ||
    !dir.exists(file.path(base_dir, "data")) ||
    !dir.exists(file.path(base_dir, "analysis"))) {
  stop("Run from the replication package root (must contain code/, data/, analysis/).")
}

results <- list()
record <- function(axis, check, pass, detail = "") {
  results[[length(results) + 1]] <<- data.frame(
    axis = axis, check = check,
    status = if (isTRUE(pass)) "PASS" else "FAIL",
    detail = detail, stringsAsFactors = FALSE)
  cat(sprintf("[%s] %-4s %s%s\n",
              if (isTRUE(pass)) "PASS" else "FAIL",
              axis, check,
              if (!nzchar(detail) || isTRUE(pass)) "" else paste0("  -->  ", detail)))
}

empty_or <- function(x, alt = "none") if (length(x) == 0) alt else paste(x, collapse = ", ")

all_r_files <- list.files(file.path(base_dir, "code"),
                          pattern = "\\.R$", recursive = TRUE, full.names = TRUE)
top_setup <- file.path(base_dir, "00_setup.R")
if (file.exists(top_setup)) all_r_files <- c(all_r_files, top_setup)

# Exclude the audit script itself from content scans — it legitimately contains
# the very patterns it searches for (/Users/, OneDrive, etc.) as string literals.
scanned_r_files <- all_r_files[!grepl("audit/run_audit\\.R$", all_r_files)]

read_txt <- function(f) suppressWarnings(readLines(f, warn = FALSE))

############################### AXIS 1 — PORTABILITY ##########################
cat("\n=== AXIS 1: Path portability ===\n")

# 1.1 — No Windows-style absolute paths inside string literals
bad <- c()
for (f in scanned_r_files) {
  txt <- read_txt(f)
  hits <- grep("\"[A-Za-z]:[/\\\\]", txt)
  if (length(hits) > 0) bad <- c(bad, sprintf("%s:%d", basename(f), hits[1]))
}
record("1.1", "No Windows absolute paths in R scripts",
       length(bad) == 0, empty_or(bad))

# 1.2 — No Unix absolute user paths inside string literals
bad <- c()
for (f in scanned_r_files) {
  txt <- read_txt(f)
  hits <- grep("\"/Users/|\"/home/|\"~/", txt)
  if (length(hits) > 0) bad <- c(bad, sprintf("%s:%d", basename(f), hits[1]))
}
record("1.2", "No Unix absolute user paths in R scripts",
       length(bad) == 0, empty_or(bad))

# 1.3 — No setwd() calls
bad <- c()
for (f in scanned_r_files) {
  txt <- read_txt(f)
  hits <- grep("^\\s*setwd\\s*\\(", txt)
  if (length(hits) > 0) bad <- c(bad, sprintf("%s:%d", basename(f), hits[1]))
}
record("1.3", "No setwd() calls",
       length(bad) == 0, empty_or(bad))

# 1.4 — Executable scripts that touch files must set base_dir <- getwd()
# Exclusions: 00_setup.R (pure install_packages wrapper — no file I/O),
# utils/eventstudyweights.R (sourced utility, no I/O of its own),
# audit/run_audit.R (already uses base_dir).
exclude_pat <- "/utils/|eventstudyweights\\.R$|00_setup\\.R$"
required_uses_getwd <- all_r_files[!grepl(exclude_pat, all_r_files)]
missing <- c()
for (f in required_uses_getwd) {
  txt <- paste(read_txt(f), collapse = "\n")
  if (!grepl("base_dir\\s*<-\\s*getwd\\(\\)", txt)) {
    missing <- c(missing, basename(f))
  }
}
record("1.4", "All I/O scripts set base_dir <- getwd()",
       length(missing) == 0, empty_or(missing))

# 1.5 — No OneDrive references
bad <- c()
for (f in scanned_r_files) {
  txt <- read_txt(f)
  hits <- grep("OneDrive", txt, ignore.case = TRUE)
  if (length(hits) > 0) bad <- c(bad, sprintf("%s:%d", basename(f), hits[1]))
}
record("1.5", "No OneDrive references",
       length(bad) == 0, empty_or(bad))

############################### AXIS 2 — HYGIENE ##############################
cat("\n=== AXIS 2: File hygiene ===\n")

all_files <- list.files(base_dir, recursive = TRUE, all.files = TRUE,
                        include.dirs = FALSE)

# 2.1 — No orphan IDE/OS/R scratch files
orphan_pat <- "(^|/)(\\.RData|\\.Rhistory|\\.DS_Store|Thumbs\\.db|Rplots\\.pdf|~\\$|\\.Rproj\\.user)"
orphans <- all_files[grepl(orphan_pat, all_files)]
record("2.1", "No orphan IDE/OS/R scratch files",
       length(orphans) == 0,
       if (length(orphans) > 0) sprintf("%d found, e.g. %s", length(orphans), orphans[1]) else "")

# 2.2 — No files > 50 MB
sizes <- file.info(file.path(base_dir, all_files))$size
big <- data.frame(f = all_files, s = sizes, stringsAsFactors = FALSE)
big <- big[!is.na(big$s) & big$s > 50 * 1024 * 1024, ]
record("2.2", "No files larger than 50 MB",
       nrow(big) == 0,
       if (nrow(big) > 0) sprintf("%d found, e.g. %s (%.1f MB)",
                                  nrow(big), big$f[1], big$s[1]/1024/1024) else "")

# 2.3 — No credential/.env files
cred_files <- all_files[grepl("(^|/)(\\.env|credentials\\.[a-z]+|secrets?\\.[a-z]+)$",
                              all_files, ignore.case = TRUE)]
record("2.3", "No credential/.env files",
       length(cred_files) == 0, empty_or(cred_files))

# 2.4 — No log files
log_files <- all_files[grepl("\\.log$", all_files, ignore.case = TRUE)]
record("2.4", "No .log files",
       length(log_files) == 0,
       if (length(log_files) > 0) sprintf("%d found", length(log_files)) else "")

# 2.5 — data/raw/ empty (raw data must not be redistributed)
raw_path <- file.path(base_dir, "data", "raw")
if (dir.exists(raw_path)) {
  raw_contents <- list.files(raw_path, recursive = TRUE, include.dirs = FALSE)
  record("2.5", "data/raw/ is empty (raw data not redistributed)",
         length(raw_contents) == 0,
         if (length(raw_contents) > 0) sprintf("%d files present", length(raw_contents)) else "")
} else {
  record("2.5", "data/raw/ is empty (raw data not redistributed)",
         TRUE, "directory absent (OK)")
}

############################### AXIS 4 — METADATA #############################
cat("\n=== AXIS 4: Metadata integrity ===\n")

meta_files <- list.files(file.path(base_dir, "data", "metadata"),
                         pattern = "\\.json$", full.names = TRUE)

# 4.1 — Exactly 56 metadata files
record("4.1", "Exactly 56 metadata files in data/metadata/",
       length(meta_files) == 56, sprintf("found %d", length(meta_files)))

# 4.2 — All parse as valid JSON
bad_parse <- c()
parsed_meta <- list()
for (mf in meta_files) {
  m <- tryCatch(fromJSON(mf), error = function(e) NULL)
  if (is.null(m)) {
    bad_parse <- c(bad_parse, basename(mf))
  } else {
    parsed_meta[[gsub("\\.json$", "", basename(mf))]] <- m
  }
}
record("4.2", "All metadata files parse as valid JSON",
       length(bad_parse) == 0, empty_or(bad_parse))

# 4.3 — All have data.file field
missing_datafile <- c()
for (id in names(parsed_meta)) {
  m <- parsed_meta[[id]]
  if (is.null(m$data$file) || !nzchar(m$data$file)) {
    missing_datafile <- c(missing_datafile, id)
  }
}
record("4.3", "All metadata have data.file field",
       length(missing_datafile) == 0, empty_or(missing_datafile))

# 4.4 — data.file paths use data/raw/{id}/ convention
bad_path <- c()
for (id in names(parsed_meta)) {
  m <- parsed_meta[[id]]
  if (is.null(m$data$file)) next
  expected_prefix <- paste0("data/raw/", id, "/")
  if (!startsWith(m$data$file, expected_prefix)) {
    bad_path <- c(bad_path, sprintf("%s -> %s", id, m$data$file))
  }
}
record("4.4", "All data.file paths use data/raw/{id}/ convention",
       length(bad_path) == 0,
       if (length(bad_path) > 0) sprintf("%d violations; first: %s",
                                         length(bad_path), bad_path[1]) else "")

# 4.5 — DAS lists exactly the 56 metadata IDs
das_file <- file.path(base_dir, "data_availability_statement.md")
das_txt <- read_txt(das_file)
das_lines <- das_txt[grepl("^\\|\\s*\\d+\\s*\\|", das_txt)]
das_ids <- sub("^\\|\\s*(\\d+)\\s*\\|.*", "\\1", das_lines)
meta_ids <- names(parsed_meta)
missing_from_das <- setdiff(meta_ids, das_ids)
extra_in_das <- setdiff(das_ids, meta_ids)
record("4.5", "DAS lists exactly the 56 metadata IDs",
       length(missing_from_das) == 0 && length(extra_in_das) == 0,
       sprintf("missing from DAS: %s ; extra in DAS: %s",
               empty_or(missing_from_das), empty_or(extra_in_das)))

# 4.6 — data/metadata/{id}.json and results/by_article/{id}/metadata.json identical
# (after a successful run, the sync step in 01_run_all_did.R should have equalised them)
out_of_sync <- c()
for (id in meta_ids) {
  src <- file.path(base_dir, "data", "metadata", paste0(id, ".json"))
  dst <- file.path(base_dir, "results", "by_article", id, "metadata.json")
  if (!file.exists(dst)) { out_of_sync <- c(out_of_sync, paste0(id, "(missing)")); next }
  if (!identical(unname(tools::md5sum(src)), unname(tools::md5sum(dst)))) {
    out_of_sync <- c(out_of_sync, id)
  }
}
record("4.6", "data/metadata/{id}.json in sync with results/by_article/{id}/metadata.json",
       length(out_of_sync) == 0,
       if (length(out_of_sync) > 0) sprintf("%d out of sync: %s",
                                            length(out_of_sync),
                                            paste(head(out_of_sync, 10), collapse=",")) else "")

# 4.7 — legacy_analysis articles have legacy_reason explanation
legacy_missing_reason <- c()
legacy_ids <- c()
for (id in meta_ids) {
  m <- parsed_meta[[id]]
  if (isTRUE(m$analysis$legacy_analysis)) {
    legacy_ids <- c(legacy_ids, id)
    if (is.null(m$analysis$legacy_reason) ||
        !nzchar(trimws(as.character(m$analysis$legacy_reason)))) {
      legacy_missing_reason <- c(legacy_missing_reason, id)
    }
  }
}
record("4.7", sprintf("legacy_analysis articles (%d) all have legacy_reason",
                      length(legacy_ids)),
       length(legacy_missing_reason) == 0,
       if (length(legacy_missing_reason) > 0)
         paste("missing reason:", paste(legacy_missing_reason, collapse=",")) else
         if (length(legacy_ids) > 0) paste("legacy IDs:", paste(legacy_ids, collapse=",")) else "none")

# 4.8 — Template has set.seed() for determinism
template_path <- file.path(base_dir, "code", "analysis", "did_analysis_template.R")
template_txt <- if (file.exists(template_path)) paste(read_txt(template_path), collapse="\n") else ""
record("4.8", "did_analysis_template.R calls set.seed() for determinism",
       grepl("set\\.seed\\s*\\(", template_txt), "")

# 4.9 — 01_run_all_did.R has metadata sync step
runall_path <- file.path(base_dir, "code", "analysis", "01_run_all_did.R")
runall_txt <- if (file.exists(runall_path)) paste(read_txt(runall_path), collapse="\n") else ""
record("4.9", "01_run_all_did.R syncs data/metadata -> results/by_article",
       grepl("sync_meta|data/metadata", runall_txt), "")

############################### AXIS 5 — TRACEABILITY #########################
cat("\n=== AXIS 5: Script<->output traceability ===\n")

# 5.1 — All expected Tier 1 PDFs exist
expected_pdfs <- c(
  "figure_4_1_aggregate_scatter_dynamic.pdf",
  "figure_4_2_density_z_dynamic.pdf",
  "figure_4_3_variation_pct_dynamic.pdf",
  "figure_4_4_panel_event_study_6cases.pdf",
  "figure_4_7_density_covariates.pdf",
  "figure_4_9_graduated_sensitivity.pdf")
fig_dir <- file.path(base_dir, "output", "figures")
missing_pdfs <- expected_pdfs[!file.exists(file.path(fig_dir, expected_pdfs))]
record("5.1", "All Tier 1 figure PDFs present in output/figures/",
       length(missing_pdfs) == 0, empty_or(missing_pdfs))

# 5.2 — appendix_article_cards.tex exists
tex_file <- file.path(base_dir, "output", "tables", "appendix_article_cards.tex")
record("5.2", "output/tables/appendix_article_cards.tex exists",
       file.exists(tex_file), "")

# 5.3 — analysis/consolidated_results.csv exists
cons_file <- file.path(base_dir, "analysis", "consolidated_results.csv")
record("5.3", "analysis/consolidated_results.csv exists",
       file.exists(cons_file), "")

# 5.4 — every results/by_article/{id}/ has results.csv
missing_res <- c()
for (id in meta_ids) {
  if (!file.exists(file.path(base_dir, "results", "by_article", id, "results.csv"))) {
    missing_res <- c(missing_res, id)
  }
}
record("5.4", "All 56 by_article/{id}/results.csv exist",
       length(missing_res) == 0, empty_or(missing_res))

# 5.5 — No orphan .R scripts (not referenced in README or master)
readme_txt <- paste(read_txt(file.path(base_dir, "README.md")), collapse = "\n")
master_txt <- paste(read_txt(file.path(base_dir, "code", "00_master.R")), collapse = "\n")
all_txt <- paste(readme_txt, master_txt)
script_rel <- list.files(file.path(base_dir, "code"), pattern = "\\.R$", recursive = TRUE)
# Allow the audit script itself
script_rel <- script_rel[!grepl("audit/run_audit\\.R$", script_rel)]
orphan_scripts <- c()
for (s in script_rel) {
  b <- basename(s)
  if (!grepl(s, all_txt, fixed = TRUE) && !grepl(b, all_txt, fixed = TRUE)) {
    orphan_scripts <- c(orphan_scripts, s)
  }
}
record("5.5", "Every code/*.R referenced in README or master",
       length(orphan_scripts) == 0, empty_or(orphan_scripts))

################################ SUMMARY ######################################
cat("\n\n=== AUDIT SUMMARY ===\n")
df <- do.call(rbind, results)
n_pass <- sum(df$status == "PASS")
n_fail <- sum(df$status == "FAIL")
cat(sprintf("%d/%d PASS, %d FAIL\n", n_pass, n_pass + n_fail, n_fail))

if (n_fail > 0) {
  cat("\nFailures:\n")
  fails <- df[df$status == "FAIL", ]
  for (i in seq_len(nrow(fails))) {
    cat(sprintf("  [%s] %s  -->  %s\n",
                fails$axis[i], fails$check[i], fails$detail[i]))
  }
  quit(status = 1)
}
