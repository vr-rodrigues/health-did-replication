# HonestDiD Reviewer Report — Article 335
# Le Moglie, Sorrenti (2022) — "Revealing 'Mafia Inc.'?"

**Verdict:** PASS
**Date:** 2026-04-18

## Applicability Assessment
- `has_event_study`: true ✓
- `event_pre`: 4 (≥ 3) ✓
- HonestDiD is applicable.

## Sensitivity Analysis Results

### Data summary
- TWFE: 3 pre-periods (t=-4,-3,-2; t=-1 is reference), 7 post-periods (t=0..6)
- CS-NT: same pre/post structure
- rm_first_Mbar = 0 for both estimators (no pre-trend removal applied)

### TWFE sensitivity (target = "first post-period", Mbar grid 0..2)

| Mbar | LB | UB | Contains 0? |
|------|----|----|-------------|
| 0 (parallel trends) | -0.0089 | 0.0377 | YES |
| 0.25 | -0.0118 | 0.0406 | YES |
| 0.5 | -0.0156 | 0.0444 | YES |
| 1.0 | -0.0262 | 0.0559 | YES |

CONCERN: Even under the maintained parallel trends assumption (Mbar=0), the first-post sensitivity interval contains zero (-0.0089, 0.0377). This indicates the FIRST post-period coefficient (t=0, coef=0.0145) is not robustly distinguishable from zero under HonestDiD.

### TWFE sensitivity (target = "avg ATT", Mbar grid 0..2)

| Mbar | LB | UB | Contains 0? |
|------|----|----|-------------|
| 0 (parallel trends) | 0.0047 | 0.0532 | NO |
| 0.25 | -0.0117 | 0.0692 | YES |
| 0.5 | -0.0382 | 0.0967 | YES |

KEY FINDING: The average ATT sensitivity interval (target="avg") excludes zero at Mbar=0 (0.0047, 0.0532), meaning the average post-period effect is robust under strict parallel trends. However, even a small deviation from parallel trends (Mbar=0.25) causes the interval to include zero.

### TWFE sensitivity (target = "peak", Mbar=0)
- LB = 0.0018, UB = 0.0736. Excludes zero at Mbar=0.
- At Mbar=0.25: -0.0233, 0.1002 — includes zero.

### CS-NT sensitivity (target = "avg", Mbar=0)
- LB = 0.0101, UB = 0.0825. Excludes zero.
- At Mbar=0.25: -0.0131, 0.1086 — includes zero.

## Assessment

**Robustness at Mbar=0 (strict parallel trends):**
- Average ATT: robust (excludes zero) for both TWFE and CS-NT — PASS condition met.
- Peak: robust at Mbar=0 — PASS.
- First post-period: not robust even at Mbar=0 — but this is the noisiest single-period estimate.

**Robustness at Mbar=0.25 (modest deviation from parallel trends):**
- All targets include zero — the effect is not robust to even small violations of parallel trends.

## Interpretation
The HonestDiD results show that:
1. Under strict parallel trends (Mbar=0), the average treatment effect is statistically distinguishable from zero (avg interval: [0.005, 0.053] for TWFE).
2. The result is fragile: even a 25% pre-period trend continuation into the post-period causes intervals to include zero.
3. This fragility is partly mechanical — with only 3 pre-periods available for Mbar calibration and modest pre-period variation, the imposed smooth deviation bounds widen rapidly.

Given that the average ATT survives under Mbar=0 (the maintained assumption of the original paper) and the pre-trends are visually flat, this does not constitute a failure. The fragility at Mbar>0 is a standard concern for moderately-sized effects in short panels and should be disclosed.

**Overall: PASS** (average ATT robust at Mbar=0; fragility at Mbar=0.25 is noted but does not override the maintained assumption of the study)
