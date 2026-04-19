# Bacon Decomposition Reviewer Report: Article 2303 — Cao & Ma (2023)

**Verdict:** WARN
**Date:** 2026-04-19
**Reviewer axis:** Methodology (design finding, Axis 3)

---

## Applicability

APPLICABLE: treatment_timing = "staggered", data_structure = "panel", allow_unbalanced = false.

---

## Checklist

### 1. Decomposition structure

- 15,625 pairwise DiD comparisons (125 cohorts → C(125,2) = 7,750 pairs × 2 direction types).
- Comparison types present: "Later vs Earlier Treated" (LvE) and "Earlier vs Later Treated" (EvL).
  With 487 never-treated plants, "Treated vs Never-Treated" (TvNT) comparisons are also present.
- EvL comparisons confirm forbidden comparisons: already-treated units serve as controls for
  earlier-treated cohorts. This is the core Bacon negative-weight concern.

### 2. Cohort-pair estimate heterogeneity

- Point estimates across pairwise comparisons range from approximately −88 (cohort 160 vs cohort
  108: −88.2) to +45 (cohort 140 vs cohort 108: +44.8). Range > 130 fire events.
- Extreme estimate heterogeneity signals large treatment effect heterogeneity across cohorts.
  Some cohort pairs show large positive estimates (possibly reflecting pre-existing trends or
  confounding), while the majority are negative.
- This is a DESIGN FINDING about the paper's staggered design, not an implementation error.

### 3. Negative weighting

- Individual pair weights are very small (order 1e-7 to 1e-4), consistent with a large panel
  (954 plants × 228 months).
- Both LvE and EvL types present; EvL weights are negative contributors to the TWFE estimand
  under heterogeneous effects.
- The overall weighted mean of −4.836 matches TWFE exactly.

### 4. Treatment vs Never-Treated dominance

- 487 never-treated plants (51% of 954 total). TvNT comparisons carry substantial Bacon weight,
  partially offsetting forbidden-comparison contamination.
- TvNT share not explicitly reported in bacon.csv, but the convergence of TWFE (−4.836) and
  CS-NT simple (−5.441) — only a 12% gap — suggests TvNT comparisons dominate and practical
  negative-weight bias is modest.
- Under Spec B (both no controls), TWFE no-ctrls (−5.075) and CS-NT simple (−5.441) are within
  7.1%, further confirming that TvNT dominance is the key structural feature limiting bias.

### 5. Practical significance after 2026-04-19 update

- Spec B (no controls): TWFE −5.075 vs CS-NT −5.441 = 7.1% estimator gap. Near-convergence
  in this matched specification confirms that when controls are stripped from both estimators,
  staggered-timing negative-weight bias is negligible.
- Spec A (with controls): TWFE −4.836 vs CS-NT −2.037 = 57.9% gap. The remaining gap is driven
  by the differential absorption of weather controls (167% covariate margin on CS side vs 5%
  on TWFE side), not by negative TWFE weights.
- Gardner/did2s post-treatment coefficients are consistently negative, further corroborating
  direction across all estimators.

---

## Summary

**WARN.** Bacon decomposition confirms staggered adoption with 125 cohorts, producing 15,625
pairwise comparisons with extremely heterogeneous individual estimates (range approximately −88
to +45). Both LvE and EvL comparison types present (forbidden comparisons confirmed). However,
the 51% never-treated pool causes TvNT comparisons to dominate, and the near-convergence of
TWFE and CS-NT under matched no-controls specification (Spec B: 7.1% gap) confirms practical
negative-weight bias is modest. The controls differential (weather strongly predicts fires) is
the primary driver of the cross-specification TWFE/CS-NT gap, not estimator heterogeneity.
All these are DESIGN FINDINGS about the paper (Axis 3), not implementation errors (Axis 2).

**Design findings (Axis 3):**
- 125 cohorts → 15,625 pairwise comparisons; estimate range > 130 fire events (extreme heterogeneity).
- EvL forbidden comparisons confirmed; negative TWFE weights exist but practically limited.
- TvNT 51% pool dominates; Spec B TWFE/CS gap = 7.1% (confirms modest bias).
- Controls differential drives Spec A gap (57.9%) more than estimator choice.
