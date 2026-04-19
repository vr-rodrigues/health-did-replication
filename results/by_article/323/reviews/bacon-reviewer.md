# Bacon Decomposition Reviewer Report — Article 323

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18
**Article:** Prem, Vargas, Mejia (2023) — "The Rise and Persistence of Illegal Crops"

---

## Applicability assessment

Bacon decomposition requires staggered treatment timing (multiple adoption cohorts). Article 323 has:
- `treatment_timing == "single"` (all treated units adopt in 2014)
- A single cohort (gvar=2014) vs. never-treated (gvar=0)
- 100% Treated-vs-Untreated weight by construction

With a single treatment date, the Bacon decomposition degenerates trivially: there is exactly one 2x2 comparison (treated 2014 vs. never-treated), which accounts for 100% of the TWFE weight. There are no forbidden "Earlier-vs-Later" or "Later-vs-Earlier" comparisons. No staggered-timing bias is possible.

**Verdict: NOT_APPLICABLE**

*This reviewer was skipped per the applicability rule: `treatment_timing == "single"`. Bacon decomposition is not informative for this design.*
