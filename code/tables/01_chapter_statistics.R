###############################################################################
# 01_chapter_statistics.R — Generate LaTeX tables for Chapters 3 and 4
#
# Writes 9 .tex files to output/tables/, each containing one \begin{table} block
# ready to \input{} from the chapter .tex files. Also prints the numbers to
# stdout for sanity checking, and copies the tables into overleaf/Tables/ and
# health_did_replication/Tables/ when those folders are present.
#
# Tables produced:
#   table_3_2_sample_detailed.tex       (Ch3 Table 2: design × data structure)
#   table_3_3_journal_final.tex         (Ch3 Table 3: journal distribution)
#   table_3_4_estimator_coverage.tex    (Ch3 Table 4: estimator coverage)
#   table_4_1_aggregate_concordance.tex (Ch4 Table 1: TWFE vs CS-DID)
#   table_4_2_timing_heterogeneity.tex  (Ch4 Table 2: divergence by timing)
#   table_4_3_bacon_summary.tex         (Ch4 Table 3: Bacon + dCdH decomposition)
#   table_4_4_progbin_sensitivity.tex   (Ch4 Table 4: progressive binning)
#   table_4_5_honestdid.tex             (Ch4 Table 5: HonestDiD summary)
#   table_4_6_aggte_comparison.tex      (Ch4 Table 6: classification across aggregations)
#
# Input:  analysis/consolidated_results.csv,
#         analysis/progbin_summary.csv,
#         analysis/honest_did_v3_summary.csv,
#         analysis/dcdh_weights_combined.csv,
#         data/metadata/*.json,
#         results/by_article/{id}/bacon.csv (27 articles).
###############################################################################
suppressPackageStartupMessages({
  library(jsonlite); library(dplyr); library(tidyr)
})

base_dir     <- getwd()
data_dir     <- file.path(base_dir, "data")
analysis_dir <- file.path(base_dir, "analysis")
results_dir  <- file.path(base_dir, "results", "by_article")
out_dir      <- file.path(base_dir, "output", "tables")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

# ─── Load metadata ──────────────────────────────────────────
meta_files <- list.files(file.path(data_dir, "metadata"),
                         pattern = "\\.json$", full.names = TRUE)
meta_rows <- list()
for (mf in meta_files) {
  m <- tryCatch(fromJSON(mf), error = function(e) NULL)
  if (is.null(m)) next
  id_str <- gsub("\\.json$", "", basename(mf))
  id_int <- suppressWarnings(as.integer(id_str))
  if (isTRUE(m$excluded_from_sample)) next   # 2026-04-19: skip 234,242,380 (paper-auditor FAIL, see metadata exclusion_reason)
  meta_rows[[length(meta_rows)+1]] <- data.frame(
    id = id_int, id_str = id_str,
    author_label   = ifelse(is.null(m$author_label), NA_character_, m$author_label),
    group_label    = ifelse(is.null(m$group_label),  NA_character_, m$group_label),
    journal        = ifelse(is.null(m$journal),      NA_character_, m$journal),
    data_structure = ifelse(is.null(m$panel_setup$data_structure),
                            NA_character_, m$panel_setup$data_structure),
    treatment_timing = ifelse(is.null(m$panel_setup$treatment_timing),
                              NA_character_, m$panel_setup$treatment_timing),
    has_event_study = ifelse(is.null(m$analysis$has_event_study), NA,
                             isTRUE(m$analysis$has_event_study)),
    run_csdid_nyt   = ifelse(is.null(m$analysis$run_csdid_nyt), NA,
                             isTRUE(m$analysis$run_csdid_nyt)),
    run_csdid_nt    = ifelse(is.null(m$analysis$run_csdid_nt), TRUE,
                             isTRUE(m$analysis$run_csdid_nt)),
    run_bacon       = ifelse(is.null(m$analysis$run_bacon), NA,
                             isTRUE(m$analysis$run_bacon)),
    run_sa          = ifelse(is.null(m$analysis$run_sa), TRUE,
                             isTRUE(m$analysis$run_sa)),
    run_gardner     = ifelse(is.null(m$analysis$run_gardner), TRUE,
                             isTRUE(m$analysis$run_gardner)),
    stringsAsFactors = FALSE)
}
meta_df <- bind_rows(meta_rows)
meta_df$ds <- ifelse(meta_df$data_structure %in% c("rcs", "repeated_cross_section"),
                     "RCS", "Panel")
meta_df$tt <- ifelse(meta_df$treatment_timing %in% c("unica", "single"),
                     "Single", "Staggered")

# ─── Load consolidated results ──────────────────────────────
con <- read.csv(file.path(analysis_dir, "consolidated_results.csv"),
                stringsAsFactors = FALSE)
con$id     <- suppressWarnings(as.integer(con$id))
meta_df$id <- suppressWarnings(as.integer(meta_df$id))
con <- con %>% select(-any_of(c("has_event_study", "treatment_timing",
                                "data_structure", "run_csdid_nyt",
                                "run_csdid_nt", "run_sa", "run_gardner",
                                "journal", "tt", "ds")))
con <- con %>% left_join(
  meta_df %>% select(id, tt, ds, journal, has_event_study,
                     run_csdid_nyt, run_csdid_nt, run_sa, run_gardner),
  by = "id")

con <- con %>% mutate(
  att_cs_dyn = coalesce(att_nt_dynamic, att_nyt_dynamic),
  se_cs_dyn  = coalesce(se_nt_dynamic,  se_nyt_dynamic),
  att_cs_grp = coalesce(att_csdid_nt,    att_csdid_nyt),
  se_cs_grp  = coalesce(se_csdid_nt,     se_csdid_nyt),
  att_cs     = coalesce(att_cs_dyn, att_cs_grp),
  se_cs      = coalesce(se_cs_dyn,  se_cs_grp))

crit <- 1.96
con <- con %>% mutate(
  sig_twfe  = !is.na(beta_twfe) & !is.na(se_twfe) & se_twfe > 0 &
              abs(beta_twfe / se_twfe) > crit,
  sig_cs    = !is.na(att_cs)    & !is.na(se_cs)   & se_cs   > 0 &
              abs(att_cs    / se_cs  ) > crit,
  same_sign = !is.na(beta_twfe) & !is.na(att_cs) & sign(beta_twfe) == sign(att_cs),
  delta_pct = (att_cs - beta_twfe) / abs(beta_twfe) * 100)

