###############################################################################
# sync_final_outputs.R -- synchronize the single final reproduction track
#
# Source of truth:
#   - overleaf/Chapters and overleaf/Appendices are the manuscript text source.
#   - output/tables and output/figures are the computational artifact source.
#
# This script copies generated tables/figures into the two LaTeX project trees
# and rebuilds health_did_replication/main.tex from the Overleaf chapters.
###############################################################################

base_dir <- getwd()

copy_one <- function(src, dst) {
  if (!file.exists(src)) {
    cat("  [MISS]", src, "\n")
    return(FALSE)
  }
  dir.create(dirname(dst), recursive = TRUE, showWarnings = FALSE)
  ok <- file.copy(src, dst, overwrite = TRUE)
  cat(sprintf("  [%s] %s -> %s\n", if (ok) "OK" else "FAIL", src, dst))
  ok
}

sync_tables <- function(project_dir) {
  dest <- file.path(project_dir, "Tables")
  if (!dir.exists(project_dir)) return(invisible(FALSE))
  dir.create(dest, recursive = TRUE, showWarnings = FALSE)
  tex_files <- list.files(file.path(base_dir, "output", "tables"),
                          pattern = "\\.tex$", full.names = TRUE)
  ok <- vapply(tex_files, function(f) {
    copy_one(f, file.path(dest, basename(f)))
  }, logical(1))
  cat(sprintf("  synced %d/%d table files -> %s\n", sum(ok), length(ok), dest))
  invisible(all(ok))
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

sync_mapped_figures <- function(project_dir) {
  if (!dir.exists(project_dir)) return(invisible(FALSE))
  dest_root <- file.path(project_dir, "Figures")
  ok <- vapply(seq_len(nrow(figure_map)), function(i) {
    copy_one(file.path(base_dir, "output", "figures", figure_map$src[i]),
             file.path(dest_root, figure_map$dst[i]))
  }, logical(1))
  cat(sprintf("  synced %d/%d mapped figures -> %s\n",
              sum(ok), length(ok), dest_root))
  invisible(all(ok))
}

extract_graphics_refs <- function(tex_dir) {
  tex_files <- list.files(tex_dir, pattern = "\\.tex$", full.names = TRUE)
  refs <- character()
  for (f in tex_files) {
    x <- readLines(f, warn = FALSE, encoding = "UTF-8")
    x <- x[!grepl("^\\s*%", x)]
    m <- gregexpr("\\\\includegraphics(?:\\[[^]]*\\])?\\{([^}]+)\\}", x,
                  perl = TRUE)
    hits <- regmatches(x, m)
    for (line_hits in hits) {
      if (length(line_hits) == 0) next
      refs <- c(refs, sub(".*\\{([^}]+)\\}.*", "\\1", line_hits))
    }
  }
  unique(refs)
}

sync_referenced_appendix_figures <- function(project_dir) {
  if (!dir.exists(project_dir)) return(invisible(FALSE))
  refs <- extract_graphics_refs(file.path(base_dir, "overleaf", "Appendices"))
  refs <- refs[grepl("^Figures/(event_study|honestdid|bacon)/", refs)]
  if (length(refs) == 0) return(invisible(TRUE))
  ok <- logical(length(refs))
  for (i in seq_along(refs)) {
    rel <- sub("^Figures/", "", refs[i])
    output_rel <- rel
    output_rel <- sub("^event_study/", "appendix_event_studies/", output_rel)
    output_rel <- sub("^honestdid/", "appendix_honestdid/", output_rel)
    output_rel <- sub("^bacon/", "appendix_bacon/", output_rel)
    src <- file.path(base_dir, "output", "figures", output_rel)
    dst <- file.path(project_dir, refs[i])
    ok[i] <- copy_one(src, dst)
  }
  cat(sprintf("  synced %d/%d referenced appendix figures -> %s\n",
              sum(ok), length(ok), project_dir))
  invisible(all(ok))
}

promote_headings <- function(lines) {
  replacements <- c(
    "\\\\subsubsection\\*" = "__L4STAR__",
    "\\\\subsubsection\\{" = "__L4__{",
    "\\\\subsection\\*" = "__L3STAR__",
    "\\\\subsection\\{" = "__L3__{",
    "\\\\section\\*" = "__L2STAR__",
    "\\\\section\\{" = "__L2__{",
    "\\\\chapter\\*" = "__L1STAR__",
    "\\\\chapter\\{" = "__L1__{"
  )
  for (pat in names(replacements)) {
    lines <- gsub(pat, replacements[[pat]], lines, perl = TRUE)
  }
  replacements2 <- c(
    "__L1__" = "\\\\section",
    "__L1STAR__" = "\\\\section*",
    "__L2__" = "\\\\subsection",
    "__L2STAR__" = "\\\\subsection*",
    "__L3__" = "\\\\subsubsection",
    "__L3STAR__" = "\\\\subsubsection*",
    "__L4__" = "\\\\paragraph",
    "__L4STAR__" = "\\\\paragraph*"
  )
  for (pat in names(replacements2)) {
    lines <- gsub(pat, replacements2[[pat]], lines, fixed = TRUE)
  }
  lines
}

write_utf8 <- function(path, lines) {
  dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
  con <- file(path, open = "w", encoding = "UTF-8")
  on.exit(close(con), add = TRUE)
  writeLines(lines, con = con, useBytes = TRUE)
}

rebuild_working_paper <- function() {
  wp_main <- file.path(base_dir, "health_did_replication", "main.tex")
  if (!file.exists(wp_main)) {
    cat("  [SKIP] health_did_replication/main.tex not found\n")
    return(invisible(FALSE))
  }

  main_lines <- readLines(wp_main, warn = FALSE, encoding = "UTF-8")
  main_start <- grep("^%.*MAIN TEXT", main_lines)[1]
  ref_start  <- grep("^%.*REFERENCES", main_lines)[1]
  if (is.na(main_start) || is.na(ref_start)) {
    stop("Cannot rebuild working paper: MAIN TEXT or REFERENCES marker missing.")
  }
  preamble <- main_lines[seq_len(main_start - 1)]
  tail <- main_lines[ref_start:length(main_lines)]

  chapter_lines <- character()
  for (n in 1:5) {
    src <- file.path(base_dir, "overleaf", "Chapters", sprintf("Chapter%d.tex", n))
    chapter_lines <- c(chapter_lines,
                       promote_headings(readLines(src, warn = FALSE,
                                                  encoding = "UTF-8")),
                       "")
  }

  rebuilt <- c(
    preamble,
    "",
    "%======================================================================",
    "%  MAIN TEXT (chapters 1-5 of the dissertation, inlined)",
    "%======================================================================",
    "",
    chapter_lines,
    tail
  )
  write_utf8(wp_main, rebuilt)
  cat(sprintf("  rebuilt %s (%d lines)\n", wp_main, length(rebuilt)))

  for (letter in LETTERS[1:5]) {
    src <- file.path(base_dir, "overleaf", "Appendices",
                     sprintf("Appendix%s.tex", letter))
    dst <- file.path(base_dir, "health_did_replication",
                     sprintf("Appendix%s.tex", letter))
    if (file.exists(src)) {
      write_utf8(dst, promote_headings(readLines(src, warn = FALSE,
                                                encoding = "UTF-8")))
      cat(sprintf("  promoted appendix %s -> %s\n", src, dst))
    }
  }
  invisible(TRUE)
}

cat("\n=== Syncing generated tables ===\n")
sync_tables(file.path(base_dir, "overleaf"))
sync_tables(file.path(base_dir, "health_did_replication"))

cat("\n=== Syncing generated figures ===\n")
sync_mapped_figures(file.path(base_dir, "overleaf"))
sync_mapped_figures(file.path(base_dir, "health_did_replication"))
sync_referenced_appendix_figures(file.path(base_dir, "overleaf"))
sync_referenced_appendix_figures(file.path(base_dir, "health_did_replication"))

cat("\n=== Rebuilding working-paper TeX from Overleaf source ===\n")
rebuild_working_paper()

cat("\nDone: sync_final_outputs.R\n")
