# Skeptic report: 525 -- Danzer & Zyska (2023)

**Overall rating:** MODERATE
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (N/A), honestdid (N/A), dechaisemartin (NOT_NEEDED), paper-auditor (N/A)

---

## Executive summary

Danzer & Zyska (2023) study the effect of Brazil 1991 rural pension reform on fertility, using PNAD repeated cross-sections (1981-2014, with survey gaps) in a 2x2 DiD comparing rural workers (treated, TREAT=1) to urban workers (control). The headline result (Table 3 Col 2) is DID = -0.008 (SE 0.003). Our TWFE replication recovers -0.00776 (SE 0.00284), a 3% gap -- excellent fidelity. The negative direction is corroborated by CS-DID NT (-0.014, SE 0.008, t~1.84), though the magnitude is 81% larger than TWFE. The key methodological flags are: (1) the no-controls TWFE reverses sign to +0.035, showing the TREAT covariate is load-bearing; (2) the 81% CS-TWFE gap is unexpectedly large for a single-cohort design and stems from cs_controls=[] omitting TREAT; (3) att_cs_nt_with_ctrls=0/NA suggests a silent propensity-score failure in the with-controls path; (4) 26 state clusters is below the 30-40 conventional threshold. The design is clean: single treatment date (1992), absorbing binary treatment, no staggered adoption, no event study. The stored TWFE (-0.00776) is a credible replication of the paper and the direction of the fertility effect is robust.

---

## Per-reviewer verdicts

### TWFE (WARN)

- TWFE reproduces Table 3 Col 2 within 3% (beta = -0.00776 vs. paper -0.008). Specification correctly implements TREAT as control, state+year FEs, state-level clustering.
- The no-controls specification produces a sign reversal (beta = +0.035), indicating TREAT absorbs a large positive baseline fertility differential and is essential for identification.
- 26 state clusters is borderline for cluster-robust inference; SEs may be modestly underestimated.
- Full report: [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)

### CS-DID (WARN)

- CS-DID NT: ATT = -0.014 (SE 0.008), directionally consistent but 81% larger in absolute magnitude than TWFE.
- Most likely driver: cs_controls=[] means CS-DID is unconditional while TWFE conditions on TREAT -- different effective estimands.
- att_cs_nt_with_ctrls=0 / SE=NA despite status=OK: likely a silent propensity score failure (Pattern 42).
- Full report: [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)

- Single treatment date + RCS data: Bacon decomposition not applicable. Correctly skipped (run_bacon=false).
- Full report: [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)

### HonestDiD (NOT_APPLICABLE)

- has_event_study=false. No pre-period dynamic estimates available for HonestDiD input. Correctly skipped.
- Full report: [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)

- Clean 2x2 design: single cohort (1992), absorbing binary treatment, no dose heterogeneity. TWFE is uncontaminated. No forbidden comparisons.
- Full report: [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)

- pdf/525.pdf not present; automated fidelity auditor cannot run.
- Manual check from metadata notes: our beta (-0.00776) vs. paper (-0.008) = 3%; SE 0.00284 vs. 0.003 = 5%. Would score WITHIN_TOLERANCE if PDF were available.
- Full report: [reviews/paper-auditor.md](reviews/paper-auditor.md)

---

## Rating derivation

**Methodology score:**
- Applicable: twfe (WARN), csdid (WARN)
- Excluded (N/A or NOT_NEEDED): bacon, honestdid, dechaisemartin
- 2 WARNs, 0 FAILs -> M-LOW

**Fidelity score:** paper-auditor NOT_APPLICABLE -> F-NA

**Combined:** M-LOW x F-NA = use methodology alone.
Applied judgment: with only 2 applicable reviewers, 0 FAILs, well-understood concerns, and robust directional inference -> **MODERATE**.

---

## Material findings (sorted by severity)

- **WARN -- CS-TWFE magnitude gap (81%)**: CS-DID NT ATT (-0.014) vs TWFE (-0.008). Unexpectedly large for a single-cohort design. Root cause: mismatched covariate sets (cs_controls=[] vs twfe_controls=[TREAT]).
- **WARN -- att_cs_nt_with_ctrls=0, SE=NA**: Silent failure in with-controls CS-DID path despite status=OK. Likely Pattern 42 propensity score overfitting with 26 clusters.
- **WARN -- TWFE no-controls sign reversal**: beta_twfe_no_ctrls=+0.035 vs beta_twfe=-0.008. TREAT is load-bearing; without it the DiD coefficient picks up the baseline rural-urban fertility differential.
- **WARN -- 26 state clusters**: Below 30-40 threshold. Cluster-robust SEs may be downward-biased; significance may be overstated.

---

## Recommended actions

- **For repo-custodian**: Investigate att_cs_nt_with_ctrls=0/NA. Re-run CS-DID with controls; check for Pattern 42 propensity score overfitting. Apply graduated overlap protocol from Pattern 42. Update cs_nt_with_ctrls_status with actual failure mode.
- **For repo-custodian**: Resolve CS-TWFE gap. Add cs_controls: ["TREAT"] to metadata to align both estimators on the TREAT-conditioned estimand. Re-run and verify convergence toward TWFE.
- **For user (methodological judgement)**: Consider wild cluster bootstrap (WCB) SEs given 26 clusters. Conventional cluster-robust SEs may understate uncertainty; WCB p-values would be more reliable.
- **No action needed on direction**: Negative fertility effect confirmed by both TWFE and CS-DID NT. The paper headline conclusion is not contradicted.

---

## Individual reports

- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md)