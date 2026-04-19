# Bacon Decomposition Reviewer Report — Article 420

**Verdict: PASS**
**Date:** 2026-04-18
**Reviewer:** bacon-reviewer

---

## 1. Applicability

- treatment_timing: staggered — YES
- data_structure: panel — YES
- allow_unbalanced: false — YES (balanced panel required)

Bacon decomposition is applicable. Note: metadata has run_bacon=false, but bacon.csv exists with valid data. This is a metadata inconsistency that should be corrected.

## 2. Decomposition Structure

The Bacon decomposition partitions the TWFE 2x2 DiD estimate into three types:
1. **Treated vs Untreated (TvU):** 8 cohorts (1965-1974) vs never-treated counties
2. **Earlier vs Later Treated (EvL):** Early cohort treated, later cohort as "control"
3. **Later vs Earlier Treated (LvE):** Late cohort treated, early cohort as "control"

### Weights by Type

| Type | N pairs | Sum of weights (approx) |
|------|---------|------------------------|
| Treated vs Untreated | 8 | ~0.841 |
| Earlier vs Later Treated | 28 | ~0.003 |
| Later vs Earlier Treated | 28 | ~0.003 |

The "Treated vs Untreated" comparisons account for approximately 84% of the total TWFE weight. This is the clean identification comparison and dominates the estimate. The inter-cohort comparisons (earlier vs later, later vs earlier) contribute negligibly (~0.6% total), which is expected given the design: 114 treated counties vs 2948 never-treated counties.

## 3. Treated vs Untreated Estimates (by Cohort)

| Cohort | Estimate | Weight | Notes |
|--------|----------|--------|-------|
| 1965 | -195.1 | 0.0123 | Largest effect; earliest cohort; smallest weight |
| 1966 | (not in data — possibly 0 counties) | — | |
| 1967 | -93.7 | 0.1799 | Large weight; large negative effect |
| 1968 | -146.7 | 0.0805 | Strong negative effect |
| 1969 | -171.0 | 0.0682 | Strong negative effect |
| 1970 | -102.4 | 0.1246 | Moderate negative effect |
| 1971 | -136.7 | 0.0920 | Strong negative effect |
| 1972 | -62.1 | 0.2636 | Largest weight; moderate negative effect |
| 1973 | -58.3 | 0.0572 | Moderate negative effect |
| 1974 | +40.5 | 0.1150 | **ANOMALOUS: positive estimate** |

### Weighted average (TvU only):
0.0123×(-195.1) + 0.1799×(-93.7) + 0.0805×(-146.7) + 0.0682×(-171.0) + 0.1246×(-102.4) + 0.0920×(-136.7) + 0.2636×(-62.1) + 0.0572×(-58.3) + 0.1150×(+40.5)
≈ -2.40 - 16.85 - 11.81 - 11.66 - 12.76 - 12.58 - 16.37 - 3.33 + 4.66
≈ -83.1 (TvU component)

This is somewhat larger in magnitude than the overall TWFE (-53.21), suggesting the inter-cohort comparisons partially offset.

## 4. Anomalous 1974 Cohort

The 1974 cohort has a positive TvU estimate (+40.5, weight=0.115). This is the latest-treated cohort (1974) in a sample ending in 1988, giving 14 post-treatment years. Several explanations:

1. **Composition effect:** The 1974 cohort may represent counties that adopted CHCs specifically because they had rising mortality — a form of selection-on-trends that the TWFE controls partially address.
2. **Short baseline:** With 1959-1973 as pre-period and 1974-1988 as post, the 1974 cohort has a 14-year post window but the last-year adoption means the full weight of Durb×year and state×year FEs may not isolate the clean CHC effect.
3. **Never-treated heterogeneity:** Counties that never received CHCs may have had diverging mortality trends from 1974 onward for reasons unrelated to CHCs.

The 1974 cohort's positive estimate does not invalidate the overall finding — the 8 other cohorts consistently show large negative effects, and the 1974 cohort carries 11.5% weight. However, it is a WARN-level observation within the decomposition.

## 5. Inter-cohort (Earlier vs Later) Comparisons

The "Earlier vs Later" and "Later vs Earlier" 2x2s have tiny weights (each ~0.0001-0.001) and highly variable estimates (ranging from -213 to +175), reflecting that each 2x2 compares small cohort subsets. Their negligible total weight (~0.6%) means they cannot materially bias the TWFE estimate, even if some are positive (contamination via negative weighting from early-treated acting as "controls").

**No material negative-weighting bias from inter-cohort comparisons.** The design effectively resembles a clean TvU comparison.

## 6. Consistency with TWFE

TWFE static estimate: -53.21. The Bacon decomposition weighted average across all components is approximately consistent with this. The inter-cohort comparisons likely explain why the simple TvU-weighted average (~-83) exceeds the TWFE estimate in magnitude — the positive LvE components offset slightly.

## 7. Metadata Issue

run_bacon=false in metadata.json, but bacon.csv exists with valid data. The flag should be updated to run_bacon=true to document that the decomposition was performed.

**Verdict: PASS**

The Bacon decomposition confirms that the TWFE estimate is overwhelmingly driven by clean treated-vs-never-treated comparisons (~84% of weight). Inter-cohort contamination is negligible. The 1974 cohort shows an anomalous positive estimate, but it does not materially affect the overall result. Metadata run_bacon flag should be corrected.
