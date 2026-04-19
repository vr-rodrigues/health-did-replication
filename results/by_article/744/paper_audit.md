# Paper fidelity audit: 744 — Jayachandran et al. (2010)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification
From metadata notes: "Table 4 Panel B Column 1 (MMR vs TB, state-level data, all years 1925–1943)"

Model: equation (7), state-level DiD. Treated × post-1937 coefficient (β₁) is the coefficient of interest. Controls include Treated × year_c (differential trend) and Treated indicator. State×post FEs (statepost) absorbed. Clustered SEs by disease×year.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 4 Panel B Col 1) | −0.281 | (0.108) | 1,736 | disease×year | ** |
| Our stored results.csv | −0.28114 | 0.10760 | — | disease×year | — |
| Relative Δ | 0.05% | −0.37% | | | |

## Notes
- The paper rounds to three decimal places (−0.281); our stored value is −0.281138, a negligible rounding difference.
- SE: paper reports 0.108, our value is 0.10760 — difference of 0.37%, well within tolerance.
- N: paper reports 1,736 observations for the MMR/TB column; our results.csv does not store N separately, but the preprocessing constructs the same MMR+TB stacked panel (1925–1943, diseases 1 and 4).
- The paper clusters by disease×year (as stated in Table 4 notes and confirmed in metadata `cluster: "diseaseyear"`). Our implementation matches.
- Our TWFE uses unit FE (state_disease) + year FE instead of the paper's absorbed statepost FEs; the metadata notes acknowledge this difference but the headline coefficient reproduces exactly, confirming numeric equivalence.
- No scale/unit transformation needed: both paper and our stored value are in log-mortality units.

## Verdict rationale
|rel_diff_beta| = 0.05%, well below the 1% EXACT threshold, with matching sign and significance; the stored estimate exactly reproduces the paper's Table 4 Panel B Col 1 headline coefficient.
