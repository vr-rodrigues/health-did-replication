# Skeptic report: 263 -- Axbard, Deng (2024)

**Overall rating:** HIGH  *(built from Fidelity x Implementation; upgraded from LOW under old conflated rubric)*
**Design credibility:** D-FRAGILE  *(separate axis -- a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS; design-WARN reclassified Axis 3), csdid (impl=PASS; Pattern-50 reclassified Axis 3), bacon (NOT_APPLICABLE), honestdid (impl=PASS; Mbar_avg=0 TWFE; breaks Mbar=0.25), dechaisemartin (NOT_NEEDED), paper-auditor (EXACT +0.86%)

---

## Executive summary

Axbard and Deng (2024) study the effect of air pollution monitoring on enforcement actions against Chinese firms, using a single-cohort DiD: treated firms are those within 10 km of a newly installed air monitor, all treated simultaneously in Q1 2015. The stored TWFE estimate (beta = 0.00333, SE = 0.000556) reproduces the paper Table 1 Panel A Col 1 to within 0.86% -- well inside the EXACT threshold. All implementation choices (FE structure, clustering at city_id, sample filter, no controls) are correct. SA and Gardner estimators confirm the direction and approximate magnitude. The credibility rating is HIGH under the 3-axis rubric.

The design-credibility finding (D-FRAGILE) is a separate axis: HonestDiD shows the avg-ATT loses significance at Mbar = 0.25 for both TWFE and CS-NT, reflecting small effect magnitude relative to pre-trend uncertainty. CS-NT SEs are 6.8x wider than TWFE (Pattern 50) because CS-DID cannot absorb the paper's 531 industry-time + 21 province-time FEs -- a structural limitation of the paper's specification, not a pipeline error. Users should treat beta = 0.00333 as the correct replication estimate; HonestDiD fragility and Pattern 50 SE inflation are Axis 3 design-credibility findings about the paper.

---

## Per-reviewer verdicts

### TWFE (impl=PASS; design-WARN reclassified Axis 3)
- beta = 0.00333 (SE = 0.000556, t ~= 5.99); FE structure, clustering, and sample filter faithfully reproduce the Stata reghdfe spec.
- Pre-period coefficients (t = -5 to t = -2) all small and insignificant -- clean parallel trends.
- WARN about high-dimensional FEs making parallel trends untestable is an Axis 3 design finding; zero Axis 2 implementation WARNs.
- Full report: reviews/twfe-reviewer.md

### CS-DID (impl=PASS; Pattern-50 SE inflation reclassified Axis 3)
- CS-NT ATT = 0.00260 (SE = 0.003758) -- directionally consistent with TWFE (78% of magnitude), individually insignificant (t ~= 0.69).
- SE ratio CS/TWFE ~= 6.8x. Root cause: Pattern 50 -- 531 industry-time + 21 province-time FEs cannot be absorbed in the did package; adding via xformla collapses ATT to 0. Structural, not a coding error.
- cs_nt_with_ctrls_status = N/A_no_twfe_controls -- correctly skipped (no baseline controls).
- Full report: reviews/csdid-reviewer.md

### Bacon (NOT_APPLICABLE)
- Single treatment timing (all firms treated Q1 2015); no staggered adoption variance to decompose.
- Full report: reviews/bacon-reviewer.md

### HonestDiD (impl=PASS; breakdown values reclassified Axis 3)
- At Mbar = 0: avg-ATT (TWFE) CI = [+0.00079, +0.00453] excludes zero; peak CI = [+0.00207, +0.00615].
- Breakdown: avg-ATT and peak-ATT lose significance at Mbar = 0.25 for TWFE; CS-NT peak barely survives at Mbar = 0.25.
- rm_first_Mbar = 0, rm_avg_Mbar = 0, rm_peak_Mbar = 0 (TWFE); CS-NT rm_peak_Mbar = 0.25.
- Pre-trends clean; low breakdown reflects small effect magnitude, not contamination. Axis 3 design finding.
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)
- Standard absorbing binary single-timing design; DIDmultiplegtDYN adds no incremental insight.
- Full report: reviews/dechaisemartin-reviewer.md

