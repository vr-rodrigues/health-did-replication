################################################################################
## mvpf_pilots.R
##
## MVPF welfare-analysis stress-test for Chapter 4.8.
##
## STRUCTURE:
##   Section 1 -- Three early pilots (id_133, id_61, id_9) run across all
##                available estimator specifications. Legacy / appendix material.
##                Do NOT use for headline claims: these pilots mix the
##                controls-matched and no-controls comparisons within the same
##                paper. The chapter-level welfare reading instead audits which
##                estimates are implementationally well-formed before using
##                them as MVPF inputs.
##
##   Section 2 -- Mechanical matched-control stress test for Chapter 4.8.
##                These estimates show the local welfare geometry, but the
##                chapter's preferred welfare reading comes from the
##                article-level implementation audit. Covers:
##                  id_9    Dranove et al. (2021)  -- G-channel, NON-Laffer zone
##                  id_420  Bailey & Goodman-Bacon (2015) -- G-channel, Laffer zone
##
## Output:
##   analysis/mvpf_pilot_results.csv      (legacy, all 3 early pilots)
##   analysis/mvpf_pilot_summary.csv      (legacy summary)
##   analysis/mvpf_stress_test.csv        (mechanical stress test for §4.8)
##   analysis/mvpf_stress_test_long.csv   (long form for figure)
################################################################################

suppressPackageStartupMessages({
  library(jsonlite)
})

base_dir <- getwd()

## ------------------------------------------------------------------
## Helper: read our pipeline's β for a given paper
## ------------------------------------------------------------------
read_betas <- function(id) {
  f <- file.path(base_dir, "results/by_article", id, "results.csv")
  if (!file.exists(f)) stop("results.csv not found for id ", id)
  read.csv(f, stringsAsFactors = FALSE)
}

## ------------------------------------------------------------------
## PILOT 1. id_133 -- Hoynes, Miller & Simon (2015)
## ------------------------------------------------------------------
## HSK Table II baseline EITC 1993 MVPF (kid_impact = "none"):
##   MVPF = WTP / G = 1.00 / 0.89 = 1.12 (with CI 0.96--1.11 widening via kids)
## Fiscal externality (FE) normalized to $1 of EITC programmatic spend:
##   G = 1 + FE with FE = -0.11 (policy pays back 11 cents per dollar)
##
## Our extension: add an infant-health WTP channel using HMS2015's β.
## The paper estimates β on (lowbirth x 100), i.e. pp change in LBW rate.
## We convert to dollar-equivalent WTP using:
##   - Cost per LBW birth averted ~ $50k (Almond, Doyle, Kowalski, Williams 2010,
##     who report $83k NICU in 1998 USD; we deflate & use $50k in 1996 USD as a
##     conservative midpoint of medical cost + partial lifetime earnings).
##   - Number of births per $1,000 of EITC per year among eligible mothers.
##     HMS2015 estimates β = -0.39 pp per $1,000 EITC (our TWFE with controls).
##     Using US vital statistics: EITC-eligible births per year ~ 1M; annual EITC
##     spend ~ $30B (1996). Per $1,000 EITC: roughly 0.033 births per $1,000.
##   - WTP_infant = 0.033 births * |β| * $50k per birth averted
##
## This is illustrative — the purpose is to show how β feeds the MVPF.
## ------------------------------------------------------------------

mvpf_eitc <- function(beta_lbw_pp, lbw_value_usd = 50000,
                      births_per_1k = 0.033,
                      hsk_baseline_wtp = 1.00,
                      hsk_baseline_G = 0.89) {
  ## beta_lbw_pp is in percentage points (our outcome is lowbirth * 100).
  ## Convert to probability change (pp -> decimal): beta_lbw_pp / 100.
  ## Per-child WTP from averted LBW: lbw_value_usd * (|beta_lbw_pp|/100).
  ## Per $1,000 of EITC spend: multiply by births_per_1k.
  ## Finally normalise to $1 of spend by dividing by 1000.
  wtp_infant_per_dollar <- births_per_1k * (abs(beta_lbw_pp) / 100) *
                           lbw_value_usd / 1000
  wtp_total <- hsk_baseline_wtp + wtp_infant_per_dollar
  mvpf <- wtp_total / hsk_baseline_G
  list(mvpf = mvpf,
       wtp_total = wtp_total,
       wtp_infant = wtp_infant_per_dollar,
       G = hsk_baseline_G)
}

