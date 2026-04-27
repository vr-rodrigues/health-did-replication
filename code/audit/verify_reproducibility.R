###############################################################################
# verify_reproducibility.R -- DCAS-style consistency checks
#
# The script writes analysis/reproducibility_audit.csv and stops only on
# critical replication failures. Documentation gaps are recorded as WARN.
###############################################################################

suppressPackageStartupMessages(library(jsonlite))

base_dir <- getwd()
audit_dir <- file.path(base_dir, "analysis")
dir.create(audit_dir, recursive = TRUE, showWarnings = FALSE)

checks <- list()
add_check <- function(scope, item, status, detail = "", path = "") {
  checks[[length(checks) + 1]] <<- data.frame(
    scope = scope,
    item = item,
    status = status,
    detail = detail,
    path = path,
    stringsAsFactors = FALSE
  )
}

file_equal <- function(a, b) {
  if (!file.exists(a) || !file.exists(b)) return(FALSE)
  sa <- file.info(a)$size
  sb <- file.info(b)$size
  if (is.na(sa) || is.na(sb) || sa != sb) return(FALSE)
  identical(readBin(a, "raw", n = sa), readBin(b, "raw", n = sb))
}

check_exists <- function(scope, item, path, critical = TRUE) {
  status <- if (file.exists(path)) "PASS" else if (critical) "FAIL" else "WARN"
  add_check(scope, item, status,
            if (file.exists(path)) "exists" else "missing", path)
}

cat("\n=== Reproducibility audit ===\n")

# ---------------------------------------------------------------------------
# Root structure and master-script invariants
# ---------------------------------------------------------------------------
for (d in c("code", "data", "analysis", "results", "output", "overleaf",
            "health_did_replication")) {
  check_exists("structure", paste0("directory ", d), file.path(base_dir, d))
}

master <- file.path(base_dir, "code", "00_master.R")
check_exists("code", "master script", master)
if (file.exists(master)) {
  txt <- readLines(master, warn = FALSE, encoding = "UTF-8")
  run_tier2_false <- any(grepl("^\\s*RUN_TIER2\\s*<-\\s*FALSE\\s*$", txt))
  repro_checks <- any(grepl("^\\s*RUN_REPRO_CHECKS\\s*<-\\s*TRUE\\s*$", txt))
  mvpf_before_fig <- which(grepl('run_script\\("code/analysis/mvpf_pilots.R"', txt))[1] <
                     which(grepl('run_script\\("code/figures/11_mvpf_stress_test.R"', txt))[1]
  add_check("code", "Tier 1 default", if (run_tier2_false) "PASS" else "FAIL",
            "RUN_TIER2 must default to FALSE for bundled-data reproduction.",
            master)
  add_check("code", "post-run audit enabled", if (repro_checks) "PASS" else "FAIL",
            "RUN_REPRO_CHECKS should be TRUE.", master)
  add_check("code", "MVPF data before MVPF figure",
            if (isTRUE(mvpf_before_fig)) "PASS" else "FAIL",
            "mvpf_pilots.R must run before 11_mvpf_stress_test.R.", master)
}

# ---------------------------------------------------------------------------
# Metadata/results sample consistency
# ---------------------------------------------------------------------------
meta_files <- list.files(file.path(base_dir, "data", "metadata"),
                         pattern = "\\.json$", full.names = TRUE)
meta <- lapply(meta_files, function(f) {
  x <- fromJSON(f)
  id_from_file <- sub("\\.json$", "", basename(f))
  data.frame(
    id = if (!is.null(x$id) && length(x$id) > 0) as.character(x$id) else id_from_file,
    excluded = isTRUE(x$excluded_from_sample),
    data_file = if (!is.null(x$data$file)) x$data$file else NA_character_,
    stringsAsFactors = FALSE
  )
})
meta_df <- do.call(rbind, meta)
results_ids <- basename(list.dirs(file.path(base_dir, "results", "by_article"),
                                  recursive = FALSE, full.names = TRUE))
extra_results <- setdiff(results_ids, meta_df$id)
missing_results <- setdiff(meta_df$id, results_ids)
add_check("data", "metadata count", if (nrow(meta_df) == 56) "PASS" else "FAIL",
          sprintf("%d metadata files", nrow(meta_df)), "data/metadata")
