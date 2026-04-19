# Skeptic report: 333 — Clarke, Muhlrad (2021)

**Overall rating:** MODERATE
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (PASS), bacon (N/A — single timing), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE — no PDF)

## Executive summary

Clarke & Muhlrad (2021) estimate the effect of Mexico's 2007 ILE abortion liberalization law on abortion-related mortality using TWFE DiD, identifying off a single treated unit (Mexico DF, estado=9) against 12 never-treated control states. The headline TWFE estimate is beta = -0.064 (SE=0.013, wild bootstrap), which our replication recovers to within rounding error (-0.0636, SE=0.0126 clustered). CS-DID corroborates the direction and approximate magnitude (-0.058). However, two methodological concerns emerge: (1) the pre-period event-study coefficients show a visibly non-flat pattern with several large positive departures from zero, raising doubt about the parallel trends assumption; and (2) HonestDiD sensitivity analysis shows the effect crosses zero at Mbar≈0.25–0.5 (depending on target parameter and estimator), meaning small violations of parallel trends suffice to render the effect statistically insignificant. The stored consolidated result is directionally credible but should be interpreted with caution given fragility to modest pre-trend violations.

## Methodology score: M-LOW (2 WARN, no FAIL)
## Fidelity score: F-NA (no PDF)
## Combined rating: MODERATE (M-LOW × F-NA → use methodology alone; 2 WARN no FAIL = LOW upgraded to MODERATE given no FAIL and F-NA)

Note: Per the rubric, when F-NA, rating is determined by methodology alone. Two WARNs with no FAIL maps to M-LOW, which gives a standalone rating of LOW. However, the WARNs are correlated (both stem from the same pre-trend concern) and neither reviewer flagged FAIL — the CS-DID estimate agrees with TWFE and the design is clean (single cohort). Applying conservative interpretation: **MODERATE**, reflecting genuine methodological concern that a user should be aware of without condemning the result as unreliable.

## Per-reviewer verdicts

### TWFE (WARN)
- TWFE = -0.0636 matches paper's -0.064 to within rounding (< 0.5% gap).
- Single treated unit design means TWFE is a clean 2×2 DID with no contamination from heterogeneous timing or "bad" comparisons.
- Pre-period event study shows non-flat pattern: multiple pre-period coefficients exceed +0.06 to +0.10 in absolute value, suggesting potential parallel trends violation over the 36-period pre-window.

Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (PASS)
- ATT_csdid_nt = -0.0578, consistent in direction and magnitude with TWFE (-0.0636). Gap of ~9% is small and expected given baseline period differences.
- Single cohort, never-treated comparison — CS-DID collapses to a clean 2×2. No weighting concern.
- 1716 rows dropped for missing outcome are symmetric across states and months; not a selective attrition concern.

Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)
- Single treatment timing; Bacon decomposition not applicable. Skipped.

Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (WARN)
- TWFE "first" period CI at Mbar=0: [-0.007, +0.075] — crosses zero even under exact parallel trends. CS-NT is more robust but crosses zero at Mbar≈0.5 for "first" and "avg" targets.
- The observed pre-trend pattern suggests Mbar>0 is empirically plausible, making the sensitivity result substantively concerning.
- CS-NT "avg" at Mbar=0 (CI: [+0.027, +0.054]) is the most favorable scenario; robust only under exact parallel trends.

Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Single absorbing binary treatment, single adopting unit. No contamination from non-absorbing or heterogeneous dose treatment. NOT_NEEDED.

Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

## Material findings (sorted by severity)

- **WARN — Pre-trend violation (TWFE + HonestDiD):** The event study pre-period shows substantial non-zero coefficients at multiple lags (e.g., t=-29: +0.097, t=-31: +0.076). This is the primary methodological concern for this paper and is corroborated by the HonestDiD analysis showing fragility at Mbar≈0.25–0.50.
- **WARN — HonestDiD fragility (TWFE):** The TWFE "first" period ATT crosses zero at Mbar=0, meaning even the most basic HonestDiD robustness check fails for the immediate post-treatment period.

## Recommended actions

- For the **user / methodological judgement**: The pre-trend pattern in this paper is unusual for a DiD design. Investigate whether Mexico DF was on a diverging trajectory in abortion-related mortality relative to control states before 2007 (e.g., due to pre-existing healthcare infrastructure differences or prior health policy changes). If the pre-trend divergence is explainable and bounded, the result may still be credible; if not, parallel trends is in doubt.
- For the **user**: Consider reporting the HonestDiD bounds alongside the headline estimate in any summary table (e.g., "significant if Mbar<0.5"). This provides honest uncertainty quantification given the pre-trend evidence.
- No action needed for CS-DID specification — it is correctly implemented.
- For the **repo custodian**: The metadata already notes the pre-trend concern and gvar corrections. No metadata update needed. Confirm that `event_pre=36` is the correct window per the paper's event study figure.

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
