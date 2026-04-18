##############################################################################
# 02_article_cards.R
# Generates Format B LaTeX article cards for the dissertation appendix.
# Each card is ~1/3 page; 3 cards per page; ~19 pages total for 56 articles.
#
# Inputs:
#   analysis/consolidated_results.csv
#   analysis/article_cards.csv
#   analysis/honest_did_v3_summary.csv
#   analysis/decision_log.csv
#
# Output:
#   output/tables/appendix_article_cards.tex  (standalone LaTeX file, \input-able)
##############################################################################

library(dplyr)
library(tidyr)
library(stringr)

# Run from replication package root.
base_dir     <- getwd()
analysis_dir <- file.path(base_dir, "analysis")

# ── 1. Load data sources ─────────────────────────────────────────────────────

consol <- read.csv(file.path(analysis_dir, "consolidated_results.csv"),
                   stringsAsFactors = FALSE)

cards  <- read.csv(file.path(analysis_dir, "article_cards.csv"),
                   stringsAsFactors = FALSE)

honest <- read.csv(file.path(analysis_dir, "honest_did_v3_summary.csv"),
                   stringsAsFactors = FALSE)

dlog   <- read.csv(file.path(analysis_dir, "decision_log.csv"),
                   stringsAsFactors = FALSE)

# ── 2. Journal mapping (audited 2026-04-08 against first page of each PDF) ──

