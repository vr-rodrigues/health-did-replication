# Paper fidelity audit: 321 — Xu (2023)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification
From metadata notes: Table 2, Column 3 — Town-Level Mortality by Indian versus Non-Indian District Officer; Town + Year FEs; full sample; standard errors clustered at district level; outcome = log(Town-level deaths); interaction term Pandemic × Indian DO.

This is the paper's headline specification as stated in metadata `original_result.source` and confirmed by the paper's Section IV.B ("Main Result and Robustness"), which describes column 3 as the baseline with town and year fixed effects.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Col 3) | -0.142 | (0.041) | 14,714 | district | *** |
| Our stored results.csv | -0.142352 | 0.041021 | 14,714 | district | *** |
| Relative Δ | -0.25% | 0.05% | | | |

Calculations:
- rel_diff_beta = (-0.142352 − (−0.142)) / |−0.142| = −0.000352 / 0.142 = −0.0025 (−0.25%)
- rel_diff_se   = (0.041021 − 0.041) / 0.041 = 0.000021 / 0.041 = 0.0005 (0.05%)

## Notes
- The paper reports a rounded value of -0.142; our stored value of -0.142352 is the full-precision estimate, consistent with rounding to -0.142 at three decimal places.
- SE agreement is near-perfect (0.05% difference), confirming identical clustering at the district level (`did` variable in the data).
- N = 14,714 town-years matches exactly; the metadata records this as 1,061 towns × 205 districts over the study period.
- The treatment variable is `indian_dm1918_post` (pre-computed interaction of Indian DO indicator × pandemic post dummy), matching the paper's Equation (1).
- No controls are included in this specification (twfe_controls = []), consistent with the paper's Column 3 which adds only Town + Year FEs over Column 2.
- Single treatment timing (1918); CS-DID is run but comparison is not required for this audit.

## Verdict rationale
Our stored beta (-0.142352) differs from the paper's reported value (-0.142) by only 0.25% with a sign match, falling comfortably within the EXACT threshold of 1%.
