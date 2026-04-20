# Skeptic report: 147 --- Greenstone, Hanna (2014)

**Overall rating:** HIGH  *(Fidelity x Implementation: F-NA x I-HIGH -> use implementation alone -> HIGH)*
**Design credibility:** BROKEN  *(separate axis -- a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS), bacon (SKIPPED: allow_unbalanced=true), honestdid (impl=PASS, design-FAIL: M_bar=0 all targets), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE: no PDF)

## Executive summary

Greenstone and Hanna (2014) estimate the effect of India catalytic converter policy on SPM using a staggered TWFE design with 9 concurrent SCAP policy controls. Our replication reproduces the headline TWFE estimate essentially exactly (8.015 vs 8.01 ug/m3, gap < 0.06%) using the metadata-recorded target; the SE difference (11.93 vs 12.59) is fully explained by feols singleton removal and all CS-DID variants are directionally consistent. Our implementation is clean (I-HIGH). However, the paper design is D-BROKEN: HonestDiD robust CIs include zero at Mbar=0 for every target (first-post, average, peak) and both estimators (TWFE and CS-NT), meaning the causal claim cannot be made robust to even the smallest pre-trend violation. Pre-trends are large and monotonically declining (TWFE h=-5: -35.6 ug/m3; CS-NT h=-5: -55.2 ug/m3) relative to the post-treatment estimate (8 ug/m3), consistent with selection of high-pollution cities into earlier policy adoption. The stored beta_twfe = 8.01 faithfully replicates the paper but should be flagged prominently in any meta-analysis as having a broken identification strategy.

## Per-reviewer verdicts

### TWFE (impl=PASS, design-WARN: pre-trends + windowed treatment)
- Point estimate replicates metadata target exactly (8.015 vs 8.01; gap < 0.06%); SE gap (11.93 vs 12.59) attributable to feols singleton removal -- implementation PASS.
- Pre-trends large and monotonically declining (h=-5: -35.6 ug/m3 to h=-1: -5.7 ug/m3): Axis 3 design finding.
- Controls attenuate coefficient ~44% (14.48 without vs 8.01 with); windowed treatment [-7,+9] complicates ATT interpretation: Axis 3 design finding.
- Full report: [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)

### CS-DID (impl=PASS, design-WARN: pre-trends + structural SCAP gap)
- CS-NT ATT = 6.97 (SE=19.94), CS-NYT ATT = 6.52 (SE=19.19): directionally consistent, both insignificant -- implementation correct.
- CS-DID cannot incorporate SCAP controls (cs_controls=[]); documented structural constraint, not an implementation error -- Axis 3 design finding.
- CS-NT pre-trends even larger than TWFE (h=-5: -55.2 vs -35.6 ug/m3): Axis 3 design finding.
- Full report: [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)

### Bacon (SKIPPED)
- Unbalanced panel (allow_unbalanced=true) and run_bacon=false preclude decomposition.
- Full report: [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)

### HonestDiD (impl=PASS, design-FAIL: M_bar=0 all targets)
- HonestDiD run correctly against valid inputs (4 pre-periods) -- implementation PASS.
- All robust CIs include zero at Mbar=0: TWFE first-post (-34.80, +37.80); CS-NT peak (-4.56, +76.67) -- Axis 3 D-BROKEN.
- No breakdown value computable: pre-trends (35-55 ug/m3) dwarf post-treatment estimate (8 ug/m3).
- Full report: [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Standard staggered absorbing binary design within event window; CS-DID framework sufficient.
- Full report: [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)

## Three-way controls decomposition

TWFE controls non-empty (9 covariates). cs_controls=[] by design -- SCAP policy controls are jointly-estimated event-window dummies, not pre-determined covariates passable to CS-DID. Spec A returns att_cs_nt_with_ctrls=0/NA (pipeline status=OK) via propensity separation -- Pattern 42 / Lesson 7 COLLAPSE-staggered.

| Spec | TWFE | CS-DID NT | Status |
|---|---|---|---|
| (A) both with controls | 8.015 (SE=11.926) | 0 / NA | COLLAPSE (Pattern 42: 9 direct-level controls + staggered DR) |
| (B) both without controls | 14.483 (SE=10.553) | 6.965 (SE=19.941) | OK |
| (C) TWFE with, CS without | 8.015 (SE=11.926) | 6.965 (SE=19.941) | -- (headline, current default) |

Key ratios:
- Estimator margin (protocol-matched, Spec B): (14.483 - 6.965) / |14.483| = +52%
- Covariate margin (TWFE side): (8.015 - 14.483) / |8.015| = -81%
- Total gap (current headline, Spec C): (8.015 - 6.965) / |8.015| = +13%

Verbal interpretation: Spec B matched-protocol reveals +52% estimator gap driven entirely by the TWFE covariate effect (-81%). CS-DID without controls confirms a positive but imprecise treatment signal. Spec A collapses (Pattern 42). Canonical Lesson 7 COLLAPSE-staggered case alongside articles 79, 47, 358.

## Material findings (sorted by severity)

**Design findings (Axis 3 -- findings about the paper, not demerits against our work):**
- D-BROKEN: M_bar = 0 at first-post and peak for both TWFE and CS-NT. All robust CIs include zero at Mbar=0. No informative lower bound achievable.
- D-BROKEN (corroborating): Pre-trends large and monotonically declining (TWFE h=-5: -35.6; CS-NT h=-5: -55.2; SA h=-5: -61.3 ug/m3). Consistent with selection of deteriorating-air-quality cities into earlier adoption.
- Structural SCAP gap: CS-DID cannot control for concurrent SCAP policy; Spec A collapses (Pattern 42); Spec B estimator margin = +52%.
- Controls sensitivity: TWFE shrinks 44% from 14.48 (no controls) to 8.01 (with controls).

**Implementation notes (no WARN-level findings):**
- SE difference (R: 11.93 vs Stata: 12.59): feols singleton removal; documented in metadata.
- tauSCR and tauCATR collinear and dropped: expected for event-window dummies + city+year FEs.

## Recommended actions

- No action needed on implementation -- all reviewers PASS on Axis 2.
- For the user: Flag article 147 as D-BROKEN in any meta-analysis. beta_twfe=8.01 faithfully replicates the paper, but causal inference is untenable.
- For the user (optional): A BJS-only HonestDiD run may be informative -- Gardner pre-trends (h=-5: -7.5 ug/m3) are much smaller than TWFE (-35.6).
- For the pattern-curator: Reinforce COLLAPSE-staggered with concurrent SCAP-type policy controls as canonical Lesson 7 COLLAPSE-staggered instance (alongside articles 79, 47, 358).
- For the pattern-curator: Document compound design failure: D-BROKEN HonestDiD + large monotone pre-trends + concurrent policy confounders (SCAP) + selection into deteriorating units.

## Individual reports
- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md)
