# Skeptic report: 147 — Greenstone, Hanna (2014)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (N/A), honestdid (FAIL), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

## Executive summary

Greenstone & Hanna (2014) estimate the effect of India's catalytic converter policy on SPM (suspended particulate matter) air pollution using a staggered TWFE design with 9 concurrent SCAP policy controls. The headline TWFE estimate (+8.01 µg/m³, SE=11.93) is statistically insignificant and our replication reproduces it to within rounding precision. However, the pre-trend pattern is systematically large and negative across all estimators (TWFE: -35.6 at h=-5; CS-NT: -55.2 at h=-5; SA: -61.3 at h=-5), revealing selection of high-pollution cities into earlier adoption. The HonestDiD sensitivity analysis fails at every Mbar level — robust confidence intervals cross zero even under the assumption of zero pre-trend violation, providing no informative causal evidence. CS-DID estimates are directionally consistent with TWFE but cannot incorporate the critical SCAP policy controls, limiting comparability. The stored consolidated result (beta_twfe = 8.01) numerically replicates the paper, but confidence in a causal interpretation is low. The primary concern is methodological, inherited from the original paper's design.

## Per-reviewer verdicts

### TWFE (WARN)
- Point estimate replicates the paper essentially exactly (8.015 vs 8.01); SE gap (11.93 vs 12.59) is due to feols singleton removal, not a methodological error.
- Pre-trends are large and systematic: h=-5 is -35.6 µg/m³ and monotonically approaches zero at h=-1, consistent with selection of deteriorating cities into policy adoption.
- Controls attenuate the coefficient substantially (14.48 without controls vs 8.01 with); windowed treatment design (event window [-7,+9]) complicates ATT interpretation.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (WARN)
- CS-NT ATT = 6.97 (SE=19.94) and CS-NYT ATT = 6.52 (SE=19.19): directionally consistent with TWFE but statistically insignificant with wider SEs.
- CS pre-trends at h=-5 are even larger than TWFE (CS-NT: -55.2; CS-NYT: -40.0), reinforcing parallel trends concern.
- CS-DID cannot incorporate SCAP policy controls by design, so it measures a different estimand — the comparison is informative but not clean.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)
- Unbalanced panel (`allow_unbalanced: true`) precludes Bacon decomposition.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (FAIL)
- All robust CIs (TWFE and CS-NT; targets first/avg/peak) cross zero at Mbar=0 — no informative lower bound on the treatment effect even assuming zero pre-trend violation.
- TWFE target=first at Mbar=0: (-34.80, +37.80); CS-NT target=peak at Mbar=0: (-4.56, +76.67).
- The observed pre-trends (35-55 µg/m³ at h=-5) dwarf the post-treatment estimate (8 µg/m³), making the sensitivity analysis uninformative.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard staggered absorbing binary design within the event window; CS-DID framework is sufficient.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

## Material findings (sorted by severity)

**FAIL:**
- HonestDiD sensitivity analysis produces uninformative bounds at all Mbar levels for all targets (TWFE and CS-NT). The pre-trend pattern makes causal identification fundamentally questionable.

**WARN:**
- TWFE: Large systematic pre-trends (h=-5: -35.6; h=-4: -30.1 µg/m³) across all estimators suggest selection into treatment based on pre-existing pollution trajectory. Post-treatment estimates oscillate with no coherent pattern.
- CS-DID: Cannot control for the concurrent SCAP policy, which is a key part of the identification strategy in the original paper. CS-DID estimates a different (and potentially confounded) estimand.
- Controls sensitivity: removing 9 TWFE controls increases the estimate from 8.01 to 14.48 (+80%), signalling substantial omitted variable dependence.
- tauSCR and tauCATR dropped for collinearity — the model is over-parameterised.

## Recommended actions

- **For the user (methodological judgement):** The HonestDiD FAIL means no robust causal inference can be drawn from any specification. The stored beta_twfe = 8.01 is a replication of the paper's number but should not be interpreted as a credible causal estimate. Flag this paper in any meta-analysis as having severe parallel trends concerns.
- **For the repo-custodian agent:** Consider flagging in metadata that the treatment variable `catconvpolicy` is a finite-window indicator (not a pure absorbing dummy), and note that the HonestDiD breakdown occurs at Mbar=0 for all targets.
- **For the pattern-curator:** Add or reinforce Pattern for "selection-into-treatment via pre-existing trend": large monotone pre-trends across all estimators (TWFE, CS-NT, CS-NYT, SA) in a context where pollution levels predict policy adoption — all post-treatment estimates are insignificant and HonestDiD provides no lower bound.
- **For the user:** If a sensitivity analysis with the Gardner (BJS) estimator pre-trends (which are smaller) is desired, a targeted re-run using the BJS event study may be informative — Gardner pre-trends (h=-5: -7.5, h=-4: -8.9) are much smaller than TWFE/CS, warranting a separate HonestDiD run.

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
