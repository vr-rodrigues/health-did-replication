# Bacon Decomposition Reviewer Report — Article 76 (Lawler & Yewell 2023)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability check

Bacon decomposition requires:
- `treatment_timing == "staggered"`: YES
- `data_structure == "panel"`: NO — metadata specifies `"repeated_cross_section"`
- `allow_unbalanced == false` (or pre-balanceable): NOT MET — `allow_unbalanced: true`

**Result: SKIP — data structure is repeated cross-section, not panel.**

Bacon decomposition (Goodman-Bacon 2021) requires a balanced or pre-balanced panel at the unit-time level. Individual-level repeated cross-section data cannot be passed to `bacondecomp` directly. The template sets `run_bacon: false` for this paper for this reason.

Note: A bacon-like analysis was run on the aggregated data (bacon.csv exists with 57 comparisons). This was produced via a custom aggregation. Results are informational only and reviewed separately as a design signal.

## Informational: Aggregated Bacon decomposition signals

The bacon.csv file contains estimates across 57 pairwise cohort comparisons. Key observations:

**Treated-vs-untreated comparisons (dominant weight ~80%):**
- 2008 vs never-treated: +0.036 (weight 17.0%) — positive
- 2005 vs never-treated: +0.006 (weight 14.6%) — small positive
- 2006 vs never-treated: +0.024 (weight 15.9%) — positive
- 2013 vs never-treated: +0.085 (weight 10.3%) — strongly positive
- 2015 vs never-treated: -0.035 (weight 8.0%) — NEGATIVE

**Later-vs-earlier (contaminated) comparisons:**
Several Later-vs-Earlier comparisons show negative estimates (e.g., 2015 vs 2013: -0.135; 2015 vs 2008: -0.111; 2015 vs 2002: -0.163). These are "bad comparisons" in the Goodman-Bacon sense — using already-treated units as controls.

The 2015 cohort has a negative TVU estimate (-0.035) AND appears as a contaminated control for earlier cohorts with strongly negative estimates. This is a design signal that the 2015 cohort may be experiencing a different (or delayed) effect, potentially contaminating the TWFE aggregate.

However, because this is RCS data, formal Bacon decomposition statistics (weighted sums recovering TWFE) cannot be validated. These are informational signals only.

**Verdict: NOT_APPLICABLE** (data structure is repeated cross-section)
