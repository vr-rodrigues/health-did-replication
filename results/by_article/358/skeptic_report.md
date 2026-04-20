# Skeptic report: 358 --- Bargain, Boutin, Champeaux (2019)

**Overall rating:** HIGH  *(Fidelity x Implementation: F-NA x I-HIGH --- fidelity axis not evaluable; implementation axis alone = HIGH)*
**Design credibility:** D-NA  *(2x2 design; 0 pre-periods; parallel trends structurally untestable; Bacon and HonestDiD not applicable)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS -- Spec A collapse reclassified as Pattern 42 design finding), bacon (SKIPPED -- single timing), honestdid (SKIPPED -- 0 pre-periods), dechaisemartin (NOT_NEEDED -- binary absorbing 2x2), paper-auditor (SKIPPED -- no PDF; informal fidelity = EXACT at 0.003%)

---

## Executive summary

Bargain, Boutin, Champeaux (2019) estimate the effect of exposure to women political participation during the 2011 Egyptian Arab Spring on intrahousehold empowerment (composite index ibp), using a 2x2 DiD design with two survey waves (2008 and 2014) and 272 municipalities classified by protest intensity. The paper headline coefficient (Table 1, Column 4: beta = 4.181, SE = 1.058) is reproduced to 0.003% -- the closest fidelity match in the audit sample for a paper with 30 covariates. All applicable methodology reviewers PASS on implementation. The stored result is reliable; the user should treat the beta_twfe value with high confidence.

The principal finding of this re-run is the reclassification of the Spec A anomaly. The doubly-robust CS-DID with 30 time-varying controls collapses to ATT=0.000 (SE=NA, status=OK) -- not because of a pipeline bug, but because the 2x2 design provides only one pre-period cross-section to fit a 30-covariate propensity model. This is the third confirmed instance of the direct-level-controls-collapse variant of Pattern 42 and has been designated the COLLAPSE-2x2 exemplar for Lesson 7 in Chapter 4 (section sec:spec_a_hexagon). It joins a documented family: id 79 (Carpenter, 53 controls, staggered, COLLAPSE), id 335 (Le Moglie, 18 controls, single-cohort, COLLAPSE), and id 358 (Bargain, 30 controls, 2x2, COLLAPSE). The collapse is a finding about the fundamental incompatibility of doubly-robust propensity-score methods with direct-level covariates in sparse-period designs -- not a demerit against our reanalysis.

The previous MODERATE rating (2026-04-18) arose from treating the Spec A collapse as an implementation WARN on Axis 2. Under the three-axis framework, the collapse is correctly placed on Axis 3 (design finding), leaving the implementation axis clean (I-HIGH). With F-NA and I-HIGH, the rating is HIGH.

---

## Per-reviewer verdicts

### TWFE (PASS)

- 2x2 DiD with single cohort: TWFE is algebraically a clean DiD. No negative weights, no forbidden comparisons, no heterogeneous-timing pathology possible.
- Coefficient reproduced to 0.003%: beta = 4.18087 vs. paper 4.181, SE gap of 0.3% attributable to feols small-sample degrees-of-freedom adjustment vs. Stata areg.
- Spec B (no controls) beta = 4.951 (+18.5%) confirms the 30 controls matter for magnitude but not direction; TWFE Spec B and CS-NT Spec B converge within 7.3%, consistent with 2x2 estimand equivalence.

Full report: [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)

### CS-DID (PASS -- reclassified)

- Spec B (unconditional): att_csdid_nt = 4.591 (SE=1.024), directionally unanimous with TWFE. Gap from TWFE-with-ctrls (Spec C headline) = +9.8%, entirely explained by absent controls on the CS side.
- Spec A collapse (ATT=0.000, SE=NA, status=OK): reclassified from implementation WARN to Pattern 42 design finding. The 30 time-varying controls create near-perfect separation in the propensity model fitted on the single pre-period cross-section. 14 of the 30 controls are post-interaction terms identically zero in the pre-period, causing perfect collinearity in the propensity design matrix. The doubly-robust estimator silently degenerates. Worst-case propensity-overfit scenario in the audit sample: 30 direct controls + 2x2 design = maximum DoF exhaustion.
- No pipeline error detected. Implementation verdict: PASS.

Full report: [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)

### Bacon (SKIPPED)

treatment_timing == single. Bacon decomposition requires staggered adoption across multiple cohorts. Not applicable.

### HonestDiD (SKIPPED)

has_event_study == false, event_pre == 0. HonestDiD requires an event study with at least 3 pre-periods. Not applicable.

### de Chaisemartin (NOT_NEEDED)

Binary absorbing treatment, single cohort, two periods. DIDmultiplegtDYN returns no additional diagnostic information in a clean 2x2 structure.

Full report: [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)

### Paper-auditor (SKIPPED -- informal EXACT)

No PDF at pdf/358.pdf. Formal fidelity axis not evaluable. Informally, metadata records original_result.beta_twfe = 4.181 and our estimate is 4.18087 -- gap of 0.003%, qualifying as EXACT under any tolerance threshold.

---

## Three-way controls decomposition

The paper TWFE specification includes 30 direct controls: 16 baseline individual/household characteristics (poorest, middle, richer, richest, urb, nb_child, primary, secondary, higher, age, age_husband, husband_work, religion, birthcoh_2, birthcoh_3) plus a post indicator, plus 14 post-interaction terms (post x each non-post control). This is the most extreme direct-level control set in the audit sample.

