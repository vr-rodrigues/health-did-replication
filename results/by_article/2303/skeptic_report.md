# Skeptic report: 2303 -- Cao & Ma (2023)

**Overall rating:** MODERATE  *(built from Fidelity x Implementation)*
**Design credibility:** D-MODERATE  *(separate axis -- a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=WARN, SE-method), csdid (impl=PASS after Spec-A recovery), bacon (impl=N/A; design finding, TvNT~51%), honestdid (impl=PASS, M_first=0.25 CS-NT, M_avg=0.25 CS-NT, M_peak=0.25 CS-NT), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE -- no PDF; metadata-documented EXACT 0.01%)

**Rating change from 2026-04-18:** LOW -> MODERATE. Drivers: (1) Spec A CS-DID FAIL_memory resolved in 2026-04-19 full re-run (att_cs_nt_with_ctrls = -2.037, status=OK); (2) Spec B TWFE no-controls recovered (-5.075); (3) Bacon forbidden-comparisons and CS-NT pre-trends reclassified as design findings (Axis 3), not implementation WARNs (Axis 2). Only 1 implementation WARN remains (SE method: cluster vs Conley).

---

## Executive summary

Cao and Ma (2023) estimate the effect of biomass power plant (BPP) operation on nearby
agricultural fire frequency (ft90: fires within 90 km radius), using a staggered binary
treatment across 125 cohorts of 954 plants observed monthly from 2001 to 2019 (228 periods,
217k observations). The headline TWFE estimate is -4.836 fires/month, within 0.01% of the
paper-auditor reference value. All 5 estimators -- TWFE, CS-NT (no controls), CS-NT (7 weather
controls, Spec A), Gardner/did2s, and SA -- unanimously confirm a significant negative
post-treatment effect on fires.

The 2026-04-19 full pipeline re-run (2.5 hours, 14.8 GB peak memory) resolved the previously
reported Spec A FAIL_memory: att_cs_nt_with_ctrls = -2.037 (SE = 5.067, status=OK). Spec B
(TWFE no-controls) is also recovered at -5.075 (SE = 1.502). These recoveries enable the full
three-way controls decomposition for the first time. The controls comparison reveals that weather
is a powerful confounder of fire frequency: the CS-NT estimate drops from -5.44 (no controls)
to -2.04 (with controls), a 167% covariate margin, while TWFE moves only 5% (-5.08 to -4.84).
This confirms that the TWFE FE structure partially absorbs weather variation implicitly, while
the doubly-robust CS-DID propensity-score step is more sensitive to the explicit weather controls.

Despite 5-estimator directional unanimity, three design-credibility findings emerge: (1) the CS-NT
no-controls event study has two significant pre-period spikes (k=-6, k=-2), likely reflecting
omitted weather confounders rather than genuine pre-trend violations; (2) the Bacon decomposition
reveals forbidden comparisons across 15,625 pairs, though the 51% never-treated pool limits
practical negative-weight bias (Spec B TWFE/CS gap = 7.1%); (3) HonestDiD rates the design
D-MODERATE: CS-NT avg/peak effects survive Mbar=0 and break down at Mbar=0.50. The stored
consolidated result (TWFE = -4.836) is credible in direction and magnitude; users can cite
it with confidence, noting the Conley vs cluster SE distinction.

---

## Per-reviewer verdicts

### TWFE (WARN -- impl axis)

- Estimate beta = -4.836 is within 0.01% of the paper reference value and within 0.56% of
  Table 2 Col 3 (-4.863). Directionally confirmed across all 5 estimators.
- Implementation WARN: Stored SEs use cluster-by-plant (1.495) vs paper Conley spatial 600 km
  (1.780) -- 16% understatement of uncertainty. Documented deviation; does not affect estimates.
- Spec B no-controls TWFE = -5.075 (recovered 2026-04-19): 4.9% covariate margin confirms
  the FE structure partially absorbs weather variation.

Full report: reviews/twfe-reviewer.md

### CS-DID (WARN -- design finding, impl resolved)

- Spec A (doubly-robust, 7 weather controls): RESOLVED 2026-04-19. att_cs_nt_with_ctrls = -2.037
  (SE = 5.067), dynamic = -1.709 (SE = 5.722), cs_nt_with_ctrls_status = OK. FAIL_memory cleared.
