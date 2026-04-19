# Bacon review: 201 — Maclean & Pabilonia (2025)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-19

## Applicability

Bacon decomposition requires `treatment_timing == "staggered"` AND `data_structure == "panel"` AND the data be pre-balanceable.

- treatment_timing: staggered (YES)
- data_structure: repeated_cross_section (NO — RCS, not panel)
- allow_unbalanced: false

Because data_structure = repeated_cross_section, the Bacon decomposition is formally NOT_APPLICABLE. An individual ATUS respondent appears in the data for exactly one diary day, so there is no within-unit variation to decompose. The bacon.csv in the article folder was generated using state-year aggregated data as a diagnostic exercise (informational only).

## Informational Bacon results (state-year pseudo-panel, diagnostic)

Despite formal inapplicability, the template ran a Bacon decomposition on a state-year aggregated version to diagnose cohort-weighting effects. Results from `results/by_article/201/bacon.csv`:

| Treated cohort | Control | Pair type | Weight | ATT |
|---|---|---|---|---|
| 163 (Cohort 2017) | 99999 (never-treated) | Treated vs Untreated | 47.73% | -3.969 |
| 194 (Cohort 2020) | 99999 (never-treated) | Treated vs Untreated | 33.97% | +10.123 |
| 228 (Cohort 2022) | 99999 (never-treated) | Treated vs Untreated | 10.42% | -21.493 |
| 163 (2017) | 194 (2020) | Earlier vs Later | 3.36% | +4.464 |
| 194 (2020) | 228 (2022) | Earlier vs Later | 2.09% | +11.397 |
| 163 (2017) | 194 (2020) | Later vs Earlier | 0.45% | +7.623 |
| 228 (2022) | 163 (2017) | Later vs Earlier | 0.25% | -3.318 |
| 228 (2022) | 194 (2020) | Later vs Earlier | 0.00% | -47.518 |

Key diagnostics:
- Cohort 2020 (ATT=+10.12, weight=34%): Treatment activation year 2020 coincides with COVID-19 lockdowns. The 2-year PSL lag maps 2018 PSL adoptions to 2020 treatment activation. COVID dramatically increased parental childcare time, contaminating this cohort's ATT.
- Cohort 2017 (ATT=-3.97, weight=48%): The largest cohort by weight shows a negative, modest effect — consistent with the hypothesis that PSL reallocates labor market time rather than increasing childcare.
- Cohort 2022 (ATT=-21.49, weight=10%): Large negative effect; post-pandemic reversal as parents returned to work.
- TVT (treated vs later-treated forbidden comparisons): Small weights (0.45% + 0.25% + 0.00%) — forbidden comparisons are negligible.
- Sign reversal mechanism: TWFE (+4.61) and Gardner agree because both weight cohort-proportionally (2020 cohort = 34% TWFE weight, positive ATT dominates). CS-NT weights uniformly by group×time, distributing weight more evenly across all 6 cohorts (3 negative ATTs vs 1 large positive), flipping the sign.

## Design finding

The COVID-contamination of Cohort 2020 is the primary threat to causal identification in this paper. TWFE and Gardner both yield positive estimates because they size-weight cohorts, giving 34% weight to the COVID-contaminated Cohort 2020. CS-NT's uniform weighting reveals that the majority of cohorts (2017, 2022, and by extension 2019) show negative or null effects. This is a **design credibility finding** (Axis 3), not an implementation error. The authors conduct their own Bacon analysis (reported: 98.5% reasonable comparisons, 1.5% forbidden) and use Gardner as their primary estimator for this reason.

## Recommended action

None required. Formal Bacon is correctly skipped. Informational decomposition is consistent with metadata notes and prior report. COVID contamination of Cohort 2020 should be prominently flagged in the consolidated skeptic report as the key confound.
