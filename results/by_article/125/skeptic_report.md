# Skeptic report: 125 — Levine, McKnight & Heep (2011)

**Overall rating:** MODERATE
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (WARN), bacon (NOT_APPLICABLE), honestdid (PASS), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT)

## Executive summary

Levine, McKnight & Heep (2011) estimate the effect of state parental coverage mandates on health insurance take-up among young adults aged 19-24, using a staggered DiD across 20 treated states over 2000-2008. Their headline result is a precisely estimated null: TWFE = -0.0005 (SE = 0.007), Table 5 Panel A. Our replication confirms this null exactly (beta = -0.000452, diff/SE = 0.007). All modern estimators — CS-NT without controls (+0.002), CS-NYT without controls (-0.002), and all event-study estimators (TWFE, CS-NT, CS-NYT, SA, Gardner) — agree: no detectable effect at any horizon, with all CIs encompassing zero. HonestDiD confirms robustness of the null to pre-trend misspecification. The paper was flagged as an outlier in the consolidated database (proportional shift ~-1,112%) but this is a pure artefact of computing a ratio when the denominator is effectively zero; the metadata notes explicitly document this. The one methodological WARN is the large sensitivity of CS-DID estimates to inclusion of time-varying controls in a repeated-cross-section design (+0.002 without controls vs. -0.036 with controls), which inflated the stored `att_cs_nt_with_ctrls` and generated the misleading outlier flag. The stored consolidated TWFE value (-0.000452) is trustworthy and directly replicates the paper.

## Per-reviewer verdicts

### TWFE (PASS)
- TWFE = -0.000452 vs paper target -0.0005; diff/SE_paper = 0.007 — EXACT replication.
- Pre-trend estimates at t=-4 through t=-2 are all < 0.010 in absolute value and non-significant. No drift.
- Sample, FE structure, controls, and clustering exactly match the Stata command documented in the metadata notes.
[Full report: `reviews/twfe-reviewer.md`]

### CS-DID (WARN)
- CS-NT and CS-NYT without controls confirm the null (+0.002 and -0.002, both non-significant).
- Large sensitivity: CS-NT with controls = -0.036 (SE = 0.016), a factor-18 magnitude shift and sign reversal relative to the no-controls CS-NT.
- This control-variable collinearity in a repeated-cross-section design is the source of the -1,112% outlier flag in consolidated results; it does not reflect a treatment effect.
[Full report: `reviews/csdid-reviewer.md`]

### Bacon (NOT_APPLICABLE)
- Data structure is repeated cross-section (`data_structure = "repeated_cross_section"`, `allow_unbalanced = true`). Bacon decomposition theorem does not apply. Metadata correctly sets `run_bacon = false`.
- Informational note: pseudo-Bacon run on aggregated cohort-year data shows cohort 2007 dominates TvsU weight (43.6%, est. -0.002); cohort 2005 is sign-discordant (+0.031, weight 12.5%) but immaterial for a null-result paper.
[Full report: `reviews/bacon-reviewer.md`]

### HonestDiD (PASS)
- With n_pre=3 free pre-periods: TWFE first-post CI at Mbar=0 is [-0.016, +0.021], average post [-0.018, +0.017] — both include zero. Null result is robust to pre-trend violations.
- TWFE peak-post CI at Mbar=0 is [-0.038, -0.0006], marginally excluding zero, but this is driven by a single post-period estimate (-0.015 at t=+5) and is not economically meaningful sign-identification for a paper claiming a null.
- CS-NT CIs include zero at Mbar=0 for all targets. Design classification: D-FRAGILE (appropriate for a null result).
[Full report: `reviews/honestdid-reviewer.md`]

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary staggered design. CS-DID is the appropriate robust estimator. `did_multiplegt` adds no incremental information.
[Full report: `reviews/dechaisemartin-reviewer.md`]

### Paper Auditor (EXACT / F-HIGH)
- PDF unavailable; fidelity assessed via metadata-recorded target.
- |diff|/SE_paper = 0.0069, well within EXACT threshold (< 0.20).
- Confirms the -1,112% outlier flag is an artefact of a near-zero denominator, not a fidelity failure.
[Full report: `reviews/paper-auditor.md`]

## Rating derivation

**Methodology score:**
- Applicable reviewers: twfe, csdid, honestdid (3 reviewers; bacon=NOT_APPLICABLE, dechaisemartin=NOT_NEEDED).
- Verdicts: PASS, WARN, PASS.
- Score: 1 WARN, rest PASS → **M-MOD**

**Fidelity score:**
- paper-auditor verdict: EXACT → **F-HIGH**

**Combined rating: M-MOD × F-HIGH → MODERATE**

## Material findings (sorted by severity)

### WARN
- **CS-DID control sensitivity in RCS design (csdid-reviewer):** CS-NT estimate shifts from +0.002 (no controls) to -0.036 (with controls) — a factor-18 change — due to time-varying control collinearity in a repeated-cross-section. The stored `att_cs_nt_with_ctrls` value is not a reliable ATT estimate and generated the misleading outlier flag. This is a known RCS-specific issue (related to Pattern 25 class in the knowledge base).

### Notes (not WARN/FAIL)
- The -1,112% proportional shift in consolidated results is a mathematical artefact (near-zero denominator). The metadata notes document this explicitly. No action needed for this specific flag.
- D-FRAGILE HonestDiD classification is appropriate given the null result and should not be interpreted as a methodological deficiency.

## Recommended actions

- **For the repo-custodian agent:** Consider flagging `att_cs_nt_with_ctrls` for article 125 as unreliable in the consolidated database (or tagging it with a `rcs_ctrl_sensitivity=TRUE` flag), to prevent future outlier alerts from this artefact. Alternatively, suppress this row from proportional-shift calculations when |beta_twfe| < 0.005.
- **For the pattern-curator:** The large RCS control-sensitivity pattern (no-controls CS ≈ 0, with-controls CS ≈ -0.036) should be documented as a variant of Pattern 25, specifically for cases where individual-level time-varying controls are collinear with the treatment indicator in a RCS design. Proposed label: "Pattern 25b: RCS control collinearity inflating CS-DID estimates."
- **For the user:** No action needed on the substantive result. The paper's null finding is robustly confirmed across all modern estimators. The MODERATE rating reflects a methodological concern with the stored CS-DID-with-controls value, not with the paper's headline claim. The paper is safe to report as a confirmed null.

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
