# Skeptic report: 44 - Bosch, Campos-Vazquez (2014)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (WARN), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Bosch and Campos-Vazquez (2014) study the effect of Mexico Seguro Popular health insurance program on the size distribution of employers, using a staggered rollout across 1,392 municipalities from 2002Q4-2010Q1. Their headline result (Figure 4 Panel D) is a negative effect on log employers with 6-50 workers. The stored TWFE static estimate is -0.00665 (SE=0.00395, t approx -1.68, not significant at 5%). Four methodological concerns are flagged: (1) the all-eventually-treated design means TWFE uses only contaminated timing comparisons with no clean never-treated control group; (2) 25 time-varying controls that may be post-treatment endogenous regressors (labor market composition variables that themselves respond to health insurance rollout); (3) substantial sign heterogeneity across Bacon cohort pairings with a pathological singleton gvar=200; and (4) HonestDiD sensitivity reveals D-FRAGILE results -- the negative effect loses significance at Mbar=0.5 across all three post-treatment targets. The CS-NYT uncontrolled estimate is positive (opposite TWFE), resolving to negative only when controls are added but with tripled standard errors. The fidelity axis is not evaluable (paper reports only distributed lag event study, no static ATT; no PDF available). The stored TWFE result should be treated with caution: all estimators agree on a small negative direction but none achieve conventional significance, and the identification rests on timing comparisons among eventually-treated units under assumptions that HonestDiD shows are fragile.

---

## Per-reviewer verdicts

### TWFE (WARN)

- Specification correctly matches the paper Stata xtreg with 25 time-varying controls and state cubic time trends.
- **WARN**: controls are time-varying labor market composition variables (industry shares, informality rates) plausibly endogenous to Seguro Popular -- may act as bad controls, partially absorbing the treatment effect.
- **WARN**: all-eventually-treated design -- TWFE uses only earlier vs. later treated comparisons; no clean never-treated control group.
- Full report: reviews/twfe-reviewer.md

### CS-DID (WARN)

- CS-NYT correctly run given no never-treated units; CS-NT disabled appropriately.
- **WARN**: uncontrolled CS-NYT gives a positive estimate (+0.00056) opposite to TWFE (-0.00665); with controls CS-NYT gives -0.012 but with standard errors tripling, suggesting thin comparison groups in later cohorts.
- **WARN**: no controls used in CS-NYT main (time-varying controls cannot enter CSDID), creating a specification mismatch with TWFE.
- CS-NYT pre-trends are clean (all pre-periods at or below 0.005 in magnitude).
- Full report: reviews/csdid-reviewer.md

### Bacon (WARN)

- **WARN**: zero Treated vs Never-Treated weight -- 100% of Bacon variance from timing comparisons among eventually-treated cohorts.
- **WARN**: gvar=200 singleton cohort (~1 municipality) produces extreme estimates of -0.8 log points; isolated by tiny weight but structurally pathological.
- **WARN**: substantial sign heterogeneity across pairings (estimates range -0.15 to +0.19 for non-trivial-weight pairs); TWFE aggregate (-0.007) is a tenuous weighted average over effects of both signs.
- Full report: reviews/bacon-reviewer.md

### HonestDiD (WARN)

- TWFE first, avg, and peak all significant at Mbar=0; CS-NYT first not significant even at Mbar=0.
- **WARN**: Design signal D-FRAGILE -- all TWFE targets and CS-NYT avg/peak lose significance at Mbar=0.5 (rm_first_Mbar=0.25, rm_avg_Mbar=0.25, rm_peak_Mbar=0.25).
- Mbar=0.5 represents only a 50% deviation from the maximum observed pre-trend -- a small tolerance for a program with large socioeconomic spillovers.
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)

- Treatment is absorbing-binary-staggered; CS-NYT subsumes this estimator purpose for this design.
- Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (NOT_APPLICABLE)

- No pdf/44.pdf present; original_result is empty (paper reports only distributed lag event study, no static ATT).
- Fidelity axis not evaluable.
- Full report: reviews/paper-auditor.md

---

## Rating derivation

| Axis | Score | Basis |
|---|---|---|
| Methodology | M-LOW | 4 WARNs, 0 FAILs across 4 applicable reviewers (>=2 WARN -> M-LOW) |
| Fidelity | F-NA | No PDF, no static ATT in paper |
| **Combined** | **LOW** | F-NA -> use methodology alone; M-LOW -> LOW |

**Design credibility signal: D-FRAGILE** (HonestDiD; rm_first_Mbar=0.25, rm_avg_Mbar=0.25, rm_peak_Mbar=0.25)

---

## Material findings (sorted by severity)

**WARN -- All-eventually-treated design (TWFE + Bacon):** No clean never-treated comparison group. TWFE identified entirely from timing variation. 100% of Bacon weight is Later vs Earlier Treated pairs. Under heterogeneous treatment effects, negative Bacon weights are structurally possible.

**WARN -- Potentially endogenous time-varying controls (TWFE):** 25 controls include labor market composition variables (informality rate, industry shares) that may be directly affected by Seguro Popular. Estimate changes 10-fold between controlled and uncontrolled TWFE (-0.00665 vs -0.000642).

**WARN -- HonestDiD fragility (D-FRAGILE):** TWFE effects lose significance at Mbar=0.5 (rm_*_Mbar=0.25). CS-NYT first not identified even at Mbar=0. Small pre-trend violations overturn the headline negative effect.

**WARN -- Sign reversal in uncontrolled CS-NYT:** Without controls, CS-NYT gives +0.00056 (positive, opposite TWFE). Sign resolves to negative with controls at the cost of tripled standard errors.

**WARN -- gvar=200 singleton cohort (Bacon):** Last adoption cohort has ~1 municipality, producing Bacon estimates of -0.80 log points -- implausible and 20+ SDs from the rest. Isolated by tiny weight but signals a degenerate tail cohort.

---

## Recommended actions

- **For repo-custodian:** Record run_bacon: true in metadata now that bacon.csv exists, so future re-runs do not repeat the manual step.
- **For repo-custodian:** Consider adding gvar_exclude: [200] to metadata to flag the singleton cohort in CS-NYT estimation and event study sensitivity checks.
- **For pattern-curator:** Add or update pattern on all-eventually-treated designs with no never-treated group: expected CS-NYT sign reversal when controls are omitted. Structurally related to Pattern 36 (singleton last cohort) but the sign-reversal phenomenon is distinct and warrants its own entry.
- **For user (methodological judgement):** The 25 time-varying TWFE controls should be reviewed for endogeneity to Seguro Popular. Consider a robustness check using only pre-treatment-measured covariates, or a 2-period collapsed specification with baseline covariates only.
- **For user (methodological judgement):** Given D-FRAGILE HonestDiD result, a narrative focused on direction (negative) rather than significance is more defensible given rm_*_Mbar=0.25.
- **For user:** SA (Sun-Abraham) estimator was disabled due to Pattern 36 (near-singular VCOV from singleton gvar=200 cohort). Gardner/BJS event study serves as partial substitute but a third major cross-validation estimator is unavailable.

---

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