# =============================================================================
# HELPERS
# =============================================================================
write_tex <- function(filename, content) {
  path <- file.path(out_dir, filename)
  writeLines(content, path)
  cat("  wrote", path, "(", length(content), "lines)\n")
}
pct  <- function(x, n) sprintf("%.1f\\%%", 100 * x / n)
pct0 <- function(x)    sprintf("%.1f\\%%", 100 * x)

# =============================================================================
# TABLE 3.2 — Sample composition
# =============================================================================
t32 <- meta_df %>% count(tt, ds) %>%
       pivot_wider(names_from = ds, values_from = n, values_fill = 0L)
t32 <- bind_rows(t32 %>% filter(tt == "Staggered"),
                 t32 %>% filter(tt == "Single"))
for (c in c("Panel", "RCS")) if (!c %in% names(t32)) t32[[c]] <- 0L
t32 <- t32 %>% mutate(Total = Panel + RCS, pct = 100 * Total / sum(Total))
total_panel <- sum(t32$Panel); total_rcs <- sum(t32$RCS); total_n <- sum(t32$Total)

lines <- c(
  "% Auto-generated by code/tables/01_chapter_statistics.R — DO NOT EDIT BY HAND.",
  "\\begin{table}[!htbp]", "\\centering",
  "\\caption{Detailed sample composition by design type}",
  "\\label{tab:sample_detailed}",
  "\\begin{threeparttable}",
  "\\begin{tabular}{lcccc}",
  "\\toprule",
  "\\textbf{Adoption type} & \\textbf{Panel} & \\textbf{RCS} & \\textbf{Total} & \\textbf{\\% of sample} \\\\",
  "\\midrule")
for (i in seq_len(nrow(t32))) {
  label <- ifelse(t32$tt[i] == "Single", "One-time", t32$tt[i])
  lines <- c(lines, sprintf("%s & %d & %d & %d & %.1f\\%% \\\\",
                            label, t32$Panel[i], t32$RCS[i], t32$Total[i], t32$pct[i]))
}
lines <- c(lines, "\\midrule",
  sprintf("\\textbf{Total} & \\textbf{%d} & \\textbf{%d} & \\textbf{%d} & \\textbf{100.0\\%%} \\\\",
          total_panel, total_rcs, total_n),
  "\\bottomrule", "\\end{tabular}",
  "\\begin{tablenotes}[flushleft]", "\\footnotesize",
  "\\item Notes: ``Staggered'' indicates that different units adopt treatment at different points in time. ``RCS'' indicates \\emph{repeated cross-sections}. The combination of these two dimensions affects which estimators and diagnostics can be applied.",
  "\\end{tablenotes}", "\\end{threeparttable}", "\\end{table}")
write_tex("table_3_2_sample_detailed.tex", lines)

# =============================================================================
# TABLE 3.3 — Journal distribution
# =============================================================================
jdf <- meta_df %>% filter(!is.na(journal), journal != "") %>%
       count(journal, sort = TRUE) %>% mutate(pct = 100 * n / sum(n))
total_j <- sum(jdf$n)

lines <- c(
  "% Auto-generated by code/tables/01_chapter_statistics.R — DO NOT EDIT BY HAND.",
  "\\begin{table}[!htbp]", "\\centering",
  "\\caption{Distribution of the final sample by journal}",
  "\\label{tab:journal_final}",
  "\\begin{threeparttable}",
  "\\begin{tabular}{p{8.5cm}cc}",
  "\\toprule",
  "\\textbf{Journal} & \\textbf{Articles in sample} & \\textbf{\\%} \\\\",
  "\\midrule")
for (i in seq_len(nrow(jdf)))
  lines <- c(lines, sprintf("\\emph{%s} & %d & %.1f \\\\",
                            jdf$journal[i], jdf$n[i], jdf$pct[i]))
lines <- c(lines, "\\midrule",
  sprintf("\\textbf{Total} & \\textbf{%d} & \\textbf{100.0} \\\\", total_j),
  "\\bottomrule", "\\end{tabular}",
  "\\begin{tablenotes}[flushleft]", "\\footnotesize",
  "\\item Notes: This table reports the journals represented in the final sample of 56 reanalyzed articles.",
  "\\end{tablenotes}", "\\end{threeparttable}", "\\end{table}")
write_tex("table_3_3_journal_final.tex", lines)

# =============================================================================
# TABLE 3.4 — Estimator coverage
# =============================================================================
es <- con %>% mutate(
  has_twfe      = !is.na(beta_twfe),
  has_csnt_sta  = !is.na(att_csdid_nt),
  has_csnyt_sta = !is.na(att_csdid_nyt),
  has_csnt_dyn  = !is.na(att_nt_dynamic),
  has_csnyt_dyn = !is.na(att_nyt_dynamic),
  has_sa        = tt == "Staggered" & has_event_study & run_sa,
  has_gardner   = has_event_study & run_gardner)

panelA <- es %>% group_by(tt) %>%
  summarise(N = n(), twfe = sum(has_twfe),
            csnt = sum(has_csnt_sta | has_csnt_dyn),
            csnyt = sum(has_csnyt_sta | has_csnyt_dyn), .groups = "drop")
panelA_ds <- es %>% group_by(ds) %>%
  summarise(N = n(), twfe = sum(has_twfe),
            csnt = sum(has_csnt_sta | has_csnt_dyn),
            csnyt = sum(has_csnyt_sta | has_csnyt_dyn), .groups = "drop")
panelA_tot <- c(N = nrow(es), twfe = sum(es$has_twfe),
                csnt = sum(es$has_csnt_sta | es$has_csnt_dyn),
                csnyt = sum(es$has_csnyt_sta | es$has_csnyt_dyn))

es_sub <- es %>% filter(has_event_study)
panelB <- es_sub %>% group_by(tt) %>%
  summarise(N = n(), twfe = sum(has_twfe), csnt = sum(has_csnt_dyn),
            csnyt = sum(has_csnyt_dyn), gardner = sum(has_gardner),
            sa = sum(has_sa), .groups = "drop")
panelB_ds <- es_sub %>% group_by(ds) %>%
  summarise(N = n(), twfe = sum(has_twfe), csnt = sum(has_csnt_dyn),
            csnyt = sum(has_csnyt_dyn), gardner = sum(has_gardner),
            sa = sum(has_sa), .groups = "drop")
panelB_tot <- c(N = nrow(es_sub), twfe = sum(es_sub$has_twfe),
                csnt = sum(es_sub$has_csnt_dyn),
                csnyt = sum(es_sub$has_csnyt_dyn),
                gardner = sum(es_sub$has_gardner),
                sa = sum(es_sub$has_sa))

