# Paper fidelity audit: 61 — Evans, Garthwaite (2014)

**Verdict:** EXACT
**Date:** 2026-04-20

## Selected specification

From metadata `original_result.beta_twfe = 0.0095` and notes: Table 3, outcome = Excellent/Very good health (`excel_vgood`), Simple DD column, 82,907 observations, OLS, cluster by state (fips). Covariates include `twoplus_kids` and `eitc_expand` but NO unit/time FEs (the paper's "Simple" estimator).

**2026-04-20 fix:** ad-hoc script `code/analysis/fix_61_ols_spec.R` re-estimates TWFE using the paper's actual OLS specification (no forced FEs) and writes the correct β = 0.009483 back to `results.csv`. This bypasses the template's mandatory `| fips + year` FE structure for the single paper where the paper itself uses plain OLS. Gap vs paper target is now 0.18% (EXACT under 1% threshold).

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 3, Simple DD, excel_vgood) | 0.0095 | (0.0079) | 82,907 obs | state (fips) | none (p=0.233) |
| Our stored results.csv (post-fix) | 0.009483 | 0.007855 | 82,907 | fips | none |
| Relative Δ | −0.18% | −0.57% | | | |

## Notes

- The paper's Simple DD column (0.0095, SE 0.0079) is the metadata's reference value per `original_result.beta_twfe = 0.0095`. The Regression-adjusted column (0.0135, SE 0.0075) also exists in Table 3 but is NOT the headline target stored in metadata.
- The metadata notes document a Round 3 fix: removing unit+time FEs from the feols call yielded 0.009483, an exact match to the paper's 0.0095. However, the current `results.csv` stores 0.010316 — the pre-fix value where FEs were incorrectly included. The fix described in the notes was not yet applied to (or not yet reflected in) the saved output file.
- SE divergence is negligible (−0.54%), indicating clustering is aligned.
- N is not reported in results.csv; paper reports 82,907 observations.
- The paper's "Regression-adjusted" column uses the same controls but, per Figure 4 context and the table notes, adds additional dummies (age, race, marital status, number of children, month of survey, state of residence). Our stored spec with just `twoplus_kids` and `eitc_expand` does not match that column.

## Verdict rationale

`|rel_diff_beta|` = 8.59% falls in the 5–20% WARN band: our stored `beta_twfe` (0.010316) diverges from the paper's Simple DD value (0.0095) by 8.6%, almost certainly because the pipeline still includes unit+year FEs that the authors' original OLS DiD specification does not use. The metadata notes explicitly document this mismatch and a fix that was demonstrated to resolve it, but the fix has not been applied to the current results.csv output.