add_check("data", "results directories match metadata",
          if (length(extra_results) == 0 && length(missing_results) == 0) "PASS" else "WARN",
          paste(c(if (length(extra_results)) paste0("extra: ", paste(extra_results, collapse = ",")),
                  if (length(missing_results)) paste0("missing: ", paste(missing_results, collapse = ","))),
                collapse = "; "),
          "results/by_article")

con_path <- file.path(base_dir, "analysis", "consolidated_results.csv")
check_exists("analysis", "consolidated_results.csv", con_path)
if (file.exists(con_path)) {
  con <- read.csv(con_path, stringsAsFactors = FALSE)
  expected_n <- sum(!meta_df$excluded)
  add_check("analysis", "consolidated row count",
            if (nrow(con) == expected_n) "PASS" else "FAIL",
            sprintf("rows=%d; expected non-excluded metadata=%d",
                    nrow(con), expected_n),
            con_path)
}

for (f in c("analysis/mvpf_stress_test.csv",
            "analysis/mvpf_stress_test_long.csv",
            "output/tables/table_4_8_mvpf_stress_test.tex",
            "output/figures/figure_4_8_mvpf_stress_test_panelA.pdf",
            "output/figures/figure_4_8_mvpf_stress_test_panelB.pdf")) {
  check_exists("lesson8", basename(f), file.path(base_dir, f))
}

# ---------------------------------------------------------------------------
# Output-to-LaTeX synchronization
# ---------------------------------------------------------------------------
table_files <- list.files(file.path(base_dir, "output", "tables"),
                          pattern = "\\.tex$", full.names = TRUE)
for (f in table_files) {
  nm <- basename(f)
  for (project in c("overleaf", "health_did_replication")) {
    target <- file.path(base_dir, project, "Tables", nm)
    if (!file.exists(target)) {
      add_check("tables", paste(project, nm), "WARN", "not copied", target)
    } else {
      add_check("tables", paste(project, nm),
                if (file_equal(f, target)) "PASS" else "FAIL",
                "must match output/tables byte-for-byte", target)
    }
  }
}

figure_map <- data.frame(
  src = c(
    "figure_4_1_aggregate_scatter_dynamic.pdf",
    "figure_4_2_density_z_dynamic.pdf",
    "figure_4_3_variation_pct_dynamic.pdf",
    "figure_4_4_panel_event_study_6cases.pdf",
    "figure_4_5_panel_binning_76.pdf",
    "figure_4_7_density_covariates.pdf",
    "figure_4_8_panel_controls_133.pdf",
    "figure_4_9_graduated_sensitivity.pdf",
    "figure_4_1_aggregate_scatter_matched.pdf",
    "figure_4_1_headline_composite.pdf",
    "figure_4_1_signif_matrix.pdf",
    "figure_4_3_variation_pct_matched.pdf",
    "figure_4_X_bacon_dcdh_maclean.pdf",
    "figure_4_8_mvpf_stress_test.pdf",
    "figure_4_8_mvpf_stress_test_panelA.pdf",
    "figure_4_8_mvpf_stress_test_panelB.pdf",
    "figure_4_10_sensitivity_210.pdf"
  ),
  dst = c(
    "agregado/agregado_dynamic_v3.pdf",
    "agregado/density_z_dynamic.pdf",
    "agregado/variacao_pct_dynamic.pdf",
    "agregado/panel_es_6cases.pdf",
    "agregado/panel_binning_76.pdf",
    "agregado/density_covariates_zscore.pdf",
    "agregado/panel_csdid_controls_133.pdf",
    "agregado/panel_graduated_sensitivity.pdf",
    "agregado/figure_4_1_aggregate_scatter_matched.pdf",
    "agregado/figure_4_1_headline_composite.pdf",
    "agregado/figure_4_1_signif_matrix.pdf",
    "agregado/variacao_pct_matched.pdf",
    "bacon/figure_4_X_bacon_dcdh_maclean.pdf",
    "figure_4_8_mvpf_stress_test.pdf",
    "figure_4_8_mvpf_stress_test_panelA.pdf",
    "figure_4_8_mvpf_stress_test_panelB.pdf",
    "sensitivity/event_study_sensitivity_210.pdf"
  ),
  stringsAsFactors = FALSE
)
for (i in seq_len(nrow(figure_map))) {
  src <- file.path(base_dir, "output", "figures", figure_map$src[i])
  for (project in c("overleaf", "health_did_replication")) {
    dst <- file.path(base_dir, project, "Figures", figure_map$dst[i])
    if (!file.exists(src)) {
      add_check("figures", paste("source", figure_map$src[i]), "WARN",
                "source figure not present in output/figures", src)
    } else if (!file.exists(dst)) {
      add_check("figures", paste(project, figure_map$dst[i]), "WARN",
                "mapped figure not copied", dst)
    } else {
      add_check("figures", paste(project, figure_map$dst[i]),
                if (file_equal(src, dst)) "PASS" else "FAIL",
                "must match mapped output/figures file byte-for-byte", dst)
    }
  }
}

