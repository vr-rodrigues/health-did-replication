# Skeptic report: 47 - Clemens (2015)

**Overall rating:** HIGH  *(built from Fidelity x Implementation)*
**Design credibility:** D-MODERATE  *(separate axis -- a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS, design-finding: pre-trend t=-5), csdid (impl=PASS, design-finding: pre-trend t=-5), bacon (N/A -- single cohort), honestdid (impl=PASS, Mbar_first=2.0/1.75, Mbar_avg=2.0/1.50, Mbar_peak=1.75/1.25 TWFE/CS-NT), dechaisemartin (NOT_NEEDED -- single-cohort absorbing binary), paper-auditor (EXACT, 0.03% gap)

## Executive summary

Clemens (2015) estimates the effect of community-rating health insurance regulations on private coverage in stable community-rating states (New York, Maine, Vermont) relative to never-regulated controls. The paper's headline estimate (beta = -0.0962, SE = 0.0206 bootstrap) is reproduced to 0.03% precision in our reanalysis (EXACT). The CS-NT estimate (-0.1243) matches the paper's reported value (-0.1248) within 0.4%. The implementation is clean on all applicable axes: single-cohort, absorbing, binary treatment means TWFE is mechanically equivalent to a clean 2x2 DiD with no staggered-timing bias, no negative weights, and no de Chaisemartin concerns. The Spec A collapse (CS-DID with 15 direct-level controls to 0/NA) is the 4th documented instance of Lesson 7 (Chapter 4 sec:spec_a_hexagon) and is handled correctly by the template; it is a known structural artefact, not a pipeline failure. The Spec B unconditional comparison (TWFE -0.098 vs CS-NT -0.124, CS 29% larger in magnitude) is the informative methodological comparison. HonestDiD confirms robustness at Mbar=1.75 (TWFE) and Mbar=1.25 (CS-NT) for peak effects; both estimators remain significant at the natural Mbar=1 benchmark. A statistically significant pre-trend at t=-5 (TWFE: -0.027, t~3.1; CS-NT: -0.047, t~3.6) is the paper's primary design-credibility concern -- recorded here as D-MODERATE (not D-FRAGILE) because Mbar values exceed 1.0 for all targets on both estimators, and the paper's institutional narrative (NJ uncompensated care spiral, excluded from the stable-state sample) partially explains the t=-5 deviation. Users should trust the stored consolidated_results value (-0.0962 TWFE, -0.1243 CS-NT) as directionally sound, numerically faithful, and technically correctly produced. The design concern is a finding about the paper, not a demerit against the reanalysis.

**Rating correction note (2026-04-19):** The prior report (2026-04-18) gave LOW, driven by the pre-trend WARNs from twfe-reviewer and csdid-reviewer. Under the corrected three-axis rubric, those WARNs are Axis-3 design findings, not Axis-2 implementation failures. With zero implementation WARNs/FAILs and EXACT fidelity, the correct rating is HIGH. The design concern is reported separately as D-MODERATE.

## Per-reviewer verdicts

### TWFE (impl=PASS, design finding noted)
- Specification matches paper equation (3) exactly: state and year FEs, full 15-variable demographic control set including superregion interactions, CPS person weights, stable-state sample. Point estimate gap 0.03% -- EXACT MATCH at 127,554 observations.
- SE discrepancy (analytic SE=0.0097 vs paper bootstrap SE=0.0206) is a known mechanical effect with 3 treated clusters; bootstrap-based inference is the paper's preferred approach. Not a misspecification.
- Design finding (Axis 3): t=-5 coefficient = -0.027 (SE=0.009, t~3.1, p~0.002) -- statistically significant pre-trend. Paper attributes to NJ market disruption in pre-period; NJ is excluded from the stable-state estimating sample, partially mitigating the concern.
- Full report: [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)

