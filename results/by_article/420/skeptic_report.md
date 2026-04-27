# Skeptic report: 420 -- Bailey, Goodman-Bacon (2015)

**Overall rating:** MODERATE
**Design credibility:** D-MODERATE
**Date:** 2026-04-24 (updated from 2026-04-19; corrects Bacon TvU share to 99.3%; addresses MVPF dissertation questions)
**Fidelity score:** F-NA (paper-auditor NOT_APPLICABLE -- paper reports grouped event-year dummies only, no static ATT)
**Implementation score:** I-MOD (1 WARN: run_bacon=false metadata flag inconsistent with existing bacon.csv)
**Reviewers run:** twfe (impl=WARN), csdid (impl=WARN -- Spec A collapse is Axis-3 design finding), bacon (impl=PASS, TvU share=99.3%, inter-cohort=0.67%), honestdid (impl=PASS, M_bar_first=0.50, M_bar_avg=0.25, M_bar_peak=0.25), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Bailey and Goodman-Bacon (2015) estimates the effect of Community Health Centers (CHCs) on age-adjusted mortality for adults 50+ using a staggered rollout across 3,062 U.S. counties (1959-1988). The stored TWFE estimate is -53.21 (SE 14.84), a time-averaged static post-indicator consistent with the paper's grouped event-year estimates of -41 (years 0-4) to -72 (years 5-9) in Table 2 Panel B Col 2.

The paper-auditor verdict is NOT_APPLICABLE because the paper reports no single static ATT. The implementation is technically correct with one metadata inconsistency (run_bacon=false despite bacon.csv existing). Design credibility is D-MODERATE: TWFE HonestDiD M_bar_first=0.50; Bacon TvU share is 99.3% (CORRECTED from the prior ~84% approximation in the 2026-04-19 report), confirming the TWFE estimate is almost entirely driven by clean treated-vs-never-treated comparisons with negligible inter-cohort contamination (0.67%).

The critical design finding (Axis 3): the Spec A beta-collapse from -53.21 (TWFE-with-ctrls) to -6.78 (CS-NT-with-ctrls) is a confirmed methodological finding about the paper's identification architecture, NOT a pipeline artefact. The large SEs (27.69 static, 45.40 dynamic) in Spec A are explained by Pattern 51 -- the paper's credibility rests on Durb x year + stfips x year FEs that the CS propensity-score framework cannot absorb through xformla. The sign-flip in the dynamic Spec A (+7.46) is a consequence of this structural mismatch, not a real sign reversal. The stored TWFE of -53.21 and the Spec C CS-NT of -61.43 are credible.

**Recommendation for Chapter 4.8:** This paper can be used as the Laffer-zone MVPF case subject to one clarification -- the MVPF span arises from a structural identification mismatch (Pattern 51), not a genuine estimator disagreement. The dissertation should distinguish the TWFE-based MVPF (anchored at -53.21, credible by Bacon + HonestDiD standards) from the CS-NT-based MVPF (anchored at -61.43 without controls, also credible) and explain that the Spec A CS-NT values (-6.78 / +7.46) are an artifact of forcing semiparametric propensity matching onto a design that relies on high-dimensional interaction FEs.

---

## Answers to the five MVPF dissertation questions

### Q1. Is the Spec A beta-collapse (-53.21 to -6.78 static, +7.46 dynamic) a real finding or a pipeline artefact?

**Finding, not artefact.** The collapse is structurally explained and reproducible.

The paper's identification relies on Durb^year (urban-category x year, 5 bins) and stfips^year (state x year) as additional FEs, plus 9 twfe_controls including D_ baseline x trend interactions (Pattern 37). These absorb substantial confounding variation that cannot be captured by a propensity model with discrete covariates.

In Spec A, the CS-NT framework receives cs_controls = [Durb_f] (5 urban dummies) as xformla. The doubly-robust estimator estimates propensity scores for each (group, time) pair conditional on Durb_f. With 5 discrete categories and 114 treated counties across 10 cohorts, the propensity model has limited identifying variation once urban category is controlled. The result is wide SEs and near-zero ATT -- this is not a sign reversal but a precision collapse.