row_stag_A   <- panelA %>% filter(tt == "Staggered")
row_single_A <- panelA %>% filter(tt == "Single")
row_panel_A  <- panelA_ds %>% filter(ds == "Panel")
row_rcs_A    <- panelA_ds %>% filter(ds == "RCS")
row_stag_B   <- panelB %>% filter(tt == "Staggered")
row_single_B <- panelB %>% filter(tt == "Single")
row_panel_B  <- panelB_ds %>% filter(ds == "Panel")
row_rcs_B    <- panelB_ds %>% filter(ds == "RCS")

fmt_a <- function(r) sprintf("%d & %d & %d & %d & --- & ---", r$N, r$twfe, r$csnt, r$csnyt)
fmt_b <- function(r) sprintf("%d & %d & %d & %d & %d & %d", r$N, r$twfe, r$csnt, r$csnyt, r$gardner, r$sa)

lines <- c(
  "% Auto-generated by code/tables/01_chapter_statistics.R — DO NOT EDIT BY HAND.",
  "\\begin{table}[!htbp]", "\\centering",
  "\\caption{Estimator coverage under the dissertation protocol}",
  "\\label{tab:estimator_coverage}",
  "\\begin{threeparttable}",
  "\\begin{tabular}{lcccccc}",
  "\\toprule",
  " & $N$ & \\textbf{TWFE} & \\textbf{CS-NT} & \\textbf{CS-NYT} & \\textbf{Gardner} & \\textbf{SA} \\\\",
  "\\midrule",
  "\\multicolumn{7}{l}{\\emph{Panel A --- Static benchmark estimates}} \\\\[2pt]",
  sprintf("One-time adoption  & %s \\\\", fmt_a(row_single_A)),
  sprintf("Staggered adoption & %s \\\\", fmt_a(row_stag_A)),
  "\\addlinespace",
  sprintf("Panel              & %s \\\\", fmt_a(row_panel_A)),
  sprintf("RCS                & %s \\\\", fmt_a(row_rcs_A)),
  "\\addlinespace",
  sprintf("\\textbf{Total}     & \\textbf{%d} & \\textbf{%d} & \\textbf{%d} & \\textbf{%d} & --- & --- \\\\",
          panelA_tot["N"], panelA_tot["twfe"], panelA_tot["csnt"], panelA_tot["csnyt"]),
  "\\midrule",
  "\\multicolumn{7}{l}{\\emph{Panel B --- Event-study estimates}} \\\\[2pt]",
  sprintf("One-time adoption  & %s \\\\", fmt_b(row_single_B)),
  sprintf("Staggered adoption & %s \\\\", fmt_b(row_stag_B)),
  "\\addlinespace",
  sprintf("Panel              & %s \\\\", fmt_b(row_panel_B)),
  sprintf("RCS                & %s \\\\", fmt_b(row_rcs_B)),
  "\\addlinespace",
  sprintf("\\textbf{Total}     & \\textbf{%d} & \\textbf{%d} & \\textbf{%d} & \\textbf{%d} & \\textbf{%d} & \\textbf{%d} \\\\",
          panelB_tot["N"], panelB_tot["twfe"], panelB_tot["csnt"], panelB_tot["csnyt"],
          panelB_tot["gardner"], panelB_tot["sa"]),
  "\\bottomrule", "\\end{tabular}",
  "\\begin{tablenotes}[flushleft]", "\\footnotesize",
  {
    cs_nyt_onetime <- as.integer(row_single_A$csnyt)
    cs_nyt_clause <- if (cs_nyt_onetime > 0)
      sprintf("CS-NYT is estimated for %d staggered and %d one-time-adoption articles; in the latter, it coincides with CS-NT by construction.",
              as.integer(row_stag_A$csnyt), cs_nyt_onetime)
    else
      sprintf("CS-NYT is estimated for %d staggered articles; for one-time-adoption designs it is not reported separately because it coincides with CS-NT by construction.",
              as.integer(row_stag_A$csnyt))
    paste0(
      "\\item Notes: Panel~A reports the number of articles included in the static benchmark analysis. Under the protocol of this paper, static comparisons are based on TWFE, CS-NT, and CS-NYT, with CS-DID as the main modern benchmark. Gardner (\\texttt{did2s}) and SA (Sun \\& Abraham) are not reported in Panel~A because they are used here only in the dynamic analysis. Panel~B reports the number of articles for which each estimator produces an event study, conditional on the article having an estimable pre-treatment path (",
      as.integer(panelB_tot["N"]), " of ", as.integer(panelA_tot["N"]),
      "). CS-NT could not be estimated in ",
      as.integer(row_stag_A$N) - as.integer(row_stag_A$csnt),
      " staggered-adoption articles due to the absence of a never-treated group or matrix singularity. ", cs_nyt_clause,
      " SA applies only to staggered-adoption settings; in ",
      as.integer(row_stag_B$N) - as.integer(row_stag_B$sa),
      " articles it could not be estimated for computational or specification reasons. Within each panel, the adoption-type and data-structure rows classify the same articles along different dimensions and should not be summed.")
  },
  "\\end{tablenotes}", "\\end{threeparttable}", "\\end{table}")
write_tex("table_3_4_estimator_coverage.tex", lines)

# =============================================================================
# TABLE 4.1 — Aggregate concordance
# =============================================================================
n <- nrow(con)
row_same  <- sum(con$same_sign,  na.rm = TRUE)
row_rev   <- sum(!con$same_sign, na.rm = TRUE)
row_ss    <- sum(con$sig_twfe  &  con$sig_cs)
row_si    <- sum(con$sig_twfe  & !con$sig_cs)
row_is    <- sum(!con$sig_twfe &  con$sig_cs)
row_ii    <- sum(!con$sig_twfe & !con$sig_cs)
row_50    <- sum(abs(con$delta_pct) > 50,  na.rm = TRUE)
row_100   <- sum(abs(con$delta_pct) > 100, na.rm = TRUE)
n_fallback_group <- sum(is.na(con$att_cs_dyn) & !is.na(con$att_cs_grp))

