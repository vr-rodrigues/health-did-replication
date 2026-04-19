# Skeptic report: 234 - Myers (2017)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (WARN), honestdid (PASS), dechaisemartin (WARN), paper-auditor (WARN)

## Executive summary

Myers (2017, JPE) examines whether state-level pill consent laws reduced teenage first births.
The pill consent exposure (epillconsent18) is a continuous fractional variable (proportion of ages 14-17
with consent access, taking values 0/0.25/0.50/0.75/1.00). The paper headline is an insignificant TWFE
coefficient (-0.0084, multivariate); our univariate replication confirms the null: beta_twfe=-0.0033,
CSDID-NT=+0.0027, CSDID-NYT=+0.0037. All four estimators agree on a null at every event-study horizon.
HonestDiD confirms the null is robust to any level of pre-trend violation (breakdown Mbar=0 for all targets).
The overall credibility rating is LOW because the continuous treatment design means TWFE, CS-DID, and
Bacon decomposition are applied outside their binary-treatment derivation assumptions, introducing estimand
imprecision. The TWFE sign is opposite to CS-DID (explained by Bacon: cohort 1957 dominates at 43% weight
with a negative estimate). Our univariate spec diverges in magnitude from the original multivariate spec.
The stored result (-0.0033) is a valid null under the univariate spec but should not be compared directly
to the paper result of -0.0084 without accounting for omitted state trends and 5 additional policy controls.

**Design credibility finding:** The continuous treatment (pill consent fraction) is a core design feature
of Myers (2017), not a replication flaw. Standard DiD estimators are not designed for continuous treatments;
a fuzzy DiD or dose-response DiD (de Chaisemartin 2024) would be more appropriate. The null holds across
all estimators so the policy conclusion is unaffected, but identification rests on assumptions not validated
by the binary-treatment DiD toolkit applied here.

## Per-reviewer verdicts

### TWFE (WARN)
- Continuous treatment (epillconsent18) correctly implemented matching original paper, but TWFE estimates a dose-response slope, not a standard ATT.
- Pre-trend test passes: all pre-period coefficients small relative to SEs, no systematic drift.
- Sign reversal vs CSDID (TWFE: -0.0033, CSDID: +0.0027) explained by Bacon but warrants noting.
- Full report: reviews/twfe-reviewer.md

### CS-DID (WARN)
- Binary discretization of continuous treatment for gvar_CS is necessary but creates estimand mismatch: TWFE estimates dose-response slope, CS-DID estimates binary adoption ATT.
- Both NT and NYT comparison groups yield null results with clean pre-trends.
- Dynamic aggregation yields more negative point estimates than simple aggregation (CS-NT: -0.033 vs -0.013), though all null.
- Full report: reviews/csdid-reviewer.md

### Bacon (WARN)
- Clean comparison (Treated vs Untreated) dominates at 88% weight -- favorable structure.
- Cohort 1957 alone carries 43% of total weight with estimate -0.0265, driving TWFE negative and explaining sign divergence from CS-DID.
- Continuous treatment makes Bacon decomposition theoretically approximate (derived for binary treatment).
- Full report: reviews/bacon-reviewer.md

### HonestDiD (PASS)
- All CIs straddle zero at Mbar=0 under both TWFE and CS-NT, for all three targets (first, avg, peak).
- Breakdown Mbar=0 for all targets: the null is unconditional, no pre-trend violation needed to explain it.
- Pre-period coefficients show no systematic drift; sensitivity analysis is valid.
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (WARN)
- Continuous treatment (5 discrete dose levels) requires fuzzy DiD framework -- not implemented here.
- 2 non-absorbing states excluded from sample; introduces potential selection concern.
- TWFE slope interpretation as dose-response ATT is approximate without formal continuous DiD.
- Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (WARN -- F-MOD)
- Our beta_twfe=-0.0033 vs paper estimate -0.0084 (our estimate is 39% of paper estimate in absolute value).
- Gap fully explained by deliberately omitted controls: paper uses 6 policy exposures + state-specific linear trends; our spec is univariate.
- Sign and significance (null) both match. No PDF available to verify exact table target.
- Full report: reviews/paper-auditor.md

## Rating computation

Methodology: twfe=WARN, csdid=WARN, bacon=WARN, honestdid=PASS, dechaisemartin=WARN
4 WARNs, 0 FAILs => M-LOW (>=2 WARN, no FAIL)

Fidelity: paper-auditor=WARN => F-MOD

Combined: M-LOW x F-MOD => **LOW**

## Material findings (sorted by severity)

1. [TWFE/dechaisemartin] Continuous treatment (5-level fractional dose) used with binary-treatment estimators; estimand imprecise without formal fuzzy/continuous DiD.
2. [Bacon] Cohort 1957 dominates at 43% weight with estimate -0.0265, driving TWFE negative while CS-DID is positive; high cohort sensitivity.
3. [CSDID] Estimand mismatch: TWFE estimates dose-response slope, CS-DID estimates binary adoption ATT.
4. [CSDID] Dynamic vs simple aggregation inconsistency under CS-NT (-0.033 vs -0.013), suggesting late-treated heterogeneity.
5. [dechaisemartin] 2 non-absorbing states (IDs 28, 30) excluded; potential selection concern.
6. [paper-auditor] Magnitude gap: our estimate is 39% of paper multivariate estimate; no PDF to verify exact comparison target.

## Recommended actions

- Repo-custodian: Populate original_result in metadata with paper univariate baseline (if available), or document that comparison is multivariate-vs-univariate.
- Analyst: Consider running did_multiplegt_dyn (de Chaisemartin 2024) with continuous treatment for a formally valid continuous DiD estimate.
- Pattern-curator: Add Pattern -- Continuous dose treatment applied to binary-treatment DiD estimators leads to estimand mismatch (TWFE slope vs CS-DID binary ATT) and approximate Bacon decomposition. Flag for fractional/dose treatment variables.
- User: The null result is robust and credible. LOW rating reflects methodological complexity in the estimators, not concern about the true effect. Policy conclusion (pill consent laws did not significantly reduce teenage births) is supported across all estimators and robust to pre-trend violations.

## Individual reports
- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
