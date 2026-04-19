# Paper fidelity audit: 254 — Gandhi et al. (2024)

**Verdict:** NOT_APPLICABLE (treatment definition mismatch — no directly comparable TWFE estimate)
**Date:** 2026-04-19

## Selected specification
From paper Figure 2a (main results figure, All Facilities panel): pooled DD estimate for all Illinois facilities vs. all non-Illinois facilities, outcome = STRIVE ratio (% of clinical target), weekly panel 2021Q2–2023Q2, N = 4,083,670 facility-week observations (15,828 facilities), robust SE clustered at facility level.

The paper does not present a standalone regression table with TWFE coefficients and SEs. All quantitative results are reported as "Pooled" values in the lower-right corner of event-study figures (Figure 2).

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Figure 2a, All Facilities) | 5.35 | (0.63) | 4,083,670 obs / 15,828 facilities | facility (CCN) | *** |
| Our stored results.csv (beta_twfe) | 5.491 | (0.581) | not reported | facility (CCN) | *** |
| Relative Δ | +2.6% | −7.8% | | | |

## Notes

- **Critical structural mismatch:** The paper's treatment variable is `IL_i` — a binary indicator equal to 1 for ALL Illinois facilities, compared to all non-Illinois facilities in the United States. The paper's main specification is a standard state-level DiD event study: `y_it = Σ β^τ (IL_i × d_t^τ) + α_i + α_t + ε_it`.

- **Our treatment variable (`Post_avg`)** is a discretized analyst-created binary: high-Medicaid IL facilities (above-median Medicaid share, 342 CCNs) = 1 vs. low-Medicaid IL facilities (308 CCNs) = 0. This compares two groups of Illinois facilities against each other, not Illinois vs. the rest of the United States.

- The metadata `notes` field explicitly documents this: "DISCRETIZED treatment (created by analyst, not paper). Paper uses continuous treatment (illinois * post) for main spec."

- The metadata `original_result` field is empty `{}`, confirming no comparable TWFE estimate was recorded at profiling time.

- **Numerical coincidence:** The surface-level relative difference is only +2.6% (our 5.491 vs. paper's 5.35). However, this numerical proximity is coincidental — the two estimates measure fundamentally different quantities: (a) the paper measures the average IL facility's response relative to non-IL facilities; (b) our stored estimate measures the high-Medicaid IL facility response relative to low-Medicaid IL facilities. Comparing them would be methodologically meaningless.

- The paper also separately reports pooled estimates for High-Medicaid facilities (9.00, SE 0.69) and Low-Medicaid facilities (1.53, SE 0.96) in Figure 2b/2c. Our `beta_twfe_high` = 8.843 and `beta_twfe_low` = 1.720 could in principle be compared to those, but those are subgroup event-study estimates from the paper's full-sample (IL vs. all other states) design, still using a different sample and treatment definition than our stored estimates.

- The SE for the paper's full-sample pooled estimate (0.63) vs. our stored SE (0.581) shows a −7.8% relative difference, within the 30% tolerance threshold, but this comparison is moot given the treatment mismatch.

## Verdict rationale
The paper's headline TWFE uses Illinois as a binary treatment indicator (all IL facilities vs. all non-IL US facilities), while our stored `beta_twfe` is based on an analyst-constructed binary separating high- vs. low-Medicaid IL facilities. There is no comparable TWFE estimate in our results.csv that corresponds to the paper's actual specification; therefore the verdict is NOT_APPLICABLE.
