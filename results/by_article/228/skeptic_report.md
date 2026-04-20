# Skeptic report: 228 -- Sarmiento, Wagner and Zaklan (2023)

**Overall rating:** HIGH *(built from Fidelity x Implementation under 3-axis rubric)*
**Design credibility:** D-MODERATE *(separate axis -- finding about the paper, not our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS; granularity gap=Axis-3 design finding), csdid (impl=PASS), bacon (NOT_APPLICABLE; unbalanced panel; informational TvT <5%), honestdid (impl=PASS; M_avg_TWFE=0, M_peak_TWFE=0.25), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE; no PDF; no comparable paper beta)

---

## Executive summary

Sarmiento, Wagner and Zaklan (2023) study the effect of Low Emission Zones (LEZs) in German cities on PM10 concentrations using staggered DiD across 588 air-quality monitoring stations over 14 years (2005-2018) with 8 adoption cohorts (2008-2016). The paper primary estimator is CS-DiD (never-treated, doubly-robust). Our reanalysis on yearly aggregated data confirms: LEZs reduce PM10 by approximately 1.6-2.0 ug/m3 with effects growing through the post-period (h=0: -0.48 to h=5: -2.35). Implementation is clean on all applicable reviewers -- no pipeline bugs, no metadata misspecification, no Pattern-50 sample-mismatch. Fidelity axis is not evaluable (F-NA): the paper TWFE operates on daily data with weather controls, a different regression intentionally not stored in original_result. Under the 3-axis rubric F-NA x I-HIGH yields overall rating HIGH. NT/NYT convergence (0.3% gap) validates the never-treated control group (Lesson 6 positive case). Design credibility is D-MODERATE: average ATT sign-identified only at Mbar=0, but TWFE peak effect at h=5 (-2.350, CI=[-4.42,-0.21] at Mbar=0.25) supports the long-run claim. Rating upgraded from MODERATE (prior 2026-04-18 report) to HIGH after reclassifying the data-granularity gap as Axis-3 design finding, not Axis-2 implementation WARN.

---

## Per-reviewer verdicts

### TWFE (impl=PASS)

- Our TWFE (-1.240, SE=0.327) uses yearly data without weather controls; the paper TWFE uses daily data with weather controls. The granularity gap is a deliberate profiling choice for CS-DID comparability, documented in metadata. Axis-3 design finding, not an Axis-2 implementation error.
- Growing post-treatment effects (h=0: -0.48 to h=5: -2.35) create negative-weight contamination attenuating TWFE static estimate by 36-58% vs CS aggregates. Expected consequence of staggered adoption with growing effects; Axis-3.
- Pre-trends flat and statistically insignificant across all 5 pre-periods.

Full report: reviews/twfe-reviewer.md

### CS-DID (impl=PASS)

- CS-NT and CS-NYT estimates converge within 0.3% (NT dynamic: -1.954, NYT dynamic: -1.948) -- Lesson 6 positive case validating the never-treated control group.
- Specification correctly matches the paper: no covariates (xformla=~1), gvar=treat_cohort, cluster at mun_id.
- Marginally significant CS-NT h=-3 pre-period (-0.827, SE=0.386, |t|=2.14) is isolated; Axis-3 design signal.

Full report: reviews/csdid-reviewer.md

### Bacon (NOT_APPLICABLE)

- Skipped per protocol: allow_unbalanced=true in metadata.
- Informational from bacon.csv: Treated vs Untreated pairs carry >95% of total Bacon weight; LvE/EvL pairs collectively <5%. Heterogeneous TvU estimates (2008: -1.48; 2011: -2.42; 2013: +0.27; 2016: +0.70) explain TWFE attenuation; middle cohorts dilute early-cohort negative signal.
- No formal TvT share evaluable under unbalanced-panel caveat.

Full report: reviews/bacon-reviewer.md

### HonestDiD (impl=PASS)

