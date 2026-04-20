# Skeptic report: 80 -- Marcus et al. (2022)

**Overall rating:** MODERATE  *(built from Fidelity x Implementation)*
**Design credibility:** MODERATE  *(separate axis -- a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=WARN: cs_cluster mismatch), bacon (N/A -- single timing + RCS), honestdid (N/A -- only 2 pre-periods), dechaisemartin (NOT_NEEDED -- absorbing binary single cohort), paper-auditor (EXACT, -0.83%)

---

## Executive summary

Marcus, Siedler & Ziebarth (2022) estimate the effect of sports club vouchers distributed to German primary-school children on sports club membership (main outcome: sportsclub), using a single-cohort DiD comparing three treated states 2008 third-grade cohort against adjacent cohorts in treated and control states. The headline TWFE result is beta = 0.0089 (SE = 0.0188, Table 2 Col 3), statistically indistinguishable from zero. Our replication reproduces this estimate essentially exactly (beta = 0.008925, SE = 0.018718; gap = -0.83%), satisfying the EXACT fidelity threshold. Under the three-axis rubric the paper rates MODERATE: fidelity is HIGH (paper-auditor EXACT), implementation has one concern (cs_cluster=none diverges from the paper municipality-level clustering), and design credibility is MODERATE -- parallel trends cannot be formally assessed given only 2 pre-periods and a repeated cross-section structure, though the single-cohort design eliminates staggered-timing negative-weight concerns. All estimators agree the effect is statistically insignificant. The stored TWFE beta (0.008925) faithfully replicates the paper; the CS-NT column (0.01991) diverges from the paper CS value (0.0058) primarily due to RCS pseudo-panel aggregation differences between R did package and Stata csdid2, and is a design-structure finding, not a pipeline error.

---

## Per-reviewer verdicts

### TWFE (impl=PASS)
- Point estimate 0.008925 replicates paper 0.009 to -0.83% (EXACT threshold); SE 0.018718 vs 0.0188 (-1.48%).
- Specification correctly implements year FE + state (bula_3rd) FE + city (cityno) FE, clustered at cityno, matching Stata spec: reg sportsclub Post_avg i.year_3rd i.bula_3rd i.cityno, vce(cluster cityno).
- Design finding (Axis 3): RCS data with city FE requires compositional stability of cohorts within city; this is an identifying assumption inherited from the paper own design, not a replication artifact.
- Full report: reviews/twfe-reviewer.md

### CS-DID (impl=WARN)
- CS-NT ATT = 0.01991 (SE 0.02779); paper reported CS value = 0.0058 (SE 0.0118) -- ratio approx 3.4x.
- Implementation WARN (Axis 2): metadata sets cs_cluster = none while the paper clusters at municipality (cityno). Correcting to cs_cluster = cityno is the primary actionable fix.
- Design finding (Axis 3): R did package collapses RCS to pseudo-panel (city x year), producing different effective weighting and aggregation than Stata csdid2 native RCS support; this divergence is documented as Pattern 25 and is a data-structure limitation, not a coding error.
- Pre-trend at t=-2: coefficient 0.013 (SE 0.042), t approx 0.32 -- non-significant; no visible parallel-trends violation, but statistical power is very low.
- Full report: reviews/csdid-reviewer.md

### Bacon (N/A)
- Not applicable: treatment timing is single (all treated cities adopt in 2008) and data structure is repeated cross-section.
- The degenerate bacon.csv artifact (one row, estimate = -0.012) is an RCS aggregation artifact; no TvT share to report.
- Full report: reviews/bacon-reviewer.md

### HonestDiD (N/A)
- Not applicable: only 2 pre-periods available (t=-2 at 2006, t=-1 at 2007). Applicability rule requires at least 3 pre-periods. No M-bar values to report.
- Full report: reviews/honestdid-reviewer.md

### de Chaisemartin (NOT_NEEDED)
- Single-cohort absorbing binary treatment; no staggered timing or continuous dose heterogeneity. TWFE is a simple DiD and does not suffer from the negative-weight problem.
- Full report: reviews/dechaisemartin-reviewer.md

---

## Three-way controls decomposition

N/A -- paper has no original covariates; twfe_controls: [] and cs_controls: []. Unconditional comparison only. Spec A collapses to Spec B = Spec C by construction. cs_nt_with_ctrls_status = N/A_no_twfe_controls in results.csv confirms this.

---

## Material findings (sorted by severity)

**WARN -- cs_cluster mismatch (csdid-reviewer, Axis 2):** Metadata sets cs_cluster = none but the paper CS-DID was estimated with municipality-level clustering. Correcting to cityno is the primary addressable implementation gap.

**Design finding -- RCS pseudo-panel aggregation divergence (Axis 3):** CS-NT ATT (0.01991) is 3.4x the paper CS value (0.0058), most likely due to R did package versus Stata csdid2 differences in pseudo-panel construction and weighting (Pattern 25). This is a data-structure limitation documented as a design finding, not a pipeline error.

**Design finding -- parallel trends untestable at conventional power (Axis 3):** Only 2 pre-periods available; HonestDiD cannot be performed. The design relies on compositional stability of school cohorts within cities, an assumption inherited from the paper.

---

## Recommended actions

- **For the repo-custodian:** Update cs_cluster from none to cityno in data/metadata/80.json and re-run the analyst.
- **For the pattern-curator:** Annotate Pattern 25 with the specific mechanism: R did on RCS data can diverge 3-4x from Stata csdid2 due to pseudo-panel aggregation differences; qualitative null conclusion is unaffected.
- **For the user (methodological judgement):** The 2 pre-period limitation prevents HonestDiD sensitivity analysis. Earlier administrative data (pre-2006) would be needed to formally test robustness to parallel-trends violations.
- The qualitative null conclusion is unanimous across all estimators (TWFE beta=0.0089 ns, CS-NT=0.020 ns, SA=TWFE by single-cohort construction). No action needed on the headline finding.

---

## Axis summary

| Axis | Score | Evidence |
|---|---|---|
| Fidelity (paper-auditor) | F-HIGH | EXACT: beta gap = -0.83%, SE gap = -1.48% |
| Implementation (twfe, csdid, bacon, honestdid, dechaisemartin) | I-MOD | 1 impl WARN: cs_cluster=none vs paper cityno clustering |
| Design credibility | D-MODERATE | Single-cohort clean design; 2 pre-periods only; pre-trend non-significant but underpowered; HonestDiD/Bacon N/A |

**Final rating: F-HIGH x I-MOD = MODERATE**
**Design credibility: MODERATE** (separate finding; does not affect the MODERATE rating)

---

## Individual reports
- reviews/twfe-reviewer.md
- reviews/csdid-reviewer.md
- reviews/bacon-reviewer.md
- reviews/honestdid-reviewer.md
- reviews/dechaisemartin-reviewer.md
- reviews/paper-auditor.md
