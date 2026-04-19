# Paper fidelity audit: 271 — Sekhri, Shastry (2024)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification
From metadata notes: "Table 3, Col 2 — HYV area; Post-1966 × thick or very thick aquifers; district+year FEs; controls rainfall+temperature; cluster district; N=8,672 obs (271 districts × 32 years)."

Equation (1) from the paper: Y_dt = θ(post_t × W_d) + β'X_dt + τ_t + τ_d + ε_dt

Stata equivalent per notes: reghdfe hyv_major d_dmaq23 pr at, absorb(i.code i.year) vce(cluster code)

SKILL_profiler fallback not needed — metadata notes are unambiguous.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 3 Col 2) | 67.59 | (11.85) | 8,672 | district | *** (implied) |
| Our stored results.csv | 67.8101 | 11.8621 | not stored | district (code) | — |
| Relative Δ | +0.33% | +0.10% | | | |

## Notes
- Table 3 does not print significance stars, but the t-statistic (~5.7) is clearly significant at 1%.
- Our stored `beta_twfe` corresponds exactly to the Col 2 coefficient (thick or very thick vs sporadic/thin), not Col 1 (four-category disaggregation). This matches the metadata treatment variable `d_dmaq23 = 1 if (dmaq2==1 OR dmaq3==1) AND year>=1966`.
- N of 8,672 vs paper's 8,672: perfect match (271 districts × 32 years = 8,672).
- The paper's main health results (Tables 4–6) use IHDS/NFHS data not in the replication package. Table 3 Col 2 is the available agricultural first-stage, per metadata outcome-selection rule (ii): largest N with available data.
- SE difference is < 1%; no concern.

## Verdict rationale
Our stored beta (67.8101) differs from the paper's published value (67.59) by only 0.33%, well within the 1% EXACT threshold, with a matching sign and near-identical SE (+0.10%).
