# Bacon Decomposition Reviewer Report — Article 309

**Verdict:** WARN
**Date:** 2026-04-18
**Reviewer:** bacon-reviewer

---

## Checklist

### 1. Applicability

- treatment_timing: staggered — YES
- data_structure: panel — YES
- allow_unbalanced: false — YES
- **Applicable**

### 2. Weight structure summary

Bacon decomposition includes:
- Treated vs Untreated (TvU): 10 comparison pairs with 1979 always-treated cohort as reference
- Later vs Earlier Treated (LvE): multiple pairs
- Earlier vs Later Treated (EvL — forbidden comparisons): multiple pairs
- Later vs Always Treated (LvA): 10 pairs using cohort 1979

TvU pairs dominate by weight (estimated from individual weights; the 10 TvU pairs account for the bulk of total weight). Full weight tabulation not directly computed, but comparison with other articles in sample suggests TvU-dominant structure.

### 3. Sign heterogeneity — cohort 1989 anomaly

A critical concern: **cohort 1989 has a POSITIVE effect estimate in the TvU comparison**:
- Cohort 1989 vs untreated: +0.316 (weight = 0.033)

This is the only cohort with a positive TvU estimate. All other cohorts show negative effects (range: -0.357 to -0.057). The 1989 cohort also contaminates forbidden-comparison pairs:
- LvE: 1989 vs 1981 = +0.478 (wt 0.011)
- LvE: 1989 vs 1986 = +0.059 (wt 0.003)
- LvE: 1989 vs 1985 = +0.062 (wt 0.002)
- EvL: 1989 vs 1991 = -0.136 (wt < 0.001)
- Multiple other EvL pairs show anomalous values near 1989

### 4. Forbidden comparisons (EvL pairs)

Earlier-vs-Later-treated pairs are present throughout the decomposition. These are "forbidden comparisons" in the sense of Callaway-Sant'Anna: they use later-treated units as controls for earlier-treated units, contaminating the estimate if treatment effects are dynamic (which the event study confirms they are).

Selected EvL estimates (large |value|):
- 1989 vs 1990 (EvL): +0.582 (wt < 0.001)
- 1989 vs 1980 (EvL): +0.811 (wt < 0.001)
- 1989 vs 1981 (EvL): +0.736 (wt < 0.001)

The 1989 cohort dominates forbidden-comparison contamination.

### 5. LvA comparisons (always-treated cohort 1979)

All 10 LvA pairs are negative except cohort 1989 vs 1979 (+0.254, wt 0.023), consistent with the TvU anomaly. The 1979 cohort was already treated when the panel began; using it as a comparison group introduces pre-treatment contamination.

### 6. Cohort heterogeneity assessment

Range of TvU estimates: -0.358 to +0.316 (span = 0.674 log points). This is substantial heterogeneity across 10 cohorts. The positive 1989 cohort may reflect a specific state-level confound (the metadata notes this covers 21 adoption cohorts 1970–1993 across states). No economic explanation for the 1989 reversal is available from the data.

### 7. TWFE weighted average

The TWFE estimate (-0.137) is a Bacon-weighted average that includes:
- Clean TvU comparisons (negative, dominant)
- Forbidden EvL comparisons (mixed sign, including 1989 outlier)
- LvA comparisons using always-treated 1979 cohort

The 1989 cohort's positive contribution attenuates the TWFE toward zero relative to the CS-DID estimate of -0.201.

---

## Material findings

- **WARN:** Cohort 1989 has sign-reversed TvU estimate (+0.316), opposite to all other cohorts and to the CS-DID average; no economic explanation available.
- **WARN:** Forbidden comparisons (EvL) present with non-trivial weight; 1989 cohort generates large anomalous EvL pairs.
- **WARN:** Always-treated 1979 cohort used as reference in LvA pairs — pre-treatment contamination risk.
- **NOTE:** TWFE attenuation toward zero (vs CS-DID -0.201) is explained by 1989 cohort pulling positive and forbidden-comparison contamination.

**Verdict: WARN**
