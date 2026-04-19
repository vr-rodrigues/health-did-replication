# Skeptic report: 228 -- Sarmiento, Wagner and Zaklan (2023)

**Overall rating:** MODERATE
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (PASS), bacon (N/A unbalanced panel), honestdid (PASS), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE no PDF)

---

## Executive summary

Sarmiento, Wagner and Zaklan (2023) study the effect of Low Emission Zones (LEZs) in German cities on PM10 concentrations using a staggered DiD design with 588 air quality monitoring stations across 14 years (2005-2018) and 8 adoption cohorts (2008-2016). The paper primary estimator is CS-DiD with never-treated controls. Our replication using yearly data confirms: LEZs reduce PM10 by approximately 1.2-2.0 ug/m3 with effects growing over time. The TWFE static estimate (-1.240) is 36-58% lower in magnitude than CS-DiD aggregates (-1.803 to -1.954), explained jointly by data granularity mismatch (daily vs. yearly) and negative-weight contamination from staggered adoption with growing effects. HonestDiD classifies this as D-MODERATE: avg ATT sign-identified at Mbar=0 but breaks at Mbar=0.25; TWFE peak effect (-2.350) holds sign-identification at Mbar=0.25. CS-NT/NYT convergence (0.3% gap) validates the never-treated control group choice (Lesson 6). Rating: MODERATE (M-MOD x F-NA).

---

## Per-reviewer verdicts

### TWFE (WARN)

- Our TWFE (-1.240, SE=0.327) uses yearly aggregated data without weather controls; the paper TWFE uses daily data with weather controls -- not directly comparable.
- Growing effects (h=0: -0.48 to h=5: -2.35) create negative-weight contamination attenuating TWFE by 36-58% vs. CS aggregates.
- Pre-trends flat and statistically insignificant across all 5 pre-periods.

(Full report: reviews/twfe-reviewer.md)

### CS-DID (PASS)

- CS-NT and CS-NYT estimates converge to within 0.3% (NT dynamic: -1.954, NYT dynamic: -1.948) -- strong NT vs. NYT robustness validation (Lesson 6 focal check).
- Specification correctly matches paper primary CS-DiD: no covariates, gvar=treat_cohort, cluster at mun_id.
- Marginally significant h=-3 pre-period in CS-NT (-0.827, SE=0.386) is isolated; does not propagate to adjacent periods.

(Full report: reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)

- Skipped per protocol: allow_unbalanced=true.
- Informational from bacon.csv: early cohorts (2008, 2009, 2012, 2011) drive large negative Treated vs. Untreated estimates; cohorts 2010 and 2013 near-zero or positive, explaining TWFE attenuation.

(Full report: reviews/bacon-reviewer.md)

### HonestDiD (PASS)

- TWFE avg ATT (-1.206): sign-identified at Mbar=0; breaks at Mbar=0.25 (ub=+0.095).
- TWFE peak ATT (-2.350): sign-identified at Mbar=0 AND Mbar=0.25 (CI=[-4.42, -0.21]) -- robust long-run claim.
- Design credibility: D-MODERATE. n_pre=4 adequate.

(Full report: reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)

- Standard absorbing binary staggered design; LEZs are permanent. No dosage variation or reversal. DCDH adds no information beyond CS-DiD.

(Full report: reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)

- No pdf/228.pdf; original_result field empty (daily vs. yearly mismatch makes fidelity comparison uninformative). F-NA.

(Full report: reviews/paper-auditor.md)

---

## Rating synthesis

| Axis | Score | Basis |
|---|---|---|
| Methodology | M-MOD | 1 WARN (twfe), 2 PASS (csdid, honestdid); bacon=N/A, dechaisemartin=NOT_NEEDED |
| Fidelity | F-NA | No PDF; no comparable paper beta |
| Combined | MODERATE | M-MOD x F-NA -> methodology alone -> MODERATE |

---

## Material findings (sorted by severity)

1. [TWFE-WARN] Data granularity mismatch: stored beta_twfe=-1.240 is not comparable to paper TWFE (daily+weather controls). Primary comparable output is the CS-DiD aggregates.

2. [TWFE-WARN] Negative-weight contamination: growing effects with staggered adoption attenuate TWFE by 36-58% vs. CS aggregates. Cohorts 2010/2013 contribute near-zero TVU estimates that dilute the weighted average.

3. [HonestDiD-informational] D-MODERATE design: avg ATT fragile at Mbar>0; TWFE peak (-2.35 at h=5) holds sign-identification at Mbar=0.25.

---

## Recommended actions

- No action on CS-DiD results: implementation correctly specified; NT/NYT convergence validates control group choice.
- Repo-custodian: add note_twfe_granularity field to metadata flagging stored beta_twfe uses yearly data without weather controls.
- No new pattern needed: NT/NYT convergence is the expected result for a well-specified LEZ design.
- User: rely on CS-NT/CS-NYT aggregates (-1.6 to -2.0 ug/m3) as primary causal estimates; TWFE (-1.240) is a lower bound attenuated by both specification and heterogeneity.

---

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
