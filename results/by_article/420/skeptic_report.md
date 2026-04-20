# Skeptic report: 420 --- Bailey, Goodman-Bacon (2015)

**Overall rating:** MODERATE
**Design credibility:** D-MODERATE
**Date:** 2026-04-19
**Fidelity score:** F-NA (paper-auditor NOT_APPLICABLE -- paper reports grouped event-year dummies only, no static ATT)
**Implementation score:** I-MOD (1 WARN: run_bacon metadata flag inconsistency)
**Reviewers run:** twfe (impl=WARN), csdid (impl=WARN -- Spec A collapse is Axis-3 design finding), bacon (impl=PASS, TvT share~84%), honestdid (impl=PASS, Mbar_first=0.50 Mbar_avg=0.25 Mbar_peak=0.25), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Bailey and Goodman-Bacon (2015) estimates the effect of Community Health Centers (CHCs) on age-adjusted mortality for adults 50+ using a staggered rollout across 3,062 U.S. counties (1959-1988). The stored TWFE estimate is -53.21 (SE 14.84), a time-averaged static post-indicator consistent with the paper period-group estimates of -41 (years 0-4) to -72 (years 5-9). The paper-auditor verdict is NOT_APPLICABLE because no single static ATT is reported in Table 2, so fidelity cannot be scored numerically. The implementation is technically correct with one metadata flag inconsistency (run_bacon=false despite bacon.csv existing). Design credibility is D-MODERATE: TWFE HonestDiD Mbar_first=0.50 and Mbar_avg/peak=0.25 provide moderate robustness to pre-trend violations but fall short of the D-ROBUST threshold (Mbar > 1 at both first-post and peak). Bacon TvT share is ~84%, confirming the TWFE estimate is overwhelmingly from clean treated-vs-never-treated comparisons. The critical design finding (Axis 3): CS-NT cannot serve as a clean robustness check for this paper because identification relies on Durb x year and state x year FEs that the CS propensity-score framework cannot absorb, producing estimates ranging from -6.78 (Spec A, with Durb_f controls) to -61.43 (unconditional). This is Pattern 51 and is a finding about the paper architecture, not a pipeline flaw. The stored TWFE of -53.21 is a credible estimate the user can trust.

---

## Per-reviewer verdicts

### TWFE (impl=WARN)

- Pre-trends clean across TWFE, SA, and Gardner: all pre-period coefficients indistinguishable from zero, no monotone drift.
- Specification fidelity confirmed: D_ baseline*trend controls, R_/H_ time-varying controls, Durb^year + stfips^year additional FEs, popwt_eld weighting, NYC/LA/Chicago sample drops all match Table 2 Panel B Col 2.
- WARN is metadata-only: run_bacon=false in metadata.json inconsistent with existing bacon.csv. The 1974 cohort positive TvU estimate (+40.5) is an Axis-3 design observation.
- Full report: reviews/twfe-reviewer.md

### CS-DID (impl=WARN)

- CS-NT without controls: -61.43 (SE 19.06), directionally consistent with TWFE -53.21.
- CS-NT Spec A with Durb_f controls: -6.78 (SE 27.69), near-zero and uninformative. Implementation is correct; collapse is Pattern 51 (Axis-3 design finding, not an implementation error).
- No-controls CS-NT shows mild positive drift at t=-4 (+28.93, ~2.2 SE), absorbed by TWFE parametric controls. Confirms unconditional parallel trends does not hold.
- Full report: reviews/csdid-reviewer.md

### Bacon (impl=PASS)

- TvT share ~84%: TWFE estimate overwhelmingly from clean treated-vs-never-treated comparisons. Inter-cohort contamination < 1% of total weight.
- 1974 cohort anomalous positive TvU estimate (+40.5, weight 11.5%) noted; not material given 8 other cohorts consistently negative.
- Metadata: run_bacon=false should be corrected to run_bacon=true.
- Full report: reviews/bacon-reviewer.md

### HonestDiD (impl=PASS)

- TWFE: Mbar_first=0.50 (CI at M=0.50: [-52.26, -0.61]), Mbar_avg=0.25 (CI: [-112.16, -10.65]), Mbar_peak=0.25 (CI: [-158.21, -8.10]).
- CS-NT: Mbar=0 at all targets. Average and peak robustly negative at M=0 (avg CI: [-94.73, -33.08]; peak CI: [-123.12, -48.55]). First-period CI barely includes zero at M=0 ([-52.13, +7.80]).
- D-MODERATE classification: Mbar_first=0.50 falls in [0.5,1]; D-ROBUST requires Mbar > 1 at both first-post and peak.
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)

