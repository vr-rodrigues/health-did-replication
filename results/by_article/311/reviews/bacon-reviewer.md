# Bacon Decomposition Reviewer Report — Article 311

**Verdict:** WARN

**Reviewer:** bacon-reviewer
**Date:** 2026-04-18
**Article:** Galasso & Schankerman (2024) — Licensing Life-Saving Drugs for Developing Countries

---

## Applicability check
- `treatment_timing == "staggered"`: YES
- `data_structure == "panel"`: YES
- `allow_unbalanced == false`: YES (in metadata)

**Applicability: YES** — Bacon decomposition is methodologically warranted for this staggered design.

---

## Checklist

### 1. Was Bacon run?
- `run_bacon = false` in metadata.
- Bacon decomposition was **disabled** — the notes field states: "Bacon decomposition disabled due to large dataset size."
- No bacon output files found in `results/by_article/311/`.

### 2. Is this flag appropriate?
- Dataset: 6746 units × 14 years = ~94,444 observations. This is not trivially large for the `bacondecomp` package in R.
- The `bacondecomp` package performs an O(G²) decomposition where G is the number of groups/cohorts. With 7 treatment cohorts + 1 never-treated group, the computation is 8×7/2 = 28 2×2 comparisons — very manageable.
- **WARN:** The stated reason ("large dataset size") does not justify disabling bacon for a 7-cohort design. The computational bottleneck in `bacondecomp` is unit count only when using within-unit variation, not cohort count. This flag should be revisited.

### 3. What we would expect
- The Bacon decomposition would reveal: (a) the weight assigned to each 2×2 DD comparison; (b) whether any "bad" comparisons (already-treated vs. later-treated) receive substantial weight; (c) the implied variance-weighted ATT.
- With 84.6% never-treated units, the never-treated vs. treated comparisons likely dominate, which is a favorable configuration.
- Without the decomposition, we cannot formally assess whether TWFE's 0.663 is a clean average.

### 4. Alternative evidence
- Event study post-period coefficients from TWFE (0.62–0.77) and SA (0.60–0.73) are broadly consistent across time, suggesting limited heterogeneity in treatment effect timing — a positive signal that Bacon weights are less likely to be severely contaminated.

---

## Summary

Bacon decomposition was disabled based on a data-size justification that does not hold for a 7-cohort staggered design. With 7 cohorts and 84.6% never-treated, the decomposition would be fast and informative. The absence of Bacon output prevents formal verification of TWFE weight signs, though event-study consistency across TWFE and SA provides indirect reassurance. `run_bacon` should be set to `true` and the analysis re-run.

**Verdict: WARN** (Bacon disabled on questionable grounds; cannot formally verify TWFE negative weights)