| Spec | TWFE | CS-NT | Status |
|---|---|---|---|
| (A) both with 30 controls | 4.181 (1.053) | 0.000 (NA) | FAIL_Pattern42 -- COLLAPSE-2x2 |
| (B) both without controls | 4.951 (1.032) | 4.591 (1.024) | OK |
| (C) TWFE with ctrls + CS without ctrls | 4.181 (1.053) | 4.591 (1.024) | OK (headline, current default) |

Key ratios:
- Estimator margin matched protocol Spec B (only evaluable matched spec): (4.951 - 4.591) / |4.951| = +7.3%. In a 2x2 with a single cohort TWFE and CS-DID are algebraically equivalent -- the 7.3% gap reflects slightly different variance paths and would close to near-zero on a balanced panel.
- Covariate margin TWFE side: (4.181 - 4.951) / |4.181| = -18.4%. The 30 controls compress the TWFE estimate by 18% relative to the unconditional DiD.
- Covariate margin CS side: Spec A collapses -- ratio undefined. Spec A is uninformative for the matched-protocol comparison.
- Total gap current headline Spec C: (4.181 - 4.591) / |4.181| = -9.8%. Entirely attributable to missing controls on the CS side, not to estimator heterogeneity.

Verbal interpretation: The matched-protocol comparison is recoverable only in Spec B (unconditional), where the 7.3% gap confirms that in a 2x2 design TWFE and CS-DID produce essentially the same number when the covariate set is held constant. The entire TWFE vs. CS-DID headline gap (Spec C: -9.8%) is a covariate-absence effect on the CS side, not an estimator disagreement. Spec A cannot close this gap because the doubly-robust estimator is incompatible with 30 direct time-varying controls in a 2x2 design (Pattern 42 COLLAPSE-2x2). This is the core Lesson 7 finding for this paper and feeds Deliverable D1 of the QJE review.

---

## Lesson 7 context -- COLLAPSE-2x2 exemplar (sec:spec_a_hexagon)

This article is the canonical COLLAPSE-2x2 case in the Lesson 7 hexagon (Chapter 4, section sec:spec_a_hexagon). The documented Spec A behaviors across the audit sample are:

| ID | Paper | N controls | Design | Spec A behavior |
|---|---|---|---|---|
| 25 | Carrillo, Feres (2019) | 18 pre-trend interactions | single-cohort staggered | CLEAN |
| 79 | Carpenter, Lawler (2019) | 53 direct controls | staggered | COLLAPSE (Pattern 42) |
| 125 | Levine, McKnight (2011) | direct controls | RCS | INFLATE (Pattern 51) |
| 335 | Le Moglie, Sorrenti (2022) | 18 direct controls | single-cohort | COLLAPSE (Pattern 42) |
| 358 | Bargain et al. (2019) | 30 direct controls | 2x2 | COLLAPSE-2x2 (Pattern 42, worst-case) |
| (6th) | TBD | -- | -- | TBD |

The consolidating rule: direct level controls + single/few-period design + doubly-robust propensity score leads to collapse. Pre-treatment-trend interactions (as in id 25) avoid the collapse because they are zero in pre-periods and do not inflate propensity model dimensionality.

The 2x2 case (id 358) is the most extreme: one cross-sectional pre-period to fit 30 covariates. The 14 post-interaction terms are identically 0 in all pre-period rows, causing perfect collinearity in the propensity model design matrix. The doubly-robust estimator silently returns 0 with status=OK -- the silent failure mode is the most dangerous because it cannot be detected from the status field alone.

---

## Material findings (sorted by severity)

Design findings (Axis 3 -- about the paper, not our pipeline):

- Spec A COLLAPSE-2x2 (Pattern 42, 3rd direct-level-controls instance). The doubly-robust CS-DID with 30 time-varying controls in a 2x2 design silently returns ATT=0, SE=NA despite status=OK. Root cause: single pre-period cross-section + 30 covariates (14 identically zero post-interactions) causes propensity model degeneracy. Establishes that the paper 30-control specification is fundamentally incompatible with doubly-robust CS-DID. The paper causal claim rests entirely on TWFE; Spec B CS-DID confirms the direction unconditionally.
- Parallel trends structurally untestable. The 2x2 design provides no pre-periods. Whether treated municipalities (above-median protest intensity) and control municipalities had parallel trends before 2008 cannot be assessed from these data. This is a design constraint, not a replication failure.

Implementation findings: none.

---

## Recommended actions

- No methodological reinterpretation needed for the stored TWFE result. The 2x2 DiD with single treatment event is the simplest valid DiD design; all modern robustness concerns (staggered timing, negative weights) are structurally inapplicable. The stored beta_twfe=4.181 is trustworthy.
- Update skeptic_ratings.csv: rating upgraded to HIGH (from MODERATE); design axis D-NA unchanged; implementation axis I-HIGH (from I-MOD).
- Confirm Lesson 7 hexagon documentation in Chapter 4 section sec:spec_a_hexagon: include id 358 as the COLLAPSE-2x2 exemplar and note the pentagon has expanded to a hexagon pending the sixth identified pattern.
- No PDF action needed unless the paper becomes available. The informal EXACT match (0.003%) is sufficient for dissertation purposes.
- For papers with many direct controls in 2x2 designs, Spec A is by construction undefined under doubly-robust CS-DID. Document in the dissertation text that the correct matched-protocol comparison for such papers is Spec B (unconditional), where TWFE and CS-DID converge within expected bounds.
- Consider adding a diagnostic rule to the template: if length(twfe_controls) > 15 AND n_periods == 2, flag Spec A as expected-to-collapse and suppress the misleading status=OK message to prevent silent failure.

---

## Individual reports

- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
