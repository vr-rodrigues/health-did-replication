# Skeptic report: 25 -- Carrillo, Feres (2019)

**Overall rating:** HIGH  *(built from Fidelity x Implementation)*
**Design credibility:** D-MODERATE  *(separate axis -- a finding about the paper, not our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS, design-finding: t=-2 borderline pre-period; controls gap=16.1% Spec A), bacon (impl=N/A -- 18 time-varying controls preclude Bacon; indirect CS-NT convergence 1.3%), honestdid (impl=PASS, M_avg=1.0 D-MODERATE, M_peak=1.75 D-ROBUST), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE -- no PDF; internal cross-check: beta_twfe=0.115942 vs metadata target 0.116 = 0.05% = EXACT)

## Executive summary

Carrillo & Feres (2019) estimate the effect of a physician distribution policy (Programa Mais Medicos) on physician supply per capita across 5565 Brazilian municipalities using staggered TWFE with 18 time-varying controls structured as pre-treatment-characteristic x linear-time interactions, plus state-specific linear trends. The headline TWFE estimate is 0.116 physicians per 1000 population (SE 0.009). Our implementation reproduces this within 0.05% (beta=0.115942). All estimators confirm a positive, growing treatment effect; the event study is clean and monotonically increasing from ~zero at t=0 to 0.113 at t=4, consistent with gradual physician reallocation. This paper is the CLEAN reference case (Lesson 7 hexagon, sec:spec_a_hexagon) for matched-protocol CS-DID behavior: Spec A (matched controls, both sides) runs successfully (cs_nt_with_ctrls_status=OK) and reveals a genuine estimator-only gap of 16.1% -- substantially larger than the apparent 1.3% under the asymmetric Spec C. The 16.1% Spec A gap is the honest measure of estimator divergence once the protocol asymmetry is removed; the 1.3% Spec C figure was misleading because controls on the TWFE side and no controls on the CS-DID side happened to cancel. Implementation axis is fully clean (all reviewers PASS on implementation checks). The two reported concerns (borderline t=-2 pre-period and controls gap) are Axis-3 design findings, not implementation errors. Rating upgraded from MODERATE (2026-04-18) to HIGH under the corrected three-axis rubric. Users should trust the stored consolidated_results value.

## Per-reviewer verdicts
### TWFE (PASS)
- TWFE beta = 0.115942 matches paper target 0.116 within 0.05% -- essentially exact reproduction.
- 18 time-varying controls correctly entered as var x date interactions, matching Stata c.(var)#c.date; state-specific linear trends correctly modelled as UF[date] in feols.
- CS-NT convergence 1.3% (no controls) indicates minimal negative-weight contamination; controls-free TWFE = 0.128 provides additional anchor.

Full report: reviews/twfe-reviewer.md

### CS-DID (PASS on implementation; design findings on Axis 3)
- All CS-DID variants positive and highly significant (t > 13); direction unanimous across NT/NYT and with/without controls.
- t=-2 CS-NT pre-period borderline significant (coef = -0.00845, SE = 0.00395, t = -2.14, p~0.03) -- 3/4 pre-periods clean; this is a mild design finding, not an implementation error.
- Spec A (CS-NT with 18 controls, status=OK): ATT=0.0972; Spec B (CS-NT without controls): ATT=0.1144; Spec C (legacy asymmetric): ATT=0.1144 vs TWFE=0.1159 (1.3% apparent gap). The controls gap is a specification-artefact finding (Axis 3), not an implementation problem.

Full report: reviews/csdid-reviewer.md

### Bacon (NOT_APPLICABLE)
- 18 time-varying controls preclude Bacon decomposition; run_bacon=false in metadata is correct.
- Indirect assessment: CS-NT/NYT identical (0.1144) -- large never-treated pool; TWFE/CS gap 1.3% without controls confirms low forbidden-comparison risk.

Full report: reviews/bacon-reviewer.md

### HonestDiD (PASS; design signal D-MODERATE)
- Average ATT robust through Mbar=1.0 (breaks at 1.25): TWFE CI [+0.005, +0.093]; CS-NT CI [+0.001, +0.091] -- D-MODERATE.
- Peak ATT (t=4) robust through Mbar=1.75 (TWFE) / 1.5 (CS-NT) -- D-ROBUST.
- Contemporaneous effect (t=0) fragility expected given gradual policy diffusion mechanism; rm_first_Mbar=0 is not a disqualifying signal for this paper.

Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered design; CS-DID is the appropriate estimator; 1.3% convergence inconsistent with significant negative-weight contamination.

