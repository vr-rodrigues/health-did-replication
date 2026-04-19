# Bacon Decomposition Reviewer Report — Article 335
# Le Moglie, Sorrenti (2022) — "Revealing 'Mafia Inc.'?"

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability Assessment

Bacon decomposition is applicable iff:
- `treatment_timing == "staggered"` AND
- `data_structure == "panel"` AND
- `allow_unbalanced == false` (or pre-balanceable)

Article 335 metadata:
- `treatment_timing`: "single" (all treated units adopt in 2007 simultaneously)
- `data_structure`: "panel" ✓
- Treatment timing is NOT staggered.

**Result: NOT_APPLICABLE**

With a single treatment cohort, the Bacon decomposition produces a trivial result: 100% of the TWFE estimate comes from the clean 2×2 comparison (treated cohort post-2007 vs. never-treated). There are no cross-cohort comparisons to decompose, no "forbidden comparisons" using already-treated units as controls. The Bacon decomposition is unnecessary and uninformative in this design.
