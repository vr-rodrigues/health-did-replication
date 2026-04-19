# Skeptic report: 262 -- Anderson, Charles, Rees (2020)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (WARN), honestdid (PASS), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Anderson, Charles, Rees (2020) studies the effect of hospital desegregation -- operationalized through Medicare certification requirements -- on Black postneonatal mortality in the Deep South, using a staggered DiD design across 7 adoption cohorts (1967-1973). The headline TWFE result is beta = 1.221 (SE = 0.888), which is not statistically significant (t = 1.38, p approx 0.17). The more credible CS-NT estimate is 0.995 (SE = 0.404, t = 2.46, significant at 5%), suggesting a real but modest effect on Black postneonatal mortality. Three methodological concerns collectively drive a LOW rating: (1) extreme cohort imbalance (1967 cohort = 85% of treated units) contaminates both TWFE and CS aggregation; (2) CS-NYT is severely underpowered (SE ~5x CS-NT) due to near-empty not-yet-treated pools for late cohorts; and (3) the Bacon decomposition reveals substantial treatment effect heterogeneity (TvU average ~9.15 vs timing-group average ~2.40), indicating the TWFE estimate is a contaminated blend rather than a clean ATT. HonestDiD provides partial reassurance: the CS-NT estimate is robust under parallel trends (Mbar=0) but breaks at Mbar approx 0.25. The stored CS-NT result (0.995, SE 0.404) can be cautiously trusted as the best available estimate, but the paper's conclusion rests on a TWFE specification that is non-significant and methodologically compromised by forbidden comparisons.

---

## Per-reviewer verdicts

### TWFE (WARN)

- Specification matches original Stata code exactly: county FE, year FE, three time-varying controls, birth-weighted, clustered by county, Black race subsample with balanced panel restriction.
- Headline TWFE result not significant at 5%: beta = 1.221, SE = 0.888, t = 1.38. Pre-trends are flat (all pre-period t-stats below 0.55) but measured imprecisely (SE approx 1.5-2.0).
- Staggered adoption with 85% of treated units adopting in 1967 creates forbidden comparison risk: TWFE uses the dominant 1967 cohort as implicit control for all later cohorts, potentially contaminating the estimate with heterogeneous treatment effects.

Full report: reviews/twfe-reviewer.md

### CS-DID (WARN)

- CS-NT delivers a significant estimate (0.995, SE 0.404, t = 2.46), in contrast to non-significant TWFE, suggesting the forbidden-comparison contamination in TWFE adds noise rather than bias.
- CS-NYT is non-significant (ATT = 1.270, SE = 2.222) due to near-empty not-yet-treated pools for the 1970-1973 cohorts (< 1% each), making the NYT estimator unreliable for this dataset.
- att_cs_nt_with_ctrls returns 0 with NA standard error -- anomalous, likely indicating a silent convergence failure in the controlled CS-NT specification.

Full report: reviews/csdid-reviewer.md

### Bacon (WARN)

- Timing-group comparisons dominate: 88.6% of TWFE weight comes from Earlier vs Later Treated (59.5%) and Later vs Earlier Treated (29.1%), with only 11.4% from Treated vs Untreated.
- Substantial treatment effect heterogeneity: TvU weighted average estimate = 9.15 vs timing-group weighted averages of 1.91 (Earlier vs Later) and 3.38 (Later vs Earlier). The cleanest comparison (against never-treated) yields much larger effects.
- Cohort 1969 shows negative estimates in some timing pairs (vs 1967: -1.33; vs 1968: -8.46), though these have small weights (< 0.5%).

Full report: reviews/bacon-reviewer.md

### HonestDiD (PASS)

- CS-NT estimate is robust at Mbar=0 (no pre-trend violations assumed): first-post lb = 0.32, ub = 3.97; avg lb = 0.30, ub = 1.99; peak lb = 1.03, ub = 4.39. All three targets exclude zero.
- TWFE estimate is not robust even at Mbar=0 (first-post lb = -0.80), but this reflects imprecision rather than pre-trend evidence -- the TWFE is simply underpowered.
- Robustness breaks down at Mbar approx 0.25 for CS-NT, meaning results are robust to pre-trend violations no larger than 25% of observed pre-period variation. Given flat observed pre-trends (max |t-stat| = 1.02), this is a plausible assumption.

Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)

- Standard absorbing binary staggered design. Treatment (Medicare certification) is permanent and binary. CDH estimator adds no diagnostic value beyond CS-DID for this design.

Full report: reviews/dechaisemartin-reviewer.md

---

## Material findings (sorted by severity)

WARN items:

1. [WARN -- TWFE] Forbidden comparison contamination. With 85% of treated units adopting in 1967, TWFE uses the dominant early adopter as implicit control for all later cohorts. This is a known source of heterogeneity bias in staggered TWFE, manifested as large SEs (0.888) relative to CS-NT (0.404).

2. [WARN -- CS-DID] CS-NYT severely underpowered. Not-yet-treated control group is near-empty for late cohorts (1970-1973 < 1% each), producing SE = 2.222 (5x the CS-NT SE). The NYT estimator should not be used as a robustness check in this setting.

3. [WARN -- CS-DID] att_cs_nt_with_ctrls anomaly. Returns 0/NA, indicating a likely silent failure in the controlled CS-NT specification. This specification should be re-run and the error investigated.

4. [WARN -- Bacon] Treatment effect heterogeneity by timing. TvU 2x2 DiDs average ~9.15 in postneonatal mortality reduction; timing-group 2x2 DiDs average ~2.5. This large gap signals that the population-level ATT differs substantially depending on which units serve as controls.

5. [WARN -- Bacon] run_bacon=false in metadata despite staggered design and existing bacon.csv. Should be reconciled.

6. [WARN -- TWFE] TWFE headline result is not statistically significant (p approx 0.17). If the paper claims TWFE significance, this is a key replication finding.

---

## Recommended actions

- For the repo-custodian agent: Populate original_result in data/metadata/262.json with the paper reported TWFE coefficient, SE, and exact table/column reference. This enables fidelity auditing in future runs.

- For the repo-custodian agent: Investigate the att_cs_nt_with_ctrls = 0, se = NA anomaly. Re-run the CS-NT with controls specification and check R template logs for convergence warnings. Update results.csv with corrected value.

- For the repo-custodian agent: Consider setting run_bacon: true in metadata (the decomposition data already exists). Reconcile the metadata note about Pattern 49.

- For the pattern-curator: Add a named pattern for extreme early-cohort dominance in staggered DiD (85%+ of treated units in earliest cohort), distinct from Pattern 49 (IW variance explosion). This pattern produces: (1) TWFE dominated by forbidden comparisons, (2) CS-NYT underpowered, (3) large gap between TvU and timing-group Bacon components.

- For the user (methodological judgement): The most defensible estimate for this paper is the CS-NT ATT (0.995 deaths per 1,000 births, SE 0.404, significant at 5%), not the headline TWFE. HonestDiD supports modest confidence under plausible parallel trends assumptions. Communicate to readers that TWFE is non-significant but robust CS-NT is significant -- this is an important finding of the reanalysis.

---

## Fidelity axis

paper-auditor: NOT_APPLICABLE -- PDF not found (pdf/262.pdf does not exist) and original_result in metadata is empty. Fidelity axis cannot be evaluated. Rating is based on methodology alone.

---

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
