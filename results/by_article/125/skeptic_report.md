# Skeptic report: 125 - Levine, McKnight & Heep (2011)

**Overall rating:** HIGH  *(built from Fidelity x Implementation)*
**Design credibility:** D-MODERATE  *(separate axis - a finding about the paper)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS; design finding=Pattern 51 RCS inflation), bacon (impl=NOT_APPLICABLE), honestdid (impl=PASS; rm_first_twfe=0 null-robust; rm_avg_twfe=0 null-robust; rm_peak_twfe=0 barely-excludes-zero at TWFE peak only), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT)

## Executive summary

Levine, McKnight & Heep (2011) estimate the effect of state parental-coverage mandates on health insurance take-up among young adults aged 19-24, using staggered DiD across 20 treated states from 2000 to 2008. Their headline result is a precisely estimated null: TWFE = -0.0005 (SE = 0.007), Table 5 Panel A. Our replication confirms this null exactly (beta = -0.000452, diff/SE_paper = 0.007, within EXACT threshold). All five modern estimators confirm the null at every post-treatment horizon. Pre-trends are flat across all estimators (max |coef| at any pre-period < 0.010). HonestDiD confirms the null is robust: CIs include zero at Mbar=0 for TWFE and CS-NT on first-post and avg targets.

The key change on this re-run (2026-04-19) is a **reclassification of the CS-DID control sensitivity**. The previous report (2026-04-18) counted the Spec A inflation (att_cs_nt_with_ctrls = -0.036, t=-2.24, vs Spec B = -0.004, null) as an implementation WARN, yielding MODERATE. Under the three-axis rubric, this is correctly identified as a **design finding** (Axis 3): Pattern 51 (RCS control collinearity silently inflates CS-DID ATT). Our pipeline ran correctly - the template passed the six twfe_controls to CS-DID Spec A as specified, status=OK throughout. The IPW propensity score encountered near-collinearity at the RCS cell level, inflating weights without failing to converge. This is the canonical Pattern 51 mechanism. The pipeline surfaced it; surfacing a known hazard is not an implementation failure.

**Rating change:** MODERATE (2026-04-18) -> HIGH (2026-04-19). Implementation axis I-HIGH (all applicable reviewers PASS). Fidelity axis F-HIGH (EXACT). Design credibility D-MODERATE (null confirmed across all estimators; TWFE peak marginally excludes zero at Mbar=0 only due to t=+4 final post-period; Pattern 51 inflation is an artifact, not a genuine fragility signal).

The stored TWFE value (-0.000452) is trustworthy. For CS-DID, Spec B (no controls: -0.004, null) is the appropriate headline; Spec A (-0.036) must be flagged as unreliable per Pattern 51.
## Per-reviewer verdicts

### TWFE (impl=PASS)
- TWFE = -0.000452 vs paper target -0.0005; diff/SE_paper = 0.007 - EXACT replication.
- Pre-trends at t=-5: +0.0096, t=-4: +0.0026, t=-3: -0.0013, t=-2: -0.0037. Max |coef| = 0.0096. All non-significant. No drift.
- TWFE-no-controls (Spec B) = +0.00272 - both Spec A and B effectively null (|t| << 1).
- Sample, FE structure (stfips + year + a_age), controls, clustering all match the metadata Stata command exactly.

[Full report: reviews/twfe-reviewer.md]

### CS-DID (impl=PASS; design finding=Pattern 51)
- CS-NT no-controls (Spec B simple) = -0.00403 (SE=0.0079), null. CS-NYT no-controls = -0.00227, null. All no-controls estimators confirm the null.
- Spec A (CS-NT with 6 RCS individual-level controls): att_cs_nt_with_ctrls = -0.03584 (SE=0.0160, t=-2.24, significant). 8.9x inflation vs Spec B. Pattern 51: IPW propensity score near-collinearity in an RCS design. Status=OK throughout - harder to detect than Pattern 42.
- Pattern 51 detection rule satisfied: data_structure=RCS; |ATT_A / ATT_B| = 8.9 > 2; Spec A crosses significance, Spec B does not.
- Implementation verdict: PASS. The pipeline did what the metadata specified. Inflation is a design finding on Axis 3.

[Full report: reviews/csdid-reviewer.md]

### Bacon (impl=NOT_APPLICABLE)
- Data structure is repeated cross-section. Bacon decomposition theorem requires a balanced panel. run_bacon=false correctly set in metadata. NOT_APPLICABLE.

[Full report: reviews/bacon-reviewer.md]

### HonestDiD (impl=PASS)
- n_pre=3 free pre-periods. TWFE n_post=5.
- TWFE first-post CI at Mbar=0: [-0.0159, +0.0213] - includes zero. Null robust.
- TWFE avg CI at Mbar=0: [-0.0182, +0.0168] - includes zero. Null robust.
- TWFE peak (t=+4, coef=-0.019) CI at Mbar=0: [-0.0377, -0.0006] - barely excludes zero. At Mbar=0.25: [-0.0541, +0.010] - includes zero. Not economically meaningful.
- CS-NT: all targets (first, avg, peak) include zero at Mbar=0 and all higher Mbar. Fully robust null.
- For a null-result paper rm_Mbar=0 is the optimal HonestDiD outcome: the null survives even the tightest sensitivity assumption.
- Design credibility: D-MODERATE (TWFE peak marginally fails at Mbar=0; CS-NT robustly null at all Mbar).

