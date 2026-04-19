# Bacon Decomposition Reviewer Report — Article 210 (Li et al. 2026)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability assessment

Applicability rule: `treatment_timing == "staggered"` AND `data_structure == "panel"` AND `allow_unbalanced == false` (or can be pre-balanced).

- `treatment_timing`: "staggered" — YES
- `data_structure`: "panel" — YES
- `allow_unbalanced`: **true** — FAILS the gate

With an unbalanced panel, the Bacon decomposition's additive weight decomposition is invalid (the weights do not sum to 1 in the standard way, and the "clean control" comparison groups are undefined). Metadata explicitly flags `allow_unbalanced=true`.

Additionally, this is an all-eventually-treated design (no never-treated units). The Bacon decomposition in this context contains only "Later vs Earlier Treated" and "Earlier vs Later Treated" pairs — no "Treated vs Never Treated" pairs. The `bacon.csv` file confirms this: all 133 pairs are either "Later vs Earlier Treated" or "Earlier vs Later Treated". This further limits the interpretability of the decomposition.

**Verdict: NOT_APPLICABLE** — unbalanced panel fails the applicability gate. The stored bacon.csv was computed but should be interpreted with extreme caution: it applies only to a balanced sub-sample, and with all-eventually-treated design the decomposition is dominated by TVT pairs with no clean untreated baseline.

## Informational note (from stored bacon.csv)
Despite NOT_APPLICABLE status, the stored bacon.csv reveals important heterogeneity:
- Cohort 688 vs 687: estimate = +0.231 — extreme outlier (41x larger than TWFE aggregate)
- Cohort 701 vs 690: estimate = -0.0601 to +0.098 depending on direction
- Many cohort pairs show wide dispersion from -0.230 to +0.259
- This heterogeneity confirms that the all-eventually-treated TWFE aggregate is masking substantial treatment effect heterogeneity across adoption cohorts
