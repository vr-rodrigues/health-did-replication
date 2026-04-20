# Skeptic report: 525 -- Danzer & Zyska (2023)

**Overall rating:** MODERATE  *(Fidelity x Implementation: F-HIGH x I-MOD)*
**Design credibility:** D-NA  *(no event study; parallel trends formally untestable)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS; design WARNs -> Axis 3), csdid (impl=WARN-1; gap -> Axis 3), bacon (NOT_APPLICABLE), honestdid (NOT_APPLICABLE), dechaisemartin (NOT_NEEDED), paper-auditor (WITHIN_TOLERANCE via metadata note; automated auditor NOT_APPLICABLE -- no PDF)

---

## Executive summary

Danzer & Zyska (2023) study the impact of Brazil 1991 pension reform on rural workers fertility using a 2x2 DiD on repeated cross-sections (PNAD). The headline TWFE estimate (Table 3 Col 2) is beta = -0.008; our stored estimate is -0.00776, a 3.0% gap explained by rounding (F-HIGH). The design is a clean single-cohort, single-date setup: bacon, HonestDiD, and de Chaisemartin add no diagnostic value. One Axis 2 implementation concern is logged: att_cs_nt_with_ctrls stores 0 with SE = NA and status OK, reflecting collinearity-by-design (TREAT = group dummy = CS cohort indicator) rather than a pipeline bug, but the misleading OK status warrants a minor fix. All other reviewer WARNs are Axis 3 design findings: the sign reversal in the no-controls TWFE spec is expected when the load-bearing group dummy is omitted; the 81% CS-DID vs TWFE gap is driven by the covariate protocol mismatch; the 26-cluster concern is a paper data-structure property. The stored result (beta_twfe = -0.00776) faithfully represents the paper and may be used with confidence.

---

## Per-reviewer verdicts

### TWFE (WARN -> Axis 3)

- Headline TWFE -0.00776 matches paper Table 3 Col 2 within 3%; implementation is correct.
- Sign reversal in no-controls spec (+0.035 vs -0.008) is Axis 3: TREAT is the load-bearing group dummy, not a robustness covariate; omitting it changes the estimand.
- 26 state clusters below Cameron-Miller threshold is an Axis 3 data-structure property of the paper.
- Full report: [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)

### CS-DID (WARN -> 1 impl WARN + Axis 3)

- CS-NT ATT = -0.0140 vs TWFE -0.00776 (81% gap): driven by absent TREAT covariate in CS model (Axis 3 covariate-protocol finding).
- att_cs_nt_with_ctrls = 0, SE = NA, status OK: 1 Axis 2 WARN (collinearity-by-design stored as OK without FAIL label).
- gvar construction, panel=FALSE (RCS), base_period=universal, never-treated identification all correct.
- Full report: [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)

- Single treatment date, RCS; Bacon decomposition undefined. Correctly disabled in metadata.
- Full report: [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)

### HonestDiD (NOT_APPLICABLE)

- No event study (has_event_study = false); pre-period dynamic estimates unavailable.
- Full report: [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)

- Absorbing binary single-cohort design; no staggered adoption, no dose heterogeneity.
- Full report: [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)

---

## Three-way controls decomposition

| Spec | TWFE | CS-DID NT | Status |
|---|---|---|---|
| (A) both with controls | -0.00776 (SE 0.00284) | 0 (SE NA) | FAIL_collinearity: TREAT = cohort indicator; CS propensity model degenerate |
| (B) both without controls | +0.0349 (SE 0.00307) | -0.0140 (SE 0.00764) | Estimands differ: TWFE without TREAT picks up baseline rural-urban fertility differential |
| (C) TWFE with, CS without | -0.00776 (SE 0.00284) | -0.0140 (SE 0.00764) | Headline (current default); 81% gap |

Key ratios:
- Estimator margin (Spec A, protocol-matched): not computable; CS collapses to 0.
- Covariate margin (TWFE side): (beta_C - beta_B) / |beta_C| = (-0.00776 - 0.0349) / 0.00776 = -5.5x; confirms TREAT is load-bearing.
- Total gap (headline Spec C): (-0.00776 - (-0.0140)) / 0.00776 = 81%.

Verbal interpretation: Spec A collapses because the single twfe_control (TREAT) is structurally collinear with the CS cohort grouping. This is collinearity-by-design, not classical Pattern 42 propensity overfit. The 81% Spec C gap is an Axis 3 covariate-protocol finding. The covariate margin of -5.5x confirms the estimand is undefined without the rural indicator.

---

## Axis 3 design findings (by severity)

1. **Spec A collapse (collinearity-by-design):** TREAT = rural indicator = gvar cohort. CS-DID propensity score undefined by construction. att_cs_nt_with_ctrls = 0, SE = NA. Not a replication error.
2. **81% estimator gap (Spec C):** CS-NT unconditional inflates ATT because it does not partial out the baseline rural-urban fertility differential that TREAT absorbs in TWFE. Both estimators are correct given their respective estimands.
3. **Sign reversal in Spec B:** Omitting TREAT reverses sign to +0.035. Confirms TREAT is a structural design component, not a robustness covariate.
4. **26 state clusters:** Below Cameron-Miller threshold; SEs may be slightly downward-biased. Paper acknowledges this.
5. **Parallel trends untestable (D-NA):** No event study; no pre-period dynamic estimates available.

---

## Material implementation findings (Axis 2)

1. WARN: att_cs_nt_with_ctrls stored as 0, SE = NA, status OK. Degenerate result stored without a FAIL label. Minor pipeline labelling issue; does not affect the headline estimate.

---

## Recommended actions

- No action on headline estimate: beta_twfe = -0.00776 is correct; use as-is in consolidated table.
- Metadata fix (minor): update cs_nt_with_ctrls_status from OK to FAIL_collinearity in results.csv to prevent future misreading of the degenerate Spec A result.
- Dissertation note: document the collinearity-by-design variant of Spec A collapse (distinct from classical Pattern 42) as a sub-case where TREAT = gvar cohort, making DR propensity estimation undefined regardless of sample size.

---

## Individual reports

- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md)