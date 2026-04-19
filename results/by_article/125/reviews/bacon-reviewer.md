# Bacon Decomposition Reviewer Report — Article 125
**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability Assessment

Bacon decomposition requires:
1. `treatment_timing == "staggered"` — YES (5 cohorts: 2003, 2005, 2006, 2007, 2008)
2. `data_structure == "panel"` — NO (`data_structure == "repeated_cross_section"`)
3. `allow_unbalanced == false` (or pre-balanceable) — NO (`allow_unbalanced == true`)

**Conditions 2 and 3 both fail.** The Bacon-Goodman (2021) decomposition theorem applies to balanced panel data. This dataset is a repeated cross-section of individuals, not a panel of individuals followed over time. Even aggregating to the state-year level would produce an unbalanced structure given the RCS nature of the MEPS/CPS survey data. Metadata explicitly sets `run_bacon=false`.

## Informational Note (from bacon.csv)

Although the metadata sets `run_bacon=false`, the `bacon.csv` file was generated as a diagnostic artefact. Its structure shows:

- **Treated vs Untreated pairs (TvsU)**: 5 cohort-control comparisons, total weight ~82.8%.
  - Cohort 2007 dominates: weight 43.6%, estimate -0.0024.
  - Cohort 2005 is notable: weight 12.5%, estimate +0.031 (sign discordant).
- **Treated vs Treated pairs (TVT)**: 20 pairs, weight ~15.2%.
- **Always-treated vs later-treated (AT)**: 5 pairs, weight ~2.0%.

The TVT weight (~15%) is non-negligible, and the cohort 2005 estimate (+0.031) diverges substantially from the dominant cohort 2007 (-0.002). However, since this is a RCS dataset, these numbers represent a pseudo-Bacon applied to an aggregated cohort-year dataset, not a proper individual-panel decomposition. Results should be treated as **illustrative, not authoritative**.

**Verdict: NOT_APPLICABLE** (RCS design, `run_bacon=false` in metadata).
