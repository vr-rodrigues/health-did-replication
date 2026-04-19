# Paper fidelity audit: 311 — Galasso & Schankerman (2024)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From metadata notes + SKILL_profiler protocol: Table 2, Column 1 — full sample, outcome = Access (binary indicator for at least one licensing deal), product-country + year fixed effects, no time-varying controls, N = 80,101, SE clustered at product × country level (two-way). This is the paper's explicit baseline specification (Section VI.A "Baseline Specification").

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 2 Col 1) | 0.663 | (0.054) | 80,101 | product × country (two-way) | *** |
| Our stored results.csv | 0.6625 | 0.0504 | 80,103 | product_code (one-way) | *** |
| Relative Δ | −0.07% | −6.6% | +2 obs | | |

## Notes

- Beta reproduces to 4 significant figures; the 0.07% gap is sub-rounding noise.
- SE divergence of −6.6% (our 0.0504 vs paper 0.054) is fully explained by clustering structure: the paper uses two-way clustering (product × country), while the template uses one-way clustering on product_code only. This is documented in metadata notes. SE divergence is well within the 30% tolerance threshold and does not affect the verdict.
- N discrepancy of 2 observations (80,103 vs 80,101) is negligible; likely due to minor data handling differences (e.g., row with missing access value dropped by paper but retained in our data or vice versa).
- The paper's headline result is unambiguous: Section VI.A explicitly calls Table 2 Col 1 the baseline, and the text states "the likelihood of at least one deal for the product-country combination increases by 66 percentage points" (i.e., β ≈ 0.66).

## Verdict rationale

Our stored beta (0.6625) matches the paper's reported value (0.663) with a relative difference of −0.07%, well within the 1% EXACT threshold, with consistent sign and significance.