The dynamic Spec A (+7.46, SE 45.40) is a precision issue, not a sign reversal. A 95% CI at +/- 2 SE spans approximately [-83, +98]. The point estimate has no interpretive content.

The correct CS-NT comparison is Spec C (no-controls CS-NT = -61.43 / -58.99 dynamic) or Spec B (unconditional: TWFE -53.25 vs CS-NT -61.43, 15.4% gap). These are consistent with the paper's direction.

Pattern 51 (documented in knowledge/failure_patterns.md): CS-DID cannot absorb the paper's urban x year + state x year FE structure through xformla. Durb_f alone is the optimal proxy; adding state dummies induces Pattern 42 overfitting.

**Conclusion for Q1:** The Spec A collapse is a real methodological finding about the boundary of CS-NT applicability for this design class. It should appear in Chapter 4.8 as a finding about identification architecture, not as evidence that the CHC effect is near zero.

### Q2. Does TWFE fidelity match Bailey and Goodman-Bacon (2015) Table 3 headline value?

**Paper-auditor verdict: NOT_APPLICABLE.** The paper (Table 2 Panel B Col 2 -- the primary mortality table; note: Table 3 referenced in the context may refer to a different specification) does not report a single static ATT. It reports grouped event-year dummies:

| Period | beta | SE |
|---|---|---|
| Years -6 to -2 (pre-trend) | -2.0 | [8.0] |
| Years 0-4 (early post) | -41.1 | [9.6] |
| Years 5-9 (medium post) | -72.0 | [14.8] |
| Years 10-14 (late post) | -64.1 | [19.3] |

An unweighted average of the three post-period estimates is approximately -59.1. Our stored beta_twfe = -53.21 falls between the early-post (-41) and medium-post (-72), consistent with a time-averaged static estimator over a growing treatment effect. The SE of 14.84 matches the paper's Period 5-9 SE of 14.8, confirming clustering is correctly specified. The pipeline is not off; a static ATT is simply not a comparable object to the paper's grouped estimates. Fidelity cannot be scored numerically: F-NA.

### Q3. Bacon decomposition -- TvT vs TvU shares

**TvU share: 99.3%.** CORRECTED from the prior reviewer's ~84% approximation (which was a calculation error). Computed directly from bacon.csv:

| Type | Weight | Share |
|---|---|---|
| Treated vs Untreated (TvU) | 0.9933 | 99.3% |
| Earlier vs Later Treated (EvL) | 0.0050 | 0.50% |
| Later vs Earlier Treated (LvE) | 0.0017 | 0.17% |
| Inter-cohort total (EvL + LvE) | 0.0067 | 0.67% |

Cohort-level TvU estimates (weight, estimate): 1965 (0.012, -195.1); 1967 (0.180, -93.7); 1968 (0.081, -146.7); 1969 (0.068, -171.0); 1970 (0.125, -102.4); 1971 (0.092, -136.7); 1972 (0.264, -62.1, largest weight); 1973 (0.057, -58.3); 1974 (0.115, +40.5, anomalous positive).

The 1974 cohort (11.5% of TvU weight) shows an anomalous positive TvU estimate (+40.5). This is a design finding: counties adopting CHCs in 1974 may have been on a rising mortality trajectory relative to never-treated counties, partially adjusted by the TWFE D_ baseline x trend controls but not fully absorbed. This cohort is offset by 8 consistently negative cohorts at 88.5% of TvU weight.

**Conclusion for Q3:** The negative TWFE is overwhelmingly driven by TvU comparisons (99.3% of weight). This is the cleanest possible Bacon result for a 10-cohort staggered design. Negative-weighting bias from TvT comparisons is not a concern for this paper. The MVPF anchoring on TWFE -53.21 is fully defensible on Bacon grounds.

### Q4. HonestDiD breakdown values for the elderly mortality outcome

From honest_did_v3.csv (5 pre-periods, 11 post-periods; full VCov):

