# Skeptic report: 309 -- Johnson, Schwab, Koval (2024)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (WARN), bacon (WARN), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Johnson, Schwab & Koval (2024) estimate the effect of legal protection against retaliatory firing on workplace safety (log accident rate) using staggered DiD across 21 adoption cohorts (1970-1993). The headline TWFE estimate is -0.137 (SE 0.046); our replication reproduces it to within 0.24%. Three methodological concerns are flagged: (1) CS-DID required a non-standard panel-balancing fix that drops 40% of cohorts; corrected CS-DID estimate is -0.201/-0.202, substantially larger than TWFE, consistent with negative-weight attenuation; (2) Bacon decomposition shows cohort 1989 has a sign-reversed TvU estimate (+0.316) contaminating TWFE via forbidden comparisons; (3) HonestDiD average ATT is robust only to Mbar=0.25 (D-MODERATE), breaking at Mbar=0.5. Direction is unanimous across all estimators. The CS-DID fix-script estimate (-0.201) is the more credible modern estimate. Rating: LOW (M-LOW x F-NA; three WARN verdicts from methodology reviewers).

---

## Per-reviewer verdicts

### TWFE (PASS)

- Stored TWFE = -0.13667 reproduces paper Table 2 Col 1 (-0.137) within 0.24% -- essentially exact.
- Pre-trends across 5 pre-periods are small and insignificant (largest |t| = 1.48 at t=-5); parallel trends supported.
- SA and Gardner/BJS corroborate negative direction; Gardner peak (-0.202) attenuated vs TWFE (-0.323), consistent with staggered-timing negative weights.

Full report: reviews/twfe-reviewer.md

### CS-DID (WARN)

- All CS-DID results in results.csv are NA: att_gt() in did v2.3.0 segfaults on the unbalanced panel (21 state-run OSHA states = 14 yrs vs 29 states = 27 yrs).
- Fix script balances panel to 29 full-coverage states, dropping 7 of 21 cohorts (1970,1974,1976,1977,1983,1984,1987 -- 40% reduction). CS-NT ATT = -0.201; CS-NYT ATT = -0.202.
- Representativeness uncertain; excluded cohorts are systematically early adopters.

Full report: reviews/csdid-reviewer.md

### Bacon (WARN)

- Cohort 1989 has sign-reversed TvU estimate (+0.316), opposite to all 9 other cohorts; contaminates EvL forbidden pairs.
- EvL pairs present with non-trivial weight; 1989 vs 1980 EvL = +0.811.
- Always-treated 1979 cohort used in LvA comparisons; TWFE attenuation partly explained by 1989 positive contribution.

Full report: reviews/bacon-reviewer.md

### HonestDiD (WARN)

- Average ATT robust to Mbar=0.25 (TWFE CI [-0.367,-0.037]; CS-NT CI [-0.379,-0.026]), breaks at Mbar=0.5; design D-MODERATE.
- CS-NT first-period and peak ATT break at Mbar=0.25 (D-FRAGILE on those targets).
- rm_avg_Mbar = 0.25 under both TWFE and CS-NT.

Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)

- Treatment binary absorbing after full adoption; fractional adoption-year is a transitional state handled correctly by gvar specification.
- DCDH estimator not required.

Full report: reviews/dechaisemartin-reviewer.md

### Paper-Auditor (NOT_APPLICABLE)

- No PDF at pdf/309.pdf; fidelity verification not possible.
- Metadata reference (-0.137) matches stored value within 0.24% -- suggestive of EXACT but unverifiable.

Full report: reviews/paper-auditor.md

---

## Rating computation

Methodology: twfe PASS, csdid WARN, bacon WARN, honestdid WARN, dechaisemartin NOT_NEEDED (excluded from count).
Count: 0 FAIL, 3 WARN -- 2+ WARN, no FAIL -- M-LOW.
Fidelity: paper-auditor NOT_APPLICABLE -- F-NA.
Combined: M-LOW x F-NA -- use methodology alone -- LOW.

---

## Material findings (sorted by severity)

1. CS-DID segfault and cohort truncation (WARN): Canonical CS-DID unavailable on full panel; fix-script covers 13/21 cohorts (62%), excluding all pre-1980 early adopters. All CS-DID columns in results.csv are NA.

2. Cohort 1989 sign reversal in Bacon (WARN): TvU estimate = +0.316 for cohort 1989, opposite to all other cohorts. Pulls TWFE toward zero via forbidden-comparison contamination.

3. D-MODERATE HonestDiD (WARN): Average ATT survives Mbar=0.25 but breaks at Mbar=0.5. Causal inference requires pre-trend violations to stay below 50% of observed pre-trend magnitude.

4. Always-treated 1979 cohort as LvA reference (WARN): Pre-treatment contamination risk in Bacon LvA comparisons.

---

## Recommended actions

1. Repo-custodian: Update results.csv to store fix-script CS-DID values (CS-NT=-0.201, CS-NYT=-0.202) with a cohort-restriction flag; current NA values cause silent data gaps in downstream analysis.

2. Repo-custodian: Add notes_csdid metadata field documenting the 40% cohort restriction, did v2.3.0 segfault, and resolution via fix_csdid_309.R.

3. Pattern-curator: Add pattern: CSDID segfault on severely unbalanced staggered panels in did v2.3.0; resolution: balance to longest-coverage units and document cohort exclusions.

4. User (judgement): Investigate 1989 cohort sign reversal. A robustness check excluding this cohort clarifies how much of the TWFE-vs-CS-DID gap is cohort-specific vs structural staggered-timing attenuation.

5. User (judgement): Use CS-DID fix-script value (-0.201) rather than stored TWFE (-0.137) as the preferred modern estimate for article 309; TWFE likely understates the effect by 30-47%.

---

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