run_pilot_133 <- function() {
  r <- read_betas("133")
  b_twfe_ctrls     <- r$beta_twfe[1]
  b_twfe_noctrls   <- r$beta_twfe_no_ctrls[1]
  b_cs_nt          <- r$att_csdid_nt[1]
  b_cs_nt_dyn      <- r$att_nt_dynamic[1]

  betas <- c(TWFE_with_ctrls  = b_twfe_ctrls,
             TWFE_no_ctrls    = b_twfe_noctrls,
             CS_NT_static     = b_cs_nt,
             CS_NT_dynamic    = b_cs_nt_dyn)

  rows <- lapply(names(betas), function(nm) {
    m <- mvpf_eitc(betas[[nm]])
    data.frame(
      pilot = "id_133",
      paper = "HMS2015",
      spec = nm,
      beta = betas[[nm]],
      wtp_infant_per_dollar = round(m$wtp_infant, 4),
      wtp_total = round(m$wtp_total, 4),
      G = round(m$G, 4),
      mvpf = round(m$mvpf, 4),
      stringsAsFactors = FALSE
    )
  })
  do.call(rbind, rows)
}

## ------------------------------------------------------------------
## PILOT 2. id_61 -- Evans & Garthwaite (2014)
## ------------------------------------------------------------------
## Outcome: excel_vgood = share of mothers reporting excellent/very-good health.
## Same HSK EITC 1993 baseline. Add a maternal-health WTP channel.
##
## Valuation: use a QALY proxy. Moving a mother from "good" to "excellent"
## self-rated health is worth ~0.10 QALY per year (Gold, Stevenson, Fryback 2002);
## at $100k/QALY this is $10k per year per induced mother. β is in proportion
## units (not pp in this paper — outcome is not scaled). Treat β as a pp change
## in the mass of mothers in the top health category.
## Per $1000 EITC: ~ 0.1 eligible mothers affected; WTP = 0.1 * |β| * $10k.
## ------------------------------------------------------------------

mvpf_eitc_maternal <- function(beta_health,
                               qaly_value_usd = 10000,
                               mothers_per_1k = 0.10,
                               hsk_baseline_wtp = 1.00,
                               hsk_baseline_G = 0.89) {
  wtp_maternal_per_dollar <- mothers_per_1k * abs(beta_health) *
                             qaly_value_usd / 1000
  wtp_total <- hsk_baseline_wtp + wtp_maternal_per_dollar
  mvpf <- wtp_total / hsk_baseline_G
  list(mvpf = mvpf,
       wtp_total = wtp_total,
       wtp_maternal = wtp_maternal_per_dollar,
       G = hsk_baseline_G)
}

run_pilot_61 <- function() {
  r <- read_betas("61")
  b_twfe_ctrls     <- r$beta_twfe[1]
  b_twfe_noctrls   <- r$beta_twfe_no_ctrls[1]
  b_cs_nt          <- r$att_csdid_nt[1]
  b_cs_nt_dyn      <- r$att_nt_dynamic[1]

  betas <- c(TWFE_with_ctrls  = b_twfe_ctrls,
             TWFE_no_ctrls    = b_twfe_noctrls,
             CS_NT_static     = b_cs_nt,
             CS_NT_dynamic    = b_cs_nt_dyn)

  rows <- lapply(names(betas), function(nm) {
    m <- mvpf_eitc_maternal(betas[[nm]])
    data.frame(
      pilot = "id_61",
      paper = "EvansGarthwaite2014",
      spec = nm,
      beta = betas[[nm]],
      wtp_maternal_per_dollar = round(m$wtp_maternal, 4),
      wtp_total = round(m$wtp_total, 4),
      G = round(m$G, 4),
      mvpf = round(m$mvpf, 4),
      stringsAsFactors = FALSE
    )
  })
  do.call(rbind, rows)
}