lines <- c(
  "% Auto-generated by code/tables/01_chapter_statistics.R — DO NOT EDIT BY HAND.",
  "\\begin{table}[htbp]", "\\centering",
  "\\caption{Aggregate comparison between TWFE and CS-DID}",
  "\\label{tab:ch3_aggregate_concordance}",
  "\\begin{threeparttable}",
  "\\begin{tabular}{lcc}",
  "\\toprule",
  "Comparison outcome & Count & Share \\\\",
  "\\midrule",
  sprintf("Same sign & %d & %s \\\\", row_same, pct(row_same, n)),
  sprintf("Sign reversal & %d & %s \\\\", row_rev,  pct(row_rev, n)),
  sprintf("Significant $\\rightarrow$ significant & %d & %s \\\\", row_ss, pct(row_ss, n)),
  sprintf("Significant $\\rightarrow$ insignificant & %d & %s \\\\", row_si, pct(row_si, n)),
  sprintf("Insignificant $\\rightarrow$ significant & %d & %s \\\\", row_is, pct(row_is, n)),
  sprintf("Insignificant $\\rightarrow$ insignificant & %d & %s \\\\", row_ii, pct(row_ii, n)),
  sprintf("$|\\Delta| > 50\\%%$ & %d & %s \\\\",  row_50,  pct(row_50, n)),
  sprintf("$|\\Delta| > 100\\%%$ & %d & %s \\\\", row_100, pct(row_100, n)),
  "\\bottomrule", "\\end{tabular}",
  "\\begin{tablenotes}[flushleft]", "\\footnotesize",
  sprintf(paste0(
    "\\item Notes: The CS-DID benchmark uses the dynamic aggregate, with the \\textit{never-treated} group when available and \\textit{not-yet-treated} otherwise. ",
    "For %s article%s without a dynamic aggregate, the group average is used instead. ",
    "The proportional change is defined as $\\Delta = (\\hat\\beta_{CS} - \\hat\\beta_{TWFE}) / |\\hat\\beta_{TWFE}|$."),
    if (n_fallback_group == 0) "no" else
    if (n_fallback_group == 1) "one" else
    if (n_fallback_group == 2) "two" else
    if (n_fallback_group == 3) "three" else
    if (n_fallback_group == 4) "four" else
    if (n_fallback_group == 5) "five" else as.character(n_fallback_group),
    ifelse(n_fallback_group == 1, "", "s")),
  "\\end{tablenotes}", "\\end{threeparttable}", "\\end{table}")
write_tex("table_4_1_aggregate_concordance.tex", lines)

# =============================================================================
# TABLE 4.2 — Divergence by timing
# =============================================================================
single <- con %>% filter(tt == "Single")
stag   <- con %>% filter(tt == "Staggered")

lines <- c(
  "% Auto-generated by code/tables/01_chapter_statistics.R — DO NOT EDIT BY HAND.",
  "\\begin{table}[htbp]", "\\centering",
  "\\caption{Aggregate divergence by the temporal structure of adoption}",
  "\\label{tab:ch3_timing_heterogeneity}",
  "\\begin{threeparttable}",
  "\\begin{tabular}{lcc}",
  "\\toprule",
  "Metric & One-time adoption & Staggered adoption \\\\",
  "\\midrule",
  sprintf("Number of articles & %d & %d \\\\", nrow(single), nrow(stag)),
  sprintf("Sign concordance & %s & %s \\\\",
          pct0(mean(single$same_sign, na.rm=TRUE)),
          pct0(mean(stag$same_sign,   na.rm=TRUE))),
  sprintf("Sign reversal & %s & %s \\\\",
          pct0(mean(!single$same_sign, na.rm=TRUE)),
          pct0(mean(!stag$same_sign,   na.rm=TRUE))),
  sprintf("Significant $\\rightarrow$ insignificant & %s & %s \\\\",
          pct0(mean(single$sig_twfe & !single$sig_cs, na.rm=TRUE)),
          pct0(mean(stag$sig_twfe   & !stag$sig_cs,   na.rm=TRUE))),
  sprintf("Insignificant $\\rightarrow$ significant & %s & %s \\\\",
          pct0(mean(!single$sig_twfe & single$sig_cs, na.rm=TRUE)),
          pct0(mean(!stag$sig_twfe   & stag$sig_cs,   na.rm=TRUE))),
  sprintf("Median proportional change & $%.1f\\%%$ & $%.1f\\%%$ \\\\",
          median(single$delta_pct, na.rm=TRUE),
          median(stag$delta_pct,   na.rm=TRUE)),
  sprintf("Mean proportional change & $%.1f\\%%$ & $%.1f\\%%$ \\\\",
          mean(single$delta_pct, na.rm=TRUE),
          mean(stag$delta_pct,   na.rm=TRUE)),
  sprintf("Share with $|\\Delta| > 50\\%%$ & %s & %s \\\\",
          pct0(mean(abs(single$delta_pct) > 50,  na.rm=TRUE)),
          pct0(mean(abs(stag$delta_pct)   > 50,  na.rm=TRUE))),
  sprintf("Share with $|\\Delta| > 100\\%%$ & %s & %s \\\\",
          pct0(mean(abs(single$delta_pct) > 100, na.rm=TRUE)),
          pct0(mean(abs(stag$delta_pct)   > 100, na.rm=TRUE))),
  "\\bottomrule", "\\end{tabular}",
  "\\begin{tablenotes}[flushleft]", "\\footnotesize",
  "\\item Notes: $\\Delta = (\\hat\\beta_{CS} - \\hat\\beta_{TWFE}) / |\\hat\\beta_{TWFE}|$. The CS-DID benchmark uses the dynamic aggregate.",
  "\\end{tablenotes}", "\\end{threeparttable}", "\\end{table}")
write_tex("table_4_2_timing_heterogeneity.tex", lines)

# =============================================================================
# TABLE 4.3 — Bacon + dCdH
# =============================================================================
stag_ids <- meta_df %>% filter(tt == "Staggered") %>% pull(id_str)
bacon_files <- file.path(results_dir, stag_ids, "bacon.csv")
bacon_files <- bacon_files[file.exists(bacon_files)]
bacon_summary <- lapply(bacon_files, function(f) {
  b <- tryCatch(read.csv(f, stringsAsFactors = FALSE), error = function(e) NULL)
  if (is.null(b)) return(NULL)
  total_w <- sum(b$weight, na.rm = TRUE); if (total_w == 0) return(NULL)
  tvt_w   <- sum(b$weight[grepl("Earlier|Later", b$type)], na.rm = TRUE)
  data.frame(id = basename(dirname(f)), tvt_share = tvt_w / total_w)
})
bacon_df      <- bind_rows(bacon_summary)
bacon_n       <- nrow(bacon_df)
bacon_mean    <- mean(bacon_df$tvt_share, na.rm = TRUE)
bacon_gt50_n  <- sum(bacon_df$tvt_share > 0.5,           na.rm = TRUE)
bacon_eq100_n <- sum(abs(bacon_df$tvt_share - 1) < 1e-9, na.rm = TRUE)
stag_total    <- length(stag_ids)
bacon_excl_n  <- stag_total - bacon_n

