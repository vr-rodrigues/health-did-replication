###############################################################################
# 03_margin_attribution.R
# Deliverable D7 (Pedro review): joint margin-attribution table showing the
# counterfactual contribution of each design margin to the average |β_TWFE - β_CS|
# gap. Output: table_4_7_margin_attribution.tex.
#
# Margins measurable from consolidated_results.csv + metadata:
#   • Covariate margin (TWFE side)     : T+  vs T0
#   • Covariate margin (CS side, Spec A): C+  vs C0     (clean-Spec-A papers only)
#   • Estimator margin (Spec A, matched): T+  vs C+
#   • Estimator margin (Spec B, unconditional): T0 vs C0
#   • Headline protocol gap (Spec C)   : T+  vs C0
#   • Control-group margin             : CS-NT vs CS-NYT (staggered only)
#   • Aggregation margin (dynamic)     : simple vs dynamic CS-DID aggregate
#   • Binning sensitivity (progressive): median |Δ| from Lesson 4 (21 papers)
#
# Notation: T+ = β_TWFE with paper's covariates; T0 = β_TWFE without;
#           C+ = β_CS-NT with matched ctrls (Spec A); C0 = β_CS-NT unconditional.
# All |Δ| statistics are scaled by |T+| so the numbers are comparable in
# "proportional gap" terms (share of the headline TWFE magnitude).
###############################################################################
suppressPackageStartupMessages({ library(jsonlite); library(dplyr) })
base_dir <- getwd()

consol <- read.csv(file.path(base_dir, "analysis/consolidated_results.csv"),
                   stringsAsFactors=FALSE)

# Metadata flags: which papers have TWFE controls / staggered adoption
meta_info <- lapply(as.character(consol$id), function(id) {
  f <- file.path(base_dir, "data/metadata", paste0(id, ".json"))
  if (!file.exists(f)) return(list(has_ctrls=NA, staggered=NA))
  m <- fromJSON(f)
  list(
    has_ctrls = isTRUE(length(m$variables$twfe_controls) > 0 &&
                       any(nchar(as.character(m$variables$twfe_controls)) > 0)),
    staggered = isTRUE(m$panel_setup$treatment_timing == "staggered"))
})
consol$has_ctrls <- vapply(meta_info, `[[`, logical(1), "has_ctrls")
consol$staggered <- vapply(meta_info, `[[`, logical(1), "staggered")

# Helper: compute abs proportional gap scaled by |T+| = |beta_twfe|
pgap <- function(a, b, denom) {
  x <- (a - b) / abs(denom)
  x[!is.finite(x)] <- NA
  abs(x)
}

# Extract columns
Tplus <- consol$beta_twfe
T0    <- consol$beta_twfe_no_ctrls
Cplus <- consol$att_cs_nt_with_ctrls_dyn  # Spec A dynamic
C0    <- consol$att_nt_dynamic            # Spec B/C dynamic unconditional
denom <- abs(Tplus)

# Clean-Spec-A mask (att!=0, SE!=NA, status=OK)
clean_A <- !is.na(consol$cs_nt_with_ctrls_status) &
           consol$cs_nt_with_ctrls_status == "OK" &
           !is.na(Cplus) & abs(Cplus) > 1e-9 &
           !is.na(consol$se_cs_nt_with_ctrls_dyn) &
           consol$se_cs_nt_with_ctrls_dyn > 0

# Control-group margin (staggered only, NT vs NYT)
NT_dyn  <- consol$att_nt_dynamic
NYT_dyn <- consol$att_nyt_dynamic

# Aggregation margin (CS-NT simple vs dynamic)
NT_sim  <- consol$att_nt_simple

# ── Compute each margin ──────────────────────────────────────────────────
margins <- list(
  list(lab = "Headline protocol gap (Spec~C)",
       src = "$\\hat\\beta^{\\text{TWFE}}_{+X}$ vs $\\widehat{ATT}^{\\text{CS}}_{-X}$",
       vals = pgap(Tplus, C0, Tplus),
       mask = TRUE),

  list(lab = "Estimator margin (Spec~A, matched)",
       src = "$\\hat\\beta^{\\text{TWFE}}_{+X}$ vs $\\widehat{ATT}^{\\text{CS}}_{+X}$",
       vals = pgap(Tplus, Cplus, Tplus),
       mask = clean_A),

  list(lab = "Estimator margin (Spec~B, unconditional)",
       src = "$\\hat\\beta^{\\text{TWFE}}_{-X}$ vs $\\widehat{ATT}^{\\text{CS}}_{-X}$",
       vals = pgap(T0, C0, Tplus),
       mask = consol$has_ctrls),

  list(lab = "Covariate margin (TWFE side)",
       src = "$\\hat\\beta^{\\text{TWFE}}_{+X}$ vs $\\hat\\beta^{\\text{TWFE}}_{-X}$",
       vals = pgap(Tplus, T0, Tplus),
       mask = consol$has_ctrls),

  list(lab = "Covariate margin (CS side)",
       src = "$\\widehat{ATT}^{\\text{CS}}_{+X}$ vs $\\widehat{ATT}^{\\text{CS}}_{-X}$",
       vals = pgap(Cplus, C0, Tplus),
       mask = clean_A),

  list(lab = "Control-group margin (NT vs NYT)",
       src = "$\\widehat{ATT}^{\\text{CS-NT}}$ vs $\\widehat{ATT}^{\\text{CS-NYT}}$",
       vals = pgap(NT_dyn, NYT_dyn, Tplus),
       mask = consol$staggered & !is.na(NYT_dyn)),

  list(lab = "Aggregation margin (simple vs dynamic)",
       src = "$\\widehat{ATT}^{\\text{CS-NT}}_{\\text{simple}}$ vs $\\widehat{ATT}^{\\text{CS-NT}}_{\\text{dynamic}}$",
       vals = pgap(NT_sim, NT_dyn, Tplus),
       mask = !is.na(NT_sim) & !is.na(NT_dyn))
)

