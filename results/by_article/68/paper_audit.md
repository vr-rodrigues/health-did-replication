# Paper fidelity audit: 68 — Tanaka (2014)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

Table 3, Column 2 — "Effects of Free Health Care on Newborns"; equation (2) specification with community fixed effects and cohort fixed effects, no household or community controls.

Selection rationale: our TWFE implementation uses `twfe_fe_override = "clustnum"` (community FEs), which absorbs the `High` dummy and matches equation (2) structurally. The metadata `original_result` field now explicitly records `beta_twfe = 0.571` with `table_reference = "Table 3 Col 2 (community FEs, no controls)"`. Per SKILL_profiler rule (i)(b), the correct target is the column the metadata explicitly names — Col 2. The earlier audit against Col 1 (pooled OLS baseline, β = 0.522) was comparing our Col-2 implementation to the wrong column.

Paper text (p. 291–292): "Column 2 provides results from equation (2), where community fixed effects absorb effects through time-invariant unobserved differences across communities, and where cohort fixed effects control for factors common to each cohort as well as the main post-period effect."

Sample: children aged 0–3 from KIDS93 (pre-reform) and KIDS98 (post-reform); restricted to black Africans with non-missing WAZ in plausible range (WAZ > −6 and WAZ < 5) and non-missing clinic93. N = 1,071 individual observations. SE clustered at the community level (62 communities).

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Table 3 Col 2) | 0.571 | (0.256) | 1,071 | community (62) | ** |
| Our stored results.csv | 0.5672 | 0.2412 | 1,071 | clustnum | — |
| Relative Δ | −0.66% | −5.8% | — | — | — |

Calculations:
- rel_diff_beta = (0.5672 − 0.571) / |0.571| = −0.0038 / 0.571 = −0.66%
- rel_diff_se   = (0.2412 − 0.256) / |0.256|  = −0.0148 / 0.256 = −5.78%

## Notes

- The −0.66% beta gap is well under the 1% EXACT threshold and the sign matches (both positive).
- The SE gap of −5.8% is within the 30% tolerance for SE divergence; the slight difference is expected given that the paper uses robust SEs clustered at community level and our implementation may use a marginally different degrees-of-freedom correction with 62 clusters.
- Col 1 (pooled OLS, β = 0.522, SE = 0.235) was used in the prior audit and produced an 8.7% beta gap (WARN). That comparison was incorrect because our `twfe_fe_override: "clustnum"` makes community FEs absorb the `High` regressor, producing a Col-2-equivalent estimator — not a Col-1-equivalent one.
- N matches exactly (1,071 in both paper and our run).
- Significance: paper reports ** (5% level) for Col 2; our stored estimate is not directly tested here, but the magnitude and SE are consistent with significance at the 5% level.

## Verdict rationale

Our stored β = 0.5672 is within 0.66% of the paper's Col 2 value (β = 0.571), well below the 1% EXACT threshold. The corrected target column (Col 2) aligns with our actual implementation (community FEs via `twfe_fe_override`), and the metadata `original_result` field now explicitly records this. Verdict: EXACT.