dcdh_df <- tryCatch(read.csv(file.path(analysis_dir, "dcdh_weights_combined.csv"),
                              stringsAsFactors = FALSE),
                    error = function(e) NULL)
if (!is.null(dcdh_df)) {
  candidates <- c("share_negative", "share_neg", "negative_share", "neg_share")
  neg_col <- candidates[candidates %in% names(dcdh_df)][1]
  if (is.na(neg_col)) {
    nm <- names(dcdh_df)
    hit <- nm[grepl("share", nm, ignore.case = TRUE) & grepl("neg", nm, ignore.case = TRUE)]
    if (length(hit) > 0) neg_col <- hit[1]
  }
  if (is.na(neg_col) && all(c("sum_positive", "sum_negative") %in% names(dcdh_df))) {
    dcdh_df$share_neg_derived <- abs(dcdh_df$sum_negative) /
      (abs(dcdh_df$sum_negative) + dcdh_df$sum_positive)
    neg_col <- "share_neg_derived"
  }
  dcdh_n      <- nrow(dcdh_df)
  dcdh_any    <- sum(dcdh_df[[neg_col]] > 0,        na.rm = TRUE)
  dcdh_mean   <- mean(dcdh_df[[neg_col]],            na.rm = TRUE)
  dcdh_median <- median(dcdh_df[[neg_col]],          na.rm = TRUE)
  dcdh_max    <- max(dcdh_df[[neg_col]],             na.rm = TRUE)
} else {
  dcdh_n <- dcdh_any <- dcdh_mean <- dcdh_median <- dcdh_max <- NA
}

lines <- c(
  "% Auto-generated by code/tables/01_chapter_statistics.R — DO NOT EDIT BY HAND.",
  "\\begin{table}[htbp]", "\\centering",
  "\\begin{threeparttable}",
  "\\caption{Diagnostic decompositions of the TWFE estimator (staggered articles)}",
  "\\label{tab:bacon_summary}",
  "\\small",
  "\\begin{tabular}{lc}",
  "\\toprule",
  "\\textbf{Statistic} & \\textbf{Value} \\\\",
  "\\midrule",
  sprintf("\\multicolumn{2}{l}{\\textit{Bacon decomposition ($N = %d$)}} \\\\", bacon_n),
  sprintf("\\quad Mean treated-vs-treated share & %.3f \\\\", bacon_mean),
  sprintf("\\quad Articles with TvT $> 50\\%%$ & %d / %d (%.0f\\%%) \\\\[6pt]",
          bacon_gt50_n, bacon_n, 100*bacon_gt50_n/bacon_n),
  sprintf("\\multicolumn{2}{l}{\\textit{de Chaisemartin--d'Haultfoeuille weights ($N = %s$)}} \\\\",
          ifelse(is.na(dcdh_n), "--", as.character(dcdh_n))),
  sprintf("\\quad Articles with any negative weight & %s / %s (%s) \\\\",
          ifelse(is.na(dcdh_any), "--", as.character(dcdh_any)),
          ifelse(is.na(dcdh_n),   "--", as.character(dcdh_n)),
          ifelse(is.na(dcdh_any) | is.na(dcdh_n), "--", sprintf("%.0f\\%%", 100*dcdh_any/dcdh_n))),
  sprintf("\\quad Mean share of negative weights & %s \\\\",
          ifelse(is.na(dcdh_mean), "--", sprintf("%.3f", dcdh_mean))),
  sprintf("\\quad Median share of negative weights & %s \\\\",
          ifelse(is.na(dcdh_median), "--", sprintf("%.3f", dcdh_median))),
  sprintf("\\quad Maximum share of negative weights & %s \\\\",
          ifelse(is.na(dcdh_max), "--", sprintf("%.3f", dcdh_max))),
  "\\bottomrule", "\\end{tabular}",
  "\\begin{tablenotes}[flushleft]", "\\footnotesize",
  sprintf(paste0(
    "\\item \\textit{Notes}: The Bacon decomposition \\citep{goodman2021difference} partitions the TWFE estimator into $2\\times2$ comparisons; treated-vs-treated (TvT) includes ``Earlier vs Later'' and ``Later vs Earlier'' comparisons, where already-treated units serve as controls. ",
    "%d article%s have TvT $= 100\\%%$, meaning all units are eventually treated and the entire TWFE estimate relies on timing variation. ",
    "The de Chaisemartin--d'Haultfoeuille decomposition \\citep{de2020two} expresses TWFE as a weighted sum of group--time ATTs; share of negative weights $= |\\Sigma\\,\\omega^{-}| \\,/\\, (|\\Sigma\\,\\omega^{-}| + \\Sigma\\,\\omega^{+})$.%s%s"),
    bacon_eq100_n, ifelse(bacon_eq100_n == 1, "", "s"),
    if (bacon_excl_n > 0)
      sprintf(" %d staggered article%s %s excluded from the Bacon computation due to panel size exceeding computational limits or lack of treatment variation in the balanced panel.",
              bacon_excl_n, ifelse(bacon_excl_n == 1, "", "s"),
              ifelse(bacon_excl_n == 1, "is", "are"))
    else "",
    if (!is.na(dcdh_n) && (stag_total - dcdh_n) > 0)
      sprintf(" %d %s excluded from the dCdH computation due to complex multi-file data construction.",
              stag_total - dcdh_n, ifelse((stag_total - dcdh_n) == 1, "is", "are"))
    else ""),
  "\\end{tablenotes}", "\\end{threeparttable}", "\\end{table}")
write_tex("table_4_3_bacon_summary.tex", lines)

# =============================================================================
# TABLE 4.4 — Progressive binning
# =============================================================================
progbin <- tryCatch(read.csv(file.path(analysis_dir, "progbin_summary.csv"),
                              stringsAsFactors = FALSE),
                    error = function(e) NULL)