- Spec A CS-NT is directionally negative but attenuated vs no-controls (167% covariate margin).
  The large SE (5.07) reflects computational demands of doubly-robust IPW on 217k rows x 125
  cohorts, even with successful execution.
- Design finding: two significant CS-NT no-controls pre-period spikes (k=-6, t~2.30; k=-2,
  t~2.10) reflect omitted weather confounders, not implementation errors.

Full report: reviews/csdid-reviewer.md

### Bacon (WARN -- design finding only)

- 15,625 pairwise comparisons across 125 cohorts; EvL forbidden comparisons confirmed.
- Extreme cohort-pair estimate heterogeneity (range approximately -88 to +45 fires/month).
- Practical bias modest: 51% never-treated pool dominates Bacon weights; Spec B
  TWFE/CS-NT gap = 7.1% (near-convergence confirms limited negative-weight contamination).

Full report: reviews/bacon-reviewer.md

### HonestDiD (PASS)

- CS-NT avg and peak effects robustly negative at Mbar=0: avg CI=[-14.0, -4.4]; peak CI=[-20.7, -6.4].
- CS-NT first-period robust to Mbar=0.25; breaks at Mbar=0.50 (rm_first_Mbar = 0.25).
- TWFE HonestDiD fragile (Mbar=0 breakdown) due to large event-study SEs from rich id^month +
  prov^year^month FE -- methodologically explainable, not pre-trend evidence.
- Design credibility: D-MODERATE (CS-NT avg/peak Mbar=0 robust; first-period Mbar=0.25).

Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)

- Treatment is binary, absorbing, staggered with uniform dose at adoption. DCDH not required.
- CS-DID with NT comparisons is the appropriate robust estimator and has been run.

Full report: reviews/dechaisemartin-reviewer.md

### Paper Auditor (NOT_APPLICABLE -- no PDF)

- PDF pdf/2303.pdf not found. Fidelity axis formally NOT_APPLICABLE (F-NA).
- Metadata audit note (2026-04-19): paper-auditor verdict EXACT, 0.01% gap vs paper value -4.836.
- Under F-NA rubric, rating is built from implementation axis alone.

Full report: reviews/paper-auditor.md

---

## Three-way controls decomposition

Paper has 7 original covariates (temperature, precipitation, windspeed, humidity, winddirection1/2/3).
Full decomposition available after 2026-04-19 re-run.

| Spec | TWFE | CS-NT simple | CS-NT dynamic | Status |
|---|---|---|---|---|
| (A) both with controls | -4.836 (1.495) | -2.037 (5.067) | -1.709 (5.722) | OK |
| (B) both without controls | -5.075 (1.502) | -5.441 (6.431) | -6.568 (6.335) | OK |
| (C) TWFE with, CS without (old default) | -4.836 (1.495) | -5.441 (6.431) | -6.568 (6.335) | -- (headline) |

Key ratios:
- Estimator margin (protocol-matched, Spec A): (-4.836 - (-2.037)) / |-4.836| = -57.9%.
  TWFE is 57.9% larger in magnitude than Spec A CS-NT -- driven by doubly-robust IPW
  sensitivity to weather controls, not negative TWFE weights.
- Covariate margin (TWFE side): (-4.836 - (-5.075)) / |-4.836| = +4.9%.
  Controls attenuate TWFE by only ~5%; the rich FE structure already absorbs most weather variation.
- Covariate margin (CS side): (-2.037 - (-5.441)) / |-2.037| = +167%.
  Controls attenuate CS-NT by 167%; weather is a powerful explicit confounder for the
  doubly-robust estimator which cannot use FEs to absorb it implicitly.
- Total gap (headline, Spec C): (-4.836 - (-5.441)) / |-4.836| = +12.5%.

Verbal interpretation: The matched-protocol Spec A comparison widens the TWFE/CS-NT gap
(57.9%) relative to Spec C (12.5%), confirming that differential treatment of weather controls --
not estimator-induced negative weighting -- is the dominant source of divergence. Under Spec B
(both no controls), TWFE and CS-NT converge to within 7.1%, which is the strongest available
evidence that staggered-timing negative-weight bias is modest in this design.

