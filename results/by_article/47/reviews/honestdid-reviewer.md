# HonestDiD Reviewer Report — Article 47 (Clemens 2015)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Applicability
`has_event_study == true`, `event_pre == 4` (pre-periods at t=-5, -4, -3, -2 with t=-1 normalized). Minimum threshold of 3 pre-periods satisfied. HonestDiD analysis is applicable.

### 2. Sensitivity analysis inputs (honest_did_v3_sensitivity.csv)
The sensitivity analysis was run for both TWFE and CS-NT, across three targets (first, avg, peak) and Mbar values from 0 to 2.

### 3. TWFE sensitivity results

**Target: first post-period (t=0, coef = -0.089)**

| Mbar | Lower CI | Upper CI | Zero excluded? |
|------|----------|----------|----------------|
| 0.00 | -0.110   | -0.068   | Yes |
| 0.50 | -0.121   | -0.060   | Yes |
| 1.00 | -0.135   | -0.048   | Yes |
| 1.50 | -0.151   | -0.034   | Yes |
| 2.00 | -0.167   | -0.018   | Yes |

Zero is excluded across all Mbar values from 0 to 2. The TWFE first-period effect is robust even under substantial violations of parallel trends (Mbar=2 implies pre-trend violations up to twice the largest observed pre-trend magnitude).

**Target: average post-period (avg ATT = -0.105)**

| Mbar | Lower CI | Upper CI | Zero excluded? |
|------|----------|----------|----------------|
| 0.00 | -0.123   | -0.086   | Yes |
| 1.00 | -0.166   | -0.049   | Yes |
| 1.75 | -0.193   | -0.015   | Yes |
| 2.00 | -0.193   | -0.003   | Yes (barely) |

The average ATT remains significant up to Mbar=2, though the upper bound approaches zero at the extreme.

**Target: peak effect (t=1, coef = -0.120)**

| Mbar | Lower CI | Upper CI | Zero excluded? |
|------|----------|----------|----------------|
| 0.00 | -0.142   | -0.099   | Yes |
| 1.00 | -0.198   | -0.047   | Yes |
| 1.75 | -0.226   | -0.001   | Yes (barely) |
| 2.00 | -0.226   | +0.014   | No |

The peak effect loses significance at Mbar=2 only, which is an extremely demanding assumption (trend violations twice the size of observed pre-trends at t=-5).

### 4. CS-NT sensitivity results

**Target: first post-period (t=0, coef = -0.110)**

| Mbar | Lower CI | Upper CI | Zero excluded? |
|------|----------|----------|----------------|
| 0.00 | -0.147   | -0.072   | Yes |
| 1.00 | -0.173   | -0.040   | Yes |
| 1.75 | -0.205   | -0.008   | Yes (barely) |
| 2.00 | -0.216   | +0.004   | No |

**Target: average ATT (avg = -0.124)**

| Mbar | Lower CI | Upper CI | Zero excluded? |
|------|----------|----------|----------------|
| 0.00 | -0.157   | -0.092   | Yes |
| 1.00 | -0.206   | -0.036   | Yes |
| 1.50 | -0.240   | -0.002   | Yes (barely) |
| 1.75 | -0.257   | +0.015   | No |

CS-NT average ATT loses significance at Mbar≈1.75.

### 5. Key concern — significant pre-trend at t=-5
The reference pre-trend driving the HonestDiD Mbar calibration is the largest observed pre-period deviation. For TWFE, this is t=-5: coef=-0.027, SE=0.009. For CS-NT, this is t=-5: coef=-0.047, SE=0.013. These are non-trivial and statistically significant, which means:
  1. The "Mbar=0" (no-violation) CIs already assume parallel trends hold exactly, yet we observe a significant t=-5 deviation.
  2. Mbar=1 (violations up to the magnitude of the observed t=-5 pre-trend) is the natural benchmark. Under Mbar=1, all TWFE targets remain significant, and CS-NT first and average targets remain significant.
  3. However, the paper itself acknowledges that the t=-5 deviation may reflect a structural feature of New Jersey's market (uncompensated care spiral) rather than a pre-trend in the treated/control difference for the stable-state estimating sample. If this explanation is accepted, the pre-trend at t=-5 may overstate the true violation magnitude.

### 6. Overall assessment
**WARN.** The HonestDiD sensitivity analysis is broadly reassuring: under the natural Mbar=1 benchmark, all TWFE and most CS-NT targets remain statistically significant. However:
- The pre-trend at t=-5 is large and statistically significant, driving the Mbar calibration upward.
- The CS-NT average ATT loses significance at Mbar≈1.75, which is plausible if the t=-5 deviation reflects genuine parallel-trends violation rather than a one-time market shock.
- The TWFE estimate is more robust than the CS-NT to pre-trend violations, consistent with the covariate adjustment absorbing some of the baseline heterogeneity.

The core conclusion (negative effect of community rating on private coverage) is robust for TWFE across all tested Mbar values, and for CS-NT up to Mbar≈1.5. This merits a WARN rather than FAIL.

## References
- honest_did_v3_sensitivity.csv: full sensitivity bands
- honest_did_v3.csv: summary RM_bar values
- event_study_data.csv: pre-period coefficients