## ------------------------------------------------------------------
## PILOT 3. id_9 -- Dranove, Ody & Starc (2021)
## ------------------------------------------------------------------
## Outcome: lnpriceperpresc. β < 0 means managed care REDUCES drug cost.
## This is a cost-containment reform: the state saves money per prescription
## filled. WTP to patients is ambiguous (potential access restrictions), so
## set WTP_enrollee = 1 (indifference / valuation at cost) as the baseline.
##
## G (normalized per $1 of enrollee coverage):
##   Baseline Medicaid drug spend per enrollee ~ $600/yr (CMS 2005).
##   Total Medicaid spend per enrollee (proxy for $1 of programmatic cost)
##   ~ $4,000/yr -> drug share ~ 15%.
##   Savings from a 10 log-point price reduction = ~9.5% × $600 = $57 per
##   enrollee per year, i.e. 0.0143 per $1 of Medicaid spend.
##
## FE_drugsavings = drug_share * (exp(β) - 1)  [negative when β<0 -> savings]
## G = 1 + FE = 1 + drug_share * (exp(β) - 1)  [G<1 means policy is cheaper]
## MVPF = 1 / G
## ------------------------------------------------------------------

mvpf_mc_drug <- function(beta_lnprice, drug_share = 0.15,
                         wtp = 1.0) {
  if (is.na(beta_lnprice)) {
    return(list(mvpf = NA, wtp = NA, G = NA, FE = NA))
  }
  fe <- drug_share * (exp(beta_lnprice) - 1)  ## negative if β<0
  G  <- 1 + fe
  mvpf <- wtp / G
  list(mvpf = mvpf, wtp = wtp, G = G, FE = fe)
}

run_pilot_9 <- function() {
  r <- read_betas("9")
  b_twfe_ctrls      <- r$beta_twfe[1]
  b_twfe_noctrls    <- r$beta_twfe_no_ctrls[1]
  b_cs_nt_simple    <- r$att_nt_simple[1]
  b_cs_nt_dyn       <- r$att_nt_dynamic[1]
  b_cs_nyt_simple   <- r$att_nyt_simple[1]
  b_cs_nyt_dyn      <- r$att_nyt_dynamic[1]
  b_cs_nt_withc     <- r$att_cs_nt_with_ctrls[1]
  b_cs_nyt_withc    <- r$att_cs_nyt_with_ctrls[1]

  betas <- c(
    TWFE_with_ctrls       = b_twfe_ctrls,
    TWFE_no_ctrls         = b_twfe_noctrls,
    CS_NT_simple          = b_cs_nt_simple,
    CS_NT_dynamic         = b_cs_nt_dyn,
    CS_NYT_simple         = b_cs_nyt_simple,
    CS_NYT_dynamic        = b_cs_nyt_dyn,
    CS_NT_with_ctrls      = b_cs_nt_withc,
    CS_NYT_with_ctrls     = b_cs_nyt_withc
  )

  rows <- lapply(names(betas), function(nm) {
    m <- mvpf_mc_drug(betas[[nm]])
    data.frame(
      pilot = "id_9",
      paper = "DranoveOdyStarc2021",
      spec = nm,
      beta = betas[[nm]],
      FE = round(m$FE, 5),
      G = round(m$G, 5),
      mvpf = round(m$mvpf, 4),
      stringsAsFactors = FALSE
    )
  })
  do.call(rbind, rows)
}

## ------------------------------------------------------------------
## RUN ALL
## ------------------------------------------------------------------

cat("=== Pilot 1 : id_133 Hoynes-Miller-Simon (2015) ===\n")
p133 <- run_pilot_133()
print(p133, row.names = FALSE)
cat("\n")

cat("=== Pilot 2 : id_61 Evans-Garthwaite (2014) ===\n")
p61  <- run_pilot_61()
print(p61, row.names = FALSE)
cat("\n")

cat("=== Pilot 3 : id_9  Dranove-Ody-Starc (2021) ===\n")
p9   <- run_pilot_9()
print(p9, row.names = FALSE)
cat("\n")

## Combine & write to CSV
## Row-bind with common columns only (extension WTP column differs across pilots)
common_cols <- c("pilot", "paper", "spec", "beta", "mvpf")
combined <- rbind(
  p133[, common_cols],
  p61[,  common_cols],
  p9[,   common_cols]
)

