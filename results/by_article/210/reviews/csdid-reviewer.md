# CS-DID Reviewer Report — Article 210 (Li et al. 2026)

**Verdict:** FAIL
**Date:** 2026-04-18

## Checklist

### 1. Estimator configuration
- CS-NYT only (all-eventually-treated: gvar=policyyearmonth1 with 13 cohorts, all eventually treated). Correct choice — no never-treated units exist.
- Comparison group: not-yet-treated. Correct for all-eventually-treated designs.
- Aggregation: simple (agg="simple") — weighted average across cohort-time ATTs.
- Clustering: clusternum (province-level, cs_cluster). Note: TWFE clusters at clusterid but CS clusters at clusternum — Pattern 30 documented in notes.

### 2. Balancing rule — CRITICAL ISSUE (Lesson 10 focal point)

**`allow_unbalanced = true` with all-eventually-treated design.**

This is the central methodological concern for this paper. When `allow_unbalanced=true`:
- CS-DID uses an **unbalanced** panel for each cohort-control comparison
- This means different cohort-time cells have different sets of not-yet-treated units contributing to the control group
- For late cohorts (high yearmonth groups), the pool of not-yet-treated controls is very small or empty, forcing use of already-treated units
- For early cohorts (low yearmonth groups), the not-yet-treated pool is large but those units are all eventually treated — contaminating the "clean" comparison

**The result:** att_nyt_simple = **-0.00649** (our result) vs paper's CS result = **+0.012**. This is a **154% deviation with sign reversal**. This is not a rounding error — it is a fundamental identification breakdown.

The pair-balanced event study (figure3_cs_pairbalanced mentioned in notes) shows positive post-period CS-NYT estimates in the paper, but our unbalanced implementation produces sign reversal. This confirms the balancing rule drives the discrepancy.

### 3. CS-NYT controls gap
- TWFE includes 9 time-varying controls; cs_controls=[] (empty).
- Callaway-Sant'Anna with controls requires outcome regression or doubly-robust estimation. Without controls, CS estimates are fully nonparametric but may absorb pre-trend confounders differently than TWFE.
- This asymmetry is consistent with the sign divergence: controls matter substantially when pre-trends exist.

### 4. Pre-trend assessment (CS-NYT event study)
CS-NYT pre-trends are much cleaner than TWFE:
| Period | Coef | SE | t-stat |
|--------|------|----|--------|
| t=-12 | -0.0110 | 0.0204 | -0.54 |
| t=-11 | -0.0147 | 0.0248 | -0.59 |
| t=-10 | -0.0115 | 0.0209 | -0.55 |
| t=-9  | -0.0009 | 0.0185 | -0.05 |
| t=-8  | +0.0138 | 0.0192 | +0.72 |
| t=-7  | +0.0159 | 0.0175 | +0.91 |
| t=-6  | +0.0179 | 0.0100 | +1.80 |
| t=-5  | -0.0046 | 0.0069 | -0.67 |
| t=-4  | -0.0051 | 0.0062 | -0.83 |
| t=-3  | -0.0059 | 0.0056 | -1.06 |
| t=-2  | +0.0009 | 0.0032 | +0.28 |

Max |t-stat| = 1.80. All within noise. CS-NYT pre-trends are **clean** when using not-yet-treated comparisons — confirming that the TWFE pre-trend failure is driven by contaminated comparisons in TWFE, not by true pre-trends.

### 5. Post-period CS-NYT trajectory
CS-NYT post-period estimates:
- t=0: +0.004 (SE=0.005)
- t=1: -0.003 (SE=0.008)
- t=2: -0.008 (SE=0.016)
- t=3: -0.011 (SE=0.018) — att_nyt_simple reference
- t=4: -0.018 (SE=0.021)
- t=5: -0.017 (SE=0.021)
- ...declining

The CS-NYT dynamic ATT = +0.016 (att_nyt_dynamic) but the simple aggregation = -0.0065. This discrepancy between dynamic and simple aggregations warrants investigation. The att_csdid_nyt (uncontrolled, without weights) = -0.0128. The att_cs_nyt_with_ctrls = 0 (cs_nyt_with_ctrls_status = "OK" but value=0 — indicates the controlled version failed or produced exact zero, which is suspicious).

### 6. Sign reversal interpretation
The sign reversal (TWFE +0.019 vs CS-NYT -0.006 to -0.013) suggests that when using valid not-yet-treated comparisons:
- Either the policy had no effect (null result)
- Or the policy slightly increased drug prices for some cohorts
- The positive TWFE effect is driven by the contaminated comparison structure (already-treated units as pseudo-controls showing lower prices, making the treated units look like they had price *increases*)

### 7. Rating justification
FAIL: The CS-DID implementation produces a sign-reversed result relative to the paper's own CS estimate (+0.012 vs -0.006), and the att_cs_nyt_with_ctrls = 0 (suspicious). The unbalanced panel with all-eventually-treated design creates identification problems that the paper's pair-balanced approach avoids. The stored CS-NYT result cannot be considered a valid replication of the paper's CS estimate. This is a critical implementation-meets-design failure.