journal_map <- data.frame(
  id = c(9, 21, 25, 44, 47, 60, 61, 65, 68, 76, 79, 80, 97, 125, 133,
         147, 201, 210, 213, 228, 233, 234, 241, 242, 253, 254, 262,
         263, 267, 271, 281, 290, 304, 305, 309, 311, 321, 323, 333,
         335, 337, 347, 358, 359, 380, 395, 401, 419, 420, 432, 433,
         437, 525, 744, 1094, 2303),
  journal = c(
    "AEJ: Applied Economics",      # 9   Dranove (2021)        AEJ:AE 13(1)
    "AEJ: Economic Policy",        # 21  Buchmueller (2018)    AEJ:EP 10(1)
    "AEJ: Economic Policy",        # 25  Carrillo (2019)       AEJ:EP 11(3)
    "AEJ: Economic Policy",        # 44  Bosch (2014)          AEJ:EP 6(4)
    "AEJ: Applied Economics",      # 47  Clemens (2015)        AEJ:AE 7(2)
    "AEJ: Economic Policy",        # 60  Schmitt (2018)        AEJ:EP 10(3)
    "AEJ: Economic Policy",        # 61  Evans (2014)          AEJ:EP 6(2)
    "AEJ: Economic Policy",        # 65  Akosa Antwi (2013)    AEJ:EP 5(4)
    "AEJ: Economic Policy",        # 68  Tanaka (2014)         AEJ:EP 6(3)
    "AEJ: Applied Economics",      # 76  Lawler (2023)         AEJ:AE 15(4)
    "AEJ: Economic Policy",        # 79  Carpenter (2019)      AEJ:EP 11(1)
    "AEJ: Economic Policy",        # 80  Marcus (2022)         AEJ:EP 14(3)
    "AEJ: Economic Policy",        # 97  Bhalotra (2021)       AEJ:EP 13(4)
    "AEJ: Economic Policy",        # 125 Levine (2011)         AEJ:EP 3
    "AEJ: Economic Policy",        # 133 Hoynes (2015)         AEJ:EP 7(1)
    "American Economic Review",    # 147 Greenstone (2014)     AER 104(10)
    "J. Health Economics",         # 201 Maclean (2025)        JHE 103
    "J. Health Economics",         # 210 Li (2026)             JHE 105
    "J. Human Resources",          # 213 Estrada (2024)        JHR (online 2024)
    "J. Public Economics",         # 228 Sarmiento (2023)      JPubE 227
    "AEJ: Economic Policy",        # 233 Kresch (2020)         AEJ:EP 12(3)
    "J. Political Economy",        # 234 Myers (2017)          JPE 125(6)
    "AEJ: Economic Policy",        # 241 Soliman (2025)        AEJ:EP 17(4)
    "AJ Health Economics",         # 242 Moorthy (2025)        AJHE (2025)
    "Rev. Econ. Statistics",       # 253 Bancalari (2024)      ReStat
    "Rev. Econ. Statistics",       # 254 Gandhi (2024)         ReStat
    "Rev. Econ. Statistics",       # 262 Anderson (2024)       ReStat
    "AEJ: Applied Economics",      # 263 Axbard (2024)         AEJ:AE 16(1)
    "J. European Econ. Assoc.",    # 267 Bhalotra (2023)       JEEA 21(5)
    "AEJ: Applied Economics",      # 271 Sekhri (2024)         AEJ:AE 16(4)
    "J. Development Economics",    # 281 Steffens (2025)       JDE 174
    "AJ Health Economics",         # 290 Arbogast (2024)       AJHE 10(2)
    "AEJ: Applied Economics",      # 304 Arthi (2022)          AEJ:AE 14(2)
    "Rev. Econ. Statistics",       # 305 Brodeur (2020)        ReStat
    "Rev. Econ. Statistics",       # 309 Johnson (2024)        ReStat
    "Rev. Econ. Statistics",       # 311 Galasso (2024)        ReStat 106(6)
    "Rev. Econ. Statistics",       # 321 Xu (2023)             ReStat
    "Rev. Econ. Statistics",       # 323 Prem (2023)           ReStat
    "J. Health Economics",         # 333 Clarke (2021)         JHE
    "Rev. Econ. Statistics",       # 335 Le Moglie (2022)      ReStat
    "Q. J. Economics",             # 337 Cameron (2021)        QJE 136(1)
    "J. European Econ. Assoc.",    # 347 Courtemanche (2025)   JEEA
    "J. Development Economics",    # 358 Bargain (2019)        JDE
    "AEJ: Applied Economics",      # 359 Anderson (2019)       AEJ:AE
    "AEJ: Economic Policy",        # 380 Kuziemko (2018)       AEJ:EP
    "Rev. Econ. Statistics",       # 395 Malkova (2018)        ReStat 100(4)
    "AEJ: Applied Economics",      # 401 Rossin-Slater (2017)  AEJ:AE 9(2)
    "AEJ: Economic Policy",        # 419 Kahn (2015)           AEJ:EP 7(4)
    "American Economic Review",    # 420 Bailey (2015)         AER 105(3)
    "AEJ: Applied Economics",      # 432 Gallagher (2014)      AEJ:AE 6(3)
    "AEJ: Economic Policy",        # 433 DeAngelo (2014)       AEJ:EP 6(2)
    "AEJ: Economic Policy",        # 437 Hausman (2014)        AEJ:EP
    "AEJ: Economic Policy",        # 525 Danzer (2023)         AEJ:EP
    "AEJ: Applied Economics",      # 744 Jayachandran (2010)   AEJ:AE 2(2)
    "AEJ: Applied Economics",      # 1094 Fisman (2017)        AEJ:AE
    "J. Development Economics"     # 2303 Cao (2023)           JDE
  ),
  stringsAsFactors = FALSE
)

# ── 3. Prepare HonestDiD: pick best row per estimator per article ────────────
#    TWFE: vcov_type == "full"
#    CS:   vcov_type == "full_IF"  (official approach)

honest_twfe <- honest %>%
  filter(estimator == "TWFE", vcov_type == "full") %>%
  select(id, rm_first_Mbar_twfe = rm_first_Mbar,
         rm_peak_Mbar_twfe = rm_peak_Mbar)

honest_cs <- honest %>%
  filter(grepl("^CS", estimator), vcov_type == "full_IF") %>%
  group_by(id) %>%
  slice(1) %>%
  ungroup() %>%
  select(id, cs_estimator = estimator,
         rm_first_Mbar_cs = rm_first_Mbar,
         rm_peak_Mbar_cs  = rm_peak_Mbar)

