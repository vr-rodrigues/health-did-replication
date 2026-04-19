# Skeptic report: 25 — Carrillo, Feres (2019)

**Overall rating:** MODERATE
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (WARN), bacon (NOT_APPLICABLE), honestdid (PASS), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE — no PDF)

## Executive summary

Carrillo & Feres (2019) estimate the effect of a physician distribution policy on physician supply per capita (`physician_cpta`) across 5565 Brazilian municipalities using staggered TWFE with 18 time-varying controls and state-specific linear trends. The headline TWFE estimate is 0.116 physicians per 1000 population, reproduced by our implementation within 0.05% (0.115942). All estimators confirm a positive, significant, and growing treatment effect: CS-NT without controls = 0.1144 (1.3% from TWFE), SA and Gardner event-study coefficients align closely. The single methodological concern is a borderline significant pre-period at t=-2 in the CS-NT event study (t-stat = 2.14), flagged as a mild concern by the CS-DID reviewer. HonestDiD shows the average ATT is robust through Mbar=1.0 (D-MODERATE) and the peak ATT through Mbar=1.75 (D-ROBUST). The fidelity axis is not evaluable (no PDF). Rating: MODERATE (M-MOD × F-NA) — the stored TWFE result is reliable; the single WARN reflects a borderline pre-period in CS-NT that does not overturn the conclusion.

## Per-reviewer verdicts

### TWFE (PASS)
- TWFE beta = 0.115942 matches paper target 0.116 within 0.05% — essentially exact reproduction.
- 18 time-varying controls correctly entered as `var × date` interactions matching Stata `c.(var)#c.date`.
- CS-NT convergence at 1.3% gap (no controls) indicates minimal negative-weight contamination despite staggered timing.
[Full report: `reviews/twfe-reviewer.md`]

### CS-DID (WARN)
- All CS-DID variants positive and highly significant (t > 13); direction unanimous.
- t=-2 CS-NT pre-period borderline significant (coef = -0.00845, SE = 0.00395, t = -2.14, p~0.03) — mild concern.
- CS-NT with controls 16% below TWFE; gap is a specification artefact (cs_controls=[] vs 18 TWFE controls), not a TWFE bias signal.
[Full report: `reviews/csdid-reviewer.md`]

### Bacon (NOT_APPLICABLE)
- 18 time-varying controls preclude Bacon decomposition (bacondecomp requires controls-free TWFE).
- `run_bacon = false` in metadata is correct.
- Indirect assessment via CS-DID convergence confirms low forbidden-comparison risk.
[Full report: `reviews/bacon-reviewer.md`]

### HonestDiD (PASS)
- Average ATT robust through Mbar=1.0 (breaks at 1.25) — D-MODERATE for both TWFE and CS-NT.
- Peak ATT robust through Mbar=1.75 (TWFE) / 1.5 (CS-NT) — D-ROBUST.
- rm_first_Mbar = 0 is expected given gradual policy diffusion mechanism (not a disqualifying signal).
[Full report: `reviews/honestdid-reviewer.md`]

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered design; CS-DID already provides the appropriate heterogeneity-robust estimator.
- 1.3% TWFE/CS convergence inconsistent with significant DID_M negative-weight contamination.
[Full report: `reviews/dechaisemartin-reviewer.md`]

## Material findings (sorted by severity)

WARN items:
- **[CS-DID / Pre-trends]** CS-NT pre-period t=-2 borderline significant (coef = -0.00845, t = -2.14). Magnitude is small relative to post-period effects but is a mild parallel-trends violation signal.
- **[CS-DID / Controls gap]** CS-NT with controls = 0.0972 vs TWFE = 0.1159 (16% gap). Expected given `cs_controls=[]` — the 18 controls are state×time linear interactions that cannot be replicated in the standard `did` package. Not a bias signal, but the CS-DID estimate without controls is the more comparable quantity.

No FAIL items.

## Recommended actions

- **No action needed on the stored TWFE result.** The 0.116 estimate is exact, the specification is correct, and the effect is robust across all applicable estimators.
- **Informational note for pattern-curator:** The t=-2 borderline pre-period in CS-NT (2.14σ) is below the threshold for a pattern-library entry but should be noted if similar papers in the `escalonada_controles` group show the same pattern.
- **Informational note for the user:** The 16% gap between TWFE and CS-NT is attributable to the impossibility of replicating 18 state×time-interacted controls in the CS-DID framework. If the paper's identification rests primarily on those controls and state trends, the CS-NT estimate (0.0972–0.1144) provides a partial robustness check only. The Callaway-Sant'Anna ATT without controls should be interpreted as a lower bound on the controlled estimate.
- **HonestDiD design signal:** D-MODERATE for avg ATT (Mbar=1.0), D-ROBUST for peak ATT. The headline conclusion that physician supply increased is credible under realistic pre-trend assumptions.

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
