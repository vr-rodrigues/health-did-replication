# HonestDiD Reviewer Report: Article 333 — Clarke & Muhlrad (2021)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Applicability
- `has_event_study = true`, `event_pre = 36` — well above the minimum of 3 pre-periods. APPLICABLE.
- HonestDiD sensitivity analysis completed for both TWFE and CS-NT estimators.
- Three target parameters tested: "first" (first post-period ATT), "avg" (average post-period ATT), "peak" (maximum effect).

### 2. TWFE sensitivity results (from honest_did_v3_sensitivity.csv)

| Target | Mbar | Lower | Upper | Crosses zero? |
|--------|------|-------|-------|----------------|
| first  | 0    | -0.0072 | 0.0753 | YES |
| first  | 0.5  | -0.0189 | 0.0930 | YES |
| avg    | 0    | +0.0138 | +0.0769 | No |
| avg    | 0.25 | -0.0010 | +0.1045 | YES |
| peak   | 0    | +0.0400 | +0.1071 | No |
| peak   | 0.25 | +0.0086 | +0.1543 | No |
| peak   | 0.5  | -0.0455 | +0.2131 | YES |

- **WARN: TWFE "first" period effect crosses zero even at Mbar=0** (CI: [-0.0072, 0.0753]). This means that even assuming exact parallel trends, the first post-period estimate is not significantly negative. The positive upper bound suggests the near-term effect is imprecisely estimated.
- TWFE "avg" crosses zero at very small violations (Mbar=0.25).
- TWFE "peak" is more robust but crosses zero at Mbar=0.5.

### 3. CS-NT sensitivity results

| Target | Mbar | Lower | Upper | Crosses zero? |
|--------|------|-------|-------|----------------|
| first  | 0    | +0.0090 | +0.0437 | No |
| first  | 0.25 | +0.0005 | +0.0522 | No |
| first  | 0.5  | -0.0108 | +0.0639 | YES |
| avg    | 0    | +0.0268 | +0.0542 | No |
| avg    | 0.25 | +0.0013 | +0.0835 | No |
| avg    | 0.5  | -0.0326 | +0.1187 | YES |
| peak   | 0    | +0.0564 | +0.0876 | No |
| peak   | 0.25 | +0.0123 | +0.1371 | No |
| peak   | 0.5  | -0.0436 | +0.1595 | YES |

- CS-NT is more robust than TWFE: "first" and "avg" survive until Mbar=0.25–0.5 before crossing zero.
- The CS-NT results suggest the effect is statistically meaningful under small parallel trend violations but breaks down at moderate violations (Mbar≈0.5).

### 4. Pre-trend plausibility
- The event study pre-trends (see event_study_data.csv) show substantial departures from zero in the pre-period. Many pre-period coefficients are 3–8× larger than the standard errors (e.g., t=-29: +0.097 SE=0.019, t=-19: +0.072 SE=0.012).
- This suggests that Mbar > 0 is not merely a theoretical concern — the observed pre-trend violations are non-trivial.
- If the pre-period trend violations at magnitude Mbar≈0.5 are plausible (as the raw data suggest), the main negative effect of ILE becomes statistically indistinguishable from zero.

### 5. Interpretation
- The HonestDiD analysis reveals that the headline effect is **fragile to modest violations of parallel trends**, particularly for the "first" and "avg" targets.
- The CS-NT "avg" at Mbar=0 (CI: [0.027, 0.054]) is the most favorable result — negative and tight — but only holds under exact parallel trends.
- Given the visible pre-trend, a skeptical reader would apply Mbar≥0.5, under which even CS-NT loses significance.

## Summary
WARN. HonestDiD results are mixed: the CS-NT estimate shows negative effect under small violations (Mbar<0.5), but the pre-period evidence suggests actual violations may be larger than Mbar=0. TWFE is particularly fragile, with the "first" period effect crossing zero at Mbar=0. The credibility of the headline result depends heavily on believing parallel trends held despite the observed pre-trend pattern.

**Full report saved to:** `reviews/honestdid-reviewer.md`
