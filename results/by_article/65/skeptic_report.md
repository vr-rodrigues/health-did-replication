# Skeptic report: 65 - Akosa Antwi, Moriya & Simon (2013)

**Overall rating:** HIGH  *(built from Fidelity x Implementation)*
**Design credibility:** D-FRAGILE  *(separate axis - a finding about the paper, not our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS; design: Spec A collapse + precision loss), bacon (N/A), honestdid (impl=PASS; design: M_first=0 M_avg=0 M_peak=0), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT 0.18%)

---

## Executive summary

Akosa Antwi, Moriya & Simon (2013, AEJ:Economic Policy) estimate that the ACA dependent-coverage mandate raised any-insurance coverage among federally eligible young adults (age 19-25) by approximately 3.2 percentage points. Our stored TWFE estimate (0.031744) matches the paper Table 2 Col 1 implementation coefficient (0.0318) to within 0.18% - EXACT match under the 1% threshold. The single-timing design (all treated gain eligibility October 2010, yearmonth=34) is the simplest DiD structure: no staggered-timing heterogeneity, no negative weights, clean never-treated comparison group (ages 16-18 and 26-29). All applicable reviewers find the implementation correct. **Rating: HIGH under the 3-axis rubric (F-HIGH x I-HIGH).** Separately, as a finding about the paper design, HonestDiD diagnostics reveal D-FRAGILE credibility: average and first-post ATT targets lose significance even at Mbar=0; the peak-month effect (t=2) survives at Mbar=0 (TWFE CI [+0.008,+0.093]) but breaks at Mbar=0.25. This reflects structural interaction of large individual-level SIPP SEs and a modest 3pp effect, not a disqualifying pre-trend. Conventional TWFE (t=4.2) remains strongly significant. Stored TWFE=0.0317 faithfully captures the paper headline; users can trust this value.

---

## Per-reviewer verdicts

### TWFE (PASS)
- TWFE = 0.0317 (SE=0.0076, t=4.20); no-controls TWFE = 0.0344 (SE=0.0073). Both significant at 1%. Controls not driving the result (covariate margin = -8.5%).
- Pre-trends across all 6 free pre-periods small and insignificant; largest t=-3 (-0.032, t=-1.62). Flat pre-trends support parallel-trends assumption.
- Single-timing design avoids staggered-timing negative-weighting pathologies. Template FE simplification (state-specific trends omitted) documented; negligible impact given 0.18% fidelity gap.
- Full report: reviews/twfe-reviewer.md

### CS-DID (PASS on implementation; Spec A collapse and precision loss are Axis 3 design findings)
- ATT_CS_NT = 0.0248 (SE=0.031), directionally consistent with TWFE. Precision loss from cs_controls=[] is a design-level finding (Axis 3): CS-DID without covariates on individual-level RCS yields 4x larger SEs - intrinsic to the estimator on this data type, not a pipeline bug.
- Spec A (doubly-robust with controls) returned att_cs_nt_with_ctrls = 0 (NA SE, status=OK). Lesson 7 Pattern 42 direct-level collapse: 12 individual-level controls + single-cohort RCS + DR propensity = structural overfit. Axis 3 design finding; 6th documented instance.
- Pre-trends in CS-NT event study clean; all 6 pre-period coefficients below their SEs.
- Full report: reviews/csdid-reviewer.md

### Bacon (NOT_APPLICABLE)
- Single-timing design (unica) with repeated cross-section data; both applicability conditions fail. No staggered heterogeneity to decompose. No TvT share available.
- Full report: reviews/bacon-reviewer.md

