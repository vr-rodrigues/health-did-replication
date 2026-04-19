# Bacon Decomposition Reviewer Report — Article 21 (Buchmueller & Carey 2018)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18
**Reviewer:** bacon-reviewer

---

## Applicability assessment

The Bacon decomposition reviewer requires:
- `treatment_timing == "staggered"` — MET
- `data_structure == "panel"` — MET
- `allow_unbalanced == false` (or can be pre-balanced) — NOT MET (`allow_unbalanced = true`)

The panel for this article is unbalanced (`allow_unbalanced = true`). The Bacon decomposition as implemented in the `bacondecomp` R package requires a balanced panel. While a bacon decomposition was run (bacon.csv exists with results), the theoretical validity of the decomposition under an unbalanced panel is not guaranteed.

**Verdict: NOT_APPLICABLE** — unbalanced panel violates the applicability criterion.

---

## Informational note (from bacon.csv, for reference only)

Although the formal verdict is NOT_APPLICABLE, the bacon.csv results are reported here for context. The decomposition shows:

| Comparison | Total weight |
|---|---|
| Treated vs Never-treated | ~89.2% |
| Later vs Earlier treated | ~10.8% |

If the panel were balanced, this would indicate minimal contamination from timing-based comparisons. The actual validity of these weights under the unbalanced setting is uncertain.