### Paper auditor (EXACT)
- Stored beta_twfe = 0.003328 vs paper Table 1 Panel A Col 1 = 0.0033. Relative delta = +0.86%, SE delta = -0.66%. Both within 1% EXACT threshold.
- Fidelity score: F-HIGH.

---

## Three-way controls decomposition

N/A -- twfe_controls = [] and cs_controls = []. Paper has no original covariates; unconditional comparison only.

---

## Design credibility: D-FRAGILE (Axis 3 findings)

| Target | Estimator | Mbar=0 CI | Mbar=0.25 CI | Breakdown Mbar |
|---|---|---|---|---|
| first | TWFE | [-0.00129, +0.00291] incl 0 | [-0.00155, +0.00326] incl 0 | < 0 |
| avg | TWFE | [+0.00079, +0.00453] excl 0 | [-0.00025, +0.00577] incl 0 | 0.25 |
| peak | TWFE | [+0.00207, +0.00615] excl 0 | [-0.00023, +0.00837] incl 0 | 0.25 |
| avg | CS-NT | [+0.00035, +0.00354] excl 0 | [-0.00015, +0.00437] incl 0 | 0.25 |
| peak | CS-NT | [+0.00070, +0.00488] excl 0 | [+0.000021, +0.00581] barely excl 0 | ~0.25-0.5 |

rm_Mbar summary: TWFE first=0, avg=0, peak=0; CS-NT first=0, avg=0, peak=0.25. Bacon TvT share: N/A (single timing). Pre-trends: flat and clean.

Design credibility = D-FRAGILE. Rule applied: rm_avg_Mbar < 0.5 for both estimators -> D-FRAGILE. Pre-trends clean; fragility reflects effect size and precision, not contamination.

---

## Three-axis synthesis

| Axis | Score | Basis |
|---|---|---|
| Fidelity (paper-auditor) | F-HIGH | EXACT (+0.86%) |
| Implementation (Axis 2) | I-HIGH | 0 implementation WARNs or FAILs; all WARNs reclassified Axis 3 design findings |
| Design credibility (Axis 3) | D-FRAGILE | avg-ATT rm_Mbar = 0; breaks Mbar=0.25; Pattern 50 SE inflation structural |

**Final rating: HIGH (F-HIGH x I-HIGH).** The prior LOW rating (2026-04-18) used the old conflated rubric that counted Pattern 50 SE inflation and HonestDiD fragility as implementation demerits. Under the 3-axis rubric both are Axis 3 design findings. No implementation error exists; fidelity is exact.

---

## Material findings (sorted by severity)

All findings are Axis 3 (design findings about the paper, not implementation errors):

1. **[D-FRAGILE -- HonestDiD] avg-ATT breaks at Mbar = 0.25.** A parallel-trends violation equal to 25% of observed pre-trends renders the average effect indistinguishable from zero. Absolute threshold is tiny (~0.0003 additional slope); fragility reflects effect size and precision, not contamination.

2. **[Pattern 50 -- csdid] CS-NT SE inflation 6.8x from FE structure mismatch.** The paper's 531 industry-time + 21 province-time FEs cannot be absorbed by the did package. CS-NT ATT = 0.0026 is directionally correct but not significant. SA and Gardner estimators confirm TWFE direction and magnitude.

3. **[Design -- twfe] Parallel trends untestable at industry-x-province-x-time granularity.** After conditioning on ~550 interacted FEs, identifying variation is narrow; visual pre-trend check passes but formal testing at this granularity is infeasible.

No implementation failures or WARNs.

---

## Recommended actions

- No implementation action needed. beta = 0.00333 is the correct replication estimate.
- For dissertation write-up: report D-FRAGILE verdict and Mbar = 0.25 breakdown in the article-level commentary. Recommend SA/Gardner as preferred semiparametric corroboration given Pattern 50 precludes meaningful CS-NT inference.
- For pattern-curator: Pattern 50 confirmed and active for article 263 (531 industry-time + 21 province-time; SE ratio 6.8x). No new entry needed; cite article 263 as a reference instance.

---

## Individual reports
- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