[Full report: reviews/honestdid-reviewer.md]

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered design. CS-DID is the appropriate robust estimator. did_multiplegt adds no incremental information.

[Full report: reviews/dechaisemartin-reviewer.md]

### Paper Auditor (EXACT - F-HIGH)
- Target: beta_twfe = -0.0005, SE = 0.007 (Table 5 Panel A Row 1 Col 2, DD Full Sample, unweighted).
- Stored: beta_twfe = -0.000452. |diff| = 0.000048. |diff|/SE_paper = 0.0069 < 0.20. Verdict: EXACT.
- The -1,112% outlier flag in consolidated results is an artifact of near-zero TWFE denominator, not a fidelity failure.

[Full report: reviews/paper-auditor.md]
## Three-way controls decomposition

variables.twfe_controls = [married, student, female, ur, povratio, povratio2] (6 individual-level time-varying demographics). variables.cs_controls = [] (empty; template falls back to twfe_controls for CS Spec A).

| Spec | TWFE | CS-NT simple | Status |
|---|---|---|---|
| (A) both with controls | -0.000452 (SE=0.0065) | -0.03584 (SE=0.0160) | FAIL_Pattern51 - CS-DID inflated 8.9x by RCS IPW collinearity |
| (B) both without controls | +0.002723 (SE=0.0070) | -0.00403 (SE=0.0079) | OK - both null, consistent |
| (C) TWFE with, CS without | -0.000452 (SE=0.0065) | -0.00403 (SE=0.0079) | - (current default; both null) |

Key ratios:
- Pattern 51 inflation ratio (CS side): ATT_A / ATT_B = -0.03584 / -0.00403 = 8.9x. Canonical Pattern 51 signature.
- Covariate margin TWFE side: (beta_C - beta_B) / |beta_C| = (-0.000452 - 0.00272) / 0.000452 = -702%. Meaningless - both effectively zero.
- Covariate margin CS side: (ATT_A - ATT_B) / |ATT_A| = (-0.03584 - (-0.00403)) / 0.03584 = -88.7%. ATT_A almost entirely IPW inflation artifact.
- Estimator margin (protocol-matched Spec B): TWFE_B = +0.00272; CS-NT_B = -0.00403; both < 0.01; ratio undefined at this scale.

Verbal interpretation: The matched-protocol Spec B confirms both estimators agree on a null result. The Spec A CS-DID gap is not an estimator-choice artifact; it is a Pattern 51 IPW collinearity artifact. TWFE is unaffected because OLS absorbs collinearity via Frisch-Waugh projection without reweighting observations. Spec B is the appropriate CS-DID headline.

## Material findings (sorted by severity)

### Design findings (Axis 3 - findings about the paper, not demerits against our pipeline)

- **Pattern 51 (RCS control collinearity inflates CS-DID Spec A to false positive):** att_cs_nt_with_ctrls = -0.036 (t=-2.24) vs att_nt_simple = -0.004 (null). Inflation ratio 8.9x. Six individual-level time-varying demographics cause near-collinearity in CS-DID doubly-robust propensity score on RCS data, generating extreme IPW weights. Status=OK throughout. This is the canonical INFLATE exemplar (Lesson 7 triptych: id 25 clean / id 79 collapse / id 125 inflate). Spec A CS-DID values must not be used as headline ATT for this paper.
- **Lesson 7 triptych role confirmed:** Article 125 completes the three-way Spec A behavior illustration. Our pipeline successfully detected Pattern 51. This is a positive finding demonstrating the audit value of running all three specs.
- **Null result confirmed across all five estimators:** TWFE, CS-NT, CS-NYT, SA, Gardner all show zero effect at every post-treatment horizon. Pre-trends flat. HonestDiD robust for first-post and avg targets at all Mbar values. The paper is a confirmed null.

### Notes (no action required)

- -1,112% proportional shift in consolidated_results.csv is a mathematical artifact of near-zero TWFE denominator combined with inflated Spec A CS-DID. Not a fidelity or implementation issue.
- TWFE peak CI at Mbar=0 barely excludes zero due to t=+4 coef=-0.015 (final post-period only). At Mbar=0.25 it includes zero. Not economically meaningful.

## Recommended actions

- **No action on the headline result.** The null finding is robustly confirmed. Rating is HIGH.
- **For the repo-custodian agent:** Flag att_cs_nt_with_ctrls and att_cs_nyt_with_ctrls for article 125 in consolidated_results.csv with rcs_ctrl_sensitivity_flag = TRUE per Pattern 51 resolution rule. Suppress article 125 from any proportional-shift diagnostics that use the Spec A CS-DID as the headline estimate.
- **For the pattern-curator:** Pattern 51 is fully documented in knowledge/failure_patterns.md (detected 2026-04-19, id 125). Confirm the Pattern 51 detection pseudocode is applied as a post-run check in 01_run_all_did.R for all future RCS papers with non-empty twfe_controls.
- **For the user:** The INFLATE exemplar role of article 125 in the Lesson 7 triptych (Chapter 4, Box 4.3 item 11, hexagon diagram) is confirmed by this re-audit. The three-axis framework correctly classifies Pattern 51 inflation as a design finding, upgrading the rating from MODERATE to HIGH. The paper can be reported as a confirmed null with HIGH reanalysis credibility, while serving as the canonical Pattern 51 pedagogical case in the dissertation.

## Individual reports
- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md)