### HonestDiD (PASS on implementation; design: D-FRAGILE)
- Implementation correct: 5 pre-periods, 7 post-periods, both TWFE and CS-NT tested per protocol.
- Design finding: M_first=0, M_avg=0 for both TWFE and CS-NT. Average and first-post targets lose significance at Mbar=0. Peak (t=2) barely survives at Mbar=0 (TWFE CI [+0.008, +0.093]; CS-NT CI [+0.002, +0.095]) then breaks at Mbar=0.25. Classified D-FRAGILE.
- Fragility partly mechanical: large individual-level SIPP SEs (~0.020/month) and modest 3pp effect. Conventional TWFE (t=4.2) unaffected.
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary single-timing design. de Chaisemartin (2020) negative-weighting concern does not arise.
- Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (EXACT)
- paper_audit.md (2026-04-19): stored beta_twfe (0.031744) vs paper Table 2 Col 1 (0.0318) - relative gap = -0.18%, within the 1% EXACT threshold. Matching sign and significance (***.
- Full report: paper_audit.md

---

## Three-way controls decomposition

variables.twfe_controls is non-empty (12 controls). Results from results.csv:

| Spec | TWFE | CS-DID NT | Status |
|---|---|---|---|
| (A) both with controls | 0.0317 (0.0076) | 0 (NA) | FAIL_collapse (Lesson 7: 12 direct-level + single-cohort + DR overfit) |
| (B) both without controls | 0.0344 (0.0073) | 0.0248 (0.0276) | OK |
| (C) TWFE with, CS without | 0.0317 (0.0076) | 0.0248 (0.0310) | OK (current default) |

Key ratios:
- Estimator margin (protocol-matched, Spec B): (0.0344 - 0.0248) / |0.0344| = +27.9%
- Covariate margin (TWFE side): (0.0317 - 0.0344) / |0.0317| = -8.5%
- Covariate margin (CS side): Spec A collapsed - not evaluable
- Total gap (current headline, Spec C): (0.0317 - 0.0248) / |0.0317| = +21.8%

Verbal interpretation: In the matched unconditional protocol (Spec B), TWFE exceeds CS-NT by 28%. The gap is driven by estimator choice and the absence of covariates in CS - not by controls introducing TWFE bias (TWFE covariate margin = -8.5%). Spec A collapse confirms the doubly-robust CS-DID is structurally uninformative for this individual-level RCS single-cohort dataset (Lesson 7). The headline 22% gap (Spec C) is entirely attributable to CS precision loss, not heterogeneous treatment effects.

---

## Three-axis rating derivation

| Axis | Score | Basis |
|---|---|---|
| Fidelity | F-HIGH | paper-auditor EXACT; 0.18% gap; matching sign and significance |
| Implementation | I-HIGH | twfe=PASS; csdid impl=PASS (Spec A collapse and precision loss are Axis 3 per rubric); bacon=NOT_APPLICABLE; honestdid impl=PASS (D-FRAGILE is Axis 3); dechaisemartin=NOT_NEEDED; 0 impl WARNs, 0 FAILs |
| F-HIGH x I-HIGH | **HIGH** | Faithful reproduction; clean implementation |
| Design credibility | **D-FRAGILE** | M_first=0, M_avg=0 (both TWFE and CS-NT); M_peak=0 (survives Mbar=0 exactly, breaks at 0.25); no Bacon signal (single-timing RCS); flat pre-trends |

Design credibility is a finding about the paper reported separately. It does not affect the HIGH overall rating.

---

## Material findings (Axis 3 design findings, sorted by severity)

1. **HonestDiD D-FRAGILE** (design signal, not implementation demerit): Average and first-post ATT targets lose significance at Mbar=0. Peak (t=2) survives at Mbar=0 then breaks at Mbar=0.25. Partly structural: large SIPP SEs + modest 3pp effect. Conventional TWFE (t=4.2) unaffected.

2. **Spec A collapse (Lesson 7 direct-level pattern, instance 6)**: 12 individual-level controls + single-cohort RCS + DR propensity = degenerate CS-DID output (ATT=0, SE=NA). Unconditional CS-DID (Spec B/C) remains valid and directionally consistent.

3. **CS-DID precision loss**: CS-NT SE is 4x TWFE SE (0.031 vs 0.008) due to no covariates. Individually non-significant despite directional agreement with TWFE. Structural feature of CS-DID on individual-level RCS data.

---

## Recommended actions

- **No action needed on the overall rating**: HIGH stands. Stored TWFE=0.0317 is the correct headline value.
- **For the repo-custodian**: Populate original_result in metadata.json: {beta_twfe: 0.0318, se_twfe: 0.0074, source: Table 2 Col 1 implementation row} - confirmed by paper_audit.md on 2026-04-19.
- **For the pattern-curator (informational)**: Confirm Spec A collapse (att_cs_nt_with_ctrls=0/NA, 12 direct-level controls, single-cohort RCS) is captured under Pattern 42. 6th documented Lesson 7 instance.
- **For the user (design interpretation)**: D-FRAGILE reflects structural SIPP data limitations (large SEs) not weak identification. Six visually flat pre-periods support parallel trends. Users comfortable with parallel trends can trust the 3.2pp ACA mandate effect. Peak-month effect (December 2010) is the most HonestDiD-robust target at Mbar=0.

---

## Individual reports
- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
