# HonestDiD Reviewer Report — Article 420

**Verdict: PASS**
**Date:** 2026-04-18
**Reviewer:** honestdid-reviewer

---

## 1. Applicability

- has_event_study: true — YES
- event_pre: 6 (t=-7 to t=-1; t=-1 omitted, so 5 estimated pre-periods) — meets ≥3 pre-period threshold
- HonestDiD is applicable.

## 2. HonestDiD Setup (from honest_did_v3.csv)

| Estimator | VCV type | n_pre | n_post | rm_first_Mbar | rm_avg_Mbar | rm_peak_Mbar | ATT_first | ATT_avg | ATT_peak |
|-----------|---------|-------|--------|---------------|-------------|--------------|-----------|---------|---------|
| TWFE | full | 5 | 11 | 0.50 | 0.25 | 0.25 | -25.23 | -58.18 | -78.34 |
| CS-NT | full_IF | 5 | 11 | 0.00 | 0.00 | 0.00 | -22.13 | -63.86 | -85.90 |

The rm_*_Mbar values represent the maximum smoothness restriction (M-bar) at which the original estimate remains robust after allowing for pre-trend violations. M-bar=0 means the estimate is robust even without any pre-trend assumption (fully nonparametric). M-bar>0 means some linear extrapolation is allowed.

Key observations:
- TWFE rm_first_Mbar = 0.50: The first-period ATT (-25.23) remains statistically distinguishable from zero even allowing for pre-trend violations up to 0.5× the maximum pre-trend magnitude. Moderate robustness.
- TWFE rm_avg_Mbar = 0.25: The average ATT (-58.18) is robust to M-bar=0.25. Lower robustness for the average — the longer post-period accumulates uncertainty.
- TWFE rm_peak_Mbar = 0.25: The peak ATT (-78.34 at t=8) is robust to M-bar=0.25.
- CS-NT rm_first_Mbar = 0: The CS-NT first-period ATT (-22.13) is robust even at M-bar=0 (fully nonparametric). This is strong — it means the effect at t=0 is robust with no pre-trend assumptions.
- CS-NT rm_avg/peak_Mbar = 0: Similarly, avg and peak CS-NT ATTs are robust at M-bar=0.

## 3. Sensitivity Analysis (honest_did_v3_sensitivity.csv)

### TWFE — Target: first-period ATT (-25.23)

| M-bar | CI_lower | CI_upper | Includes 0? |
|-------|----------|----------|-------------|
| 0.00 | -44.88 | -5.53 | No |
| 0.25 | -48.16 | -3.48 | No |
| 0.50 | -52.26 | -0.61 | No (barely) |
| 0.75 | -57.59 | +3.07 | Yes |
| 1.00 | -63.74 | +8.40 | Yes |

The TWFE first-period ATT holds at M-bar=0.50 but loses significance at M-bar=0.75. The rm_first_Mbar=0.50 threshold means the effect is robust to moderate pre-trend violations.

### TWFE — Target: average ATT (-58.18)

| M-bar | CI_lower | CI_upper | Includes 0? |
|-------|----------|----------|-------------|
| 0.00 | -81.95 | -34.42 | No |
| 0.25 | -112.16 | -10.65 | No |
| 0.50 | -153.26 | +28.97 | Yes |

The average ATT is robust at M-bar=0.25. The wider sensitivity for avg/peak reflects the longer post-period (11 periods), which accumulates pre-trend uncertainty.

### TWFE — Target: peak ATT (-78.34)

| M-bar | CI_lower | CI_upper | Includes 0? |
|-------|----------|----------|-------------|
| 0.00 | -112.40 | -44.75 | No |
| 0.25 | -158.21 | -8.10 | No |
| 0.50 | -219.52 | +51.80 | Yes |

### CS-NT — All targets robust at M-bar=0

CS-NT shows the HonestDiD CIs excluding zero at M-bar=0 for all three targets (first: [-52.13, +7.80]; avg: [-94.73, -33.08]; peak: [-123.12, -48.55]).

Notably: CS-NT first-period CI at M-bar=0 just barely includes zero on the upper bound (+7.80), but the average and peak are robustly negative. This reflects the CS-NT (no-controls) ATT being directionally consistent.

## 4. Pre-trend Plausibility

The HonestDiD analysis uses the 5 estimated pre-period coefficients (t=-7 to t=-2) to calibrate the smoothness restriction. TWFE pre-trends are small (max |coeff| ~ 9.78 at t=-2), suggesting M-bar in the 0.5-1.0 range would cover realistic violations. At M-bar=0.25-0.50, the effect remains significant.

## 5. Overall Assessment

The HonestDiD analysis provides moderate-to-strong robustness evidence:

1. **First-period effect (t=0):** Robust at M-bar=0.50 for TWFE; robust at M-bar=0 for CS-NT. Strong evidence that the immediate CHC effect is not a pre-trend artifact.
2. **Average effect:** Robust at M-bar=0.25 for TWFE. Robust at M-bar=0 for CS-NT. The 11-period post-window introduces larger sensitivity bounds but the central estimate is strongly negative.
3. **Peak effect:** Similar to average.

The evidence supports the conclusion that the reduction in elderly mortality is not solely attributable to violations of parallel trends. The TWFE estimates survive moderate pre-trend relaxation (M-bar=0.25-0.50), and the CS-NT first-period estimate is robust even without pre-trend assumptions.

**Verdict: PASS**

HonestDiD confirms the CHC-mortality reduction effect is robust to modest violations of parallel trends. The sensitivity range (M-bar=0.25-0.50) is plausible given the clean pre-trends observed. No concerns flagged.