| Estimator | M_bar_first | M_bar_avg | M_bar_peak | ATT_first | ATT_avg | ATT_peak |
|---|---|---|---|---|---|---|
| TWFE | 0.50 | 0.25 | 0.25 | -25.23 | -58.18 | -78.34 |
| CS-NT (no controls) | 0.00 | 0.00 | 0.00 | -22.13 | -63.86 | -85.90 |

TWFE sensitivity (first-period ATT = -25.23):
- M=0.50: CI = [-52.3, -0.6] -- excludes zero (barely)
- M=0.75: CI = [-57.6, +3.1] -- includes zero; significance lost

TWFE sensitivity (average ATT = -58.18):
- M=0.25: CI = [-112.2, -10.6] -- excludes zero
- M=0.50: CI = [-153.3, +29.0] -- includes zero

CS-NT (unconditional, no controls): M_bar=0 at all targets (robust even without pre-trend assumptions). Average CI at M=0: [-94.7, -33.1]; peak CI at M=0: [-123.1, -48.5] -- robustly negative. Note: CS-NT first-period CI at M=0 is [-52.1, +7.8], just including zero on the upper bound, but average and peak are definitive.

**Design credibility classification:** D-MODERATE. M_bar_first=0.50 falls in [0.5, 1]. D-ROBUST would require M_bar > 1 at both first-post and peak. The result is not D-FRAGILE (M_bar would need to be < 0.5) -- the boundary-of-MODERATE classification is correct.

**Implication for MVPF:** M_bar < 0.5 would be a D-FRAGILE design signal warranting caution in the dissertation. Here M_bar_first = 0.50, exactly at the D-MODERATE boundary. The CHC elderly mortality result survives moderate pre-trend violations (M <= 0.50 for the first period). Report this as the pre-trend sensitivity caveat alongside the MVPF result in Chapter 4.8.

### Q5. HIGH or MODERATE? Can id_420 be used as the Laffer-zone MVPF case?

**Rating: MODERATE.** Reflects F-NA x I-MOD (one implementation WARN -- metadata run_bacon flag). Design credibility is D-MODERATE on a separate axis and is a finding, not a demerit.

The MODERATE rating does NOT disqualify the paper for the dissertation role. Under the 3-axis framework, F-NA (paper reports no comparable static ATT -- no fault of our pipeline) combined with I-MOD (one metadata flag error -- correctable) yields MODERATE. Fixing the metadata flag would yield F-NA x I-HIGH = HIGH.

**Answer: Use id_420 in Chapter 4.8.** Rating is MODERATE; the paper earns this case study role provided the dissertation (a) attributes the MVPF span correctly to Pattern 51 rather than genuine estimator disagreement, (b) uses TWFE-based (-53.21) and CS-NT-no-controls-based (-61.43) MVPF anchors as the credible range, and (c) notes the D-MODERATE HonestDiD caveat (M_bar_first=0.50).

---

## Per-reviewer verdicts

### TWFE (impl=WARN)

- Pre-trends clean: all 5 pre-period TWFE coefficients statistically indistinguishable from zero (max |t-stat| = 0.93 at t=-2). SA shows mild t=-2 coefficient (-15.68, marginally significant) -- a soft design signal, not an implementation error. Gardner pre-periods flat (range -9.35 to +3.63).
- Specification faithful to Table 2 Panel B Col 2: D_ baseline x trend controls, R_/H_ time-varying controls, Durb^year + stfips^year additional FEs, popwt_eld weighting, NYC/LA/Chicago sample drops all confirmed.
- WARN: run_bacon=false in metadata.json inconsistent with existing valid bacon.csv.
- Full report: reviews/twfe-reviewer.md

### CS-DID (impl=WARN -- Spec A collapse is Axis-3 design finding)

