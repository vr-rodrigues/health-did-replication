# Paper fidelity audit: 76 — Lawler, Yewell (2023)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From metadata notes and SKILL_profiler protocol: Table 2, Column 1 — Breastfeeding initiation (bf_ever); single binary TWFE indicator (HospitalPolicy_st); individual + state/time-varying X controls; state + birth year fixed effects; NIS-Child sample weights; cluster SE at state level; N = 354,642; sample: mobil == 2 (children still in state of birth).

This is the paper's explicitly labeled baseline DiD estimate in the headline Section IV.B table. The abstract and main text both reference "3.8 percentage points" for breastfeeding initiation as the headline finding.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Col 1) | 0.0383 | (0.00950) | 354,642 | state | *** |
| Our stored results.csv | 0.03832 | (0.00950) | not stored | state (fips) | — |
| Relative Δ | +0.06% | -0.01% | — | — | — |

## Notes

- The paper reports the coefficient rounded to 4 decimal places (0.0383); our stored value is 0.0383225319, which rounds to 0.0383 — exact agreement at the precision the paper reports.
- SE agreement is essentially perfect: paper 0.00950, ours 0.009499 — difference is sub-rounding-error.
- N is reported in the paper as 354,642 observations; our results.csv does not store N, but the metadata notes and the notes field document that the sample filter is mobil == 2 which matches the paper's NIS-Child restricted sample.
- Clustering: paper clusters at state level; our specification uses fips (state FIPS), consistent.
- The metadata notes document a non-trivial implementation fix (Stata month() applied to %tm values treated as %td → corrected in R, plus explicit omission of styr_pergt64 to replicate Stata's collinearity drop). The EXACT match confirms both fixes were correctly applied.
- SE convention: paper uses cluster-robust SE at state level; ours uses the same via feols(cluster = ~fips).

## Verdict rationale

Our stored beta_twfe (0.03832) matches the paper's Table 2 Col 1 coefficient (0.0383) within 0.06% — comfortably within the 1% EXACT threshold — with negligible SE divergence, confirming the headline breastfeeding initiation result is faithfully reproduced.
