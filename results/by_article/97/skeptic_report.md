# Skeptic report: 97 --- Bhalotra et al. (2021)

**Overall rating:** HIGH *(Fidelity x Implementation)*
**Design credibility:** D-FRAGILE *(separate finding about the paper design, not a demerit against our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS, design-WARN), csdid (impl=PASS, design-WARN), bacon (SKIPPED), honestdid (impl=PASS, M_first=0, M_avg=0.25, M_peak=0.50), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT -- corrected from 2026-04-18 NOT_APPLICABLE; pdf/97.pdf confirmed present)

## Executive summary

Bhalotra et al. (2021) estimate the effect of urban water disinfection (1991) on under-5 infant mortality in Brazilian municipalities using a dual-cohort repeated cross-section design. Our reanalysis reproduces the TWFE composite estimate (-0.303, SE 0.069) within 0.01% and the CS-NT estimate (-0.352, SE 0.039) within 0.02%, confirming F-HIGH fidelity. All implementation checks pass across TWFE, CS-DID, and HonestDiD -- every WARN in the prior 2026-04-18 report was a design finding about the paper, not a coding error. Under the three-axis rubric the overall rating is HIGH. The design credibility is D-FRAGILE: four of five pre-period coefficients are significantly positive (peak +0.335 at t=-4, 6.8 SEs), average ATT survives HonestDiD only to M_bar=0.25, and the first-post coefficient (-0.035) is not significant at any M_bar. These are findings about the paper parallel-trends assumption, not pipeline problems.

**Note on additive_2 and Spec A/B/C:** The six twfe_controls variables (treated_post_year, treated_year, treated, post, y, post_year) are algebraic components of the composite estimand theta_1 + 2*theta_2, not substantive covariates. Spec A/B/C does not apply: Spec B returns NA (composite undefined without its components), Spec A equals headline beta=-0.303. No covariate-margin decomposition is possible or meaningful.

## Per-reviewer verdicts

### TWFE (impl=PASS, design-WARN)
- All implementation checks PASS: composite additive_2 indicator correct, treated2 FE necessary and included, clustering at mun_reg matches paper, numerical match exact.
- Pre-trends (+0.335 at t=-4, 4 of 5 pre-periods significant) are Axis 3 design finding, not an implementation error.
- Gardner (BJS) level shift ~0.146 is Pattern 47 (documented), attributable to asymmetric untreated sample in first-stage FE estimation -- understood structural feature, not a bug.
- Full report: [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)

### CS-DID (impl=PASS, design-WARN)
- All implementation checks PASS: single-cohort RCS handled correctly, composite unit IDs (mun_reg*10+treated2) correct, base_period=universal appropriate.
- CS-NT (-0.352) matches paper (-0.3517) within 0.02%; 16% divergence from TWFE within expected range for controls-inclusion difference.
- CS-NT and TWFE event-study paths numerically identical -- pre-trends structural to data, not a TWFE weighting artefact.
- Full report: [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)

### Bacon (SKIPPED)
- Not applicable: treatment_timing=single, data_structure=repeated_cross_section. All three applicability gates fail.