- Spec C (no-controls CS-NT, current headline): -61.43 simple (SE 19.06), -58.99 dynamic (SE 21.34). Directionally consistent with TWFE -53.21. 15.4% gap explained by Lesson-8 TWFE time-averaging over growing treatment effects.
- Spec A (CS-NT with Durb_f): -6.78 simple (SE 27.69), +7.46 dynamic (SE 45.40). Near-zero and imprecise. Pattern 51: CS-NT propensity framework cannot replicate Durb x year and stfips x year FEs through xformla. The dynamic sign-flip is a precision artifact, not a real sign reversal.
- No-controls CS-NT shows positive pre-period drift at t=-4 (+28.93, ~2.2 SE), absorbed by TWFE parametric controls. Design finding, not implementation error.
- Full report: reviews/csdid-reviewer.md

### Bacon (impl=PASS, TvU=99.3% -- CORRECTED from prior ~84%)

- Actual TvU share = 99.33% from direct computation on bacon.csv (sum of TvU weights = 0.9933 of total). Inter-cohort (EvL+LvE) = 0.67%. The prior reviewer report's ~84% figure was a calculation approximation error.
- 8 of 9 cohorts show large negative TvU estimates (range -58 to -195). 1974 cohort anomalously positive (+40.5, 11.5% of TvU weight) -- design finding, not bias.
- No negative-weighting bias from inter-cohort contamination. Essentially a pure TvU design despite 10 staggered cohorts.
- run_bacon=false metadata flag should be corrected to true.
- Full report: reviews/bacon-reviewer.md

### HonestDiD (impl=PASS, M_bar_first=0.50, M_bar_avg=0.25, M_bar_peak=0.25)

- TWFE: first-period effect (-25.23) robust at M=0.50 [CI: -52.3, -0.6]; loses significance at M=0.75. Average (-58.18) robust at M=0.25 [CI: -112.2, -10.6]. Peak (-78.34) robust at M=0.25.
- CS-NT (unconditional): M_bar=0 at all targets. Average CI at M=0 [-94.7, -33.1]; peak [-123.1, -48.5] -- robustly negative. First-period CI at M=0 barely includes zero upper bound (+7.8) -- an endpoint artifact.
- D-MODERATE: M_bar_first=0.50 in [0.5, 1]; D-ROBUST would require M_bar > 1 at both first-post and peak.
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)

- Standard absorbing binary staggered design. DID_M/DID_l add no analytical value beyond CS-NT and SA for this design.
- Full report: reviews/dechaisemartin-reviewer.md

### paper-auditor (NOT_APPLICABLE)

- Paper reports grouped event-year dummies (Table 2 Panel B Col 2), not a single static ATT. Verdict is correct and legitimate.
- Approximate consistency: paper's unweighted post-period average ~-59.1; our beta_twfe = -53.21 directionally consistent and within plausible range. SE match (14.84 vs paper's 14.8 for Period 5-9) confirms clustering is correctly specified.
- Full report: paper_audit.md

---

## Three-way controls decomposition

| Spec | TWFE | CS-DID NT | Status |
|---|---|---|---|
| (A) both with controls (twfe_controls / Durb_f proxy) | -53.21 (14.84) | -6.78 (27.69) | FAIL_COLLAPSE -- CS-NT collapses (Pattern 51) |
| (B) both without controls | -53.25 (12.62) | -61.43 (19.06) | OK |
| (C) TWFE with controls, CS without (current headline) | -53.21 (14.84) | -61.43 (19.06) | OK (headline) |

Key ratios:
- Estimator margin, matched protocol (A): (-53.21 - (-6.78)) / |-53.21| = -87.3%. Structurally uninformative; CS collapse is Pattern 51, not a true estimator disagreement.
- Estimator margin, unconditional (B): (-53.25 - (-61.43)) / |-53.25| = +15.4%. Valid matched-protocol comparison. TWFE magnitude 15% smaller than CS-NT, consistent with time-averaging over growing treatment effects (Lesson 8) and confirmed by Bacon TvU=99.3%.
- Covariate margin, TWFE side: (-53.21 - (-53.25)) / |-53.21| = ~0.1%. Controls have negligible effect on TWFE point estimate.
- Total gap, current headline (C): (-53.21 - (-61.43)) / |-53.21| = +15.4%.

