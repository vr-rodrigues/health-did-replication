# Skeptic report: 133 -- Hoynes et al. (2015)

**Overall rating:** MODERATE
**Design credibility:** FRAGILE
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=WARN -- Spec A anomalous zero), bacon (SKIPPED -- single timing/RCS), honestdid (impl=PASS; M_avg=0.25 TWFE; M_peak=0.25 TWFE; CS-NT uninformative at all M), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE -- no PDF)

## Executive summary

Hoynes; Miller & Simon (2015) estimate the effect of the 1993 EITC expansion on low birthweight among low-income mothers; comparing high-parity mothers (treated) to low-parity mothers (control) over 1991-1998. Our TWFE estimate (-0.387 pp) and CS-NT ATT (-0.403 pp) are directionally consistent and statistically significant. The TWFE implementation is clean. One implementation concern exists: att_cs_nt_with_ctrls returns 0 with status OK (Spec A silent failure; Lesson 7 instance 9; racemiss collinearity in DR propensity). The CS-NT divergence from the paper ATT (-0.403 vs -0.180) and all HonestDiD sensitivity findings are Axis 3 design-credibility signals; not Axis 2 implementation errors. Under the 3-axis rubric: F-NA (no PDF) x I-MOD (1 Spec A anomaly) -> MODERATE. Design is D-FRAGILE: TWFE average effect robust only to M=0.25; significant positive pre-trends in CS-NT no-controls specification. Single-cohort structure avoids staggered-adoption contamination but cannot address parallel-trends concerns. The stored beta_twfe (-0.387) is a credible implementation of the TWFE specification.

## Per-reviewer verdicts

### TWFE (impl=PASS)
- Our estimate (-0.387 pp) is 9% larger in magnitude than the paper -0.355 pp -- same sign and significance. The 9% gap is a fidelity observation (Axis 1/F-NA); not an implementation error. Full TWFE spec (FEs; controls; clustering; weights) all PASS.
- Mild positive pre-trends at t=-3 (+0.094; ns) and t=-2 (+0.061; ns): a design finding (Axis 3); not an implementation WARN.
- Post-period effects grow monotonically (-0.132 to -0.564); consistent with a cumulating income effect.
- Full report: reviews/twfe-reviewer.md

### CS-DID (impl=WARN)
- CS-NT ATT (-0.403) is directionally consistent with TWFE and internally coherent for a single-cohort design (TWFE vs CS gap = 0.016 pp). The paper TWFE/CS gap (-0.355 vs -0.180) is internally inconsistent for a single-cohort structure -- a paper-side puzzle; not our pipeline failure.
- att_cs_nt_with_ctrls = 0 (status OK) is anomalous: Lesson 7 instance 9 (racemiss=0 for all parvar==1 control units -> DR propensity separation). This is the one genuine Axis 2 implementation concern.
- Significant positive pre-trends in CS-NT no-controls spec (t=-3: t-stat~2.49; t=-2: t-stat~2.14) are a design finding (Axis 3).
- Full report: reviews/csdid-reviewer.md

### Bacon (SKIPPED)
- treatment_timing=single; data_structure=repeated_cross_section. Applicability gate not met. Bacon.csv single row (weight=1.0; type=TvU) confirms clean 2x2 structure.
- Full report: reviews/bacon-reviewer.md

### HonestDiD (impl=PASS)
- TWFE average effect: CI [-0.502; -0.158] at M=0 (robustly negative); breaks down at M=0.25. TWFE peak: CI [-0.776; -0.354] at M=0; also breaks at M=0.25. First-period: includes zero even at M=0.
- CS-NT: all three targets include zero at M=0 (wide SEs ~0.088-0.131); HonestDiD uninformative for CS-NT -- a precision issue; not evidence of bias.
- All HonestDiD findings are Axis 3 design findings. HonestDiD execution itself: PASS.
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)
- Binary; absorbing; single-timing treatment. de Chaisemartin estimator not needed.
- Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (NOT_APPLICABLE)
- pdf/133.pdf not found. Fidelity axis cannot be evaluated from published tables. Metadata original_result field (beta_twfe=-0.3549; CS-NT=-0.1799) cannot be verified against the actual paper.
- Full report: reviews/paper-auditor.md

## Three-way controls decomposition

twfe_controls is non-empty (10 covariates: treat1; after; other; black; age2; age3; high; racemiss; hispanic; hispanicmiss). Decomposition applies.