### CS-DID (impl=PASS, design finding noted)
- Single-cohort CS-DID correctly implemented with never-treated comparison (gvar_CS=7 for NY/ME/VT, 0 for never-treated). Point estimate -0.1243 within 0.4% of paper's -0.1248 -- confirms correct group-time cell construction.
- cs_controls=[] is intentional (metadata-specified); CS-DID runs unconditionally per the paper's own CS-NT specification.
- Spec A (cs_nt_with_ctrls=0): Lesson 7 collapse -- see Three-way controls section below. Correctly recorded as att_cs_nt_with_ctrls=0, cs_nt_with_ctrls_status=OK (template handled it; not a pipeline crash).
- Design finding (Axis 3): t=-5 CS-NT coefficient = -0.047 (SE=0.013, t~3.6) -- larger than TWFE, reflecting absence of covariate adjustment. Consistent with TWFE pre-trend finding.
- CS-NT (-0.1243) is 29% larger in magnitude than TWFE (-0.0962): reflects covariate adjustment absorbing demographic heterogeneity between stable-CR states and controls (Pattern 25 -- RCS aggregation magnitude gap).
- Full report: [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)
- treatment_timing=single and data_structure=repeated_cross_section -- both applicability conditions fail.
- The single bacon.csv row (type=Treated vs Untreated, weight=1.0, estimate=-0.1005) confirms 100% of TWFE weight on the clean 2x2 comparison with zero timing-contamination. Design is maximally clean with respect to Bacon weighting.
- Full report: [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)

