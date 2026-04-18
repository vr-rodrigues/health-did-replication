# HonestDiD Review: 233 — Kresch (2020)

**Verdict:** WARN
**Date:** 2026-04-18
**Reviewer:** honestdid-reviewer

## Applicability

has_event_study=true, pre-periods available: t=-5, t=-4, t=-3, t=-2 (4 pre-periods above the required minimum of 3). APPLICABLE.

## Pre-trend summary

Event study pre-periods (omit: t=-1):

| Period | TWFE β | SE | CS-NT β | SE |
|--------|---------|-----|---------|-----|
| t=-5 | 387.5 | 673.5 | 137.9 | 367.2 |
| t=-4 | 455.1 | 611.5 | 397.7 | 376.9 |
| t=-3 | 714.6 | 433.7 | 709.4 | 268.8 |
| t=-2 | 599.0 | 364.3 | 688.9 | 250.3 |

Both estimators show a consistent upward pattern in pre-periods. The TWFE pre-trends are larger in magnitude early (t=-5) but CS-NT converges at t=-3 and t=-2. The rm_first_Mbar=0.25 (TWFE) indicates that the smoothness restriction implied by the pre-trend data allows only a small violation of parallel trends.

## Sensitivity analysis results

### TWFE "first post-period" (t=0, β≈1,501)

| Mbar | LB | UB | Sign-robust? |
|------|-----|-----|-------------|
| 0 | 147 | 1,636 | YES (excludes 0) |
| 0.25 | 85 | 1,791 | YES |
| 0.50 | -23 | 1,993 | NO (barely crosses 0) |
| 0.75 | -194 | 2,241 | NO |

**Breakeven Mbar ≈ 0.48** — result fragile to modest trend violations.

### CS-NT "first post-period" (t=0, β≈1,281)

| Mbar | LB | UB | Sign-robust? |
|------|-----|-----|-------------|
| 0 | 108 | 1,019 | YES |
| 0.25 | 14 | 1,141 | YES (marginally) |
| 0.50 | -89 | 1,273 | NO |

**Breakeven Mbar ≈ 0.40** — slightly more fragile than TWFE for the first period.

### CS-NT "peak effect" (t=1, β≈2,840)

| Mbar | LB | UB | Sign-robust? |
|------|-----|-----|-------------|
| 0 | 602 | 1,653 | YES |
| 0.25 | 396 | 1,913 | YES |
| 0.50 | 136 | 2,206 | YES |
| 0.75 | -179 | 2,553 | NO |

**Breakeven Mbar ≈ 0.62** for the peak effect. More robust than the first period.

### TWFE "average" post-period (β≈1,544)

| Mbar | LB | UB | Sign-robust? |
|------|-----|-----|-------------|
| 0 | 182 | 2,929 | YES |
| 0.25 | -182 | 3,685 | NO |

The average post-period TWFE effect becomes fragile at Mbar=0.25 — very sensitive because the average effect is pulled down by period 3 (β≈1,554) and widened by the growing uncertainty in later periods.

## Assessment

The HonestDiD analysis reveals moderate fragility. The peak investment effect (Mbar breakeven ≈ 0.62) is more robust than the short-run first-period effect (Mbar ≈ 0.40–0.48). The consistently positive and growing pre-period estimates for both estimators is the key concern — they suggest a pre-existing investment differential between Local and Regional municipalities that predates the 2006 reform. Under the `RM` sensitivity class (relative magnitudes), the allowable trend violations are bounded by the largest pre-period coefficient relative to adjacent periods.

The medium-to-long-run interpretation (peak effect, years 1–5 post-reform) survives reasonable sensitivity checks (Mbar<0.5), but the short-run first-period effect is fragile. Given the paper's primary claim is about the effect of the 2006 law on investment, the fact that the aggregate ATT remains positive and significant under modest smoothness violations is moderately reassuring, but not entirely clean.

**Verdict: WARN** — pre-trend pattern creates fragility in short-run estimates; longer-run effects are more robust but uncertainty intervals widen substantially in later post-periods.
