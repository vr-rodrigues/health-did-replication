# Skeptic report: 744 - Jayachandran et al. (2010)

**Overall rating:** HIGH  *(Fidelity x Implementation: F-NA x I-HIGH)*
**Design credibility:** FRAGILE  *(Axis 3 finding - strong monotonic pre-trend drift over 12 pre-years; CS-NT avg ATT robust only to Mbar=0.50)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS; design=WARN x3), csdid (impl=PASS; design=WARN x2), bacon (NOT_APPLICABLE - single timing), honestdid (impl=PASS; Mbar_first=1.00, Mbar_avg=0.50 CS-NT, Mbar_peak=0.75 CS-NT), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE - no PDF or reference beta)

---

## Executive summary

Jayachandran, Lleras-Muney & Smith (2010) estimate the effect of sulfa drug introduction (1937) on log mortality using a cross-disease DiD: treated diseases (MMR, disease=1) vs. never-treated control (tuberculosis, disease=4), 1925-1943. Headline TWFE = -0.281 (28% mortality reduction); CS-NT = -0.333 confirms direction. Our pipeline faithfully reproduces the paper unusual specification (statepost absorbing FE, treatedXyear_c linear trend interaction as control variable). The stored consolidated result (-0.281 TWFE, -0.333 CS-NT) should be trusted as a correct reanalysis. However, the reanalysis reveals significant design fragility: without the parametric linear trend control the estimate flips to +13.616 (sign reversal); HonestDiD shows the CS-NT average ATT is robust only to Mbar=0.50; and a strong monotonic pre-trend drift spans 12 pre-years (amplitude ~0.26 log points). These are Axis 3 findings about the paper design - not demerits against our pipeline (Axis 2 implementation is clean, I-HIGH). Rating: HIGH (F-NA x I-HIGH). Design credibility: FRAGILE.

---

## Per-reviewer verdicts

### TWFE (impl=PASS; design findings classified WARN)

- Pipeline faithfully reproduces original areg/absorb(statepost)/cluster(diseaseyear). Non-standard statepost FE (state x post-period cells) is the paper own design choice, not our error.
- Design finding: beta_twfe_no_ctrls = +13.616 vs beta_twfe = -0.281 (sign reversal of ~14 log points when linear trend controls removed). Entire causal interpretation depends on the parametric linear trend assumption.
- Design finding: TWFE event study shows strong monotonic pre-trend drift -0.259 at t=-12 converging to near-zero at t=-3, partially absorbed by treatedXyear_c.
- Full report: reviews/twfe-reviewer.md

### CS-DID (impl=PASS; design findings classified WARN)

- CS-NT ATT = -0.333 (SE=0.026), statistically significant, directionally consistent. Single-cohort gvar=1937 correctly implemented.
- Design finding: TB as cross-disease counterfactual is the paper identifying assumption, not a pipeline concern.
- Design finding: CS-NT pre-periods mirror TWFE monotonic drift (t=-12: -0.261, t=-3: +0.030), confirming it is a data feature not a TWFE artifact.
- att_cs_nt_with_ctrls = 0 is a placeholder (cs_controls=[] empty; Spec A vacuously equals Spec C; status=OK).
- Full report: reviews/csdid-reviewer.md

### Bacon (NOT_APPLICABLE)

- treatment_timing=single (all treated adopt 1937 simultaneously). No staggered-adoption decomposition possible. run_bacon=false correctly set in metadata.
- Full report: reviews/bacon-reviewer.md

### HonestDiD (impl=PASS; design findings classified WARN)

- 11 pre-periods used (t=-12 to t=-2, t=-1 normalised). Computation clean.
- TWFE: Mbar_first=1.00, Mbar_avg=0.75, Mbar_peak=1.00.
- CS-NT: Mbar_first=1.00, Mbar_avg=0.50, Mbar_peak=0.75. Binding constraint (preferred estimator): Mbar_avg=0.50 (D-FRAGILE threshold).
- Design finding: accepting the result requires post-1937 violations to be at most half the observed pre-trend magnitude - non-trivial given a 0.26 log-point drift over 12 years.
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)

- Standard absorbing binary single-cohort design. No dose heterogeneity, no switching. CS-DID already recovers the ATT correctly.
- Full report: reviews/dechaisemartin-reviewer.md

### Paper auditor (NOT_APPLICABLE - F-NA)

- No PDF at pdf/744.pdf. No reference beta in original_result field of metadata. Fidelity axis not evaluable. Rating determined by implementation axis alone (I-HIGH -> HIGH).
- Full report: reviews/paper-auditor.md

---

## Three-way controls decomposition

cs_controls=[] (empty). twfe_controls=[treatedXyear_c, treated, year_c] are structural identification components (linear trend interaction), not standard covariates. Spec A is vacuously identical to Spec C.

| Spec | TWFE | CS-NT | Status |
|---|---|---|---|
| (C) TWFE with trend controls + CS without ctrls (headline) | -0.281 (0.108) | -0.333 (0.026) | OK - current default |
| (B) TWFE without controls + CS without controls | +13.616 (0.109) | N/A | TWFE collapses (sign reversal) |
| (A) both with controls | -0.281 (0.108) | 0/NA (placeholder) | OK (cs_controls=[]; vacuously Spec C) |

Key ratios:
- Estimator margin, headline (CS-NT vs TWFE): (-0.333-(-0.281))/0.281 = +18.5% (CS-NT larger; linear trend control in TWFE suppresses some post-treatment effect)
- Covariate margin (TWFE): removing trend controls flips sign ~4947%; treatedXyear_c is identification-critical not a sensitivity covariate

Verbal interpretation: the +18.5% estimator margin reflects that TWFE suppresses some post-treatment effect through the linear trend absorber while CS-NT does not. This gap is a design finding (Axis 3), not an implementation inconsistency.

---

## Material findings (sorted by severity)

Design findings (Axis 3 - findings about the paper, not demerits against our reanalysis):

- D-FRAGILE: CS-NT average ATT robust only to Mbar=0.50. The result stands only if post-1937 parallel-trends violations are at most half the observed pre-trend deviations.
- D-FRAGILE: Extreme parametric trend dependence. beta_twfe flips -0.281 to +13.616 without treatedXyear_c. Entire causal claim rests on this linear differential trend assumption being correctly specified.
- D-FRAGILE: Strong monotonic pre-trend drift over 12 pre-years (TWFE: -0.259 at t=-12 converging to +0.013 at t=-3; CS-NT mirrors; amplitude ~0.26 log points).
- D-NOTE: Cross-disease DiD (MMR vs TB) - validity of TB as counterfactual for MMR absent sulfa drugs is the paper central untestable identifying assumption.

No implementation WARNs or FAILs on Axis 2.

---

## Recommended actions

- No implementation action needed. I-HIGH is confirmed.
- Metadata (optional): populate original_result.beta = -0.281 and original_result.se = 0.108 in data/metadata/744.json to enable future paper-auditor fidelity check once PDF is available.
- User (methodological judgement): Design-credibility concerns (parametric trend dependence, cross-disease counterfactual validity, Mbar=0.50 HonestDiD constraint) should be surfaced to readers as Axis 3 findings, not attributed to our reanalysis methodology.
- No new failure pattern needed: parametric trend dependence is documented under Lesson 5; cross-disease DiD is paper-specific.

---

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