if (!is.null(progbin) && nrow(progbin) > 0) {
  col <- names(progbin)
  id_col   <- grep("^id$|article|paper", col, value = TRUE, ignore.case = TRUE)[1]
  ds_col   <- grep("^ds$|design|data_structure|structure", col, value = TRUE, ignore.case = TRUE)[1]
  k0_col   <- grep("k_?0|beta_k0|k0", col, value = TRUE, ignore.case = TRUE)[1]
  kmax_col <- grep("k_?max|beta_kmax", col, value = TRUE, ignore.case = TRUE)[1]
  kn_col   <- grep("^k_?max_?val|^kmax$|^k$", col, value = TRUE, ignore.case = TRUE)[1]
  d_col    <- grep("delta|change_pct|pct_change", col, value = TRUE, ignore.case = TRUE)[1]
  sig_col  <- grep("^sig$|^significant$|_sig$|^is_sig", col, value = TRUE, ignore.case = TRUE)[1]
  auth_col <- grep("author|cite|biblio|textcite|ref|label", col, value = TRUE, ignore.case = TRUE)[1]

  progbin$.id     <- progbin[[id_col]]
  progbin$.ds     <- if (!is.na(ds_col))   progbin[[ds_col]]   else NA_character_
  progbin$.k0     <- if (!is.na(k0_col))   progbin[[k0_col]]   else NA_real_
  progbin$.kmax   <- if (!is.na(kmax_col)) progbin[[kmax_col]] else NA_real_
  progbin$.kn     <- if (!is.na(kn_col))   progbin[[kn_col]]   else NA_integer_
  progbin$.delta  <- if (!is.na(d_col))    progbin[[d_col]]    else NA_real_
  progbin$.sig    <- if (!is.na(sig_col))  progbin[[sig_col]]  else
                       (!is.na(progbin$.k0) & !is.na(progbin[["k0_se"]]) &
                        progbin[["k0_se"]] > 0 & abs(progbin$.k0 / progbin[["k0_se"]]) > 1.96)
  progbin$.author <- if (!is.na(auth_col)) progbin[[auth_col]] else as.character(progbin$.id)
  progbin <- progbin %>% arrange(.delta)

  n_articles <- nrow(progbin)
  median_abs_delta <- median(abs(progbin$.delta), na.rm = TRUE)
  share_gt20 <- sum(abs(progbin$.delta) > 20, na.rm = TRUE)
  share_gt50 <- sum(abs(progbin$.delta) > 50, na.rm = TRUE)
  sig_rows <- which(isTRUE(progbin$.sig) | progbin$.sig == TRUE | progbin$.sig == "TRUE" |
                    progbin$.sig == 1)
  n_sig <- length(sig_rows)
  median_abs_delta_sig <- if (n_sig > 0)
    median(abs(progbin$.delta[sig_rows]), na.rm = TRUE) else NA
  share_sig_gt20 <- if (n_sig > 0)
    sum(abs(progbin$.delta[sig_rows]) > 20, na.rm = TRUE) else 0

  lines <- c(
    "% Auto-generated by code/tables/01_chapter_statistics.R — DO NOT EDIT BY HAND.",
    "\\begin{table}[htbp]", "\\centering",
    "\\caption{Sensitivity of the far-post bin coefficient to progressive binning}",
    "\\label{tab:progbin_sensitivity}",
    "\\small",
    "\\begin{tabular}{lccccr}",
    "\\toprule",
    "Article & Design & $\\hat\\beta_{k=0}$ & $\\hat\\beta_{k_{\\max}}$ & $k_{\\max}$ & $\\Delta$ \\\\",
    "\\midrule")
  for (i in seq_len(nrow(progbin))) {
    sig_val <- progbin$.sig[i]
    is_sig <- isTRUE(sig_val) || identical(sig_val, TRUE) ||
              identical(sig_val, "TRUE") || identical(sig_val, 1)
    dag <- if (is_sig) "" else "\\textsuperscript{\\dag}"
    author_tx <- progbin$.author[i]
    if (!grepl("\\\\textcite|\\\\cite", author_tx))
      author_tx <- sprintf("\\textcite{%s}", author_tx)
    lines <- c(lines, sprintf(
      "%s%s & %s & $%+.3f$ & $%+.3f$ & %s & $%+.0f\\%%$ \\\\",
      author_tx, dag,
      ifelse(is.na(progbin$.ds[i]), "---", as.character(progbin$.ds[i])),
      progbin$.k0[i], progbin$.kmax[i],
      ifelse(is.na(progbin$.kn[i]), "---", as.character(progbin$.kn[i])),
      progbin$.delta[i]))
  }
  lines <- c(lines,
    "\\midrule",
    sprintf("\\multicolumn{5}{l}{\\textit{Summary (all %d articles)}} \\\\", n_articles),
    sprintf("\\multicolumn{3}{l}{\\quad Median $|\\Delta|$} & \\multicolumn{3}{r}{%.0f\\%%} \\\\",
            median_abs_delta),
    sprintf("\\multicolumn{3}{l}{\\quad Share $|\\Delta| > 20\\%%$} & \\multicolumn{3}{r}{%.0f\\%% (%d/%d)} \\\\",
            100*share_gt20/n_articles, share_gt20, n_articles),
    sprintf("\\multicolumn{3}{l}{\\quad Share $|\\Delta| > 50\\%%$} & \\multicolumn{3}{r}{%.0f\\%% (%d/%d)} \\\\",
            100*share_gt50/n_articles, share_gt50, n_articles),
    "\\addlinespace",
    sprintf("\\multicolumn{5}{l}{\\textit{Summary excl.\\ \\dag\\ articles (%d articles, $\\hat\\beta_{k=0}$ significant)}} \\\\",
            n_sig),
    sprintf("\\multicolumn{3}{l}{\\quad Median $|\\Delta|$} & \\multicolumn{3}{r}{%s} \\\\",
            ifelse(is.na(median_abs_delta_sig), "---",
                   sprintf("%.0f\\%%", median_abs_delta_sig))),
    sprintf("\\multicolumn{3}{l}{\\quad Share $|\\Delta| > 20\\%%$} & \\multicolumn{3}{r}{%.0f\\%% (%d/%d)} \\\\",
            ifelse(n_sig == 0, 0, 100*share_sig_gt20/n_sig), share_sig_gt20, n_sig),
    "\\bottomrule", "\\end{tabular}", "",
    "\\footnotesize",
    paste0("\\textit{Notes:} $\\Delta = (\\hat\\beta_{k_{\\max}} - \\hat\\beta_{k_0}) / |\\hat\\beta_{k_0}|$. ",
           "At $k = 0$ the far-post bin contains only the endpoint period and treated observations outside the event window are excluded; at $k_{\\max}$ the bin absorbs all available horizons. ",
           "Controls are restricted to the calendar-time range of the remaining treated observations at each $k$. ",
           "\\dag~indicates $\\hat\\beta_{k=0}$ is not statistically significant at the 5\\% level; percentage changes for these articles are mechanically large and should be interpreted with caution."),
    "\\end{table}")
  write_tex("table_4_4_progbin_sensitivity.tex", lines)
} else {
  cat("  [SKIP] table_4_4_progbin_sensitivity.tex — progbin_summary.csv missing/empty\n")
}

