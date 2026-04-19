# Bacon Decomposition Reviewer Report — Article 201 (Maclean & Pabilonia 2025)

**Verdict:** NOT_APPLICABLE

**Date:** 2026-04-18

## Applicability assessment
Per protocol, Bacon decomposition is applicable iff:
- treatment_timing == "staggered": YES
- data_structure == "panel": NO — data_structure is "repeated_cross_section"
- allow_unbalanced == false (or can be pre-balanced): allow_unbalanced == true

Applicability gate NOT met: data_structure is repeated_cross_section, not panel. Bacon decomposition requires balanced panel data (or data that can be balanced). The ATUS repeated cross-section does not allow tracking the same units over time.

**Note:** Despite NOT_APPLICABLE status, bacon.csv was produced (likely on the yearly collapsed CS panel). Results are reported below for informational purposes only — they should not be used to mechanically assess the TWFE ATT since the underlying data for the TWFE is monthly RCS, not the yearly collapsed panel.

## Bacon results (informational only, from yearly collapsed panel)
| Cohort (treated) | Comparison (untreated) | ATT | Weight | Type |
|---|---|---|---|---|
| 163 (2017) | 99999 (never-treated) | -3.97 | 47.7% | Treated vs Untreated |
| 194 (2020) | 99999 (never-treated) | +10.12 | 33.9% | Treated vs Untreated |
| 228 (2022) | 99999 (never-treated) | -21.49 | 10.4% | Treated vs Untreated |
| 194 | 163 | +7.62 | 0.5% | Later vs Earlier Treated |
| 228 | 163 | -21.93 | 0.2% | Later vs Earlier Treated |
| 163 | 194 | -3.32 | 1.6% | Earlier vs Later Treated |
| 163 | 228 | +4.46 | 3.4% | Earlier vs Later Treated |
| 194 | 228 | +11.40 | 2.1% | Earlier vs Later Treated |
| 228 | 194 | -47.52 | 0.1% | Later vs Earlier Treated |

## Key findings (informational)
1. Cohort 2020 dominates with 33.9% weight and ATT=+10.12 — this cohort is most plausibly confounded with COVID-19 (2-year PSL lag means a 2018 adoption becomes "active" in 2020).
2. Cohorts 2017 (-3.97) and 2022 (-21.49) show negative ATTs, partially offsetting.
3. Earlier vs Later Treated and Later vs Earlier Treated comparisons are small weight (<5%) — minimal "forbidden comparison" contamination from these.
4. The TWFE weighted average (+4.61) primarily reflects the size-weighted blend of Cohort 2017 (-4, 48%) and Cohort 2020 (+10, 34%), with Cohort 2022 (-21, 10%) partially cancelling.

## Conclusion
NOT_APPLICABLE per protocol (RCS data). The informational Bacon results confirm the COVID-confounding hypothesis for Cohort 2020 and explain the TWFE vs CS-NT divergence.
