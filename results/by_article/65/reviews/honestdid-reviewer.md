# HonestDiD Reviewer Report: Article 65
# Akosa Antwi, Moriya & Simon (2013) — ACA Dependent-Coverage Mandate

**Verdict:** WARN

**Date:** 2026-04-18

---

## Checklist

### 1. Applicability
- has_event_study = true, event_pre = 6 (≥ 3 required). APPLICABLE.
- HonestDiD run on both TWFE and CS-NT estimators.

### 2. Pre-period count and quality
- n_pre = 5 (from honest_did_v3.csv; t=-6 through t=-2 used; t=-7 excluded as the furthest lag).
- n_post = 7 (t=0 through t=6).
- Pre-trend coefficients are small and insignificant — good baseline for sensitivity analysis.

### 3. Sensitivity results — TWFE

#### Target: first post-period (t=0, ATT=0.0107)
- Mbar=0: CI = [-0.026, +0.047] — INCLUDES ZERO. Not robust at any Mbar.
- rm_first_Mbar = 0 (breaks at Mbar=0 itself).

#### Target: average ATT (avg=0.0214)
- Mbar=0: CI = [-0.006, +0.049] — nearly includes zero (lower bound barely negative, barely including 0).
- Mbar=0.25: CI = [-0.054, +0.092] — INCLUDES ZERO.
- rm_avg_Mbar = 0 (breaks immediately).

#### Target: peak ATT (t=2, ATT=0.0504)
- Mbar=0: CI = [+0.008, +0.093] — EXCLUDES ZERO. Positive and significant.
- Mbar=0.25: CI = [-0.016, +0.121] — INCLUDES ZERO.
- rm_peak_Mbar = 0.

### 4. Sensitivity results — CS-NT

#### Target: first post-period (t=0, ATT=0.0074)
- Mbar=0: CI = [-0.038, +0.053] — INCLUDES ZERO.
- rm_first_Mbar = 0.

#### Target: average ATT (avg=0.0218)
- Mbar=0: CI = [-0.012, +0.056] — INCLUDES ZERO (barely).
- rm_avg_Mbar = 0.

#### Target: peak ATT (t=2, ATT=0.0489)
- Mbar=0: CI = [+0.002, +0.095] — EXCLUDES ZERO at Mbar=0.
- Mbar=0.25: CI = [-0.019, +0.116] — INCLUDES ZERO.
- rm_peak_Mbar = 0.

### 5. Design credibility classification

| Target | TWFE rm_Mbar | CS-NT rm_Mbar |
|--------|-------------|---------------|
| first  | 0 (D-FRAGILE) | 0 (D-FRAGILE) |
| avg    | 0 (D-FRAGILE) | 0 (D-FRAGILE) |
| peak   | 0 (D-FRAGILE) | 0 (D-FRAGILE) |

- All three targets fail to remain significant even at Mbar=0.
- Exception: the peak target (t=2) is barely significant at Mbar=0 for both TWFE and CS-NT (lower bounds: TWFE=+0.008, CS-NT=+0.002). This is technically a pass at Mbar=0 but loses significance at Mbar=0.25.
- Interpretation: The HonestDiD analysis reveals that the headline result is **very fragile** to pre-trend violations. Even allowing zero violation of the parallel trends assumption (Mbar=0), only the peak month's effect survives (and barely).

### 6. Why does HonestDiD fragment these estimates?

The fragility arises from two structural features:
1. **Large standard errors** relative to effect size: The average post-period ATT is ~0.021, but SEs are ~0.019–0.023 for individual TWFE months. With 7 post-periods of averaging, the uncertainty compounds in HonestDiD's worst-case framework.
2. **Irregular post-period pattern**: The spike at t=2 (0.050) surrounded by smaller coefficients (0.004–0.011 at t=0,1,3) makes the average target fragile. HonestDiD's linear extrapolation of pre-trends introduces enough uncertainty to swamp the modest average effect.

### 7. Context for interpretation
- The TWFE static estimate (0.0317, t=4.20) is significant in the conventional framework. HonestDiD asks: if the pre-trend were extrapolated forward at the same linear rate, would the effect remain significant? With 5 pre-periods and modest variation, even a small extrapolated pre-trend can swamp a 2–3 percentage point effect.
- This is not a disqualifying finding — it reflects the inherent limitation of micro-level survey data in a single-timing design where effect sizes are modest (~3pp) and individual-level SEs are large.
- The peak effect (month +2, approximately December 2010, first full month after the mandate) is the most robust: TWFE CI at Mbar=0 = [+0.008, +0.093], CS-NT = [+0.002, +0.095]. This is the only target that survives HonestDiD at Mbar=0.

### 8. Comparison with similar papers in the corpus
- Article 201 (Maclean & Pabilonia 2025): rm_first=0, rm_avg=0 → D-FRAGILE, rated LOW.
- Article 76 (Lawler & Yewell 2023): rm_avg=0.25, rm_peak=0.50 → D-MODERATE, rated LOW.
- Article 65 falls in D-FRAGILE territory: all Mbar thresholds are 0 for first and avg, only peak survives at Mbar=0.

---

## Material findings

1. **WARN: D-FRAGILE design** — avg and first targets lose significance at Mbar=0. Only the peak effect (t=2) survives at Mbar=0 for both TWFE and CS-NT. Effect is fragile to even minimal pre-trend violations.
2. **Contextual note**: The fragility partly reflects the large individual-level SEs in SIPP data (monthly micro-data), not necessarily a weak causal signal. The conventional TWFE is highly significant (t=4.2).

---

## Summary

The HonestDiD analysis reveals a D-FRAGILE design: the first-post and average ATT estimates lose significance even at Mbar=0 (no pre-trend extrapolation tolerance). Only the peak effect at t=2 survives at Mbar=0 (TWFE CI [+0.008,+0.093]), and this too loses significance at Mbar=0.25. This fragility is partly mechanical — the large individual-level SEs of SIPP micro-data mean that monthly averages are noisy — but it is a legitimate concern for a reader relying on HonestDiD as the credibility standard.

**Verdict: WARN**
