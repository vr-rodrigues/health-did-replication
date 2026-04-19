# HonestDiD Reviewer Report — Article 380
## Kuziemko, Meckel & Rossin-Slater (2018)

**Verdict:** WARN
**Date:** 2026-04-18

---

## 1. Setup

- Pre-periods: n_pre = 4 (t = -5, -4, -3, -2; t=-1 is omitted)
- Post-periods: n_post = 6 (t = 0 through t = 5)
- Estimators: TWFE (with controls) and CS-NT (without controls)
- Sensitivity grid: Mbar ∈ {0, 0.25, 0.5, ..., 2.0}
- Targets evaluated: first-period effect, average effect, peak effect

---

## 2. TWFE Sensitivity Results

### Target: First post-period effect (t=0)

Point estimate: -0.475 (SE from event study)

| Mbar | Lower CI | Upper CI | Excludes zero? |
|---|---|---|---|
| 0 | -0.923 | -0.023 | YES (marginally) |
| 0.25 | -1.025 | +0.060 | No |
| 0.5 | -1.155 | +0.172 | No |
| 1.0 | -1.470 | +0.478 | No |
| 2.0 | -2.221 | +1.210 | No |

The TWFE first-period estimate is significant ONLY at Mbar=0 (assuming exactly zero pre-trend drift). At Mbar=0.25, the CI already includes zero.

### Target: Average post-period effect

Point estimate: -0.168

| Mbar | Lower CI | Upper CI | Excludes zero? |
|---|---|---|---|
| 0 | -0.529 | +0.189 | No |
| 0.25 | -0.958 | +0.706 | No |

The average post-period TWFE effect is never significant at any Mbar.

### Target: Peak effect

Peak equals first-period effect (rm_peak_idx=1), so results identical to "first" target.

---

## 3. CS-NT Sensitivity Results

### Target: First post-period effect

CS-NT first effect: -0.211

| Mbar | Lower CI | Upper CI | Excludes zero? |
|---|---|---|---|
| 0 | -1.088 | +0.656 | No |
| 0.25 | -1.286 | +0.926 | No |
| 1.0 | -2.131 | +1.951 | No |

CS-NT is never significant at any Mbar.

### Target: Average post-period effect

CS-NT avg: -0.015

| Mbar | Lower CI | Upper CI | Excludes zero? |
|---|---|---|---|
| 0 | -0.760 | +0.729 | No |

Extremely wide CIs; completely uninformative.

---

## 4. Pre-Trend Calibration

The observed pre-period TWFE coefficients (omitting t=-1):
- t=-5: -0.292
- t=-4: -0.298
- t=-3: -0.425
- t=-2: +0.026

The maximum absolute pre-trend magnitude is 0.425. The sensitivity grid uses Mbar as a bound on the maximum deviation from parallel trends relative to the pre-trend magnitude. Given observed pre-trends on the order of 0.3-0.4, a credible Mbar in practice is at minimum 0.25-0.5, at which point the TWFE first-period CI already fails to exclude zero.

The t=-3 coefficient (-0.425) is notable: it is almost as large in absolute value as the first post-period effect (-0.475), which means even a small allowance for pre-trend extrapolation swamps the treatment signal.

---

## 5. Overall Assessment

The HonestDiD analysis reveals that the TWFE estimate is not robust to even modest violations of the parallel trends assumption:

- The first-period effect (-0.475) is statistically significant only under strict parallel trends (Mbar=0)
- At Mbar=0.25, significance disappears
- Given observed pre-trends of 0.3-0.4 in magnitude, Mbar=0 is untenable
- The average post-period effect is never robust
- CS-NT provides no statistically distinguishable evidence either

---

## 6. Verdict Rationale

**WARN**: The headline TWFE first-period estimate (-0.475, suggesting MMC reduced Black infant mortality) does not survive modest relaxation of parallel trends. Given the visible pre-period drift (particularly t=-3), the strict Mbar=0 identification is not credible. The result is fragile to exactly the kind of pre-trend violation that is visible in the event-study plot.

---

*Full data: `results/by_article/380/honest_did_v3.csv`, `results/by_article/380/honest_did_v3_sensitivity.csv`*