# =============================================================================
# TABLE 4.5 — HonestDiD
# =============================================================================
hd <- tryCatch(read.csv(file.path(analysis_dir, "honest_did_v3_summary.csv"),
                         stringsAsFactors = FALSE),
               error = function(e) NULL)
if (!is.null(hd) && nrow(hd) > 0) {
  # Long format: columns id, estimator, vcov_type, rm_first_Mbar, rm_peak_Mbar.
  # Keep the canonical per-estimator row: TWFE with vcov_type="full",
  # CS-NT (fallback CS-NYT) with vcov_type="full_IF".
  hd_twfe <- hd[hd$estimator == "TWFE" & hd$vcov_type == "full", ]
  hd_cs   <- hd[grepl("^CS", hd$estimator) & hd$vcov_type == "full_IF", ]
  # Dedup: keep first row per id (CS-NT preferred over CS-NYT when both exist)
  hd_cs   <- hd_cs[!duplicated(hd_cs$id), ]

  f_twfe_v <- hd_twfe$rm_first_Mbar
  f_cs_v   <- hd_cs$rm_first_Mbar
  p_twfe_v <- hd_twfe$rm_peak_Mbar
  p_cs_v   <- hd_cs$rm_peak_Mbar

  safe_mean <- function(x) if (length(x) == 0) NA else mean(x,   na.rm=TRUE)
  safe_med  <- function(x) if (length(x) == 0) NA else median(x, na.rm=TRUE)
  safe_eq0  <- function(x) if (length(x) == 0) NA else mean(x == 0, na.rm=TRUE)
  safe_gt0  <- function(x) if (length(x) == 0) NA else mean(x >  0, na.rm=TRUE)
  count_rel <- function(twfe_col, cs_col, op) {
    # Merge TWFE and CS values by id for paired comparison.
    both <- merge(
      data.frame(id = hd_twfe$id, t = twfe_col),
      data.frame(id = hd_cs$id,   c = cs_col), by = "id")
    both <- both[!is.na(both$t) & !is.na(both$c), ]
    switch(op,
           gt = sum(both$t > both$c),
           lt = sum(both$t < both$c),
           eq = sum(both$t == both$c))
  }
  # Aliases so the existing printf lines keep working:
  f_twfe <- TRUE; f_cs <- TRUE; p_twfe <- TRUE; p_cs <- TRUE
  # Override safe_* to use pre-bound vectors for those 4 calls:
  safe_mean_wrap <- function(which) safe_mean(switch(which,
    ft = f_twfe_v, fc = f_cs_v, pt = p_twfe_v, pc = p_cs_v))
  safe_med_wrap  <- function(which) safe_med(switch(which,
    ft = f_twfe_v, fc = f_cs_v, pt = p_twfe_v, pc = p_cs_v))
  safe_eq0_wrap  <- function(which) safe_eq0(switch(which,
    ft = f_twfe_v, fc = f_cs_v, pt = p_twfe_v, pc = p_cs_v))
  safe_gt0_wrap  <- function(which) safe_gt0(switch(which,
    ft = f_twfe_v, fc = f_cs_v, pt = p_twfe_v, pc = p_cs_v))
  fmt3 <- function(x) ifelse(is.na(x), "---", sprintf("%.3f", x))
  fmtp <- function(x) ifelse(is.na(x), "---", sprintf("%.1f\\%%", 100*x))

  lines <- c(
    "% Auto-generated by code/tables/01_chapter_statistics.R — DO NOT EDIT BY HAND.",
    "\\begin{table}[htbp]", "\\centering",
    "\\caption{Sensitivity of dynamic effects to violations of parallel trends}",
    "\\label{tab:ch3_honestdid}",
    "\\begin{threeparttable}",
    "\\begin{tabular*}{0.75\\textwidth}{@{\\extracolsep{\\fill}}lcc@{}}",
    "\\toprule",
    "\\textbf{Metric} & \\textbf{TWFE} & \\textbf{CS-DID} \\\\",
    "\\midrule",
    "\\multicolumn{3}{l}{\\textit{First post-treatment period}} \\\\",
    sprintf("\\quad Mean $\\bar M$ & %s & %s \\\\", fmt3(safe_mean_wrap("ft")), fmt3(safe_mean_wrap("fc"))),
    sprintf("\\quad Median $\\bar M$ & %s & %s \\\\", fmt3(safe_med_wrap("ft")), fmt3(safe_med_wrap("fc"))),
    sprintf("\\quad Share with $\\bar M = 0$ & %s & %s \\\\", fmtp(safe_eq0_wrap("ft")), fmtp(safe_eq0_wrap("fc"))),
    sprintf("\\quad Share with $\\bar M > 0$ & %s & %s \\\\", fmtp(safe_gt0_wrap("ft")), fmtp(safe_gt0_wrap("fc"))),
    "\\addlinespace",
    "\\multicolumn{3}{l}{\\textit{Peak post-treatment effect}} \\\\",
    sprintf("\\quad Mean $\\bar M$ & %s & %s \\\\", fmt3(safe_mean_wrap("pt")), fmt3(safe_mean_wrap("pc"))),
    sprintf("\\quad Median $\\bar M$ & %s & %s \\\\", fmt3(safe_med_wrap("pt")), fmt3(safe_med_wrap("pc"))),
    sprintf("\\quad Share with $\\bar M = 0$ & %s & %s \\\\", fmtp(safe_eq0_wrap("pt")), fmtp(safe_eq0_wrap("pc"))),
    sprintf("\\quad Share with $\\bar M > 0$ & %s & %s \\\\", fmtp(safe_gt0_wrap("pt")), fmtp(safe_gt0_wrap("pc"))),
    "\\bottomrule", "\\end{tabular*}",
    "", "\\vspace{0.4cm}", "",
    "\\begin{tabular*}{0.75\\textwidth}{@{\\extracolsep{\\fill}}lccc@{}}",
    "\\toprule",
    "\\textbf{Post period} & \\textbf{TWFE $>$ CS} & \\textbf{TWFE $<$ CS} & \\textbf{TWFE $=$ CS} \\\\",
    "\\midrule",
    sprintf("First & %s & %s & %s \\\\",
            count_rel(f_twfe_v, f_cs_v, "gt"), count_rel(f_twfe_v, f_cs_v, "lt"), count_rel(f_twfe_v, f_cs_v, "eq")),
    sprintf("Peak & %s & %s & %s \\\\",
            count_rel(p_twfe_v, p_cs_v, "gt"), count_rel(p_twfe_v, p_cs_v, "lt"), count_rel(p_twfe_v, p_cs_v, "eq")),
    "\\bottomrule", "\\end{tabular*}",
    "\\begin{tablenotes}[flushleft]", "\\footnotesize",
    "\\item \\textit{Notes}: Higher values of $\\bar M$ indicate that the empirical conclusion survives larger departures from exact parallel trends.",
    "\\end{tablenotes}", "\\end{threeparttable}", "\\end{table}")
  write_tex("table_4_5_honestdid.tex", lines)
} else {
  cat("  [SKIP] table_4_5_honestdid.tex — honest_did_v3_summary.csv missing/empty\n")
}

