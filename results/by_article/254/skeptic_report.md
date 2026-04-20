# Skeptic report: 254 -- Gandhi et al. (2024)

**Overall rating:** HIGH  (Fidelity x Implementation; upgraded from stale LOW dated 2026-04-18)
**Design credibility:** D-ROBUST  (first-period Mbar >= 1.75 both estimators; separate Axis-3 finding)
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS; design-scoping WARN -> Axis 3), csdid (impl=PASS; aggregation WARN -> Axis 3), bacon (N/A -- single timing), honestdid (impl=PASS; Mbar_first=2.0/1.75, Mbar_avg=0.5/1.25), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE -- structural estimand mismatch)

---

## Executive summary

Gandhi et al. (2024) examine the effect of the Illinois 2022 Medicaid reimbursement rate reform on nursing home staffing using a continuous treatment (Illinois x Medicaid share x post) and a single adoption date (Q3 2022, bubble excluded). Our reanalysis binarizes the treatment -- splitting Illinois facilities into high-Medicaid (above-median share, n=342 CCNs) vs. non-Illinois controls -- a documented analyst choice flagged in metadata as legacy_analysis: true. This is a structural estimand mismatch: the paper headline is a continuous dose-response coefficient (beta approx 5.35, Figure 2a, IL vs. non-IL pooled), while we store a binary-split ATT (beta_twfe = 5.491, CS-NT = 5.693). Numerical closeness is coincidental.

The stored estimate is internally coherent. Pre-trends are flat across 28 pre-treatment weekly periods. The heterogeneity gradient (high-Medicaid = 8.84, pooled = 5.49, low-Medicaid = 1.72) is consistent with the dose-response hypothesis. HonestDiD first-period robustness is high (Mbar >= 1.75 for both TWFE and CS-NT). Our implementation is technically correct -- the two WARNs in the cached reviewer reports are documented scoping decisions (continuous-to-binary discretization; weekly-to-quarterly aggregation for CS-DID), not pipeline errors. Under the correct 3-axis rubric they belong on Axis 3 (design/scope notes) not Axis 2 (implementation faults). Overall rating: HIGH.

Users should treat the stored beta_twfe (5.491) as a directionally valid but estimand-distinct approximation of the paper headline finding. It should not be compared numerically to any specific table in Gandhi et al. (2024).

---

## Axis derivation

| Axis | Score | Basis |
|---|---|---|
| Fidelity (Axis 1) | F-NA | paper-auditor NOT_APPLICABLE; structural estimand mismatch (binary split != continuous dose-response); original_result: {} confirms no comparable reference beta |
| Implementation (Axis 2) | I-HIGH | FE structure correct (ccn + wk_end_mdy, cluster=ccn); single-timing correct; bubble exclusion correct; no xformla/sample/clustering errors; both reviewer WARNs are documented design choices not pipeline bugs |
| Design credibility (Axis 3) | D-ROBUST | Mbar_first = 2.0 (TWFE) / 1.75 (CS-NT); Mbar_avg = 0.5 (TWFE) / 1.25 (CS-NT); avg fragility is structural (ramp-up dynamics not parallel-trends violation); pre-trends flat 28 weeks; no Bacon (single timing) |
| **Final rating** | **HIGH** | F-NA x I-HIGH -> use implementation alone -> HIGH (precedent: articles 323, 432, 44, 147) |

Prior rating (2026-04-18): LOW. The prior report classified documented scoping decisions as implementation WARNs on the M-LOW axis, then applied F-NA x M-LOW -> LOW. Under the correct 3-axis rubric, pre-documented scoping decisions are Axis-3 findings, not Axis-2 faults.

---

## Per-reviewer verdicts

### TWFE (impl=PASS)
- FE structure and clustering correctly specified (unit=ccn, time=wk_end_mdy, cluster=ccn). Bubble period correctly excluded. Single-timing treatment correctly handled.
- Heterogeneity gradient (high=8.84 > pooled=5.49 > low=1.72) internally consistent with dose-response hypothesis.
- Design note (Axis 3): stored beta_twfe reflects the binary high/low split, not the paper continuous-treatment DiD coefficient. Documented in metadata; not an implementation error.

Full report: [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)