honest_merged <- full_join(honest_twfe, honest_cs, by = "id")

# ── 4. Prepare decision log ──────────────────────────────────────────────────

dlog_clean <- dlog %>%
  filter(tractable %in% c("yes", "approx")) %>%
  select(id = result_id, rule, rationale, citation, collapse)

# ── 5. Merge everything ─────────────────────────────────────────────────────
# Note: consol already has treatment_timing, data_structure, has_event_study.
# Cards has more detailed versions. Use cards' versions with suffix.

df <- consol %>%
  left_join(cards %>% select(id, title, outcome, treatment_twfe,
                              twfe_controls, cs_controls, additional_fes,
                              card_data_structure = data_structure,
                              card_treatment_timing = treatment_timing,
                              card_has_es = has_event_study,
                              event_pre, event_post,
                              run_csdid_nt, run_csdid_nyt, notes),
            by = "id") %>%
  left_join(journal_map, by = "id") %>%
  left_join(honest_merged, by = "id") %>%
  left_join(dlog_clean, by = "id")

# ── 6. Helper: compute significance stars ────────────────────────────────────

sig_stars <- function(beta, se) {
  if (is.na(beta) | is.na(se) | se == 0) return("")
  p <- 2 * pnorm(-abs(beta / se))
  if (p < 0.001) return("***")
  if (p < 0.01)  return("**")
  if (p < 0.05)  return("*")
  if (p < 0.10)  return("\\dag")
  return("")
}

# ── 7. Helper: smart number formatting ───────────────────────────────────────

fmt_num <- function(x, digits = 3) {
  if (is.na(x)) return("---")
  abs_x <- abs(x)
  if (abs_x == 0) return("0.000")
  if (abs_x >= 100)  return(formatC(x, format = "f", digits = 1))
  if (abs_x >= 10)   return(formatC(x, format = "f", digits = 2))
  if (abs_x >= 0.0001) return(formatC(x, format = "f", digits = max(digits, 4)))
  # very small numbers: scientific
  return(formatC(x, format = "e", digits = 1))
}

# ── 8. Helper: escape LaTeX special chars ────────────────────────────────────

esc <- function(x) {
  if (is.na(x) || x == "") return("---")
  x <- gsub("_", "\\_", x, fixed = TRUE)
  x <- gsub("%", "\\%", x, fixed = TRUE)
  x <- gsub("&", "\\&", x, fixed = TRUE)
  x <- gsub("#", "\\#", x, fixed = TRUE)
  x <- gsub("\\$", "\\$", x, fixed = TRUE)
  x
}

# ── 9. Helper: concordance assessment ────────────────────────────────────────

concordance <- function(beta_twfe, se_twfe, beta_cs, se_cs) {
  if (is.na(beta_twfe) | is.na(beta_cs)) return("N/A (estimator unavailable)")

  same_sign <- sign(beta_twfe) == sign(beta_cs)

  p_twfe <- 2 * pnorm(-abs(beta_twfe / se_twfe))
  p_cs   <- 2 * pnorm(-abs(beta_cs / se_cs))
  sig_twfe <- p_twfe < 0.05
  sig_cs   <- p_cs < 0.05

  if (same_sign & sig_twfe & sig_cs) return("Sign \\checkmark, Sig. \\checkmark")
  if (same_sign & !sig_twfe & !sig_cs) return("Sign \\checkmark, both insig.")
  if (same_sign & (sig_twfe != sig_cs)) {
    if (sig_twfe) return("Sign \\checkmark, TWFE sig./CS insig.")
    return("Sign \\checkmark, TWFE insig./CS sig.")
  }
  if (!same_sign & !sig_twfe & !sig_cs) return("Sign differs, both insig.")
  return("Sign reversal (one sig.)")
}

# ── 10. Helper: truncate controls string ─────────────────────────────────────

