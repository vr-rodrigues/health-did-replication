# HonestDiD Reviewer Report — Article 433

**Article:** DeAngelo, Hansen (2014) — "Life and Death in the Fast Lane: Police Enforcement and Traffic Fatalities"
**Reviewer:** honestdid-reviewer
**Date:** 2026-04-18
**Verdict:** WARN

---

## Applicability

`has_event_study = true`, `event_pre = 6` (>= 3). The HonestDiD analysis runs on 5 free pre-periods (excluding the base t=-1). Applicable.

## HonestDiD sensitivity results

From `honest_did_v3.csv`:

| Estimator | n_pre | n_post | rm_first_Mbar | rm_avg_Mbar | rm_peak_Mbar | peak_idx |
|---|---|---|---|---|---|---|
| TWFE | 5 | 7 | 0 | 0 | 0.25 | 2 |
| CS-NT | 5 | 7 | 0 | 0 | 0.25 | 2 |

### Sensitivity by target (from `honest_did_v3_sensitivity.csv`)

**TWFE:**

| Target | Mbar=0 lb | Mbar=0 ub | Robust at Mbar=0? | Breaks at Mbar=... |
|---|---|---|---|---|
| first | -0.700 | +1.193 | No (includes 0) | Already at Mbar=0 |
| avg | +1.044 | +3.223 | Yes | Mbar=0.25 (lb=-1.988) |
| peak | +2.989 | +5.369 | Yes | Mbar=0.25 still excludes 0; Mbar=0.50 includes 0 |

Wait — let me re-read the sensitivity data carefully:
- TWFE peak at Mbar=0: CI = [+2.989, +5.369] — robust
- TWFE peak at Mbar=0.25: CI = [+1.624, +6.485] — still robust
- TWFE peak at Mbar=0.50: CI = [-0.012, +7.973] — marginally breaks (lb barely negative)
- So rm_peak_Mbar = 0.50 (breaks at Mbar=0.50)

But `honest_did_v3.csv` says `rm_peak_Mbar = 0.25` — let me reconcile: the data file shows at Mbar=0.25, lb=1.624 (robust), at Mbar=0.50, lb=-0.012 (just barely includes 0). So rm_peak_Mbar is effectively 0.50, with the sign-change occurring between 0.25 and 0.50. The stored rm_peak_Mbar=0.25 appears to use a conservative rounding convention (last robust value). I will use the sensitivity data directly.

**TWFE detailed sensitivity:**

| Target | Mbar | lb | ub | CI excludes 0? |
|---|---|---|---|---|
| first | 0 | -0.700 | +1.193 | No |
| first | 0.25 | -1.312 | +1.686 | No |
| avg | 0 | +1.044 | +3.223 | Yes |
| avg | 0.25 | -1.988 | +5.895 | No |
| peak | 0 | +2.989 | +5.369 | Yes |
| peak | 0.25 | +1.624 | +6.485 | Yes |
| peak | 0.50 | -0.012 | +7.973 | No (barely) |

**CS-NT detailed sensitivity:**

| Target | Mbar | lb | ub | CI excludes 0? |
|---|---|---|---|---|
| first | 0 | -0.570 | +0.987 | No |
| first | 0.25 | -1.148 | +1.533 | No |
| avg | 0 | +0.437 | +1.887 | Yes |
| avg | 0.25 | -2.361 | +4.773 | No |
| peak | 0 | +2.060 | +4.048 | Yes |
| peak | 0.25 | +0.797 | +5.229 | Yes |
| peak | 0.50 | -0.735 | +6.720 | No |

### Design credibility classification

| Target | Criterion | Classification |
|---|---|---|
| first-period | rm_first_Mbar = 0 (not robust even at Mbar=0) | D-FRAGILE |
| average ATT | rm_avg_Mbar = 0 (breaks at Mbar=0.25) | D-FRAGILE |
| peak-period | rm_peak_Mbar ≈ 0.25–0.50 | D-MODERATE |

Overall design credibility: **D-FRAGILE** (the key "average" and "first-period" ATT estimates are not robust to any linear violation of parallel trends).

## Interpretation

The HonestDiD results reveal a critical pattern specific to the single-treated-unit design:

1. **First-period ATT (Feb 2003 = t=0)**: Not robust even at Mbar=0. The CI [-0.700, +1.193] for TWFE already includes zero at Mbar=0. This reflects genuine imprecision for the immediate post-treatment period — the crash did not happen in the first month alone.

2. **Average ATT**: Robust only at Mbar=0, breaks at Mbar=0.25. This means the average treatment effect is statistically significant only if one assumes the pre-treatment trends were exactly parallel. Any deviation — even a small linear trend — is sufficient to explain away the result.

3. **Peak ATT (month t=+1, the largest single-period estimate ~4.18 fatalities/VMT×100k)**: Robust through Mbar=0.25 for both TWFE and CS-NT. This peak effect — concentrated in the period immediately after the layoff — is the most robust finding. However, it breaks at Mbar=0.50.

4. **CS-NT pre-trend violations** (t=-4, t=-6, t=-2 significant in the event study data) are directly relevant: these non-zero pre-trends mean the actual Mbar for this paper could be above 0.25, which would collapse the HonestDiD confidence intervals to include zero for all targets.

## Conclusions

- The peak-period effect is moderately robust (D-MODERATE for rm_peak_Mbar ≈ 0.25–0.50).
- The average and first-period effects are D-FRAGILE (rm_Mbar = 0).
- The significant pre-periods in CS-NT data suggest plausible Mbar > 0.25, which would invalidate all CIs.
- Single-treated-unit identification means HonestDiD cannot distinguish Oregon-specific pre-treatment level shifts from trend violations.

**Verdict: WARN**
(D-FRAGILE on avg/first targets; D-MODERATE on peak; significant CS-NT pre-trends suggest plausible Mbar > 0.25)
