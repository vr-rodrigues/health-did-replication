# TWFE Reviewer Report — Article 305 (Brodeur & Yousaf 2020)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Specification alignment
- The paper reports two key specifications: Col 1 (fips + year FEs only, aroundms filter, beta=-2.658) and Col 3 (adds division×year FEs, beta=-1.348).
- The event study (Figure 2) is based on the Col 3 specification with division×year FEs.
- Our stored TWFE = -1.348 (SE=0.522), which matches Col 3. This is appropriate since Col 3 is the specification used for the paper's primary event study and is methodologically preferred (absorbs division-specific economic cycles).
- **Concern:** The metadata lists `original_result.beta_twfe = -2.658` (Col 1) but our stored result implements Col 3 (-1.348). The beta stored in results.csv does not match `original_result.beta_twfe`. This is intentional per the notes (Col 1 produces spurious pre-trends) but creates a fidelity discrepancy.

### 2. Pre-trend assessment
- TWFE event study (with div×year FEs): t-5=+0.522, t-6=+1.274. The t-6 coefficient is large (+1.27, SE=0.666) and economically meaningful.
- Without div×year FEs (Col 1 spec), the notes state t-5 coefficient exceeds 1.5 — a severe pre-trend failure.
- Even with div×year FEs, t-6 is positive and large, suggesting pre-existing trends that the FEs only partially absorb.
- SA estimator (anticipation-robust): t-5=+0.477, t-6=+1.145 — similar pattern, somewhat attenuated.
- Gardner (imputation): t-5=+0.255, t-6=+0.928 — further attenuated but still elevated at t-6.

### 3. Heterogeneous treatment effects
- Post-period TWFE coefficients show a monotonically growing negative effect: t=0 (-0.121), t=1 (-0.454), t=2 (-0.768), t=3 (-1.056), t=4 (-1.281), t=5 (-1.787). This ramp-up is consistent across SA and Gardner.
- The growing effect over time is plausible for persistent economic disruption from mass shootings, but also raises concern that TWFE early-period estimates are being contaminated by heterogeneous treatment timing.

### 4. aroundms filter concern
- The `aroundms==1` filter keeps ±6 years around shooting for treated units but all years for never-treated units, creating structural imbalance (treated: 8-16 years, never-treated: up to 24 years). This is a design-level concern that inflates the comparison group's time coverage relative to treated units.
- This asymmetry can introduce spurious pre-trends and bias TWFE estimates.

### 5. Additional fixed effects
- The div×year FEs (`div_9_all^year`) are appropriate and necessary to absorb division-specific economic cycles that correlate with mass shooting incidence and employment.

## Verdict rationale
WARN (not FAIL) because: (1) with div×year FEs the pre-trends are materially reduced and the sign of pre-trends is in the opposite direction of post-treatment effects; (2) all modern estimators (SA, Gardner) confirm a negative effect of similar magnitude; (3) but t-6 pre-period elevation and the aroundms structural imbalance are genuine methodological concerns that cannot be dismissed.

## Links
Full data: `results/by_article/305/event_study_data.csv`
