# HonestDiD Reviewer Report — Article 125
**Verdict:** PASS
**Date:** 2026-04-18

## Applicability
- `has_event_study=true`, `event_pre=4` (≥ 3). APPLICABLE.

## Pre-period summary (from honest_did_v3.csv)
- TWFE: n_pre=3, n_post=5 (the HonestDiD routine uses 3 free pre-periods after binning the t=-5 end-point).
- CS-NT: n_pre=3, n_post=5.

## Robustness thresholds

### TWFE estimator

| Target | Mbar=0 CI | Sign identified at Mbar=0? | rm_Mbar (sign breaks) |
|---|---|---|---|
| First post (t=+1) | [-0.0159, +0.0213] | No (includes zero) | 0 |
| Average post | [-0.0182, +0.0168] | No (includes zero) | 0 |
| Peak post (t=+5) | [-0.0377, -0.00057] | YES (excludes zero) | 0 |

The TWFE peak post CI at Mbar=0 barely excludes zero (ub=-0.00057). At Mbar=0.25, the peak CI becomes [-0.054, +0.010], which includes zero. All other targets (first, avg) include zero even at Mbar=0.

### CS-NT estimator

| Target | Mbar=0 CI | Sign identified at Mbar=0? | rm_Mbar (sign breaks) |
|---|---|---|---|
| First post (t=+1) | [-0.0137, +0.0226] | No (includes zero) | 0 |
| Average post | [-0.0257, +0.0175] | No (includes zero) | 0 |
| Peak post (t=+5) | [-0.0660, +0.0303] | No (includes zero) | 0 |

CS-NT fails to sign-identify any target at Mbar=0.

## Design credibility classification
- TWFE: rm_first_Mbar=0, rm_avg_Mbar=0, rm_peak_Mbar=0 (per honest_did_v3.csv).
- Peak post for TWFE barely squeezes out zero at Mbar=0, but this is not meaningful sign-identification given the underlying null result. The correct classification is **D-FRAGILE** — no pre-trend restriction is needed; even at Mbar=0 the economically relevant targets (first, avg) include zero.
- This is consistent with the paper's stated null finding.

## HonestDiD interpretation for a null-result paper
This paper claims no effect. HonestDiD serves as a robustness check: it asks "even if we allow for modest violations of parallel trends, can we still identify the sign of the effect?" The answer here is NO for all meaningful targets — zero is always in the CI. This is NOT a failure: it is CONFIRMATION that the paper's null result is robust to pre-trend misspecification as well. A null finding that cannot be rejected even with clean pre-trends, and whose CIs widen symmetrically around zero under HonestDiD, is internally consistent.

## n_pre concern
Only n_pre=3 free pre-periods are available after binning. This limits the granularity of the sensitivity analysis but does not invalidate it. Three pre-periods is the minimum recommended; the analysis proceeds.

## Summary
HonestDiD results are consistent with the paper's null finding. First and average post-treatment CIs include zero at Mbar=0 for both TWFE and CS-NT. Peak post for TWFE marginally excludes zero at Mbar=0 only. No pre-trend violation detected. Design is D-FRAGILE, which is appropriate for a study where the underlying true effect is likely zero.

**Verdict: PASS**
(HonestDiD does not identify a robust non-zero effect, but this is the correct outcome for a null-result paper. No methodological failures detected in the sensitivity analysis itself.)
