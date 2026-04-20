# Skeptic report: 61 - Evans, Garthwaite (2014)

**Overall rating:** LOW  *(built from Fidelity x Implementation)*
**Design credibility:** D-NA  *(no event study possible; diagnostics inapplicable)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=WARN), csdid (impl=WARN), bacon (N/A), honestdid (N/A), dechaisemartin (NOT_NEEDED), paper-auditor (WARN - F-MOD)

## Executive summary

Evans and Garthwaite (2014) estimate the effect of the 1995 EITC expansion on maternal excellent/very-good self-reported health via single-adoption DiD on BRFSS repeated cross-section data (paper beta_twfe = 0.0095, plain OLS, no unit/time FEs). The identification strategy is conceptually sound: single timing eliminates staggered heterogeneity bias, forbidden comparisons, and de Chaisemartin concerns. Two pipeline implementation problems reduce confidence in the stored estimates. (1) The R template added spurious fips+year two-way FEs absent from the Stata original, inflating stored TWFE to 0.01032 (8.8% above paper); the correct no-FE spec produces 0.009483 exactly, but results.csv has not been updated since the Round 3 fix. (2) The doubly-robust CS-DID with controls collapsed to zero (att_cs_nt_with_ctrls=0, status=OK) -- a Pattern 42 computational failure (5th instance), not a genuine zero; the pipeline mislabels it as passing. No event study is available because dd_treatment is constructed at the individual level (kids>1 x post), not at the fips level, making HonestDiD and parallel-trends pre-testing structurally impossible from our pipeline. The positive EITC-health direction is unanimous across TWFE and CS-DID (no controls); the design is clean by single-timing standards. LOW rating: F-MOD (stored TWFE 8.8% off) x I-LOW (2 implementation errors). The correct stored value should be 0.009483.

## Per-reviewer verdicts

### TWFE (WARN - implementation)
- Stored beta_twfe = 0.01032 from over-specified model (template added fips+year FEs not in Stata original). Correct no-FE beta = 0.009483, documented in metadata Round 3 fix but not written back to results.csv.
- Controls twoplus_kids and eitc_expand correctly included; cluster(fips) correct; sample filter kids>0 and educ<=2 correct.
- Individual-level treatment construction (dd_treatment = post x kids>1) is a design property of this paper, not an implementation error.
- Full report: reviews/twfe-reviewer.md

### CS-DID (WARN - implementation)
- att_cs_nt_with_ctrls = 0 is a degenerate numerical result (Pattern 42: direct-level controls + single-cohort RCS + doubly-robust propensity), not a genuine zero effect. Pipeline status column records OK -- should be FAIL_COLLINEAR.
- ATT_NT (no controls) = 0.0065 (SE=0.0138): direction consistent with TWFE, ~31% smaller in magnitude, not significant (t~0.47). This is a design-level comparison finding, not an implementation error.
- SE inflation 75% wider than TWFE SE: consistent with RCS pseudo-panel efficiency loss -- design finding, not error.
- Full report: reviews/csdid-reviewer.md

### Bacon (NOT_APPLICABLE)
- Single-timing design on repeated cross-section. Bacon decomposition inapplicable by design (treatment_timing=single, data_structure=repeated_cross_section, run_bacon=false).
- Full report: reviews/bacon-reviewer.md

### HonestDiD (NOT_APPLICABLE)
- No event study available; individual-level treatment (kids>1) prevents fips-level pre-period estimation. Parallel trends cannot be assessed from our pipeline outputs.
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)
- Absorbing binary single-timing design. No staggered cohorts, no dose heterogeneity, no treatment reversals. No concerns triggered.
- Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (WARN - F-MOD)
- Stored beta = 0.01032 vs paper beta = 0.0095: divergence = 8.8%, above 5% tolerance (WARN), below 20% (not FAIL).
- Root cause: spurious FEs added by template; correct spec yields exact match 0.009483.
- PDF confirmed present at pdf/61.pdf; original_result field matches paper Table 2.
- Full report: reviews/paper-auditor.md

## Three-way controls decomposition

twfe_controls = [twoplus_kids, eitc_expand] -- non-empty; decomposition applicable.

