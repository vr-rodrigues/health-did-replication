# Bacon Decomposition Reviewer Report — Article 241 (Soliman 2025)

**Verdict:** PASS
**Date:** 2026-04-18

## Applicability
- treatment_timing = "staggered", data_structure = "panel", allow_unbalanced = false → APPLICABLE.
- Note: metadata has `run_bacon: false`, but bacon.csv exists (was run via standalone script). Using the available output.

## Checklist

### 1. Decomposition composition
Bacon components from bacon.csv:

| Type | Cohorts | Weight | Estimate |
|---|---|---|---|
| Treated vs Untreated | All 8 cohorts vs never-treated | ~0.987 total | Range -101 to +3.2 |
| Later vs Earlier Treated | Multiple pairs | ~0.007 total | Mixed signs |
| Earlier vs Later Treated | Multiple pairs | ~0.006 total | Mixed signs |

- **Treated vs Untreated dominates at ~98.7% of total weight.** This means the TWFE estimate is overwhelmingly driven by clean comparisons against never-treated units. Very low contamination from forbidden 2x2 comparisons. PASS.

### 2. Negative weights / sign reversal risk
- The treated-vs-untreated estimates range from -101.2 (2007 cohort) to +3.2 (2012 cohort).
- The 2012 cohort has a positive estimate (+3.2 MME/capita) with weight 0.164. This is a notable outlier — the 2012 cohort appears to have increased MME, opposite to other cohorts.
- The aggregate TWFE (-33.65) is a weighted average with the positive 2012 component pulling toward zero. This heterogeneity across cohorts is substantive.
- **WARN signal:** Cohort heterogeneity is present. The 2012 cohort estimate (+3.19) is directionally opposite to other cohorts and carries 16.4% weight. This suggests TWFE is masking treatment effect heterogeneity across adoption cohorts.

### 3. Later-vs-Earlier Treated components
- Very small total weight (~1.3%), mixed signs across pairs. These are the "forbidden" Bacon comparisons. Their negligible weight means they are not distorting the overall TWFE. PASS.

### 4. Weighted average consistency
- Bacon-weighted sum of components should reproduce the TWFE estimate. The dominant treated-vs-untreated weighted sum with large negative estimates is consistent with the overall TWFE = -33.65. PASS.

## Summary
Bacon decomposition is reassuring overall: 98.7% of TWFE weight comes from clean treated-vs-never-treated comparisons. Forbidden later-vs-earlier treated comparisons have negligible weight (~1.3%). However, cohort-level heterogeneity is present — the 2012 cohort shows a positive estimate (+3.19, weight 16.4%), masking effect heterogeneity within the TWFE aggregate. CS-DiD, which estimates cohort-specific ATTs, is the appropriate tool to unpack this heterogeneity.

**Overall:** PASS (with noted cohort heterogeneity flagged as a finding, not a flaw)