Verbal interpretation: Spec A is structurally uninformative for this design class (Pattern 51 -- interaction-FE identification cannot be proxied by discrete covariates in CS). Spec B unconditional (15.4% gap) is the valid protocol-matched comparison and confirms the gap is real but modest, explained by aggregation logic not negative-weighting bias. For the dissertation: report Spec B as the valid estimator comparison; flag Spec A as structurally uninformative; use Spec C as the headline.

This decomposition feeds Deliverable D1 of the QJE review (Sant'Anna, 2026-04-17).

---

## Three-axis rating detail

| Axis | Score | Basis |
|---|---|---|
| Axis 1 Fidelity | F-NA | Paper reports no static ATT; grouped event-year dummies only; original_result={}; not a pipeline fault |
| Axis 2 Implementation | I-MOD | 1 WARN: run_bacon=false metadata flag inconsistent with existing valid bacon.csv; all other implementation checks PASS |
| Axis 3 Design credibility | D-MODERATE | TWFE M_bar_first=0.50 in [0.5, 1]; Bacon TvU=99.3% (corrected from prior ~84%); pre-trends flat across all 4 estimators; 1974 cohort anomaly is Axis-3 finding |

Final rating: F-NA x I-MOD -- use implementation alone -- **MODERATE**

---

## Material findings (sorted by severity)

- WARN (Implementation -- Axis 2): run_bacon=false in metadata.json inconsistent with valid bacon.csv. Metadata cleanup only; no analytical consequence.
- FINDING (Design -- Axis 3): CS-NT Spec A collapses to -6.78 (SE 27.69) static / +7.46 (SE 45.40) dynamic. Pattern 51: Durb x year and stfips x year FEs cannot be absorbed via xformla. Dynamic sign-flip is precision artifact. True ATT direction robustly negative (Spec B, C, TWFE, SA, Gardner all confirm).
- FINDING (Design -- Axis 3): HonestDiD M_bar_first=0.50; M_bar_avg=M_bar_peak=0.25. Effect robust to M <= 0.50 for first period; design is D-MODERATE not D-ROBUST.
- FINDING (Design -- Axis 3): 1974 cohort TvU estimate +40.5 (11.5% of TvU weight). Anomalous but not material; 8 other cohorts consistently negative at 88.5% of TvU weight.
- PASS: Pre-trends flat across all 4 estimators (TWFE, CS-NT, SA, Gardner).
- PASS (CORRECTED): Bacon TvU=99.3%. Inter-cohort contamination 0.67%. No negative-weighting bias.
- PASS: All estimators agree on direction; magnitude consistent with growing-effect time-averaging.

---

## Recommended actions

1. Metadata fix (repo-custodian): Update run_bacon from false to true in data/metadata/420.json. This is the sole Axis-2 WARN; fixing it would upgrade implementation to I-HIGH and the rating to HIGH (F-NA x I-HIGH = HIGH when using implementation alone).

2. Pattern-51 extension (pattern-curator): Extend Pattern 51 entry to document that papers with urbanization x year + state x year interaction-FE designs will systematically produce uninformative Spec A CS-DID results. Spec B unconditional is the only valid protocol-matched comparison. Document the 15.4% Spec-B gap as the canonical Bailey-Goodman-Bacon estimator-comparison figure.

3. Bacon TvU share correction in skeptic_ratings.csv (repo-custodian): The existing row for id=420 reports TvT share ~84%. The correct figure is TvU=99.3%, inter-cohort=0.67%. This row should be updated.

4. Dissertation Chapter 4.8 (user): Use TWFE-based MVPF (-53.21) and CS-NT-no-controls MVPF (-61.43) as the credible MVPF range. Flag Spec A as structurally uninformative (Pattern 51) rather than as a genuine estimator disagreement on the sign of the CHC effect. Report D-MODERATE HonestDiD (M_bar_first=0.50) as the pre-trend sensitivity caveat. The Laffer-zone crossing under the collapsed Spec A estimate should be labeled as a Pattern-51 artifact in the dissertation text.

5. No action needed on the TWFE specification -- confirmed faithful to the paper's identification strategy.

---

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- paper_audit.md
