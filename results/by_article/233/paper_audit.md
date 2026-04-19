# Paper fidelity audit: 233 — Kresch (2020)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification
From metadata notes: "Table 3 Col 1 (invest_total/1000). Stata: reghdfe invest_total muni_companyxlaw controls if balance2001==1, absorb(code year) vce(cluster company)."

Table 3 — WS Investment, Column 1 (Total investment). Outcome is total WS system investment in thousand reais. Treatment is `muni_companyxlaw` (self-run municipality × post-2005 law indicator). Municipality + year fixed effects, 14 controls including `baseinvestTT`. Standard errors clustered at WS company level.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 3 Col 1) | 2,868 | (1,319) | 14,460 | WS company (149 clusters) | none |
| Our stored results.csv | 2,868.317 | (1,254.260) | 14,460 | WS company | none |
| Relative Δ | 0.01% | −4.91% | | | |

## Notes
- The paper rounds to the nearest integer (2,868); our stored value is 2,868.317, a difference of 0.317 units — within rounding of the paper's display.
- SE divergence of −4.91% is within the 30% tolerance threshold. The paper reports 1,319; our template yields 1,254. The gap is consistent with minor implementation differences in cluster-robust SE (e.g., small-sample corrections, `vce(cluster company)` vs fixest default finite-sample adjustment). The metadata notes document that company-level clustering uses a composite code: `code` for Local scope, state-level code for Regional scope — this mapping is correctly implemented.
- N = 14,460 matches exactly between the paper and our stored result.
- The paper Table 3 note confirms 149 WS company clusters; our metadata has `cluster = "company"` with 149 clusters consistent.
- Outcome is invest_total in thousand reais (`df$invest_total <- df$invest_total / 1000` in preprocessing), matching the paper's unit of measurement ("Investment levels are measured in thousand reals").
- The coefficient is not statistically significant in the paper (no stars), consistent with our stored result.

## Verdict rationale
Our stored beta (2,868.317) differs from the paper's reported value (2,868) by 0.01%, well within the 1% EXACT threshold, with matching sign.