### HonestDiD (impl=PASS)
- Run on 3 pre-periods (t=-5, -4, -3 with t=-1 normalized), 2 post-periods. Applicability threshold met.
- TWFE: Mbar_first=2.0, Mbar_avg=2.0, Mbar_peak=1.75 -- robust across all targets at Mbar=1 and beyond.
- CS-NT: Mbar_first=1.75, Mbar_avg=1.50, Mbar_peak=1.25 -- all above the natural Mbar=1 benchmark; loses significance only at demanding Mbar>1.5 assumptions.
- Both estimators remain significant at Mbar=1. Reassuring given the pre-trend is statistically significant.
- Full report: [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Single-cohort, absorbing, binary treatment with clean never-treated comparison. TWFE mechanically equivalent to a clean 2x2 DiD. No negative weights possible by construction. KY and NH (states that repealed community-rating) are excluded from the sample.
- Full report: [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (EXACT)
- TWFE point estimate: paper -0.0962, ours -0.09617 -- gap 0.03% (EXACT). CS-NT: paper -0.12480, ours -0.12429 -- gap 0.4% (within tolerance).
- SE difference fully explained by bootstrap vs. analytic clustering with 3 treated units. Not a replication failure.
- Full report: [reviews/paper-auditor.md](reviews/paper-auditor.md)

## Three-way controls decomposition

variables.twfe_controls is non-empty (15 direct-level controls: kid, kidlt2, kidlt6, femhead, black, poverty_percent, and 9 superregion interaction dummies). The decomposition applies.

| Spec | TWFE | CS-NT | Status |
|---|---|---|---|
| (A) both with controls | beta=-0.09617 (SE=0.00974) | ATT=0 (NA) | FAIL_LESSON7_COLLAPSE |
| (B) both without controls | beta=-0.09752 (SE=0.00889) | ATT=-0.12429 (SE=0.01784) | OK -- headline unconditional comparison |
| (C) TWFE with, CS without | beta=-0.09617 (SE=0.00974) | ATT=-0.12429 (SE=0.01784) | -- (stored consolidated default) |

Key ratios (Spec B -- the informative protocol-matched comparison):
- Estimator margin (protocol-matched): (beta_B_TWFE - ATT_B_CS) / |beta_B_TWFE| = (-0.09752 - (-0.12429)) / 0.09752 = +27.5% (CS-NT 27.5% larger in magnitude)
- Covariate margin (TWFE side): (beta_C - beta_B) / |beta_C| = (-0.09617 - (-0.09752)) / 0.09617 = -1.4% (near-zero -- covariates barely change TWFE)
- Total gap (stored headline, Spec C): (beta_C - ATT_C) / |beta_C| = (-0.09617 - (-0.12429)) / 0.09617 = -29.2% (CS-NT 29% larger in magnitude)

Spec A collapse -- Lesson 7 (4th documented instance, Chapter 4 sec:spec_a_hexagon): This is the 4th instance of direct-level-controls collapse in the CS-DID doubly-robust estimator, joining articles 79 (staggered), 335 (single-cohort), and 358 (2x2). The pattern: passing 15 individual-level demographic covariates directly to the doubly-robust CS-DID propensity model in a single-cohort 2x2 design causes the IPW propensity scores to degenerate (perfect separation or rank deficiency with only 3 treated state-years), collapsing the ATT to 0/NA. The template records this as cs_nt_with_ctrls_status=OK (no crash) with value 0. This is correct template behavior -- the collapse is noted, Spec B provides the valid unconditional comparison.

Verbal interpretation: The near-zero covariate margin on the TWFE side (-1.4%) confirms that the 15 demographic controls do very little to the TWFE point estimate -- OLS is robust to their inclusion/exclusion in this stable-state sample. The TWFE/CS-NT gap (29%) is entirely attributable to the estimator choice (conditional vs. unconditional parallel trends assumption), not to the controls themselves. This is a clean Pattern 25 result: in repeated cross-sections, CS-DID without covariate adjustment attributes more of the cross-sectional demographic composition difference to the treatment, while TWFE absorbs it through the covariate vector.

This decomposition feeds Deliverable D1 of the QJE review (Sant'Anna, 2026-04-17).

## Material findings (sorted by severity)

Design finding (Axis 3) -- Pre-trend at t=-5 (statistically significant): Both event studies show a statistically significant negative coefficient at t=-5 (TWFE: -0.027, p~0.002; CS-NT: -0.047, p<0.001). The paper's institutional explanation (NJ uncompensated care spiral excluded from the stable-state sample) is partially mitigating. HonestDiD Mbar>1 for all targets on both estimators -- the result survives plausible pre-trend violations. This is a finding about the paper's design credibility (Axis 3 = D-MODERATE), not an implementation failure.

Design finding (Axis 3) -- Few effective clusters (inference): 3 treated states (NY, ME, VT). The paper's bootstrap SEs (~2x analytic) are the appropriate inference tool. Our analytic SEs should not be compared directly to the paper's bootstrap SEs. Direction and magnitude of the effect are well-identified; inference is the limiting factor.

Structural note -- Spec A Lesson 7 collapse (4th instance): att_cs_nt_with_ctrls=0 is a structural collapse (doubly-robust propensity degeneracy with 15 direct-level controls in a single-cohort 2x2 setting), not a pipeline failure. Confirmed generalisation rule: direct-level controls + DR propensity model + singleton/near-singleton treated group in propensity space causes collapse.

## Recommended actions

- No action needed on metadata or implementation -- specification is correctly coded, achieves exact numerical replication, and the Spec A collapse is correctly handled.
- For the user: the prior LOW rating was driven by conflating the pre-trend design finding (Axis 3) with an implementation concern (Axis 2). The corrected rating is HIGH. The pre-trend at t=-5 remains a genuine design concern -- appropriate to flag in the dissertation as a known limitation acknowledged by the original paper, with HonestDiD providing quantitative bounds (result robust to Mbar=1, meaning violations up to the magnitude of the observed pre-trend do not overturn the conclusion).
- For the pattern-curator: article 47 is now the canonical 4th instance of Lesson 7 in the single-cohort 2x2 setting (alongside 79, 335, 358). The generalisation rule is confirmed: direct-level covariates + doubly-robust propensity + single-cohort 2x2 + small treated group causes Spec A collapse. Consider adding a cross-reference in failure_patterns.md linking all four instances under the sec:spec_a_hexagon umbrella.
- For the repo-custodian: update the skeptic_ratings.csv entry for id=47 to rating=HIGH, design_credibility=D-MODERATE, impl_axis=HIGH, fidelity=EXACT (see updated entry appended to analysis/skeptic_ratings.csv).

## Individual reports
- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md)