| Spec | TWFE | CS-DID NT | Status |
|---|---|---|---|
| (A) both with controls | -0.387 (se=0.083) | 0 (se=NA) | FAIL_Lesson7 -- Spec A CS-NT collapses to 0 (racemiss=0 for all control units; DR propensity separation; 9th Lesson 7 instance) |
| (B) both without controls | -0.447 (se=0.103) | -0.403 (se=0.088) | OK |
| (C) TWFE with controls; CS without (headline) | -0.387 (se=0.083) | -0.403 (se=0.088) | OK -- current default |

Key ratios (Spec B -- only valid matched-protocol spec):
- Estimator margin (Spec B protocol-matched): (-0.447 - (-0.403)) / |-0.447| = -9.8% (CS-NT 9.8% smaller in magnitude than TWFE without controls)
- Covariate margin (TWFE side): (-0.387 - (-0.447)) / 0.387 = +15.5% (controls attenuate TWFE; removes 15.5% of the no-controls effect)
- Total gap (headline Spec C): (-0.387 - (-0.403)) / 0.387 = +4.1% (TWFE and CS-NT almost identical in Spec C)

Verbal interpretation: Spec B shows both estimators agree directionally with a 9.8% magnitude gap -- modest. The large divergence from the paper CS-NT (-0.180) is not reproduced by our pipeline; our single-cohort CS-NT (-0.403) is mechanically coherent with our TWFE (-0.387). Spec A collapses (Lesson 7 Pattern 42; racemiss collinearity). The matched-protocol estimate confirms the estimator gap is small.

This decomposition feeds Deliverable D1 of the QJE review (Sant Anna; 2026-04-17).

## Three-axis rating derivation

| Axis | Score | Basis |
|---|---|---|
| Fidelity (paper-auditor) | F-NA | PDF not available; fidelity not evaluable |
| Implementation (Axis 2) | I-MOD | 1 WARN: att_cs_nt_with_ctrls=0 anomaly (Spec A Lesson7 instance 9). TWFE impl PASS. HonestDiD impl PASS. Pre-trend/divergence WARNs reclassified as Axis 3 design findings. |
| Design credibility (Axis 3) | D-FRAGILE | TWFE avg M=0.25 (breaks); peak M=0.25; CS-NT positive significant pre-trends; first-period not robust at M=0 |

F-NA x I-MOD -> use implementation alone -> MODERATE

Design credibility is a finding about the paper: parallel-trends evidence is fragile under HonestDiD and the CS-NT no-controls specification shows significant positive pre-trends. This does not downgrade our rating.

## Material findings (sorted by severity)

- [Axis 2 -- WARN: Spec A collapse] att_cs_nt_with_ctrls = 0 (status OK) is a silent failure of the doubly-robust CS-NT with controls. Lesson 7 instance 9: racemiss=0 for all parvar==1 control units causes DR propensity separation. Spec A not usable for this article.
- [Axis 3 -- Design finding: positive CS-NT pre-trends] CS-NT no-controls specification shows statistically significant positive pre-trends at t=-3 (t~2.49) and t=-2 (t~2.14). TWFE pre-trends milder (+0.094; +0.061; both ns).
- [Axis 3 -- Design finding: HonestDiD fragility] TWFE average and peak effects robust only to M=0.25. First-period effect not robust even at M=0. CS-NT HonestDiD uninformative (precision issue; not bias).
- [Axis 3 -- Design finding: CS-NT divergence from paper] Paper reports CS-NT=-0.180; our CS-NT=-0.403. The paper TWFE/CS gap is internally inconsistent for a single-cohort design. Source of the paper -0.180 is unresolved.
- [Axis 1 -- Fidelity not evaluable] No PDF available. Profiled metadata (beta_twfe=-0.3549) suggests a 9% gap from our stored -0.387; documented in metadata as template drift (audit 2026-04-19).

## Recommended actions

- For repo-custodian: Investigate att_cs_nt_with_ctrls=0 anomaly -- add diagnostic logging to confirm Lesson 7 Pattern 42 (propensity separation from racemiss) and note Spec A as unavailable in metadata.
- For user (methodological judgement): Disclose HonestDiD M=0.25 breakdown for the average TWFE effect in the dissertation. The CS-NT pre-trends (significant at t=-3 and t=-2) reinforce the D-FRAGILE signal.
- For user: Disclose the CS-NT divergence (-0.403 vs paper -0.180) when reporting this article reanalysis. Our value is mechanically coherent for single-cohort.
- No new pattern needed: racemiss collinearity in Spec A is Lesson 7 / Pattern 42; already documented. 9% TWFE template drift is documented in metadata notes (audit 2026-04-19).

## Individual reports
- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
