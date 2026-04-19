# Paper fidelity audit: 347 — Courtemanche et al. (2025)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification
From metadata notes: Table 3, Column 1 — BMI outcome, calorie posting law indicator (`law_enacted`), county FE + month×year FE + county-specific linear trends, individual and county-level controls, cluster at county level, BRFSS 1994–2012, N=594,364.

This is the paper's main reported DiD estimate (Section 5.3, first paragraph references "column (1) of Table 3").

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 3 Col 1) | −0.174 | (0.081) | 594,364 | county | ** |
| Our stored results.csv | −0.17440 | 0.08077 | — | county | ** |
| Relative Δ | −0.23% | −0.28% | | | |

## Notes
- Paper reports: "Standard errors, heteroskedasticity-robust, and clustered by county, are in parentheses." (Table 3 footnote). Our implementation uses the same clustering.
- The paper rounds to three decimal places (−0.174); our stored value is −0.174401, a difference of 0.001 in the fourth decimal place — well within rounding.
- SE: paper reports 0.081; our stored value is 0.08077, rounding to the same 0.081.
- N is not stored in results.csv but the metadata `original_result.n` records 594,364, consistent with Table 3.
- The metadata `notes` field already documents "TWFE EXACT MATCH: R=−0.1744 vs paper=−0.174", confirming this result was verified at implementation time.
- This is a repeated cross-section; CS-DID estimates (CS-NT=−0.448, CS-NYT=−0.439) are substantially larger in magnitude than TWFE (−0.174), suggesting possible TWFE attenuation bias in the staggered adoption setting.

## Verdict rationale
|rel_diff_beta| = 0.23%, which is well below the 1% EXACT threshold, and the sign matches; the stored TWFE estimate reproduces the paper's Table 3 Column 1 headline result to within rounding error.
