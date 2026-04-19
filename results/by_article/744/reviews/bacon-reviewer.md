# Bacon Decomposition Reviewer Report — Article 744

**Article:** Jayachandran, Lleras-Muney & Smith (2010) — "Modern Medicine and the 20th Century Decline in Mortality"
**Reviewer:** bacon-reviewer
**Date:** 2026-04-18
**Verdict:** NOT_APPLICABLE

---

## Applicability check

- `treatment_timing = "single"` — ALL treated units adopt treatment simultaneously in 1937
- `data_structure = "panel"` — panel data
- `allow_unbalanced = false` — balanced panel

**Bacon decomposition requires staggered adoption timing.** With a single treatment year (1937), all treated units (MMR disease across all states) are treated simultaneously. There are no "timing-variation" or "2×2 DiD" subsets created by different adoption dates. The Bacon-Goodman decomposition is not meaningful in this setting — there is only one comparison: treated (MMR post-1937) vs. never-treated (TB, all periods).

**Decision: SKIP.** `run_bacon = false` in metadata correctly reflects this.

**Verdict: NOT_APPLICABLE**
