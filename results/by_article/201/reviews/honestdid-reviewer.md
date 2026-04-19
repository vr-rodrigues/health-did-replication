# HonestDiD Reviewer Report — Article 201 (Maclean & Pabilonia 2025)

**Verdict:** WARN

**Date:** 2026-04-18

## Applicability
has_event_study: true; event_pre: 7 (>= 3 pre-periods). APPLICABLE.

## Setup assessment

### Pre-periods used in HonestDiD
n_pre = 2 (only 2 pre-periods used despite 7 being available). This is a significant limitation: HonestDiD uses the pre-period event-study coefficients to bound violations of parallel trends. Using only 2 pre-periods:
(a) Reduces statistical power to detect violations.
(b) Uses only t=-2 (TWFE: -21.02, SE=15.52; CS-NT: +3.57, SE=5.89) as the information-bearing pre-period.
The discrepancy between n_pre=2 and event_pre=7 suggests a technical limitation (likely the yearly collapsed CS panel only has 2 pre-periods with sufficient cell counts, or the HonestDiD specification was set up on the collapsed data).

### ATTs used in HonestDiD
From honest_did_v3.csv:
- TWFE: att_first=-11.65, att_avg=-11.37, att_peak=-18.90
- CS-NT: att_first=-8.30, att_avg=-5.01, att_peak=-8.30

IMPORTANT SIGN NOTE: These are NEGATIVE, contradicting the static TWFE=+4.61. This is because HonestDiD here uses the event-study post-period coefficients, which average negative. The static TWFE (+4.61) is estimated from the level regression (pslm_state_lag2 dummy), while the event-study post-period coefficients (TWFE: t=0 to t=+7 averaging around -12 to -15) are estimated from a separate event-study specification. This discrepancy is a WARN: the static and dynamic TWFE estimates tell different stories.

### Mbar breakeven analysis
From honest_did_v3_sensitivity.csv:
**TWFE:**
- target=first, Mbar=0: CI=[-33.10, +9.86] — INCLUDES ZERO, not robust even at Mbar=0
- target=avg, Mbar=0: CI=[-29.52, +6.87] — INCLUDES ZERO
- target=peak, Mbar=0: CI=[-39.17, +1.05] — barely includes zero

**CS-NT:**
- target=first, Mbar=0: CI=[-19.59, +2.90] — INCLUDES ZERO
- target=avg, Mbar=0: CI=[-13.73, +3.68] — INCLUDES ZERO
- target=peak, Mbar=0: CI=[-19.59, +2.90] — INCLUDES ZERO

All sensitivity intervals include zero even at Mbar=0 (no parallel trends violation allowed). The Mbar_breakeven=0 in the CSV means there is NO positive Mbar at which the result becomes significant — the ATT is already insignificant under the event-study specification. This confirms the event-study-based ATTs (which are negative but imprecise) are fragile.

## Pre-trend assessment
TWFE pre-period used: t=-2: -21.02 (SE=15.52). A pre-treatment coefficient of -21 minutes is large relative to the outcome mean (pre-treatment mean ~77 min/day in treated states). This is a concerning pre-trend, though imprecise. It suggests potential differential pre-trends, which is exactly what HonestDiD is designed to handle — but with only 2 pre-periods, the sensitivity calibration is based on very little information.

CS-NT pre-period: t=-2: +3.57 (SE=5.89) — small and flat, more reassuring for parallel trends.

## Design credibility signal
The TWFE event-study Mbar analysis (all CIs include zero at Mbar=0) signals the event-study TWFE estimate is NOT robust to ANY degree of parallel trends violation. The CS-NT sensitivity intervals are also all non-significant at Mbar=0. This is a FAIL on design credibility grounds: if we trust the event-study specification, the result cannot survive even zero trend violation.

However, this finding must be interpreted carefully: the event-study ATTs (negative) differ from the static ATT (positive). The static TWFE captures the average post-treatment effect, while the event-study average collapses across heterogeneous lags (some positive early, some large negative late — see t=+4:-15.4, t=+5:-18.1, t=+7:-9.7). The static specification may be more informative given the noisy post-period event study.

## Mbar design credibility classification
- TWFE Mbar_first breakeven: 0 (insignificant at Mbar=0 → D-FRAGILE)
- TWFE Mbar_avg breakeven: 0 (D-FRAGILE)
- TWFE Mbar_peak breakeven: 0 (D-FRAGILE)
- CS-NT: all D-FRAGILE

**Design credibility: D-FRAGILE** (event-study estimates insignificant even at Mbar=0)

## Summary
WARN issued because:
1. HonestDiD used only n_pre=2 despite 7 pre-periods specified — severe underutilization of pre-period information.
2. TWFE pre-period t=-2 coefficient (-21.02 min) is large relative to outcome, suggesting possible pre-trends.
3. All sensitivity CIs include zero at Mbar=0 for both TWFE and CS-NT event-study specs — design is fragile.
4. Discrepancy between static TWFE ATT (+4.61) and event-study average ATT (-11 to -19) is a specification-choice concern.

## Reference
Full data: `results/by_article/201/honest_did_v3.csv`, `results/by_article/201/honest_did_v3_sensitivity.csv`