Note: Stored TWFE uses the incorrect FE-inflated spec. Correct values not yet in results.csv: beta_no_ctrls=0.004753, beta_with_ctrls=0.009483.

| Spec | TWFE | CS-DID NT | Status |
|---|---|---|---|
| (A) both with controls | 0.01032 SE=0.00786 [stored; incorrect FE spec] | 0 SE=NA | FAIL_COLLINEAR: CS collapsed Pattern 42 |
| (B) both without controls | 0.004753 SE=0.00504 | 0.006514 SE=0.01307 | OK |
| (C) TWFE with, CS without | 0.01032 SE=0.00786 [stored] | 0.006514 SE=0.01375 | Current headline (TWFE spec incorrect) |

Key ratios:
- Estimator margin (Spec B, protocol-matched unconditional): (0.004753 - 0.006514) / |0.004753| = -37% (CS-DID 37% larger than TWFE-no-ctrls)
- Covariate margin (TWFE side, Spec C vs B): (0.01032 - 0.004753) / |0.01032| = +54%
- Covariate margin (CS side): Spec A CS degenerate (=0); cannot compute
- Total gap (current headline Spec C): (0.01032 - 0.006514) / |0.01032| = +37%

Verbal interpretation: Spec B (clean unconditional matched comparison) shows CS-DID is 37% larger than TWFE-no-ctrls. Adding controls nearly doubles the TWFE (+54% covariate margin), consistent with twoplus_kids and eitc_expand being component terms of dd_treatment rather than pure confounders. The Spec A CS degeneracy (Pattern 42, 5th confirmed instance) prevents a clean matched-protocol comparison with controls. The Spec C gap (37%) is driven by asymmetric controls specification, not staggered-timing heterogeneity -- expected for a single-timing design. Controls are structural to the DiD construction here, making symmetric doubly-robust comparison technically infeasible in the RCS single-cohort context. This feeds Deliverable D1 of the QJE review.

## Rating decomposition

| Axis | Score | Basis |
|---|---|---|
| Fidelity | F-MOD | paper-auditor WARN: stored beta 8.8% above paper (documented spurious-FE cause) |
| Implementation | I-LOW | 2 pipeline errors: (1) results.csv not updated after Round 3 fix; (2) att_cs_nt_with_ctrls=0 mislabeled as OK |
| **Overall** | **LOW** | F-MOD x I-LOW |
| Design credibility | D-NA | No event study possible; HonestDiD/pre-trends structurally inapplicable; Bacon N/A; parallel trends must be defended institutionally |

## Material findings (sorted by severity)

- WARN (Axis 2) -- Stored results.csv beta_twfe = 0.01032 from mis-specified model (spurious fips+year FEs). Correct no-FE spec = 0.009483 but results.csv not updated. Downstream analyses 8.8% overstated.
- WARN (Axis 2) -- att_cs_nt_with_ctrls = 0 is a degenerate Pattern 42 result (5th instance: direct-level component-term controls + single-cohort RCS + doubly-robust propensity). Status column records OK -- should be FAIL_COLLINEAR.
- NOTE (design context) -- Controls carry structural load: +54% covariate margin (TWFE side). twoplus_kids and eitc_expand are component terms of dd_treatment, not pure confounders.
- NOTE (design context) -- No parallel-trends assessment possible post-hoc. Must be defended institutionally (federal EITC expansion quasi-random with respect to maternal health trends for 2+-child households).

## Recommended actions

- **Repo-custodian:** Re-run TWFE without fips+year FEs (plain OLS per metadata Round 3 notes) and update results.csv with beta_twfe = 0.009483.
- **Repo-custodian:** Change cs_nt_with_ctrls_status from OK to FAIL_COLLINEAR in results.csv. The zero att_cs_nt_with_ctrls is a Pattern 42 computational artefact.
- **User:** HonestDiD is structurally impossible for this paper. Parallel trends for the EITC expansion must be defended via institutional argument (federal legislative change quasi-random with respect to maternal health trends).
- **Pattern-curator:** Tag RCS single-cohort sub-variant of Pattern 42: component-term controls (twoplus_kids, eitc_expand are parts of dd_treatment interaction) are structurally collinear with treatment in doubly-robust propensity model. 5th confirmed instance.

## Individual reports
- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
