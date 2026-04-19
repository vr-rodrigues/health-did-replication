# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 47 (Clemens 2015)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Applicability assessment
de Chaisemartin & D'Haultfoeuille (2020, 2022) decompositions are designed to detect negative weights arising from:
1. Staggered treatment adoption (heterogeneous timing)
2. Non-absorbing treatment (units can enter and exit treatment)
3. Continuous or heterogeneous-dose treatment

For article 47:
- `treatment_timing == "single"`: all treated states adopt community rating simultaneously. No differential timing.
- Treatment is absorbing binary: once a state adopts community-rating regulation, it is coded as treated throughout the sample (within the analysis window). Kentucky and New Hampshire, which repealed their community-rating regimes, are EXCLUDED from the primary estimating sample (excluded state_fips 21 and 33). The remaining treated states (NY, ME, VT) maintain their regulations throughout.
- Treatment is binary (not continuous, not dose-varying).

Under these conditions, the de Chaisemartin & D'Haultfoeuille critique does not apply. With a single cohort, absorbing binary treatment, and a clean never-treated comparison group, TWFE is mechanically equivalent to a clean 2×2 DiD. There are no negative weights.

## Confirmation from Bacon decomposition
The bacon.csv shows 100% weight on "Treated vs Untreated" — confirming zero contamination from timing-based comparisons.

## Verdict: NOT_NEEDED
The standard absorbing-binary single-cohort design is precisely the setting where TWFE is unbiased with respect to the de Chaisemartin critique. No further decomposition is warranted.

