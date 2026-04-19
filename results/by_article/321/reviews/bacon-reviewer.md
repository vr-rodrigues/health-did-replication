# Bacon Decomposition Reviewer Report — Article 321 (Xu 2023)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability Assessment

Article 321 has `treatment_timing = "single"` in the metadata panel_setup. All treated units (Indian-DM towns) adopt the treatment simultaneously in 1918. With a single treatment cohort:

- There are no "Earlier vs Later" or "Later vs Earlier" comparison pairs.
- The Goodman-Bacon decomposition is only meaningful under staggered adoption (multiple cohorts with different adoption dates).
- Running bacon on a single-timing design would yield a degenerate decomposition with 100% weight on the single Treated-vs-Untreated (TVU) pair, which is just the 2×2 DiD estimate itself.

**Bacon reviewer is NOT_APPLICABLE for this article.**

No staggered-timing concerns, no negative-weighting from heterogeneous treatment timing, and no forbidden comparisons of the Earlier/Later type.