# ---------------------------------------------------------------------------
# LaTeX references: every included table/figure should exist.
# ---------------------------------------------------------------------------
extract_refs <- function(tex_files, pattern) {
  refs <- character()
  for (f in tex_files) {
    x <- readLines(f, warn = FALSE, encoding = "UTF-8")
    x <- x[!grepl("^\\s*%", x)]
    m <- gregexpr(pattern, x, perl = TRUE)
    hits <- regmatches(x, m)
    for (line_hits in hits) {
      if (length(line_hits) == 0) next
      refs <- c(refs, sub(".*\\{([^}]+)\\}.*", "\\1", line_hits))
    }
  }
  unique(refs)
}

overleaf_tex <- c(list.files(file.path(base_dir, "overleaf", "Chapters"),
                             pattern = "\\.tex$", full.names = TRUE),
                  list.files(file.path(base_dir, "overleaf", "Appendices"),
                             pattern = "\\.tex$", full.names = TRUE))
table_refs <- extract_refs(overleaf_tex, "\\\\input\\{([^}]+)\\}")
table_refs <- table_refs[grepl("^Tables/", table_refs)]
for (r in table_refs) {
  check_exists("latex", paste("overleaf", r), file.path(base_dir, "overleaf", r))
  check_exists("latex", paste("working-paper", r),
               file.path(base_dir, "health_did_replication", r))
}

fig_refs <- extract_refs(overleaf_tex,
                         "\\\\includegraphics(?:\\[[^]]*\\])?\\{([^}]+)\\}")
fig_refs <- fig_refs[grepl("^Figures/", fig_refs)]
for (r in fig_refs) {
  check_exists("latex", paste("overleaf", r), file.path(base_dir, "overleaf", r))
  check_exists("latex", paste("working-paper", r),
               file.path(base_dir, "health_did_replication", r))
}

# ---------------------------------------------------------------------------
# DCAS documentation checks
# ---------------------------------------------------------------------------
readme <- file.path(base_dir, "README.md")
das <- file.path(base_dir, "data_availability_statement.md")
check_exists("documentation", "README.md", readme)
check_exists("documentation", "data_availability_statement.md", das)
check_exists("documentation", "README PDF required by AEA/DCAS",
             file.path(base_dir, "README.pdf"), critical = FALSE)

if (file.exists(das)) {
  das_txt <- readLines(das, warn = FALSE, encoding = "UTF-8")
  placeholders <- grep("<LINK>", das_txt, fixed = TRUE, value = TRUE)
  add_check("documentation", "source links filled",
            if (length(placeholders) == 0) "PASS" else "WARN",
            sprintf("%d placeholder source links remain", length(placeholders)),
            das)
}

if (file.exists(readme)) {
  readme_txt <- readLines(readme, warn = FALSE, encoding = "UTF-8")
  old_fig48 <- any(grepl("Figure 4\\.8 \\(ID 133 conditional CS-DID\\)",
                         readme_txt))
  add_check("documentation", "README Figure 4.8 mapping",
            if (!old_fig48) "PASS" else "FAIL",
            "README should map Figure 4.8 to Lesson 8 MVPF panels, not the old ID 133 panel.",
            readme)
}

audit <- do.call(rbind, checks)
out_csv <- file.path(audit_dir, "reproducibility_audit.csv")
write.csv(audit, out_csv, row.names = FALSE)

summary <- table(audit$status)
cat("\nAudit summary:\n")
print(summary)
cat("Wrote", out_csv, "\n")

failures <- audit[audit$status == "FAIL", ]
if (nrow(failures) > 0) {
  cat("\nCritical failures:\n")
  print(failures[, c("scope", "item", "detail", "path")], row.names = FALSE)
  stop("Reproducibility audit failed.", call. = FALSE)
}

cat("\nDone: verify_reproducibility.R\n")
