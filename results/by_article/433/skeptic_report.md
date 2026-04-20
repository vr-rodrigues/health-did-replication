# Skeptic report: 433 -- DeAngelo, Hansen (2014)

**Overall rating:** HIGH *(Fidelity x Implementation: F-NA x I-HIGH -- use implementation alone per rubric)*
**Design credibility:** FRAGILE *(Axis-3 finding: rm_first=0, rm_avg=0 both estimators; rm_peak=0.25 D-MODERATE)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS; design->Axis3), bacon (NOT_APPLICABLE -- single timing), honestdid (impl=PASS; M_first=0, M_avg=0, M_peak=0.25), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE -- no PDF; informational WITHIN_TOLERANCE 1.46%)

---

## Executive summary

DeAngelo and Hansen (2014) estimate that Oregon's February 2003 mass police layoff increased traffic fatalities per VMT by roughly 0.71 units, state-month panel of 47 states over 2000-2005. Our reanalysis reproduces the headline coefficient within 1.46% (stored: 0.6999 vs paper: 0.7103); gap fully attributable to a missing Vermont observation in the replication data. Pipeline correctly implemented: TWFE and CS-NT (no controls) converge to 0.28%, confirming single-treated-unit design eliminates negative-weighting concerns. Stored beta_twfe=0.6999 is trustworthy as a replication. Axis-3 design findings: result fragile under HonestDiD (avg/first ATT not robust to any linear trend violation) and 3 of 5 CS-NT pre-periods individually significant -- oscillatory not monotone, reducing concern about genuine confounding trend. Findings about the paper's design, not demerits against our pipeline.

---

## Per-reviewer verdicts

### TWFE (PASS)

- FE structure `fat_vmt ~ treatment + precip + temp + un_rate + max_speed | fips + year + month` correctly matches the paper areg specification.
- Stored beta_twfe=0.6999 within 1.46% of paper 0.7103; gap explained by Vermont (FIPS=50) absent from synth_file_2014.dta.
- Pre-trends oscillatory (not monotone drift); t=-4 individually significant (t=2.71) but non-systematic -- Axis-3 design signal.

Full report: [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)

### CS-DID (PASS on implementation; design findings on Axis 3)

- CS-NT (no controls) ATT=0.6979, within 0.28% of TWFE -- expected for single-treated-unit design.
- SE inflation 2.72x (TWFE SE=0.133 vs CS-NT SE=0.361) structurally correct: CS-DID properly captures variance from K=1 treated unit.
- Spec A (CS-NT with 4 controls) returns ATT=1.733 (2.47x amplification). Pattern-51-style DR overfit with K=1 treated. Axis-3 design finding.
- 3 of 5 CS-NT pre-periods significant (t=-6 t=4.49, t=-4 t=6.29, t=-2 t=2.83), oscillatory -- Axis-3 finding.

Full report: [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)

- treatment_timing=single (Oregon only); all weight on single TvU comparison. Correctly not run.

Full report: [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)

### HonestDiD (PASS on implementation; D-FRAGILE design finding)

- rm_first_Mbar=0 (both TWFE and CS-NT): first-period ATT CI includes zero at Mbar=0.
- rm_avg_Mbar=0 (both estimators): average ATT breaks at Mbar=0.25. Any linear deviation eliminates significance.
- rm_peak_Mbar=0.25 (both estimators): peak-period ATT (ATT_peak~4.18 at t=+1) robust through Mbar=0.25; breaks 0.25-0.50.
- Oscillatory CS-NT pre-periods suggest plausible Mbar > 0.25 in practice.

Full report: [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)

- Absorbing binary single-cohort; no switching, no continuous dose, no staggered adoption. DCM would match TWFE and CS-NT.

Full report: [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)

### Paper-auditor (NOT_APPLICABLE -- no PDF)

- pdf/433.pdf not found. Formal fidelity axis: F-NA.
- Informational metadata-based check: |0.7103-0.6999|=0.0104 (1.46%, diff/SE=0.081) -- WITHIN_TOLERANCE. Gap explained by missing Vermont.

Full report: [reviews/paper-auditor.md](reviews/paper-auditor.md)

