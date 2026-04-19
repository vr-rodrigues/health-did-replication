# Paper fidelity audit: 147 — Greenstone, Hanna (2014)

**Verdict:** WARN
**Date:** 2026-04-19

## Selected specification

From metadata notes and SKILL_profiler protocol: Table 3, Col 8 — one-step version of equation (2C), Panel A (PM / SPM = e_spm_mean), Catalytic converter policy (catconvpolicy). This is the closest published analog to the standard TWFE regression documented in metadata notes (`xi: reg e_spm_mean ... catconvpolicy ... i.city i.year [aw=pop_urban], cluster(city)`). The paper's preferred second-step estimator is equation (2C); column 8 is its one-step OLS equivalent — the standard TWFE representation in the published paper.

Note: The paper's main econometric approach is a two-step procedure (event-study first stage, regression of event-study coefficients on policy indicators as second step). The one-step TWFE (col 8 of Table 3) is explicitly described as the "analogous one-step approach" and is directly comparable to our pipeline's TWFE estimate.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper Table 3 Col 8 (one-step (2C), PM, cat. conv.) | 7.6 | (12.3) | 1,165 | city | not sig |
| Metadata original_result (Stata xi:reg direct output) | 8.01 | (12.59) | 1,172 | city | not sig |
| Our stored results.csv (beta_twfe / se_twfe) | 8.015 | 11.926 | — | city | not sig |
| Relative Δ vs. paper Table 3 Col 8 | +5.5% | −3.0% | | | |
| Relative Δ vs. metadata original_result | +0.1% | −5.3% | | | |

## Notes

- The paper does not run a single conventional TWFE as its main estimator. Its primary approach is a two-step event-study procedure. The one-step OLS version (equation (2C) estimated directly) appears in Table 3, Col 8 as a robustness check alongside the two-step results.
- The N difference between Table 3 Col 8 (1,165) and our stored result / metadata (1,172) is documented in the metadata notes: the Table 3 sample is restricted to the event-study window tau=-7 to +9 for the catalytic converter policy, while the full one-step regression uses all available observations.
- The metadata `original_result` field (beta=8.01, se=12.59) records the direct Stata `xi: reg` output on the full sample. Our stored beta_twfe=8.015 matches this to within rounding precision (0.1% relative difference) — this is an EXACT match against the metadata-documented target.
- The 5.5% gap relative to Table 3 Col 8 (7.6) is entirely explained by the sample restriction difference (1,172 full sample vs. 1,165 event-study window sample).
- SE divergence vs. metadata (12.59 Stata vs. 11.926 R feols): metadata notes document this is due to feols singleton removal. At -5.3% relative difference this is within normal tolerance.
- SE divergence vs. Table 3 Col 8 (12.3) is -3.0%, well within tolerance.
- The paper reports catconvpolicy coefficient is positive (increase in SPM = 8 ug/m3) and statistically insignificant — consistent with our stored result (sign match, insignificant).

## Verdict rationale

Our stored TWFE (8.015) differs from the closest published table number (7.6 in Table 3 Col 8) by 5.5%, placing the verdict formally at WARN. However, this divergence is fully mechanistically explained by sample restriction (full sample N=1,172 vs. event-study-window-restricted N=1,165) and is documented in the metadata notes. Our result is EXACT against the metadata-recorded target (8.01). The WARN verdict reflects the 5.5% gap vs. the published table, not a specification misalignment.