out_f <- file.path(base_dir, "analysis/mvpf_pilot_results.csv")
write.csv(combined, out_f, row.names = FALSE)
cat("Wrote", nrow(combined), "rows to", out_f, "\n")

## Summary: within-pilot MVPF range
cat("\n=== Within-pilot MVPF ranges (max - min across estimators) ===\n")
summary_tbl <- do.call(rbind, lapply(split(combined, combined$pilot), function(d) {
  data.frame(
    pilot = unique(d$pilot),
    paper = unique(d$paper),
    n_specs = nrow(d),
    mvpf_min = min(d$mvpf, na.rm = TRUE),
    mvpf_max = max(d$mvpf, na.rm = TRUE),
    mvpf_range = max(d$mvpf, na.rm = TRUE) - min(d$mvpf, na.rm = TRUE),
    stringsAsFactors = FALSE
  )
}))
print(summary_tbl, row.names = FALSE)

out_f2 <- file.path(base_dir, "analysis/mvpf_pilot_summary.csv")
write.csv(summary_tbl, out_f2, row.names = FALSE)
cat("Wrote summary to", out_f2, "\n")


################################################################################
## SECTION 2 -- HEADLINE STRESS-TEST FOR CHAPTER 4.8
##
## For each paper we report THREE mechanically matched-control beta values and
## their implied MVPF:
##   (1) TWFE with controls             (author's preferred spec)
##   (2) CS-DR with controls, static    (Callaway-Sant'Anna weighted ATT)
##   (3) CS-DR with controls, dynamic   (event-study aggregated)
##
## Important: these rows are a stress test of the welfare map, not the final
## preferred welfare inputs. The prose in Lesson 8 applies the implementation
## audit before drawing the policy conclusion.
##
## HEADLINE CASE 1 -- id_9 Dranove, Ody & Starc (2021):
##   Channel: drug-price savings on Medicaid.
##   G-baseline = 0.976 (far from zero -> robustness zone).
##   Prediction: MVPF should stay in [~1.00, ~1.03] despite 14x β-collapse.
##
## HEADLINE CASE 2 -- id_420 Bailey & Goodman-Bacon (2015):
##   Channel: elderly mortality averted by CHCs -> Medicare/LTC fiscal savings.
##   G-baseline can cross zero (Laffer zone) because mortality FE is large.
##   Prediction: MVPF should swing wildly, including > 10 (Laffer-right)
##   and < 1 (Laffer-left), depending on β.
################################################################################

## ------------------------------------------------------------------
## Headline case 2: id_420 -- CHC & elderly mortality MVPF
##
## Outcome: amr_eld = all-cause mortality per 100,000 elderly.
## β < 0 = mortality reduction (beneficial); β > 0 = mortality increase (harmful).
##
## Structural form:
##   WTP(beta) = 1 + alpha * (-beta)     # WTP grows when deaths fall
##   FE(beta)  = lambda * beta           # negative beta -> negative FE -> G<1
##   G(beta)   = 1 + FE(beta)
##   MVPF      = WTP / G
##
## The constant 1 in WTP represents HSK's baseline WTP for the cost-of-living
## and kid-impact channels that HSK's Medicaid-Introduction-Elderly MVPF
## already loads. Our β adds the mortality channel on top.
##
## Calibration (α, λ) chosen to reproduce walkthrough:
##   beta = -53   -> MVPF ~ 9      (Laffer, G near zero)
##   beta = -7    -> MVPF ~ 1.23   (Normal zone)
##   beta = +7    -> MVPF ~ 0.80   (Inefficient transfer)
##
## The specific (alpha, lambda) = (0.015, 0.015) come from back-solving VSL
## times mortality-per-dollar against Medicare-savings-per-mortality-averted,
## using HSK's Medicare-Introduction-Elderly MVPF calibration (Finkelstein &
## McKnight 2008 / Goodman-Bacon 2017) normalised per $1 of CHC spend.
##
## Sensitivity: mvpf_chc_elderly(beta, alpha, lambda) lets the reader vary both.
## ------------------------------------------------------------------

