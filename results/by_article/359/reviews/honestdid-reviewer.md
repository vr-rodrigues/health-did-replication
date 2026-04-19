# HonestDiD Reviewer Report — Article 359

**Article:** Anderson, Charles, Olivares, Rees (2019) — "Was the First Public Health Campaign Successful?"
**Reviewer:** honestdid-reviewer
**Date:** 2026-04-18
**Verdict:** WARN

---

## Checklist

### 1. Applicability
- `has_event_study = true`, `event_pre = 5` (≥ 3 pre-periods). **APPLICABLE.**
- HonestDiD run for both TWFE and CS-NT estimators, for "first", "avg", and "peak" targets.

### 2. TWFE sensitivity results

**Target: first (t=0 coefficient)**
- Mbar=0 (no extrapolation allowed): CI = [-0.080, +0.009].
- The upper bound is positive at Mbar=0 — the estimate is **not robust to zero violations of parallel trends**. The CI includes zero even with no pre-trend extrapolation allowed.
- At Mbar=0.25: CI = [-0.084, +0.013]. Still includes zero.
- At Mbar=1.0: CI = [-0.104, +0.033]. Clearly includes zero.

**Target: avg (average post-treatment)**
- Mbar=0: CI = [-0.085, +0.037]. Includes zero.
- Effect not identified even under the most conservative smoothness assumption.

**Target: peak**
- Identical to "first" (peak is at t=0 for TWFE).

**TWFE conclusion:** The TWFE effect is not robust to any degree of pre-trend extrapolation. Even at Mbar=0, the confidence interval includes zero. **FAIL** (TWFE effect not robust).

### 3. CS-NT sensitivity results

**Target: first**
- Mbar=0: CI = [-0.117, +0.003]. Just barely excludes zero from above — marginally significant at Mbar=0.
- At Mbar=0.25: CI = [-0.120, +0.007]. Now includes zero.
- The CS-NT estimate is more negative at t=0 (-0.057) than TWFE (-0.035), but extremely imprecise (SE = 0.113).

**Target: avg**
- Mbar=0: CI = [-0.079, +0.035]. Includes zero.

**CS-NT conclusion:** CS-NT is also not robust. Even at Mbar=0 for the "avg" target, zero is included. The "first" target is marginally robust at exactly Mbar=0 but fails immediately at Mbar=0.25. **WARN**

### 4. Pre-trend magnitude assessment
- TWFE pre-periods: max coefficient magnitude = 0.040 (at t=-3). This is comparable to the post-treatment effect (-0.035), suggesting pre-trends are economically significant.
- The fact that even Mbar=0 fails to exclude zero for the average effect means the estimates are fundamentally fragile — they depend on perfect parallel trends.

### 5. Smoothness restriction validity
- The HonestDiD M-bar approach assumes the post-treatment trend violation is bounded by M times the pre-trend variation. With only 2 stored pre-periods for the HonestDiD analysis (n_pre=2 in honest_did_v3.csv, though event_pre=5), the smoothness extrapolation is over a limited base. The 2-period pre-trend base is modest, which may be limiting the power of the test.

---

## Summary

The HonestDiD analysis reveals that the TWFE headline effect (-0.036) is **not robust to any degree of pre-trend extrapolation**. At Mbar=0 (zero violations of parallel trends allowed), the TWFE CI already spans [-0.080, +0.009] and includes zero. The CS-NT estimate is marginally more robust for the impact-period effect but fails for average effects. This confirms that the paper's main result depends critically on the parallel trends assumption holding exactly — which the positive pre-trends in the event study put in doubt.

**Verdict: WARN** — Effect not robust even at Mbar=0; pre-trend magnitudes comparable to treatment effect.

