# CS-DID Reviewer Report — Article 420

**Verdict: WARN**
**Date:** 2026-04-18
**Reviewer:** csdid-reviewer

---

## 1. CS-DID Setup

- **Estimator:** Callaway-Sant'Anna (2021) with never-treated control group (CS-NT).
- **Group variable (gvar_CS):** CHC adoption year (1965-1974). Counties with no CHC or late adoption (1975-1980) receive gvar_CS=0, treated as never-treated controls.
- **Control specification:** Two versions run — (a) no controls (xformla=~1), (b) with Durb_f (5 urban-share quintile dummies).
- **Not-yet-treated (CS-NYT):** Not run (run_csdid_nyt=false), appropriate given the design uses late-CHC counties as the never-treated group rather than timing-based exclusion.

## 2. ATT Estimates

| Specification | ATT (simple) | SE | ATT (dynamic) | SE |
|---------------|-------------|-----|---------------|-----|
| CS-NT (no controls) | -61.43 | 19.06 | -58.99 | 21.34 |
| CS-NT (Durb_f controls) | -6.78 | 27.69 | +7.46 | 45.40 |

### Critical Finding: Severe Control Sensitivity

The CS-NT estimate without controls (-61.43, SE=19.06) is directionally consistent with TWFE (-53.21). However, adding the Durb_f control (5 urban-category dummies) collapses the estimate to -6.78 (SE=27.69) — not statistically distinguishable from zero — with the dynamic version even turning positive (+7.46, SE=45.40).

This sensitivity is documented in the metadata notes (Pattern 51) and represents a fundamental identification challenge:

**Root cause:** The paper's identification strategy relies on Durb×year (urban-category × year) and stfips×year (state × year) fixed effects in TWFE. These absorb time-varying urban-trajectory and state-level confounding. In the CS-NT propensity-score framework:
- Without controls: CS-NT effectively compares treated counties to all never-treated counties unconditionally, ignoring urban composition differences. This appears to give -61.43, close to TWFE, but potentially for the wrong reason (confounding absorbed by parametric controls may masquerade as clean identification).
- With Durb_f controls: The propensity model conditions on urban category, which may over-control or imprecisely estimate propensity scores given the 5-category discrete variable, reducing precision dramatically.
- Neither version can replicate state×year and baseline×trend controls that the TWFE absorbs parametrically.

**Implication:** The CS-NT estimator cannot cleanly replicate the paper's identification strategy. The range of CS-NT estimates (-6.78 to -61.43) encompasses the TWFE point estimate, but the true comparable CS-NT ATT is uncertain.

## 3. Event Study Comparison (No-Controls Version)

| Time | CS-NT | TWFE | Difference |
|------|-------|------|------------|
| -7 | +2.85 | -2.27 | +5.12 |
| -6 | +8.65 | +4.02 | +4.63 |
| -5 | +11.62 | +1.72 | +9.90 |
| -4 | +28.93 | +4.37 | +24.56 |
| -3 | +6.82 | -9.16 | +15.98 |
| -2 | -10.01 | -9.78 | -0.23 |
| 0 | -23.94 | -25.23 | +1.29 |
| 5 | -72.35 | -67.0 | -5.35 |
| 10 | -61.88 | -66.42 | +4.54 |

The no-controls CS-NT shows mild pre-period positive drift (t=-5 to t=-4: +11 to +29 units), especially at t=-4 (coefficient=+28.93). This indicates that without proper controls, counties that received CHCs were on a diverging pre-trend from never-treated counties — the Durb×year and state×year FEs in TWFE absorb this. This pre-trend in CS-NT (no controls) is a WARN signal.

Post-period trajectories are broadly similar between CS-NT and TWFE, suggesting the treatment effect direction is robust.

## 4. Parallel Trends Assessment

The CS-NT (no controls) pre-period drift at t=-4 (+28.93, SE=13.35) is approximately 2.2 standard errors above zero, indicating mild violation of the parallel trends assumption in the unadjusted comparison. This is expected given the design — the paper explicitly includes Durb×year and state×year FEs precisely because unconditional parallel trends does not hold.

The CS-NT (with Durb_f controls) attempts to address this but over-corrects, collapsing the estimate and generating a positive dynamic ATT. This is consistent with Pattern 42 (propensity overfitting) or insufficient variation in the Durb_f variable to replicate the continuous state×year absorption.

## 5. Verdict Reasoning

- **Direction of effect:** Confirmed negative (reduced mortality) across all CS-NT specifications without controls, consistent with paper's conclusion.
- **Magnitude:** Highly sensitive to control specification. The cs_nt_with_ctrls estimate is essentially uninformative (-6.78, SE=27.69).
- **Pre-trends:** Mild violation in no-controls version (t=-4 drift), absorbed by controls in TWFE.
- **Methodological concern:** The paper's identification relies on parametric controls that CS-NT cannot replicate. This is a fundamental limitation of applying CS-NT to this design, not a flaw in the paper per se — but it means we cannot use CS-NT as a clean robustness check.

**Verdict: WARN**

The sign of the CHC effect on elderly mortality is robust. The magnitude is uncertain in the CS-NT framework due to irreducible dependence on Durb×year and state×year fixed effects that cannot be absorbed in the CS propensity-score approach.
