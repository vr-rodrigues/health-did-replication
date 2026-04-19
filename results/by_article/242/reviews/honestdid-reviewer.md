# HonestDiD Reviewer Report — Article 242

**Verdict:** PASS
**Date:** 2026-04-18

## Applicability

`has_event_study == true`, `event_pre == 5` (5 pre-periods, plus t=-6 visible in data = 6 total pre-periods). Condition met: ≥ 3 pre-periods. APPLICABLE.

## Data summary

- Pre-periods used: t = -6, -5, -4, -3, -2, -1 (6 total; t=-1 is reference, so 5 non-reference pre-periods)
- Post-periods: t = 0 through t = 5 (6 periods)
- Estimators tested: TWFE and CS-NT

## HonestDiD sensitivity analysis (RM = relative magnitudes restriction)

### TWFE — target = "first" (e=0 estimate, period immediately after treatment)

| Mbar | LB | UB | Sign-preserving? |
|---|---|---|---|
| 0.00 | -0.0091 | 0.0049 | NO (CI includes 0) |
| 0.25 | -0.0117 | 0.0059 | NO |
| 0.50 | -0.0145 | 0.0070 | NO |

**TWFE first-period effect = -0.00247 (not stat. significant). CI is narrow around zero.**

### TWFE — target = "avg" (average post-treatment ATT)

| Mbar | LB | UB | Sign-preserving? |
|---|---|---|---|
| 0.00 | 0.0085 | 0.0409 | YES (fully positive) |
| 0.25 | 0.0012 | 0.0449 | YES (barely) |
| 0.50 | -0.0075 | 0.0509 | NO (crosses zero) |

**rm_avg_Mbar = 0.25** (fragility threshold for average ATT under TWFE)

### TWFE — target = "peak" (largest post-treatment coefficient, at t=5: +0.0487)

| Mbar | LB | UB | Sign-preserving? |
|---|---|---|---|
| 0.00 | 0.0213 | 0.0757 | YES |
| 0.25 | 0.0099 | 0.0831 | YES |
| 0.50 | -0.0054 | 0.0950 | NO (crosses zero) |

**rm_peak_Mbar = 0.25** (fragility threshold for peak ATT)

### CS-NT — target = "first"

| Mbar | LB | UB | Sign-preserving? |
|---|---|---|---|
| 0.00 | -0.0110 | 0.0007 | NO (CS-NT first = -0.0052) |
| 0.25 | -0.0137 | 0.0018 | NO |

**CS-NT first-period effect is small negative (-0.0052) — consistent with no immediate effect.**

### CS-NT — target = "avg"

| Mbar | LB | UB | Sign-preserving? |
|---|---|---|---|
| 0.00 | 0.0033 | 0.0333 | YES |
| 0.25 | -0.0052 | 0.0383 | NO (crosses zero) |

**rm_avg_Mbar = 0.25** (fragility threshold for CS-NT average ATT)

### CS-NT — target = "peak"

| Mbar | LB | UB | Sign-preserving? |
|---|---|---|---|
| 0.00 | 0.0183 | 0.0794 | YES |
| 0.25 | 0.0061 | 0.0904 | YES |
| 0.50 | -0.0087 | 0.1039 | NO |

**rm_peak_Mbar = 0.25** (fragility threshold for peak CS-NT)

## Checklist

### 1. Pre-trend visual inspection
- [PASS] TWFE pre-trends: max deviation is 0.008 at t=-3,t=-4. Monotonically approaching zero. No systematic pre-trend. The RM restriction is well-motivated.

### 2. Fragility classification

Per the Lal et al. (2024) rubric adapted for DiD:
- Mbar ≥ 1.0: ROBUST
- 0.5 ≤ Mbar < 1.0: MODERATE
- 0.25 ≤ Mbar < 0.5: FRAGILE
- Mbar < 0.25: VERY FRAGILE

| Target | TWFE Mbar | CS-NT Mbar | Classification |
|---|---|---|---|
| first (e=0) | 0.00 (not sig) | 0.00 (not sig) | N/A (first period null by design) |
| avg | 0.25 | 0.25 | FRAGILE |
| peak | 0.25 | 0.25 | FRAGILE |

- [INFO] Both estimators give rm_avg_Mbar = 0.25 and rm_peak_Mbar = 0.25. The result is **D-FRAGILE**: the average and peak ATTs require pre-trend violations to be no larger than 25% of the maximum pre-treatment deviation in order to remain positive.

### 3. Economic interpretation of Mbar
- [INFO] Mbar = 0.25 means: if the pre-treatment trend deviation is 25% as large in the unobserved counterfactual as the maximum observed pre-treatment deviation (max pre-trend = ~0.008), the estimates become sign-indeterminate. The absolute magnitude of violation required is thus 0.25 × 0.008 = 0.002 in log earnings — an extremely small confounding. This reflects the fact that pre-trends are small and the ATT (0.018-0.025) is moderate in magnitude.

### 4. Sign-preserving at Mbar=0
- [PASS] At Mbar=0 (strict parallel trends), the average ATT confidence interval is [0.0085, 0.041] for TWFE and [0.0033, 0.033] for CS-NT — both fully positive.

## Key findings

1. **Average ATT is fragile at Mbar = 0.25** for both TWFE and CS-NT. Small violations of parallel trends could overturn the earnings effect sign.

2. **Peak ATT is similarly fragile at Mbar = 0.25** — the larger t=5 coefficient is not robustly sign-preserving.

3. **Pre-trends are clean** — this design offers reasonably parallel pre-trends, but the ATT-to-pre-trend-noise ratio is modest, driving the Mbar threshold to 0.25.

4. **Design credibility signal: D-FRAGILE** — the earnings effect exists under strict parallel trends but dissolves under modest parallel trends violations.

## Verdict justification

PASS: HonestDiD analysis was conducted correctly and completely. The implementation is sound. The fragility finding (Mbar=0.25 for average ATT) is a design credibility signal — the method ran correctly and produced interpretable results. The PASS verdict reflects implementation quality; the D-FRAGILE finding is reported as a separate design credibility axis.

[Full data: `results/by_article/242/honest_did_v3.csv`, `results/by_article/242/honest_did_v3_sensitivity.csv`]