- Standard absorbing binary staggered design. DID_M/DID_l add no analytical value beyond CS-NT and SA for this design.
- Full report: reviews/dechaisemartin-reviewer.md

---

## Three-way controls decomposition

| Spec | TWFE | CS-DID NT | Status |
|---|---|---|---|
| (A) both with controls (twfe_controls / Durb_f proxy) | -53.21 (14.84) | -6.78 (27.69) | FAIL_COLLAPSE -- CS-NT collapses (Pattern 51) |
| (B) both without controls | -53.25 (12.62) | -61.43 (19.06) | OK |
| (C) TWFE with controls, CS without (current headline) | -53.21 (14.84) | -61.43 (19.06) | OK (headline) |

Key ratios:
- Estimator margin, matched protocol (A): (-53.21 - (-6.78)) / |-53.21| = -87.3% -- CS collapse renders this ratio meaningless for estimator comparison.
- Estimator margin, unconditional (B): (-53.25 - (-61.43)) / |-53.25| = +15.4% -- valid comparison; TWFE magnitude 15% smaller than CS-NT, consistent with time-averaging over growing treatment effect.
- Covariate margin, TWFE side: (-53.21 - (-53.25)) / |-53.21| = ~0.1% -- covariates have negligible effect on TWFE.
- Total gap, current headline (C): (-53.21 - (-61.43)) / |-53.21| = +15.4%.

Verbal interpretation: Spec A is uninformative for this design class; the unconditional comparison (Spec B, 15.4% gap) is the only valid estimator-choice comparison. The gap reflects TWFE time-averaging, not negative-weighting bias (confirmed by 84% TvT Bacon share). For the dissertation, report Spec B as the valid protocol-matched comparison.

This decomposition feeds Deliverable D1 of the QJE review (Sant Anna, 2026-04-17).

---

## Three-axis rating detail

| Axis | Score | Basis |
|---|---|---|
| Axis 1 Fidelity | F-NA | Paper reports no static ATT; grouped event-year dummies only; original_result is empty |
| Axis 2 Implementation | I-MOD | 1 WARN: run_bacon=false metadata flag inconsistent with existing bacon.csv |
| Axis 3 Design credibility | D-MODERATE | TWFE Mbar_first=0.50 in [0.5,1]; TvT share=84% (clean); pre-trends flat; CS identification limitation is a design finding not an implementation error |

Final rating: F-NA x I-MOD -- use implementation alone -- **MODERATE**

---

## Material findings (sorted by severity)

- WARN (Implementation): run_bacon=false in metadata.json is inconsistent with bacon.csv in results. The Bacon decomposition was executed and is valid.
- WARN (Design -- Axis 3): CS-NT Spec A collapses to -6.78 (SE 27.69), effectively zero. Root cause: Durb x year and state x year FEs cannot be absorbed via xformla in CS framework. Pattern 51.
- WARN (Design -- Axis 3): HonestDiD Mbar_first=0.50, Mbar_avg/peak=0.25 -- moderate robustness, below the D-ROBUST threshold (Mbar > 1).
- WARN (Design -- Axis 3): 1974 cohort shows positive TvU estimate (+40.5, weight 11.5%). Anomalous but not material to overall estimate.
- PASS: Pre-trends clean across all estimators (TWFE, SA, Gardner).
- PASS: Bacon TvT share ~84%; inter-cohort contamination negligible; TWFE negative-weighting bias not a concern.

---

## Recommended actions

- Update run_bacon in data/metadata/420.json from false to true. Assign to repo-custodian.
- Extend Pattern 51 in knowledge/failure_patterns.md: papers with interaction-FE identification strategies (urbanization x year, state x year) will systematically produce uninformative Spec A CS-DID results; Spec B unconditional is the only valid protocol-matched comparison for this design class. Assign to pattern-curator.
- No action needed on the TWFE specification -- confirmed faithful to the paper.
- For the dissertation: report Spec B gap (15.4%) as the valid estimator comparison; flag Spec A as structurally uninformative for this design class.

---

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
