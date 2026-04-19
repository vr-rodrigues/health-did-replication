# Bacon Reviewer Report: Article 1094

**Verdict: NOT_APPLICABLE**
**Date:** 2026-04-18
**Paper:** Fisman & Wang (2017) — "The Distortionary Effects of Incentives in Government: Evidence from China's Death Ceiling Program"

---

## Applicability Assessment

Bacon decomposition requires:
- `treatment_timing == "staggered"`: YES
- `data_structure == "panel"`: YES
- `allow_unbalanced == false` (or can be pre-balanced): NO — `allow_unbalanced: true`

The panel is unbalanced (province x industry units across 1993-2013 with varying coverage). The Bacon decomposition estimator requires a balanced panel to produce valid 2x2 decomposition weights. Since `allow_unbalanced=true`, the formal Bacon decomposition with valid weight interpretation is not applicable.

Note: The analysis pipeline did run a Bacon decomposition (`run_bacon=true` in metadata, bacon.csv exists), but the weights and estimates should be interpreted with caution given the unbalanced panel structure. The bacon.csv results are used qualitatively by the de Chaisemartin reviewer for cross-reference only.

**Verdict: NOT_APPLICABLE**

Reason: `allow_unbalanced=true`; formal Bacon decomposition requires a balanced panel for valid weight decomposition.