# ── Build the table ──────────────────────────────────────────────────────
fmt_pct <- function(x) ifelse(is.na(x), "---", sprintf("%.1f\\%%", 100*x))

rows <- character()
for (m in margins) {
  v <- m$vals[m$mask]
  v <- v[is.finite(v)]
  n <- length(v)
  mean_ <- if (n == 0) NA else mean(v)
  med_  <- if (n == 0) NA else median(v)
  q75_  <- if (n == 0) NA else quantile(v, 0.75, names = FALSE)
  rows <- c(rows,
    sprintf("%s & %s & %d & %s & %s & %s \\\\",
            m$lab, m$src, n, fmt_pct(mean_), fmt_pct(med_), fmt_pct(q75_)))
}

# Append binning margin as an external reference (from Lesson 4)
rows <- c(rows, "\\addlinespace",
  "\\multicolumn{6}{@{}l}{\\textit{External reference (Lesson 4):}} \\\\",
  "Binning sensitivity & $\\hat\\beta_{k=0}$ vs $\\hat\\beta_{k_{\\max}}$ (progressive) & 21 & --- & 34.0\\%{}$^{\\ast}$ & --- \\\\")

out_dir <- file.path(base_dir, "output", "tables")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)

tex <- c(
  "% Auto-generated by code/tables/03_margin_attribution.R --- DO NOT EDIT BY HAND.",
  "\\begin{table}[htbp]",
  "\\centering",
  "\\small",
  "\\begin{threeparttable}",
  "\\caption{Joint margin-attribution decomposition of the TWFE vs.\\ CS-DID gap}",
  "\\label{tab:margin_attribution}",
  "\\begin{tabular*}{\\textwidth}{@{\\extracolsep{\\fill}}p{4.8cm} p{4.8cm} r r r r@{}}",
  "\\toprule",
  "\\textbf{Margin} & \\textbf{Source of variation} & $N$ & \\textbf{Mean} $|\\Delta|$ & \\textbf{Median} $|\\Delta|$ & \\textbf{$Q_{75}$} $|\\Delta|$ \\\\",
  "\\midrule",
  rows,
  "\\bottomrule",
  "\\end{tabular*}",
  "\\begin{tablenotes}[flushleft]",
  "\\footnotesize",
  "\\item \\textit{Notes}: Each row reports the distribution of the proportional absolute gap $|\\Delta| = |a - b|/|\\hat\\beta^{\\text{TWFE}}_{+X}|$ for the pair $(a,b)$ in column~2, across the $N$ papers where the pair is jointly estimable. Estimates are from the dynamic CS-DID aggregate. The headline protocol gap (first row) bundles the estimator-change and the covariate-change margins; rows 2--5 decompose it. Under a purely additive decomposition, the Spec~C gap should equal the sum of the Spec~B estimator margin and the TWFE-side covariate margin; deviations from additivity reflect interaction between the two margins and are visible in the joint distribution rather than in marginal means. The aggregation and control-group margins are alternative estimator-choice dimensions and are reported here for completeness; they are the identifying comparisons behind Lessons~6 and~9. $^{\\ast}$Binning-sensitivity median from Table~\\ref{tab:progbin_sensitivity}; the $N=21$ subsample excludes papers without a progressively-binned event study.",
  "\\end{tablenotes}",
  "\\end{threeparttable}",
  "\\end{table}")

outfile <- file.path(out_dir, "table_4_7_margin_attribution.tex")
writeLines(tex, outfile)
cat(sprintf("Written %d lines to %s\n", length(tex), outfile))

cat("\n===== Margin-attribution summary (console) =====\n")
for (m in margins) {
  v <- m$vals[m$mask]
  v <- v[is.finite(v)]
  cat(sprintf("  %-45s N=%3d mean=%5.1f%%  med=%5.1f%%  Q75=%5.1f%%\n",
              m$lab, length(v),
              100*mean(v, na.rm=TRUE), 100*median(v, na.rm=TRUE),
              100*quantile(v, 0.75, names=FALSE, na.rm=TRUE)))
}
