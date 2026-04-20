# Skeptic report: 1094 — Fisman & Wang (2017)

**Overall rating:** MODERATE  *(Fidelity × Implementation: F-MOD × I-HIGH)*
**Design credibility:** MODERATE  *(separate axis — finding about the paper, not our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS), bacon (impl=NOT_APPLICABLE — unbalanced panel), honestdid (impl=PASS, M̄_first=N/A — null confirmed at all Mbar, M̄_peak=N/A), dechaisemartin (NOT_NEEDED), paper-auditor (WARN — 8.9% gap, documented Stata/R merge difference)

---

## Executive summary

Fisman & Wang (2017) estimate the effect of China's NSNP death-ceiling law on whether province-industry cells exceed their mortality quota, finding a negative but statistically insignificant TWFE coefficient (−0.051, SE=0.040, Table 2 Col 1). Our reanalysis reproduces this null finding across all estimators: TWFE −0.047, CS-NT simple −0.001, CS-NT dynamic +0.028 — all statistically insignificant. The 8.9% coefficient gap (−0.051 vs −0.047) is fully explained by a single-observation merge discrepancy between the original Stata code and our R pipeline (Stata drops 1 obs during a multi-step merge, R retains it); this is a documented limitation, not a specification error, and places fidelity in the F-MOD band. Implementation is clean (I-HIGH): the FE structure, clustering, treatment indicator, and gvar_CS construction are all correctly specified. HonestDiD confirms the null at all values of Mbar for both TWFE and CS-NT, consistent with the paper's own conclusions. Design credibility is assessed D-MODERATE: pre-trends are flat under TWFE (all insignificant), mildly variable under CS-NT (t=-3 coefficient approaches 1.5 SEs), Bacon TvT-contaminated share is ~29% (informational only given unbalanced panel), and the paper makes no significant positive claim that could be overturned. The stored consolidated_results value (beta_twfe = −0.047) may be used with the caveat that the paper's exact number (−0.051) involves a Stata preprocessing step not fully reproducible in R without a full port of the original data-prep pipeline.

---

## Per-reviewer verdicts

### TWFE (WARN)

- Coefficient −0.047 (SE=0.041, N=1756) vs paper −0.051 (SE=0.040, N=1755): 7.8% gap, within the WARN band; attributed to 1-obs Stata/R merge discrepancy, not a specification error.
- FE structure (provinceind + year + industry), clustering (province, 31 clusters), and treatment indicator (strict inequality post) are all correctly matched to Table 2 Col 1.
- Post-period TWFE dynamics are noisy and sign-inconsistent across t=0 to t=4; 7 adoption cohorts create heterogeneity risk, but qualitative null conclusion is preserved.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (WARN — design finding, not implementation)

- CS-NT simple ATT −0.001 (SE=0.061), dynamic +0.028 (SE=0.057): ~38% smaller in absolute value than TWFE, suggesting mild heterogeneity bias in TWFE, but both insignificant.
- gvar_CS = effective_year + 1 correctly handles the strict-inequality treatment indicator; 16 clean control provinces correctly identified.
- t=-3 CS-NT pre-period coefficient −0.103 (SE=0.069) approaches 1.5 SEs — flagged as a design finding; SA estimates closely agree (−0.093 at t=-3), confirming internal consistency.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)

- Formal Bacon decomposition not applicable: `allow_unbalanced=true`; province × industry panel is unbalanced, invalidating 2x2 weight decomposition.
- Qualitative read from bacon.csv: TvT-clean component ≈ 71% of total TWFE weight; contaminated (EvsL + LvsE) ≈ 29% — moderate contamination, wide cross-cohort heterogeneity (range −0.309 to +0.113). Treated-vs-untreated comparisons dominate.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (PASS)

- Both TWFE and CS-NT CIs include zero at Mbar=0 (no pre-trend violation allowed): TWFE [−0.157, +0.046], CS-NT [−0.169, +0.019]. The null is robust to any level of parallel-trends relaxation.
- HonestDiD confirms, not contradicts, the paper's stated null conclusion — no statistically significant claim is overturned.
- CS-NT first-period CI upper bound barely at +0.019 at Mbar=0 is the closest thing to fragility, but this is consistent with the paper's p≈0.20.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)

- Standard absorbing binary staggered design (NSNP law adoption, no reversal, no dose heterogeneity). DID_M recovers identical clean comparisons as CS-NT; no additional insight gained.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

---

## Three-way controls decomposition

N/A — paper has no original covariates; unconditional comparison only. `twfe_controls = []`, `cs_controls = []`. The metadata group label is `escalonada_sem_controles`. Specs B and C are identical (no controls to vary); Spec A is marked `N/A_no_twfe_controls` in results.csv.

---

## Three-axis rating breakdown

| Axis | Score | Evidence |
|---|---|---|
| Fidelity (paper-auditor) | F-MOD | 8.9% gap; documented Stata/R single-obs merge difference; not a specification error |
| Implementation (our pipeline) | I-HIGH | All applicable reviewers PASS on implementation; FE/cluster/gvar all correctly specified |
| Design credibility (finding) | D-MODERATE | Pre-trends flat under TWFE; CS-NT t=-3 mild; null robust at all Mbar; TvT contamination ~29% (informational) |

**F-MOD × I-HIGH → MODERATE**

---

## Material findings (sorted by severity)

- WARN (Fidelity): 8.9% coefficient gap (−0.051 paper vs −0.047 ours); caused by 1-obs Stata/R merge discrepancy in data-prep (reshape long + multi-step merges + `property_quota` format handling + `drop _m==2`). Full Stata→R port of data-prep required to fully close the gap. Both are insignificant nulls in the same direction.
- WARN (Design finding): CS-NT pre-period t=-3 coefficient −0.103 (SE=0.069) approaches 1.5 SEs. SA agrees (−0.093). Mild pattern, does not reach significance; HonestDiD confirms null is robust.
- WARN (Design finding): 7 adoption cohorts, wide cross-cohort heterogeneity in Bacon 2x2 estimates (−0.309 to +0.113). TWFE inflated in absolute magnitude by ~38% relative to CS-NT, consistent with heterogeneity bias — but both are insignificant.

---

## Recommended actions

- No action needed on implementation: specification is correctly coded.
- Metadata documentation: the 8.9% gap is fully documented in the metadata notes field and in paper_audit.md. No metadata fix will close it without a full Stata data-prep port. Treat as a known, documented limitation.
- For the dissertation: cite this paper as a case where the qualitative null conclusion is robust across TWFE, CS-NT, and HonestDiD sensitivity analysis, despite the merge discrepancy. The stored beta_twfe = −0.047 is a valid R-based replication; the 8.9% offset from the paper's −0.051 should be noted in the paper-fidelity table.
- No pattern-curator action needed: the Stata/R merge difference is already documented in the metadata notes (Pattern-type: preprocessing pipeline divergence).

---

## Individual reports

- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