trunc_controls <- function(x, max_chars = 70) {
  if (is.na(x) || x == "" || x == "NA") return("None")
  x_esc <- esc(x)
  if (nchar(x_esc) > max_chars) {
    n_vars <- length(strsplit(x, ";")[[1]])
    first_three <- paste(head(strsplit(x, ";\\s*")[[1]], 3), collapse = "; ")
    return(paste0(esc(first_three), " (+ ", n_vars - 3, " more)"))
  }
  x_esc
}

# ── 11. Determine which CS estimator to report per article ───────────────────

df <- df %>%
  mutate(
    # Pick CS-NT if available, otherwise CS-NYT
    cs_label = case_when(
      !is.na(att_csdid_nt)  ~ "CS-NT",
      !is.na(att_csdid_nyt) ~ "CS-NYT",
      TRUE ~ NA_character_
    ),
    beta_cs = ifelse(!is.na(att_csdid_nt), att_csdid_nt, att_csdid_nyt),
    se_cs   = ifelse(!is.na(se_csdid_nt),  se_csdid_nt,  se_csdid_nyt)
  )

# ── 12. Generate LaTeX ──────────────────────────────────────────────────────

# Sort by ID
df <- df %>% arrange(id)

lines <- character()

# Preamble
lines <- c(lines,
  "% Auto-generated by code/tables/02_article_cards.R",
  "% Format B: Individual article cards (~1/3 page each)",
  "",
  "\\newcommand{\\articlecard}[1]{%",
  "  \\begin{tcolorbox}[",
  "    colback=white, colframe=black!60, boxrule=0.4pt,",
  "    arc=2pt, left=4pt, right=4pt, top=3pt, bottom=3pt,",
  "    fonttitle=\\small\\bfseries, title={}",
  "  ]",
  "  #1",
  "  \\end{tcolorbox}",
  "  \\vspace{2pt}",
  "}",
  "",
  "% Requires: \\usepackage{tcolorbox, booktabs, threeparttable}",
  "% in your main document preamble.",
  ""
)

