# TWFE Reviewer Report — Article 147 (Greenstone & Hanna 2014)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Specification fidelity
- Treatment variable: `catconvpolicy` — a windowed event indicator (post-adoption × within[-7,9] window). This is non-standard: the treatment "switches off" after 9 years post-adoption, making it a finite-window absorbing dummy rather than a pure absorbing indicator. The metadata and notes confirm this matches the Stata specification (`xi: reg e_spm_mean ... catconvpolicy ... i.city i.year [aw=pop_urban], cluster(city)`).
- Controls: 9 covariates included (scaprange, scappolicy, tauSCL, tauSCR, catrange, tauCATL, tauCATR, lit_urban, mean_ctrl). Notes confirm tauSCR and tauCATR dropped for collinearity with city+year FEs — this is expected in two-way FE with event-window dummies.
- Weights: urban population (`pop_urban`) used as analytical weights — matches Stata `[aw=pop_urban]`.
- Clustering: city-level — matches original.
- N=1172 (150 obs dropped for missing lit_urban/mean, auto-handled by feols).

### 2. Coefficient fidelity
- Our beta_twfe: 8.015, SE: 11.926
- Paper reports: beta_twfe: 8.01, SE: 12.59
- Point estimate match: essentially exact (difference < 0.005).
- SE difference: R=11.93 vs Stata=12.59. The 5.2% SE gap is attributable to feols singleton removal (documented in notes). Not a methodological failure.

### 3. Sensitivity to controls
- Without controls: 14.483 (SE=10.553)
- With controls: 8.015 (SE=11.926)
- Controls attenuate the coefficient by ~44%. The sign is preserved, but the sensitivity is notable: removing controls shifts the estimate substantially. This raises concern about the robustness of the TWFE specification.

### 4. Pre-trend assessment (TWFE event study)
| Horizon | Coefficient | SE |
|---------|------------|-----|
| h=-5 | -35.55 | 17.77 |
| h=-4 | -30.14 | 23.70 |
| h=-3 | -12.33 | 18.09 |
| h=-2 | -5.74 | 14.11 |
| h=0  | +1.44 | 18.69 |
| h=1  | +17.03 | 14.97 |
| h=2  | -11.69 | 19.83 |
| h=3  | -30.15 | 19.78 |
| h=4  | -16.33 | 19.40 |

Pre-trends at h=-5 and h=-4 are large in magnitude (35-36 µg/m³) relative to the post-treatment estimate (8 µg/m³). This suggests a pre-existing downward trend in SPM levels for cities that eventually adopted the catalytic converter policy — a violation of the parallel trends assumption. The monotonic improvement from h=-5 toward h=-1 is a classic pattern of mean-reversion or selection bias.

Post-treatment effects are highly oscillating (positive at h=1, negative by h=3) with no coherent causal narrative.

### 5. Multicollinearity
- tauSCR and tauCATR dropped for collinearity. The presence of collinear regressors in the original spec suggests the TWFE model is over-parameterised. Dropped variables could mask policy interaction effects.

### 6. Treatment timing concern
- Treatment `catconvpolicy` is a windowed indicator, not a clean absorbing-binary treatment. Cities "exit" the treatment window after 9 years. This makes interpretation as an ATT non-standard — the TWFE is estimating an average effect only over the policy-active window.

## Summary
The TWFE point estimate replicates the paper essentially exactly. However, the pre-trend pattern is large and systematic, the controls attenuate the estimate substantially, and the windowed treatment design complicates ATT interpretation. These are methodological concerns inherited from the paper's own specification.

**Verdict: WARN** — Pre-trends are large and systematic; post-treatment oscillation; windowed treatment non-standard.