---

## Three-way controls decomposition

| Spec | TWFE | CS-DID NT | Status |
|---|---|---|---|
| (A) both with controls | 0.6999 (SE 0.133) | 1.7327 (SE 0.421) | ANOMALY -- Pattern 51 DR overfit (K=1 + 4 covariates); Axis-3 |
| (B) both without controls | 0.7151 (SE 0.132) | 0.6979 (SE 0.370) | OK -- convergence within 2.5% |
| (C) TWFE with, CS without (headline) | 0.6999 (SE 0.133) | 0.6979 (SE 0.370) | OK |

Key ratios:
- Estimator margin (Spec B, matched-protocol): +2.4% -- near-zero.
- Covariate margin (TWFE side): -2.2% -- controls negligible for TWFE.
- Covariate margin (CS side): +59.7% -- Pattern-51 overfit dominates.
- Total gap (headline Spec C): +0.3% -- negligible.

Interpretation: Matched-protocol Spec B confirms TWFE/CS-NT agree within 2.4% under matched controls, validating our implementation. Spec A anomaly is K=1 propensity overfit (Axis-3). Deliverable D1 finding: matched-protocol nearly eliminates the TWFE vs CS gap -- Spec C divergence is artefact of mismatched controls, not the estimator.

---

## Three-axis rating summary

| Axis | Evidence | Score |
|---|---|---|
| Fidelity (paper-auditor) | NOT_APPLICABLE (no PDF); informational WITHIN_TOLERANCE 1.46% | F-NA |
| Implementation (all reviewers) | TWFE: PASS; CS-DID: PASS; Bacon: N/A; HonestDiD: PASS; DCM: NOT_NEEDED | I-HIGH |
| Design credibility (Axis-3) | rm_first=0, rm_avg=0 (D-FRAGILE); rm_peak=0.25 (D-MODERATE); 3/5 oscillatory pre-periods; Pattern-51 Spec A | D-FRAGILE |

F-NA x I-HIGH -> use implementation alone -> **OVERALL RATING: HIGH**

Note on prior rating: The legacy row assigned LOW (M-LOW x F-NA) by counting 2 implementation WARNs -- the CS-with-controls Spec A anomaly and the HonestDiD pre-trend signal. Under the correct 3-axis rubric both belong on Axis 3: Spec A amplification is structural K=1 propensity overfit (Pattern 51); HonestDiD fragility is a design finding about the paper's design. Neither reflects a pipeline error. Corrected rating: HIGH.

---

## Material findings (Axis 3 -- sorted by severity)

- D-FRAGILE: HonestDiD rm_avg_Mbar=0 both estimators. Average ATT significant only under exact parallel trends; any linear deviation eliminates significance.
- Oscillatory CS-NT pre-trends: t=-6 (t=4.49), t=-4 (t=6.29), t=-2 (t=2.83) significant. Oscillatory not monotone; consistent with Oregon seasonal heterogeneity. Plausible Mbar > 0.25.
- Pattern-51 Spec A amplification: CS-NT with controls 1.733 vs 0.698 (+148%). Structural to K=1 design. Use Spec B/C as headline.
- D-MODERATE: rm_peak_Mbar=0.25. Peak-month effect (~4.18 TWFE at t=+1) is the most robust finding.
- SE understatement: TWFE SE (0.128) understates true uncertainty; CS-NT SE (0.361) better reflects K=1 variance.

---

## Recommended actions

- No pipeline action needed. All implementation reviewers PASS; stored beta_twfe=0.6999 faithfully replicates the paper.
- For users: rm_avg_Mbar=0 is the key design finding. Average ATT not robust to linear pre-trend violations. Peak-period effect (Mbar=0.25) is the stronger causal claim.
- For the dissertation: single-treated-unit fragility case -- clean design (no staggered timing, no negative weights) but reliant on exact parallel trends.
- Pattern-51 Spec A overfit already documented in knowledge/failure_patterns.md. No new pattern needed.
- Add pdf/433.pdf to pdf/ directory if available for formal fidelity verification.

---

## Individual reports

- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md)