for (i in seq_len(nrow(df))) {
  r <- df[i, ]

  # Author + journal line
  auth <- esc(r$author_label)
  jour <- ifelse(is.na(r$journal), "---", r$journal)

  # Outcome + protocol
  out_var  <- esc(r$outcome)
  rule_str <- ifelse(is.na(r$rule), "---", esc(r$rule))
  cit_str  <- ifelse(is.na(r$citation), "---", esc(r$citation))
  coll_str <- ifelse(is.na(r$collapse), "---", as.character(r$collapse))

  # Design — use card_ prefixed columns (from article_cards.csv)
  grp <- esc(r$group_label)
  ds  <- ifelse(is.na(r$card_data_structure) || r$card_data_structure == "",
                esc(r$data_structure), esc(r$card_data_structure))
  tt  <- ifelse(is.na(r$card_treatment_timing) || r$card_treatment_timing == "",
                esc(r$treatment_timing), esc(r$card_treatment_timing))
  ctrl <- trunc_controls(r$twfe_controls)
  fes  <- ifelse(is.na(r$additional_fes) || r$additional_fes == "" ||
                   r$additional_fes == "NA", "", paste0("Add. FEs: ", esc(r$additional_fes)))

  # Estimates
  b_twfe <- fmt_num(r$beta_twfe)
  s_twfe <- fmt_num(r$se_twfe)
  sig_tw <- sig_stars(r$beta_twfe, r$se_twfe)

  cs_lab <- ifelse(is.na(r$cs_label), "CS", r$cs_label)
  b_cs   <- fmt_num(r$beta_cs)
  s_cs   <- fmt_num(r$se_cs)
  sig_cs <- sig_stars(r$beta_cs, r$se_cs)

  # Concordance
  conc <- concordance(r$beta_twfe, r$se_twfe, r$beta_cs, r$se_cs)

  # HonestDiD
  hd_twfe <- ifelse(is.na(r$rm_peak_Mbar_twfe), "---",
                     formatC(r$rm_peak_Mbar_twfe, format = "f", digits = 2))
  hd_cs   <- ifelse(is.na(r$rm_peak_Mbar_cs), "---",
                     formatC(r$rm_peak_Mbar_cs, format = "f", digits = 2))

  # Event study — use card_has_es (from article_cards.csv), fallback to consol
  has_es <- r$card_has_es
  if (is.na(has_es) || has_es == "") has_es <- r$has_event_study
  es_str <- ifelse(as.character(has_es) %in% c("TRUE", "1", "true"),
                   paste0("Yes (", r$event_pre, " pre, ", r$event_post, " post)"),
                   "No")

  # Build card
  card <- paste0(
    "\\articlecard{%\n",
    "  \\footnotesize\n",
    "  \\textbf{", auth, "} \\hfill \\textit{", jour, "}\\\\[2pt]\n",
    "  \\tcbline\n",
    "  \\textbf{Outcome:} \\texttt{", out_var, "} \\hfill ",
    "\\textbf{Rule:} ", rule_str, "\\\\\n",
    "  \\textbf{Collapse:} ", coll_str, " \\hfill ",
    "\\textbf{Citation:} ", cit_str, "\\\\\n",
    "  \\tcbline\n",
    "  \\textbf{Design:} ", grp, " $\\cdot$ ", ds, " $\\cdot$ ", tt, "\\\\\n",
    "  \\textbf{Controls:} ", ctrl, "\\\\\n",
    ifelse(fes != "", paste0("  ", fes, "\\\\\n"), ""),
    "  \\tcbline\n",
    "  \\begin{tabular}{@{}lccc@{}}\n",
    "    & $\\hat{\\beta}$ & SE & \\\\\n",
    "    TWFE & $", b_twfe, "$ & $", s_twfe, "$ & ", sig_tw, " \\\\\n",
    "    ", cs_lab, " & $", b_cs, "$ & $", s_cs, "$ & ", sig_cs, " \\\\\n",
    "  \\end{tabular}\\\\\n",
    "  \\tcbline\n",
    "  \\textbf{Concordance:} ", conc, " \\hfill ",
    "\\textbf{ES:} ", es_str, "\\\\\n",
    "  \\textbf{HonestDiD} $\\bar{M}_{\\text{peak}}$: ",
    "TWFE = ", hd_twfe, ", ", cs_lab, " = ", hd_cs, "\n",
    "}\n"
  )

  lines <- c(lines, card, "")

  # Page break every 3 cards
  if (i %% 3 == 0 && i < nrow(df)) {
    lines <- c(lines, "\\clearpage", "")
  }
}

# Footnote at the end
lines <- c(lines,
  "",
  "\\vspace{6pt}",
  "\\noindent\\footnotesize\\textit{Notes:} ",
  "Stars: $^{***}p<0.001$, $^{**}p<0.01$, $^{*}p<0.05$, $^{\\dag}p<0.10$. ",
  "TWFE = two-way fixed effects. CS-NT = \\citet{callaway_santanna_2021} never-treated. ",
  "CS-NYT = not-yet-treated. ",
  "HonestDiD $\\bar{M}_{\\text{peak}}$ = breakdown value (relative magnitudes) for the peak post-treatment effect; ",
  "larger values indicate greater robustness to parallel-trends violations. ",
  "Rule = outcome selection protocol rule: (i) declared preference, (ii) largest $N$, ",
  "(iii) tiebreakers. Collapse = 1 if paper reports only event-study (no static ATT). ",
  "--- = data unavailable."
)

# Write output
out_dir <- file.path(base_dir, "output", "tables")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
outfile <- file.path(out_dir, "appendix_article_cards.tex")
writeLines(lines, outfile)
cat("Written", length(lines), "lines to", outfile, "\n")
cat("Articles:", nrow(df), "\n")