Full report: reviews/dechaisemartin-reviewer.md

## Three-way controls decomposition

Paper has twfe_controls with 18 variables, all entered as pre-treatment-characteristic x linear-time interactions (var_X_date). Spec A runs successfully (cs_nt_with_ctrls_status=OK).

| Spec | TWFE | CS-DID NT | Status |
|---|---|---|---|
| (A) both with controls -- matched protocol | 0.1159 (SE 0.00859) | 0.0972 (SE 0.00667) | OK |
| (B) both without controls -- clean unconditional | 0.1281 (SE 0.00871) | 0.1144 (SE 0.00730) | OK |
| (C) TWFE with, CS without -- legacy asymmetric (headline) | 0.1159 (SE 0.00859) | 0.1144 (SE 0.00730) | -- |

Key ratios:
- Estimator margin (protocol-matched, Spec A): (0.1159 - 0.0972) / |0.1159| = +16.1% -- genuine estimator-only divergence
- Covariate margin, TWFE side (C to B): (0.1159 - 0.1281) / |0.1159| = -10.5% (controls pull TWFE down)
- Covariate margin, CS side (A to B): (0.0972 - 0.1144) / |0.0972| = -17.7% (controls pull CS-DID down further)
- Total gap, headline Spec C: (0.1159 - 0.1144) / |0.1159| = +1.3% -- apparent concordance, MISLEADING

Verbal interpretation: The matched-protocol Spec A widens the gap from 1.3% (Spec C) to 16.1%, demonstrating that the near-zero Spec C gap is a fortuitous cancellation between the TWFE-covariate effect (-10.5%) and the CS-covariate effect (-17.7%), not genuine estimator agreement. The 16.1% Spec A gap is the honest estimator-only divergence and the load-bearing number for Chapter 4 (sec:spec_a_hexagon). Lesson 7 critique confirmed: asymmetric control structures mask estimator heterogeneity.

## Material findings (sorted by severity)

Design findings (Axis 3 -- about the paper; not demerits against our reanalysis):

- [Design / Controls asymmetry] Spec A matched-protocol gap = 16.1% (CS-NT=0.097 vs TWFE=0.116). The asymmetric Spec C gives a misleading 1.3% gap. This is Lesson 7 central illustration: protocol matching is necessary to measure genuine estimator divergence.
- [Design / Pre-trends] CS-NT pre-period t=-2: coef=-0.00845, t=-2.14 (p~0.03). Borderline; 3/4 remaining pre-periods clean. Magnitude small (~7.5% of peak effect). Not disqualifying.
- [Design / HonestDiD] Average ATT D-MODERATE (rm_avg_Mbar=1.0 -- breaks at 1.25). Peak ATT D-ROBUST (rm_peak_Mbar=1.75). Contemporaneous fragility expected by mechanism.

No implementation WARN or FAIL items.

## Recommended actions

- No action needed on the stored TWFE result or the implementation. The 0.116 estimate is exact, specification is correct, all methodology reviewers PASS on implementation.
- Rating upgraded from MODERATE (2026-04-18) to HIGH (2026-04-19). The prior report incorrectly counted the controls-gap WARN and t=-2 borderline pre-period as Axis-2 implementation concerns. Under the corrected three-axis rubric both are Axis-3 design findings. I-HIGH x F-HIGH = HIGH.
- Note for chapter writing (sec:spec_a_hexagon): Article 25 is the CLEAN HIGH-rated reference case for Spec A. Cite as: Spec A succeeds (status=OK) and reveals the genuine estimator gap as 16.1% -- six times larger than the apparent 1.3% under the asymmetric Spec C. The near-cancellation in Spec C (TWFE covariate margin -10.5% vs CS covariate margin -17.7%) is coincidental, not substantive.
- Update skeptic_ratings.csv row for article 25: rating=HIGH, design_credibility=D-MODERATE, fidelity=F-HIGH (EXACT internal cross-check), impl_axis=I-HIGH (0 impl WARNs), n_impl_warn=0, n_impl_fail=0.
- No pattern-library entry needed: this is a clean reference case, not a failure mode.

## Individual reports
- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