### CS-DID (impl=PASS)
- CS-NT ATT = 5.693, TWFE = 5.491 (ratio 1.037); near-identical as expected for a single-cohort design. Correct comparison group (never-treated non-Illinois facilities). run_csdid_nyt=false correct (non-staggered).
- Design note (Axis 3): CS-DID run on quarterly-aggregated data (3 pre-periods) vs. weekly TWFE (9 pre-periods). Documented tractability choice in legacy_reason. Estimates within 0.2 nursing hours/resident.

Full report: [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)

### Bacon (N/A)
- Not applicable: single adoption date (Q3 2022). run_bacon: false correctly set. No TvT share diagnostic; not needed.

Full report: [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)

### HonestDiD (impl=PASS; D-ROBUST at first-period target)
- Mbar_first: 2.0 (TWFE), 1.75 (CS-NT). Both > 1. CI at Mbar=2 (TWFE): [0.406, 9.264], still excludes zero.
- Mbar_avg: 0.5 (TWFE), 1.25 (CS-NT). TWFE avg more sensitive, reflecting ramp-up dynamics (effects grow from ~5 to ~11 over 25 weeks) not a parallel trends violation.
- Design credibility: D-ROBUST at first-period target; D-MODERATE for average effect.

Full report: [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Single absorbing binary treatment (discretized version). No contaminated 2x2 comparisons. DCD adds no diagnostic value beyond TWFE + CS-NT.

Full report: [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE -- structural)
- Fidelity axis structurally non-evaluable: our estimand (binary high/low split, within-IL comparison) differs fundamentally from the paper headline (continuous Illinois x Medicaid share x post; IL vs. non-IL pooled). original_result: {} confirms no comparable reference beta at profiling.
- Note: the cached paper-auditor report (2026-04-18) incorrectly states PDF NOT FOUND -- the PDF does exist at pdf/254.pdf -- but this does not change the NOT_APPLICABLE verdict, which is legitimate for structural estimand reasons. The numerical proximity (paper approx 5.35 vs. ours 5.491, 2.6% gap) is coincidental and should not be interpreted as fidelity confirmation.

Full report: [reviews/paper-auditor.md](reviews/paper-auditor.md)

---

## Three-way controls decomposition

N/A -- twfe_controls: [] (no covariates). Paper main binary-split specification is unconditional. No Spec A/B/C applicable.

---

## Material findings (sorted by severity)

**Design note (Axis 3) -- Continuous-to-binary estimand mismatch:**
The paper main specification is continuous (illinois x mcaid_share2019/100 x post). We store a binary-split ATT (high-Medicaid IL vs. non-IL). These are different parameters. The stored beta_twfe (5.491) cannot be directly compared to any single number in Gandhi et al. (2024). The heterogeneity gradient (8.84 / 5.49 / 1.72) is qualitatively consistent with the paper dose-response story. Scope limitation documented in metadata, not an implementation error.

**Design note (Axis 3) -- Weekly-to-quarterly aggregation for CS-DID:**
TWFE on weekly data (9+ pre-periods); CS-DID on quarterly-aggregated data (3 pre-periods). Documented tractability necessity. Estimates agree within 0.2 nursing hours/resident.

**Design note (Axis 3) -- Mbar_avg fragility (TWFE = 0.5):**
Reflects growing post-treatment effects (ramp-up dynamics), not a pre-trend violation. Pre-trends clean across 28 pre-treatment weeks. First-period effect remains robust at Mbar = 2.0.

---

## Recommended actions

- No action needed on implementation. The pipeline is correctly specified for the chosen estimand.

- For the repo-custodian (low priority): Consider recording the paper continuous-treatment DiD coefficient (Figure 2a, approx 5.35) in original_result with a flag estimand_comparable: false, to prevent automated fidelity miscomparison.

- For the repo-custodian (low priority): Consider adding treatment_type: continuous_approximated_as_binary to the metadata schema to make the discretization explicit in consolidated_results.csv.

- For the user: Trust the sign and significance of the stored estimates. The direction and heterogeneity gradient are consistent with the paper dose-response findings. HonestDiD robustness at Mbar = 1.75-2.0 for first-period effects is strong. Do not use the stored 5.491 as a direct replication of any specific Gandhi et al. (2024) table entry.

---

## Individual reports
- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md)
