# Skeptic report: 254 — Gandhi et al. (2024)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (WARN), csdid (WARN), bacon (N/A), honestdid (PASS), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Gandhi et al. (2024) study the effect of Illinois's 2022 Medicaid reimbursement rate reform on nursing home staffing, using a weekly panel of nursing homes with a continuous treatment (Illinois × Medicaid share percentage) and a single adoption date (Q3 2022, excluding a Jan–Jun 2022 transition bubble). The stored consolidated result (beta_twfe = 5.491, se = 0.581; CS-NT ATT = 5.693, se = 0.915) reflects a **discretized binary treatment** created by the analyst — splitting Illinois facilities into high-Medicaid (above-median share, n=342) vs. non-Illinois controls — rather than the paper's actual continuous dose-response specification. This design choice is documented in metadata and is a known approximation. The event study shows clean pre-trends across all four estimators (TWFE, CS-NT, SA, Gardner) and a monotonically growing post-treatment effect (from ~5 to ~11 nursing hours/resident over 25 weeks), consistent with gradual staffing adjustment. HonestDiD sensitivity analysis confirms strong robustness of the first-period effect (breakdown Mbar >= 1.75 for both TWFE and CS-NT). The LOW rating reflects two concurrent WARN flags — the continuous-to-binary treatment discretization and the weekly-to-quarterly aggregation asymmetry — which together mean the stored beta_twfe is an approximation of the paper's causal parameter, not a direct replication. Users should interpret the consolidated result as a directionally valid but not numerically comparable estimate of the paper's headline finding.

---

## Per-reviewer verdicts

### TWFE (WARN)
- Parallel trends: clean pre-trends across ~28 pre-treatment weeks; no evidence of violation.
- Point estimate (5.491) and heterogeneity gradient (high: 8.843, low: 1.720) are internally consistent with dose-response hypothesis.
- **WARN:** Stored beta_twfe reflects the analyst-constructed binary high/low Medicaid split, not the paper's continuous treatment coefficient (`illinois * mcaid_share2019/100 * post`). These measure different estimands.

Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (WARN)
- CS-NT ATT (5.693) is nearly identical to TWFE (5.491) — ratio 1.037 — consistent with a single-cohort design where TWFE and CS-NT are theoretically equivalent.
- **WARN:** CS-DID runs on quarterly aggregated data while TWFE runs on weekly data, creating an asymmetry in pre-period resolution (3 vs. 9+ pre-periods).
- **WARN:** Inherited from TWFE — binary treatment discretization is an approximation of the paper's continuous estimand.

Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (N/A)
- Not applicable: single adoption date, no staggered timing. `run_bacon: false` correctly set.

Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (PASS)
- First-period effect: breakdown Mbar = 2.0 (TWFE) and 1.75 (CS-NT) — high robustness; confidence set excludes zero across full sensitivity range tested.
- Average post-period effect: breakdown Mbar = 0.5 (TWFE) and 1.25 (CS-NT) — more sensitive, but consistent with the growing (ramp-up) treatment effect trajectory rather than a pre-trend violation.
- No concerns with the sensitivity analysis implementation.

Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Single adoption, absorbing binary treatment. No contaminated 2x2 comparisons; DCD diagnostic adds no value over TWFE + CS-NT in this design.

Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)
- No PDF available at pdf/254.pdf; `original_result` in metadata is an empty object. Fidelity axis not evaluable (F-NA).

Full report: [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

---

## Rating derivation

| Axis | Score | Basis |
|------|-------|-------|
| Methodology | M-LOW | 2 WARN (twfe, csdid) + 1 PASS (honestdid); 2 excluded (bacon N/A, dechaisemartin NOT_NEEDED) |
| Fidelity | F-NA | paper-auditor NOT_APPLICABLE; no PDF |
| **Combined** | **LOW** | M-LOW × F-NA → use methodology alone → LOW |

---

## Material findings (sorted by severity)

**WARN — Continuous treatment discretization (both twfe and csdid):**
The paper's main specification is `illinois * (mcaid_share2019/100) * post` (continuous dose-response). Our reanalysis creates a binary treatment (above-median Medicaid share = treated). The stored beta_twfe (5.491) reflects the pooled high/low binary ATT, not the paper's headline continuous-treatment coefficient. This is a known and documented approximation; the metadata `legacy_reason` and `notes` fields explain it. The binary estimate is directionally valid and internally coherent but is not numerically comparable to any single table in the paper.

**WARN — Weekly-to-quarterly aggregation asymmetry for CS-DID:**
TWFE is estimated on weekly data (4.2M+ observations), while CS-DID is estimated on quarterly-aggregated data. This reduces pre-period resolution for CS-NT to 3 periods vs. 9 for TWFE. The estimates are close (difference < 0.2), but the asymmetry is worth flagging for methodological transparency.

---

## Recommended actions

- **For the repo-custodian:** Consider adding a `beta_twfe_continuous` field to results.csv or a separate `results_continuous.csv` that records the paper's actual continuous-treatment DiD coefficient (from `staffing_event_study.do` lincomest output), to enable fidelity auditing. The current `original_result: {}` prevents any numerical comparison to the paper.

- **For the repo-custodian:** Consider updating metadata to flag `treatment_type: "continuous_approximated_as_binary"` to make the discretization explicit in the schema for downstream consumers.

- **For the pattern-curator:** Consider adding a pattern: "Pattern: Continuous-treatment DID approximated with binary high/low split — stored beta reflects binary ATT, not dose-response coefficient; mark fidelity axis as structurally non-comparable rather than FAIL."

- **For the user (methodological judgement):** The direction and magnitude of the binary-split estimate (5.491 nursing hours/resident for high-Medicaid IL facilities) is consistent with the paper's reported heterogeneity findings. The HonestDiD robustness is strong for first-period effects. Trust the sign and significance, but do not compare the stored 5.491 directly to any specific table in Gandhi et al. (2024) without accounting for the discretization.

---

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