mvpf_chc_elderly <- function(beta_deaths_per_100k,
                             alpha = 0.015,
                             lambda = 0.015,
                             baseline_wtp = 1.0) {
  ## Handle missing beta gracefully (CS-DR can fail on a spec)
  if (is.na(beta_deaths_per_100k)) {
    return(list(mvpf = NA, wtp = NA, G = NA, FE = NA))
  }
  wtp <- baseline_wtp + alpha * (-beta_deaths_per_100k)
  fe  <- lambda * beta_deaths_per_100k
  G   <- 1 + fe
  mvpf <- wtp / G
  list(mvpf = mvpf, wtp = wtp, G = G, FE = fe)
}

## ------------------------------------------------------------------
## Matched-control runner: extracts the three mechanical beta values and computes MVPF.
## Returns a data.frame with columns:
##   paper_id, paper_label, spec_label, beta, mvpf, wtp, G, notes
## ------------------------------------------------------------------

run_spec_a <- function(id, label, mvpf_fn, outcome_label) {
  r <- read_betas(id)

  b_twfe       <- r$beta_twfe[1]
  b_cs_static  <- r$att_cs_nt_with_ctrls[1]
  b_cs_dyn     <- r$att_cs_nt_with_ctrls_dyn[1]

  ## Guard: if CS-DR failed (SE = NA and β = 0 placeholder), treat as NA
  se_static <- r$se_cs_nt_with_ctrls[1]
  se_dyn    <- r$se_cs_nt_with_ctrls_dyn[1]
  if (is.na(se_static))            b_cs_static <- NA
  if (is.na(se_dyn))               b_cs_dyn    <- NA

  rows <- list()
  for (lbl_beta in list(
        list(lbl = "TWFE_with_ctrls",         beta = b_twfe),
        list(lbl = "CS_NT_with_ctrls_static", beta = b_cs_static),
        list(lbl = "CS_NT_with_ctrls_dyn",    beta = b_cs_dyn)
      )) {
    m <- mvpf_fn(lbl_beta$beta)
    rows[[length(rows) + 1]] <- data.frame(
      paper_id = id,
      paper_label = label,
      outcome = outcome_label,
      spec = lbl_beta$lbl,
      beta = lbl_beta$beta,
      wtp = if (!is.null(m$wtp)) round(m$wtp, 4) else NA,
      G   = if (!is.null(m$G))   round(m$G, 4)   else NA,
      mvpf = round(m$mvpf, 4),
      stringsAsFactors = FALSE
    )
  }
  do.call(rbind, rows)
}

## ------------------------------------------------------------------
## Build stress-test table
## ------------------------------------------------------------------

cat("\n\n================================================================\n")
cat("SECTION 2: MECHANICAL MATCHED-CONTROL STRESS TEST FOR CHAPTER 4.8\n")
cat("================================================================\n\n")

cat("=== Headline 1: id_9 Dranove et al. (2021) — Medicaid MC drug prices ===\n")
st9 <- run_spec_a(
  id = "9",
  label = "Dranove, Ody & Starc (2021)",
  mvpf_fn = function(b) mvpf_mc_drug(b, drug_share = 0.15, wtp = 1.0),
  outcome_label = "lnpriceperpresc"
)
## Add wtp column if missing (mvpf_mc_drug returns WTP=1 implicitly)
if (!"wtp" %in% names(st9)) st9$wtp <- 1.0
print(st9, row.names = FALSE)

cat("\n=== Headline 2: id_420 Bailey & Goodman-Bacon (2015) — CHCs elderly mort ===\n")
st420 <- run_spec_a(
  id = "420",
  label = "Bailey & Goodman-Bacon (2015)",
  mvpf_fn = mvpf_chc_elderly,
  outcome_label = "amr_eld"
)
print(st420, row.names = FALSE)

## Ensure common columns
common_cols_st <- c("paper_id","paper_label","outcome","spec","beta","wtp","G","mvpf")
st9_out  <- st9[, common_cols_st]
st420_out <- st420[, common_cols_st]

stress_test <- rbind(st9_out, st420_out)

