# Bacon Decomposition Reviewer Report — Article 47 (Clemens 2015)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability ruling
Bacon decomposition requires staggered treatment adoption across units AND a balanced (or balanceable) panel structure. Article 47 has:
- `treatment_timing == "single"`: all treated states (NY, ME, VT) adopt community rating simultaneously in 1993. There is no differential timing across treated units.
- `data_structure == "repeated_cross_section"`: not a true panel.

Both conditions for Bacon applicability fail. The Bacon decomposition is NOT APPLICABLE for this article.

## Note on bacon.csv
A bacon.csv file exists in the results directory, showing a single row:
`treated=7, untreated=99999, estimate=-0.100494, weight=1.0, type="Treated vs Untreated"`

With only one effective cohort (g=7) and all other units as never-treated (99999), the Bacon decomposition collapses to a single 2×2 comparison — identical in structure to the TWFE estimate. This confirms the absence of staggered-timing bias: 100% of the TWFE weight falls on the clean "treated vs. never-treated" comparison. No contamination from timing-based heterogeneity is present.

The Bacon estimate (-0.1005) is close to but not identical to TWFE (-0.0962), reflecting the absence of covariate adjustment in the decomposition. This is expected behavior.