### HonestDiD (impl=PASS, M_first=0, M_avg=0.25, M_peak=0.50)
- Applicability confirmed: has_event_study=true, 5 pre-periods (>=3).
- First-post (-0.035, SE 0.048): CI [-0.128, +0.059] straddles zero at M_bar=0. Design finding (Axis 3).
- Average ATT (-0.352) survives M_bar=0.25 (TWFE CI: [-0.427,-0.277]; CS-NT: [-0.461,-0.242]). Loses significance at M_bar=0.50.
- Peak ATT (-0.556 at t=3) survives M_bar=0.50 (TWFE) and M_bar=0.25 (CS-NT).
- Full report: [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Binary, absorbing, single-cohort treatment. No conditions triggering this estimator are present.
- Full report: [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)

### Paper-auditor (EXACT -- corrected)
- Correction: 2026-04-18 report marked NOT_APPLICABLE because it failed to locate pdf/97.pdf. File is confirmed present.
- Numerical match: TWFE within 0.01%, SE within 0.03%, CS-NT within 0.02%. All within EXACT tolerance.
- Metadata notes confirm: Paper-auditor EXACT (0.09%).
- Full report: [reviews/paper-auditor.md](reviews/paper-auditor.md) (outdated -- shows NOT_APPLICABLE due to path error; correct verdict is EXACT)

## Three-way controls decomposition

N/A -- paper 97 has no substantive covariates. The six twfe_controls variables are the algebraic components of the composite DiD coefficient theta_1 + 2*theta_2 (additive_2). Required for the estimand to be defined, not optional covariates to toggle. Spec B returns NA; Spec A equals headline beta=-0.303. No covariate-margin decomposition is possible or meaningful.

## Material findings (sorted by severity)

**Design finding (Axis 3) -- Large, structured pre-trends (all three applicable estimators):**
Four of five pre-period coefficients are significantly positive, peaking at +0.335 (t=6.8) at t=-4. Non-monotone pattern (rises t=-6 to t=-4, then declines). Identical across TWFE, CS-NT, and SA -- structural to the dual-cohort design. Magnitude comparable to headline ATT (-0.303). Serious concern for the paper parallel-trends assumption; not a pipeline problem.

**Design finding (Axis 3) -- First-post ATT not significant at any M_bar:**
The t=0 coefficient (-0.035, SE 0.048) is indistinguishable from zero even at M_bar=0 (CI [-0.128, +0.059]).

**Design finding (Axis 3) -- Average ATT fragile at M_bar=0.25:**
Average ATT loses significance at M_bar=0.50. Given pre-trends of +0.335, M_bar=0.25 implies allowable confound ~0.084 units -- non-negligible.

**Documented pattern (not an error) -- Gardner (BJS) level divergence (Pattern 47):**
Gardner estimates are ~0.146 units more negative than TWFE/CS-NT/SA across all periods. Root cause: asymmetric untreated sample in first-stage FE estimation. Dynamics preserved. Already documented in metadata.

## Three-axis rating derivation

| Axis | Score | Basis |
|---|---|---|
| Fidelity (paper-auditor) | F-HIGH | EXACT: beta_twfe 0.01%, CS-NT 0.02%; PDF confirmed present |
| Implementation (all applicable reviewers) | I-HIGH | All TWFE/CS-DID/HonestDiD implementation checks PASS; WARNs are design findings |
| F-HIGH x I-HIGH | **HIGH** | Clean pipeline, faithful reproduction |
| Design credibility (Axis 3 -- separate finding) | D-FRAGILE | M_avg=0.25 (boundary), M_first=0, pre-trends +0.335 at t=-4 |

## Recommended actions

- No action needed on implementation: pipeline for paper 97 is correctly specified and numerically faithful. Stored results.csv values (-0.303 TWFE, -0.352 CS-NT) are trustworthy.
- For the user (methodological judgement): D-FRAGILE is a finding about the paper. The positive pre-trend structure (rising t=-6 to t=-4 then declining) may reflect a compositional feature of the dual-cohort RCS design or genuine pre-reform differential trend. Average and peak ATTs are robust to modest violations but fragile beyond M_bar=0.25.
- For the user (scope of inference): Trust average ATT (-0.352) and peak ATT (-0.556) over the first-year impact (-0.035, not significant). Direction of effect (mortality reduction) is consistent across all five estimators.
- Correct the paper-auditor.md: the 2026-04-18 file incorrectly marks NOT_APPLICABLE due to PDF path error. Correct verdict is EXACT. A future paper-auditor re-run will overwrite it.
- No pattern-curator action needed: Pattern 47 already documented.

## Individual reports
- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md) (note: outdated -- correct verdict is EXACT)