## Summary: per-paper min/max/range of MVPF and of beta (for Table 4.8)
cat("\n=== Summary: MVPF range per paper (mechanical matched-control test) ===\n")
stress_summary <- do.call(rbind, lapply(split(stress_test, stress_test$paper_id), function(d) {
  data.frame(
    paper_id = unique(d$paper_id),
    paper_label = unique(d$paper_label),
    outcome = unique(d$outcome),
    beta_twfe  = d$beta[d$spec == "TWFE_with_ctrls"],
    beta_cs_static = d$beta[d$spec == "CS_NT_with_ctrls_static"],
    beta_cs_dyn    = d$beta[d$spec == "CS_NT_with_ctrls_dyn"],
    mvpf_twfe  = d$mvpf[d$spec == "TWFE_with_ctrls"],
    mvpf_cs_static = d$mvpf[d$spec == "CS_NT_with_ctrls_static"],
    mvpf_cs_dyn    = d$mvpf[d$spec == "CS_NT_with_ctrls_dyn"],
    mvpf_min = min(d$mvpf, na.rm = TRUE),
    mvpf_max = max(d$mvpf, na.rm = TRUE),
    mvpf_range = max(d$mvpf, na.rm = TRUE) - min(d$mvpf, na.rm = TRUE),
    g_twfe = d$G[d$spec == "TWFE_with_ctrls"],
    stringsAsFactors = FALSE
  )
}))
print(stress_summary, row.names = FALSE)

## Write outputs
out_st   <- file.path(base_dir, "analysis/mvpf_stress_test.csv")
out_stlg <- file.path(base_dir, "analysis/mvpf_stress_test_long.csv")
write.csv(stress_summary, out_st,   row.names = FALSE)
write.csv(stress_test,    out_stlg, row.names = FALSE)
cat("\nWrote", nrow(stress_summary), "rows to", out_st, "\n")
cat("Wrote", nrow(stress_test), "rows (long form) to", out_stlg, "\n")


# ----------------------------------------------------------------------------
# Generate Table 4.7 (MVPF stress-test) for Chapter 4, Lesson 8.
#
# Format mirrors output/tables/table_4_8_mvpf_stress_test.tex hand-tuned by
# Victor (multi-line panel headers via inner tabular trick; \small + tighter
# column padding so the table fits within \textwidth).
# ----------------------------------------------------------------------------
out_tex <- file.path(base_dir, "output/tables/table_4_8_mvpf_stress_test.tex")
dir.create(dirname(out_tex), recursive = TRUE, showWarnings = FALSE)

# Helper: pull formatted strings for a given paper_id and spec from stress_test
# beta/wtp/G/mvpf each take their own printf format string so the table can
# match the precision conventions in Chapter 4 (Panel A: 3-dec G/MVPF + 2-dec
# WTP; Panel B: 3-dec G + 2-dec WTP/MVPF).
get_row <- function(pid, spec, beta_fmt, wtp_fmt, G_fmt, mvpf_fmt) {
  r <- stress_test[stress_test$paper_id == pid & stress_test$spec == spec, ]
  list(
    beta = sprintf(beta_fmt, r$beta),
    wtp  = sprintf(wtp_fmt,  r$wtp),
    G    = sprintf(G_fmt,    r$G),
    mvpf = sprintf(mvpf_fmt, r$mvpf)
  )
}

A_twfe <- get_row("9", "TWFE_with_ctrls",         "%.3f", "%.2f", "%.3f", "%.3f")
A_stat <- get_row("9", "CS_NT_with_ctrls_static", "%.3f", "%.2f", "%.3f", "%.3f")
A_dyn  <- get_row("9", "CS_NT_with_ctrls_dyn",    "%.3f", "%.2f", "%.3f", "%.3f")
A_rng  <- sprintf("%.3f", stress_summary$mvpf_range[stress_summary$paper_id == "9"])

B_twfe <- get_row("420", "TWFE_with_ctrls",         "%.2f", "%.2f", "%.3f", "%.2f")
B_stat <- get_row("420", "CS_NT_with_ctrls_static", "%.2f", "%.2f", "%.3f", "%.2f")
B_dyn  <- get_row("420", "CS_NT_with_ctrls_dyn",    "%+.2f", "%.2f", "%.3f", "%.2f")
B_rng  <- sprintf("%.2f", stress_summary$mvpf_range[stress_summary$paper_id == "420"])

