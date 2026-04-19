# Bacon Decomposition Reviewer Report — Article 419

**Verdict:** NOT_APPLICABLE

**Article:** Kahn, Li, Zhao (2015) — "Water Pollution Progress at Borders"
**Date:** 2026-04-18

---

## Applicability check

Bacon decomposition applies iff `treatment_timing == "staggered"` AND `data_structure == "panel"` AND `allow_unbalanced == false`.

Article 419 has `treatment_timing == "single"` — all treated units adopt simultaneously in 2006. With a single adoption cohort there are no cohort-vs-cohort comparisons to decompose. Bacon decomposition is NOT APPLICABLE.

The `run_bacon: false` flag in metadata.json correctly reflects this.
