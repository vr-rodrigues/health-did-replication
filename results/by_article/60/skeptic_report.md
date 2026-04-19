# Skeptic report: 60 — Schmitt (2018)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (PASS), bacon (PASS), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

## Executive summary

Schmitt (2018) estimates that multimarket contact among hospitals raises non-medical prices by approximately 7% (TWFE: beta=0.070, SE=0.017). Our reanalysis with modern robust estimators confirms the positive direction unanimously across all five estimators (TWFE, CS-NT, CS-NYT, SA, Gardner), with ATTs ranging 0.053–0.093 depending on specification. The stored TWFE result is methodologically sound in terms of specification adherence and Bacon composition (93.8% clean Treated-vs-Untreated weight). However, two reviewers issued WARNs: (1) the TWFE and CS-NT event studies both show a systematic negative pre-trend drift at t=-4 and t=-3 (coefficients around -0.047 to -0.059, t-stats ~-1.05 to -1.22), which while individually insignificant represents ~70-84% of the ATT in magnitude; (2) HonestDiD reveals that aggregate ATT estimates (average, peak) are fragile to any deviation from parallel trends — CIs include zero at Mbar=0.25 for all estimators, classifying this as D-FRAGILE. The contemporaneous (first-period) effect is more robust under CS-NT, surviving to Mbar=0.25 (CI fully positive). Users should treat the stored beta_twfe=0.070 as directionally reliable but quantitatively fragile — the effect is consistently positive but the magnitude is sensitive to modest pre-trend violations. The fidelity axis is NOT_APPLICABLE (no PDF, no reference beta).

## Per-reviewer verdicts

### TWFE (WARN)
- Specification faithfully matches Schmitt (2018): areg with 6 controls, aweights=dis_tot, cluster by hospital, absorb hospital FE, year FE, sample restricted to indirect==0. PASS.
- Pre-trend drift at t=-4 (coef=-0.059, t=-1.05) and t=-3 (coef=-0.026, t=-1.05): individually insignificant but systematic downward pattern warrants disclosure.
- Bacon composition is highly favorable: 93.8% TVU weight; LvE/EvL forbidden comparisons contribute only 6.2%.

Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (PASS)
- CS-NT and CS-NYT unconditional ATTs (0.053) are 24.6% below TWFE (0.070), fully explained by controls: conditional CS-DID (0.080–0.083) exceeds TWFE, confirming direction.
- NT and NYT comparators agree within 0.4 percentage points — no contamination from already-treated units.
- CS-NT pre-trends clean at conventional significance: all t-stats below |1.22|. Mild negative drift at t=-4/-3 consistent with TWFE.

Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (PASS)
- TVU weight = 93.8%; forbidden (LvE/EvL) comparisons = 6.2%. The TWFE estimate is overwhelmingly identified from clean never-treated comparisons.
- TVU weighted mean = 0.053, matching CS-NT ATT exactly — confirms TWFE is not materially distorted by staggered-adoption heterogeneity.
- Three cohorts show negative TVU estimates (2007: -0.002, 2003: -0.012, 2010: -0.078) but their combined weight is modest (19.0%); positive cohorts (especially 2000 at 21.7% weight and 2008 at 8.7%) dominate.

Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (WARN)
- D-FRAGILE overall: TWFE avg and peak ATTs lose significance at Mbar=0.25 (modest violation tolerance). CS-NT average and peak ATTs also lose significance at Mbar=0.25.
- More robust: CS-NT first-period ATT survives to Mbar=0.25 (CI=[+0.007, +0.079] still fully positive). Contemporary effect is credible.
- Fragility driver: systematic negative pre-trend at t=-4/-3 (~-0.047 to -0.059) is extrapolated by HonestDiD, widening post-period CIs rapidly even at small Mbar.

Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered design: treatment is `post` (binary, irreversible). de Chaisemartin estimator not needed — CS-DID covers this design fully.

Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)
- No PDF available for article 60; no reference TWFE beta extracted in metadata. Fidelity axis cannot be evaluated.

Full report: [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

## Material findings (sorted by severity)

### WARN items
- **[WARN — HonestDiD] D-FRAGILE aggregate ATT.** Both TWFE and CS-NT average/peak ATTs lose statistical significance at Mbar=0.25 in the HonestDiD sensitivity analysis. Only the first-period CS-NT effect survives to Mbar=0.25. Conclusion: the direction (positive price effect of multimarket contact) is robust; the magnitude is fragile.
- **[WARN — TWFE] Pre-trend drift at t=-4 and t=-3.** Both TWFE and CS-NT event studies show negative coefficients at t=-4 (~-0.047 to -0.059) and t=-3 (~-0.026 to -0.033), individually insignificant but representing 70–84% of the ATT in magnitude. This pattern is the direct cause of HonestDiD fragility.

## Recommended actions

- For the dissertation: Report the D-FRAGILE HonestDiD classification. Note that the direction of the effect (positive price effect, ~0.05–0.07 log points) is consistent across all 5 estimators, but the magnitude is sensitive to even modest pre-trend violations (Mbar=0.25). The contemporaneous (first-period) CS-NT effect is the most credible single-number summary (Mbar=0.25 robust: CI=[+0.007, +0.079]).
- For the repo-custodian: Consider extracting the original TWFE coefficient from Schmitt (2018) Table 2 (or equivalent) and populating `original_result` in metadata — this would enable paper-auditor fidelity check on the next run.
- For the repo-custodian: The metadata notes flag a sensitivity check (CS-NT with fp+sysoth controls improving pre-trends). This result is already computed (`att_cs_nt_with_ctrls = 0.080`). Consider documenting this as a named sensitivity in the dissertation to illustrate Pattern: "controls improve pre-trends when treatment timing correlates with time-varying hospital characteristics."
- No action needed on Bacon (PASS) or CS-DID (PASS) axes.

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