# =============================================================================
# TABLE 4.6 — Aggregation comparison
# =============================================================================
classify <- function(att_cs, se_cs, beta_twfe, se_twfe) {
  keep <- !is.na(beta_twfe) & !is.na(se_twfe) & se_twfe > 0
  att_cs <- att_cs[keep]; se_cs <- se_cs[keep]
  beta   <- beta_twfe[keep]; se_w <- se_twfe[keep]
  has_cs <- !is.na(att_cs) & !is.na(se_cs) & se_cs > 0
  att_cs <- att_cs[has_cs]; se_cs <- se_cs[has_cs]
  beta   <- beta[has_cs];   se_w  <- se_w[has_cs]
  sig_t <- abs(beta  / se_w ) > 1.96
  sig_c <- abs(att_cs / se_cs) > 1.96
  same  <- sign(beta) == sign(att_cs)
  cat <- character(length(beta))
  cat[ same  &  sig_t &  sig_c] <- "Concordant"
  cat[ same  &  sig_t & !sig_c] <- "Significance loss"
  cat[ same  & !sig_t &  sig_c] <- "Significance gain"
  cat[!same  & ( sig_t |  sig_c)] <- "Sign reversal (>=1 sig.)"
  cat[!same  & !sig_t & !sig_c] <- "Sign reversal (both insig.)"
  cat[ same  & !sig_t & !sig_c] <- "Both insignificant"
  list(total = length(beta), counts = table(cat))
}
c_dyn <- classify(con$att_cs_dyn, con$se_cs_dyn, con$beta_twfe, con$se_twfe)
c_grp <- classify(con$att_cs_grp, con$se_cs_grp, con$beta_twfe, con$se_twfe)
con <- con %>% mutate(att_cs_simple = coalesce(att_nt_simple, att_nyt_simple),
                       se_cs_simple  = coalesce(se_nt_simple,  se_nyt_simple))
c_sim <- classify(con$att_cs_simple, con$se_cs_simple, con$beta_twfe, con$se_twfe)

cell <- function(cls, key) {
  x <- as.integer(cls$counts[key]); if (is.na(x)) 0L else x
}
row_tex <- function(label, key)
  sprintf("%s & %d & %d & %d \\\\", label,
          cell(c_dyn, key), cell(c_grp, key), cell(c_sim, key))

lines <- c(
  "% Auto-generated by code/tables/01_chapter_statistics.R — DO NOT EDIT BY HAND.",
  "\\begin{table}[htbp]", "\\centering",
  "\\caption{Classification of the TWFE vs.\\ CS-DID comparison under each aggregation type}",
  "\\label{tab:ch3_aggte_comparison}",
  "\\begin{threeparttable}",
  "\\begin{tabular}{lccc}",
  "\\toprule",
  "Category & Dynamic & Group & Simple \\\\",
  "\\midrule",
  row_tex("Concordant",                    "Concordant"),
  row_tex("Significance loss",             "Significance loss"),
  row_tex("Significance gain",             "Significance gain"),
  row_tex("Sign reversal ($\\geq$1 sig.)", "Sign reversal (>=1 sig.)"),
  row_tex("Sign reversal (both insig.)",   "Sign reversal (both insig.)"),
  row_tex("Both insignificant",            "Both insignificant"),
  "\\midrule",
  sprintf("Total & %d & %d & %d \\\\", c_dyn$total, c_grp$total, c_sim$total),
  "\\bottomrule", "\\end{tabular}",
  "\\begin{tablenotes}[flushleft]", "\\footnotesize",
  sprintf(paste0(
    "\\item Notes: Each column classifies the comparison between the original TWFE estimate and the CS-DID ATT under the indicated aggregation type. ",
    "``Concordant'': same sign, both significant or both insignificant. ",
    "``Significance loss'': same sign, TWFE significant but CS-DID not. ",
    "``Sign reversal ($\\geq$1 sig.)'': opposite signs and at least one individually significant at 5\\%%. ",
    "CS-DID uses the never-treated control group (not-yet-treated as fallback). ",
    "%d article%s lack the simple aggregation, giving $n=%d$ in that column."),
    c_dyn$total - c_sim$total,
    ifelse((c_dyn$total - c_sim$total) == 1, "", "s"),
    c_sim$total),
  "\\end{tablenotes}", "\\end{threeparttable}", "\\end{table}")
write_tex("table_4_6_aggte_comparison.tex", lines)

# =============================================================================
# Console summary + sync to LaTeX projects
# =============================================================================
cat("\n===== KEY NUMBERS FOR CHAPTER BODY TEXT =====\n")
cat(sprintf("Chapter 4 opening: preserved in %d cases and reverses in %d\n", row_same, row_rev))
w <- con %>% filter(same_sign, !is.na(se_twfe), !is.na(se_cs), se_twfe > 0, se_cs > 0)
cat(sprintf("Median CS SE / TWFE SE (same-sign subset): %.2f\n",
            median(w$se_cs / w$se_twfe, na.rm = TRUE)))
cat(sprintf("|Delta|>50%%: %.1f%%  |  |Delta|>100%%: %.1f%%\n",
            100*mean(abs(con$delta_pct) > 50,  na.rm=TRUE),
            100*mean(abs(con$delta_pct) > 100, na.rm=TRUE)))

sync_tables <- function(dest_dir) {
  if (!dir.exists(dest_dir)) return(invisible(FALSE))
  dir.create(file.path(dest_dir, "Tables"), recursive = TRUE, showWarnings = FALSE)
  tex_files <- list.files(out_dir, pattern = "^table_.*\\.tex$", full.names = TRUE)
  for (f in tex_files) file.copy(f, file.path(dest_dir, "Tables", basename(f)),
                                  overwrite = TRUE)
  cat(sprintf("  synced %d table(s) -> %s/Tables/\n", length(tex_files), dest_dir))
}
cat("\n===== Syncing tables to Overleaf folders =====\n")
sync_tables(file.path(base_dir, "overleaf"))
sync_tables(file.path(base_dir, "health_did_replication"))

cat("\n\nDone: 01_chapter_statistics.R\n")
