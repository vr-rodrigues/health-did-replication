# Bacon Decomposition Reviewer Report — Article 228
# Sarmiento, Wagner & Zaklan (2023) — Air Quality and LEZ

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

---

## Applicability Assessment

Per protocol, bacon-reviewer is applicable iff:
- `treatment_timing == "staggered"` — TRUE (cohorts 2008-2016)
- `data_structure == "panel"` — TRUE
- `allow_unbalanced == false` (or can be pre-balanced) — **FALSE** (`allow_unbalanced: true`)

Since `allow_unbalanced: true` in the metadata, this reviewer is formally **NOT_APPLICABLE**.

---

## Informational note (bacon.csv exists)

Despite the formal NOT_APPLICABLE status, `bacon.csv` was generated as part of the analysis pipeline. The data is provided below for reference only; it does not change the verdict.

### Decomposition summary (informational)

The Bacon decomposition (for informational purposes only given unbalanced panel caveat) identifies:

**Treated vs. Untreated comparisons (dominant):**
The "Treated vs Untreated" pairs carry nearly all the weight (>95% collectively), ranging from cohort 2008 (weight=26.8%, estimate=-1.478) to cohort 2016 (weight=4.5%, estimate=+0.697).

**Notable positive estimates in Treated vs. Untreated:**
- Cohort 2010: estimate=+0.185 (weight=6.1%)
- Cohort 2013: estimate=+0.274 (weight=15.1%)
- Cohort 2016: estimate=+0.697 (weight=4.5%)
- Cohort 2015: estimate=-0.113 (weight=3.6%)

These positive estimates from cohorts 2010, 2013, and 2016 relative to never-treated units suggest heterogeneous effects across adoption timing — the early cohorts (2008, 2009, 2012, 2011) show strong negative effects while some middle cohorts show near-null or positive estimates.

**Later vs. Earlier Treated (LvE) contamination:**
LvE and Earlier vs. Later (EvL) pairs have collectively very small weights (each pair ~0.1-1.0% of total), but several show large magnitudes (e.g., cohort 2011 vs. 2016: +2.531, weight=0.03%). These negative-weight-eligible pairs are a minor contributor to the overall TWFE estimate.

**Interpretation:** The TWFE static estimate (-1.240) is lower in magnitude than CS aggregates (-1.803 to -1.954) primarily because of the heterogeneous "Treated vs. Untreated" comparison across cohorts — early cohorts drive most of the negative effect, while middle cohorts (2010, 2013) contribute near-zero or positive estimates. This is not primarily a forbidden comparison problem but a genuine heterogeneity in treatment effect timing.

---

## Formal conclusion

**NOT_APPLICABLE** per protocol (unbalanced panel). Informational Bacon data is available at `results/by_article/228/bacon.csv` for contextual reference.