- TWFE avg ATT (-1.206): sign-identified at Mbar=0 (CI=[-1.90,-0.50]); breaks at Mbar=0.25 (ub=+0.095). M_bar_avg_TWFE = 0.
- TWFE peak ATT (-2.350): sign-identified at Mbar=0 AND Mbar=0.25 (CI=[-4.42,-0.21]). M_bar_peak_TWFE = 0.25.
- CS-NT: all targets sign-identified at Mbar=0; all break at Mbar=0.25. M_bar_peak_CSNT = 0.
- Design credibility: D-MODERATE -- avg fragile beyond Mbar=0; TWFE peak robust at Mbar=0.25 supporting long-run claim; n_pre=4 adequate.

Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)

- Standard absorbing binary staggered design; LEZs are permanent. No dosage variation or reversal. DCDH adds no information beyond CS-DiD.

Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (NOT_APPLICABLE)

- No pdf/228.pdf; original_result field empty. Paper TWFE is on daily data with weather controls, intentionally not stored. Fidelity axis: F-NA.

Full report: reviews/paper-auditor.md

---

## Three-way controls decomposition

N/A -- paper has no original covariates (twfe_controls=[], cs_controls=[]). Unconditional comparison only. All Spec A/B/C rows carry status N/A_no_twfe_controls.

---

## Three-axis rating synthesis

| Axis | Score | Basis |
|---|---|---|
| Fidelity (Axis 1) | F-NA | No PDF; paper TWFE on daily+weather data; not comparable to stored yearly TWFE |
| Implementation (Axis 2) | I-HIGH | 0 impl WARNs; 0 FAILs; all applicable reviewers PASS or NOT_APPLICABLE/NOT_NEEDED |
| Design credibility (Axis 3) | D-MODERATE | TWFE avg M_bar=0 (fragile); TWFE peak M_bar=0.25 (robust long-run claim); pre-trends flat |
| **Final rating** | **HIGH** | F-NA x I-HIGH -> use implementation alone -> HIGH |

**Upgrade note vs prior report (2026-04-18):** Prior report scored TWFE impl=WARN -> I-MOD -> MODERATE. Under the strict 3-axis rubric the daily-vs-yearly granularity gap is a deliberate profiling decision documented in metadata, not a pipeline error. Reclassified Axis-3 -> impl=PASS -> I-HIGH -> **HIGH**.

---

## Material findings (sorted by severity)

All findings are Axis-3 (about the paper design, not our reanalysis):

1. [Axis-3 / D-MODERATE] HonestDiD avg ATT fragile at Mbar>0 (both TWFE and CS-NT). Long-run (h=5) TWFE peak sign-identified at Mbar=0.25 (CI=[-4.42,-0.21]) -- the more credible claim.
2. [Axis-3 / design] TWFE underestimates ATT by 36-58% vs CS aggregates due to growing staggered effects and cohort heterogeneity in TvU estimates. Expected TWFE property, not a bug.
3. [Axis-3 / design] CS-NT h=-3 pre-period marginally significant (-0.827, |t|=2.14) but isolated; does not propagate.
4. [Fidelity / F-NA] Stored beta_twfe not comparable to any published number. Primary causal estimates: CS-NT dynamic ATT (-1.954, SE=0.353) and CS-NYT dynamic ATT (-1.948, SE=0.337).

---

## Recommended actions

- No action on CS-DID implementation: correctly specified; NT/NYT convergence validates the design.
- No new patterns needed: granularity gap documented in metadata notes.
- User: rely on CS-NT/CS-NYT dynamic ATTs (-1.95 ug/m3) as primary causal estimates; TWFE static (-1.240) is a lower bound attenuated by both the granularity gap and heterogeneous cohort effects.
- User: the long-run (h=5) PM10 reduction claim is more credible under HonestDiD than the average-ATT claim; the latter requires perfect parallel trends.

---

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