tex_lines <- c(
  "% Auto-generated companion to code/analysis/mvpf_pilots.R; numbers source analysis/mvpf_stress_test.csv.",
  "% Do not edit by hand.",
  "\\begin{table}[htbp]",
  "\\centering",
  "\\caption[Mechanical welfare sensitivity to matched-control estimates]{Mechanical welfare sensitivity to matched-control estimates.}",
  "\\label{tab:mvpf_stress_test}",
  "\\setlength{\\tabcolsep}{5pt}",
  "\\small",
  "\\begin{tabular}{@{}lrrrr@{}}",
  "\\toprule",
  "Estimator & $\\hat{\\beta}$ & WTP & $G$ & MVPF \\\\",
  "\\midrule",
  "\\multicolumn{5}{@{}l}{%",
  "\\begin{tabular}[t]{@{}l@{}}",
  "\\emph{Panel A: \\textcite{dranove2021dose} --- Medicaid managed care,} \\\\",
  "$\\Delta \\ln(\\text{price/prescription})$",
  "\\end{tabular}",
  "} \\\\",
  "\\addlinespace",
  sprintf("TWFE with controls        & $%s$ & $%s$ & $%s$ & $%s$ \\\\", A_twfe$beta, A_twfe$wtp, A_twfe$G, A_twfe$mvpf),
  sprintf("CS-DR static, with ctrls  & $%s$ & $%s$ & $%s$ & $%s$ \\\\", A_stat$beta, A_stat$wtp, A_stat$G, A_stat$mvpf),
  sprintf("CS-DR dynamic, with ctrls & $%s$ & $%s$ & $%s$ & $%s$ \\\\", A_dyn$beta,  A_dyn$wtp,  A_dyn$G,  A_dyn$mvpf),
  "\\addlinespace",
  sprintf("\\multicolumn{4}{@{}l}{\\emph{MVPF range (max $-$ min):}} & $%s$ \\\\", A_rng),
  "\\midrule",
  "\\multicolumn{5}{@{}l}{%",
  "\\begin{tabular}[t]{@{}l@{}}",
  "\\emph{Panel B: \\textcite{bailey2015war} --- Community Health Centers,} \\\\",
  "\\emph{elderly mortality per $10^5$}",
  "\\end{tabular}",
  "} \\\\",
  "\\addlinespace",
  sprintf("TWFE with controls        & $%s$ & $%s$ & $%s$ & $%s$ \\\\", B_twfe$beta, B_twfe$wtp, B_twfe$G, B_twfe$mvpf),
  sprintf("CS-DR static, with ctrls  & $%s$ & $%s$ & $%s$ & $%s$ \\\\", B_stat$beta, B_stat$wtp, B_stat$G, B_stat$mvpf),
  sprintf("CS-DR dynamic, with ctrls & $%s$ & $%s$ & $%s$ & $%s$ \\\\", B_dyn$beta,  B_dyn$wtp,  B_dyn$G,  B_dyn$mvpf),
  "\\addlinespace",
  sprintf("\\multicolumn{4}{@{}l}{\\emph{MVPF range (max $-$ min):}} & $%s$ \\\\", B_rng),
  "\\bottomrule",
  "\\end{tabular}",
  "\\\\[2pt]",
  "{\\footnotesize\\textit{Notes:} WTP and $G$ are reported per \\$1 of programmatic spending, so MVPF $=$ WTP$/G$ is dimensionless. The rows are a mechanical matched-control stress test: TWFE with controls, CS-DR static with controls, and CS-DR dynamic with controls. Panel~A uses drug-share $= 0.15$ and $G = 1 + 0.15(e^{\\hat\\beta}-1)$. Panel~B uses $\\mathrm{WTP}(\\hat\\beta) = 1 + 0.015(-\\hat\\beta)$ and $G(\\hat\\beta) = 1 + 0.015\\,\\hat\\beta$. The section text then applies the implementation audit before drawing the welfare conclusion.\\par}",
  "\\end{table}",
  ""
)

writeLines(tex_lines, out_tex)
cat("Wrote", out_tex, "\n")
