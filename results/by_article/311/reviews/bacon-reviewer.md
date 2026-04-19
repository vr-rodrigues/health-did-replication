# Bacon Decomposition Reviewer Report — Article 311

**Verdict:** WARN

**Reviewer:** bacon-reviewer
**Date:** 2026-04-19 (updated to reflect allow_unbalanced = true; substantive verdict unchanged)
**Article:** Galasso & Schankerman (2024) — Licensing Life-Saving Drugs for Developing Countries

---

## Applicability check
- `treatment_timing == "staggered"`: YES
- `data_structure == "panel"`: YES
- `allow_unbalanced == false`: NO — as of 2026-04-19, `allow_unbalanced = true`

Note: The protocol gate is `allow_unbalanced == false OR can be pre-balanced`. With `allow_unbalanced = true`, the panel is processed natively as unbalanced. The `bacondecomp` package requires a balanced panel, so Bacon would need a pre-balancing step. This is feasible for a 7-cohort design, but `run_bacon = false` is set in metadata, so it was not run.

**Applicability: YES (Bacon is methodologically warranted; however run_bacon = false — see below)**

---

## Checklist

### 1. Was Bacon run?
- `run_bacon = false` in metadata.
- Bacon decomposition was **disabled** — the notes field states: "Bacon decomposition disabled due to large dataset size."
- No bacon output files found in `results/by_article/311/`.

### 2. Is this flag appropriate?
- Dataset: 6,746 units × 14 years = ~94,444 observations. This is not trivially large for the `bacondecomp` package in R.
- The `bacondecomp` package performs an O(G²) decomposition where G is the number of groups/cohorts. With 7 treatment cohorts + 1 never-treated group, the computation involves 28 two-by-two comparisons — very manageable.
- The panel is unbalanced (84.8% fill rate). `bacondecomp` requires a balanced panel. Pre-balancing by dropping units not observed in all 14 years would retain approximately 84.8% of units in expectation, though the exact overlap across all 14 years may be lower. This introduces a minor implementation complexity.
- **WARN:** The stated reason ("large dataset size") does not justify disabling Bacon for a 7-cohort design. The computational bottleneck in `bacondecomp` is unit count, not cohort count, and 94K observations is well within capacity. The unbalanced-panel complication is manageable by pre-balancing.

### 3. What we would expect from Bacon
- With 84.6% never-treated units, the "treated vs. never-treated" (TVU) comparison would almost certainly dominate the Bacon weights. This is a favorable configuration: TVU comparisons are the "clean" comparisons in Bacon's framework.
- The "treated vs. earlier-treated" (TvE, forbidden) and "treated vs. later-treated" (TvL, forbidden) comparisons would receive small residual weight.
- TWFE β = 0.6625 is likely close to a clean ATT given this structure.
- Without the decomposition we cannot formally verify: only indirect reassurance from event-study consistency across TWFE, CS-NT, SA, and Gardner (all clustered in 0.60–0.74 range post-treatment).

### 4. Alternative evidence on heterogeneity
- Event-study post-period coefficients from TWFE (0.62–0.77), CS-NT (0.64–0.74), SA (0.60–0.73), and Gardner (0.62–0.72) are broadly consistent across estimators and across time. This pattern strongly suggests limited heterogeneous treatment effects that would contaminate Bacon weights.
- With 84.6% never-treated, the SA and CS-NT estimators effectively confirm the TWFE result: contamination from forbidden comparisons is minor.

---

## Summary

Bacon decomposition remains disabled (`run_bacon = false`) despite a 7-cohort staggered design that is computationally tractable. The justification ("large dataset size") is inadequate. However, the 84.6% never-treated share and multi-estimator consistency (TWFE / CS-NT / SA / Gardner all aligned) provide strong indirect evidence that TVU comparisons dominate and TWFE weights are not severely contaminated. The TvT share (forbidden comparisons) is expected to be low. Re-enabling Bacon with pre-balancing would formalize this assessment.

**Verdict: WARN** (Bacon disabled on insufficient grounds; indirect evidence suggests clean TVU-dominant decomposition, but formal verification missing)
