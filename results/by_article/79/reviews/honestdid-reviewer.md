# HonestDiD Reviewer Report — Article 79 (Carpenter & Lawler 2019)

**Verdict:** PASS

**Date:** 2026-04-18

---

## Applicability

- `has_event_study`: true
- Pre-periods: 6 (t = -6 through t = -1, with t=-1 as reference) >= 3 threshold. APPLICABLE.

---

## Checklist

### 1. Estimators covered

HonestDiD run on both TWFE and CS-NYT event study estimates (from `honest_did_v3.csv`):

| Estimator | Pre-periods | Post-periods | rm_first_Mbar | rm_avg_Mbar | rm_peak_Mbar |
|---|---|---|---|---|---|
| TWFE | 5 | 7 | 1.75 | 0.50 | 0.25 |
| CS-NYT | 5 | 7 | 1.50 | 0.25 | 0.25 |

Note: 5 "free" pre-periods (t=-6 through t=-2; t=-1 is reference, excluded).

### 2. Sensitivity interpretation

The `rm_*_Mbar` values indicate the maximum relative magnitude (Mbar) of post-treatment violations of parallel trends that the result can tolerate before the confidence interval crosses zero.

**TWFE sensitivity:**
- `rm_first_Mbar` = 1.75: The first-period post-treatment ATT (t=0: β=0.112) remains significantly positive even if post-treatment violations are 1.75× the pre-trend variation. This is **robust**.
- `rm_avg_Mbar` = 0.50: The average ATT (β≈0.176) can withstand violations up to 0.50× pre-trend variation — **moderately robust**.
- `rm_peak_Mbar` = 0.25: The peak ATT (t=6: β=0.215) is less robust to sustained violations — **fragile** for the peak.

**CS-NYT sensitivity:**
- `rm_first_Mbar` = 1.50: First-period ATT (β=0.104) robust up to 1.5× pre-trend — **robust**.
- `rm_avg_Mbar` = 0.25: Average ATT (β≈0.105) is **fragile** — crosses zero at Mbar=0.25× pre-trend variation.
- `rm_peak_Mbar` = 0.25: Peak ATT (β≈0.182) fragile at same threshold.

### 3. Sensitivity curves: TWFE

From `honest_did_v3_sensitivity.csv`:

| Target | Mbar | Lower bound | Upper bound |
|---|---|---|---|
| first | 0 | 0.081 | 0.143 |
| first | 0.50 | 0.063 | 0.157 |
| first | 1.00 | 0.042 | 0.177 |
| first | 1.75 | 0.006 | 0.212 |
| first | 2.00 | -0.006 | 0.224 |
| avg | 0 | 0.125 | 0.228 |
| avg | 0.25 | 0.091 | 0.261 |
| avg | 0.50 | 0.048 | 0.303 |
| avg | 0.75 | -0.002 | 0.351 |
| peak | 0 | 0.124 | 0.306 |
| peak | 0.25 | 0.071 | 0.366 |
| peak | 0.50 | -0.003 | 0.444 |

TWFE first-period ATT is robust to substantial violations (Mbar=1.75). Average ATT is robust to Mbar=0.50 (moderate). Peak ATT is fragile at Mbar=0.50.

### 4. Sensitivity curves: CS-NYT

| Target | Mbar | Lower bound | Upper bound |
|---|---|---|---|
| first | 0 | 0.076 | 0.132 |
| first | 0.50 | 0.056 | 0.143 |
| first | 1.00 | 0.032 | 0.160 |
| first | 1.50 | 0.007 | 0.183 |
| first | 1.75 | -0.006 | 0.195 |
| avg | 0 | 0.078 | 0.132 |
| avg | 0.25 | 0.036 | 0.165 |
| avg | 0.50 | -0.014 | 0.213 |
| peak | 0 | 0.121 | 0.242 |
| peak | 0.25 | 0.057 | 0.303 |
| peak | 0.50 | -0.027 | 0.386 |

CS-NYT first-period ATT is robust to Mbar=1.50. CS-NYT average and peak ATT are fragile at Mbar=0.25 and Mbar=0.50 respectively.

### 5. Design signal classification

- TWFE: rm_avg_Mbar = 0.50 → **D-MODERATE** for the average ATT; rm_first_Mbar = 1.75 → robust for contemporaneous effect.
- CS-NYT: rm_avg_Mbar = 0.25 → **D-FRAGILE** for the average ATT.

The gap between TWFE and CS-NYT HonestDiD robustness is meaningful: TWFE average is moderately robust while CS-NYT average is fragile. This reflects the smaller CS-NYT ATT (0.105 vs. 0.176), which has a lower signal-to-noise ratio.

### 6. Pre-trend context

The TWFE pre-periods show a mild systematic negative pattern (all pre-period coefficients negative, with magnitude 0.033–0.060). This motivates the HonestDiD exercise. The pre-trend is not zero, but it is modest — supporting that Mbar values around 0.5–1.0 are plausible assumptions for sensitivity analysis.

### 7. Overall HonestDiD verdict

The **contemporaneous effect** (t=0) is robust for both estimators (Mbar > 1.50), which is the strongest claim. The **average post-treatment effect** is moderately robust under TWFE (Mbar = 0.50) but fragile under CS-NYT (Mbar = 0.25). Since there is a mild but systematic pre-trend in the data, a conservative analyst might apply Mbar = 0.50–1.0, which would preserve significance for TWFE but erode it for CS-NYT average. The peak effect is fragile under both.

---

## Summary

- The first-period/contemporaneous treatment effect is robust across reasonable violations (Mbar > 1.50 for both estimators). This is the most policy-relevant estimate (immediate mandate uptake effect).
- The average post-treatment effect is moderately robust under TWFE (D-MODERATE) and fragile under CS-NYT (D-FRAGILE).
- No implementation errors detected. HonestDiD correctly uses 5 free pre-periods.

**Verdict: PASS** — contemporaneous effect robust; average effect moderately robust (TWFE) to fragile (CS-NYT). Design signal: D-MODERATE for TWFE, D-FRAGILE for CS-NYT average.