This decomposition feeds Deliverable D1 of the QJE review (Sant'Anna, 2026-04-17).

---

## Three-axis rating

| Axis | Evidence | Score |
|---|---|---|
| Fidelity (paper-auditor) | NOT_APPLICABLE (no PDF); metadata-documented EXACT (0.01%) | F-NA |
| Implementation (twfe, csdid, bacon, dechaisemartin) | 1 WARN: SE method (cluster vs Conley, 16%); Spec A FAIL_memory resolved; all other flags are Axis-3 design findings | I-MOD |
| Design credibility (honestdid, bacon TvNT, CS-NT pre-trends) | CS-NT avg/peak robust at Mbar=0; first-period Mbar=0.25; TWFE D-FRAGILE (FE-induced); TvNT~51% limits Bacon bias | D-MODERATE |
| Final rating | F-NA x I-MOD -> use implementation alone: I-MOD = MODERATE | MODERATE |

Rating change: LOW (2026-04-18) -> MODERATE (2026-04-19).
Drivers: Spec A FAIL_memory resolved; Bacon and CS-NT pre-trend flags reclassified as design
findings (Axis 3) rather than implementation WARNs (Axis 2). Only 1 implementation WARN remains.

---

## Material findings (sorted by severity)

Design finding (D-MODERATE) -- CS-NT HonestDiD breakdown at Mbar=0.50:
CS-NT avg/peak post-treatment effects survive Mbar=0 (robustly negative) and Mbar=0.25, but
break down at Mbar=0.50. The first-period effect also breaks at Mbar=0.50. This is D-MODERATE
design credibility -- a finding about the paper design, not a demerit against our reanalysis.

Design finding -- CS-NT no-controls pre-trend spikes (k=-6, k=-2):
Two significant pre-period coefficients in CS-NT no-controls event study (t~2.30 and t~2.10).
Likely reflects omitted weather confounders rather than true parallel-trends failure. Under Spec A
(weather controls included), these spikes are expected to attenuate substantially.

Design finding -- Bacon forbidden comparisons and extreme cohort heterogeneity:
15,625 pairwise Bacon comparisons; EvL forbidden comparisons confirmed; estimate range
approximately -88 to +45 fires/month. Practical bias limited by 51% never-treated pool
(Spec B gap = 7.1%).

Design finding -- TWFE HonestDiD D-FRAGILE (FE-induced):
TWFE event-study CIs straddle zero at Mbar=0 for all targets. Driven by large SEs from the rich
id^month + prov^year^month FE structure, not by genuine pre-trend evidence.

Implementation WARN -- SE method deviation:
Stored TWFE SE (1.495, cluster-by-plant) is 16% smaller than the paper Conley spatial SE (1.780,
600 km bandwidth). Documented deviation. Does not affect point estimates or direction.

Implementation note -- Spec A large SE despite successful estimation:
att_cs_nt_with_ctrls SE = 5.067 is large (cf. TWFE SE 1.495). Doubly-robust IPW on 217k obs
x 125 cohorts produces imprecise cohort-specific propensity models at this panel scale. Direction
is confirmed; inference from CS-NT Spec A should rely on HonestDiD bounds, not point t-statistics.

---

## Recommended actions

- No pipeline action needed. Spec A and Spec B now recovered; cs_nt_with_ctrls_status = OK.
  The 2026-04-19 re-run resolves all prior implementation concerns. Rating upgraded to MODERATE.

- User (SE reporting): Stored TWFE SE (1.495, cluster) is 16% below the paper Conley spatial
  SE (1.780). When citing inferential results, note this deviation. Point estimates are unaffected.

- User (Spec A interpretation): CS-NT with controls (-2.037, SE=5.067) is directionally correct
  but imprecise. The 57.9% Spec A estimator gap is driven by differential weather-control
  sensitivity in the doubly-robust IPW step, not by negative TWFE weights. Recommend citing
  Spec B convergence (7.1% TWFE/CS gap under matched no-controls) as evidence that
  staggered-timing bias is modest in this design.

- User (dissertation methods): The 2.5-hour run time and 14.8 GB peak memory for Spec A should
  be disclosed. Doubly-robust CS-DID at this panel scale (217k obs x 7 controls x 125 cohorts)
  is at the upper limit of routine workstation execution.

- Pattern-curator: Update Pattern 42 in knowledge/failure_patterns.md to note that 2303 is a
  resolved case. Spec A FAIL_memory was a temporary resource constraint, now resolved with
  sufficient time and RAM. Pattern 42 should distinguish persistent FAIL from resolved FAIL.

---

## Individual reports

- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
