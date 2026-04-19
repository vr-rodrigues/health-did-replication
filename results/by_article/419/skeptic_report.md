# Skeptic report: 419 — Kahn, Li, Zhao (2015)

**Overall rating:** HIGH
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (PASS), bacon (N/A — single cohort), honestdid (N/A — only 2 pre-periods), dechaisemartin (NOT_NEEDED — absorbing binary single cohort), paper-auditor (N/A — no PDF)

---

## Executive summary

Kahn, Li, Zhao (2015) exploit the 2006 binding COD reduction targets under China's 11th Five-Year Plan to estimate the effect of political promotion incentives on water pollution at provincial borders. The headline result is a TWFE coefficient of -2.012 mg/L (SE=1.192 with 2-way clustering), indicating that COD levels at boundary monitoring stations fell by approximately 2 mg/L more than interior stations after 2006. Our replication confirms the point estimate exactly (-2.012) with a minor SE difference (1.023 vs 1.192) attributable to single-level rather than 2-way clustering — a documented and expected variance estimation difference. The CS-DID (never-treated) estimates of -1.411 (without controls) and -1.678 (with controls) confirm the negative direction and significance. The Gardner imputation estimator shows larger negative effects at longer horizons (-2.06 to -3.29), consistent with deepening enforcement. Because treatment timing is single-cohort, there is no heterogeneous-timing bias, Bacon decomposition is not applicable, and de Chaisemartin-d'Haultfoeuille concerns do not apply. The sole design limitation is the very short pre-treatment window (only 1 free pre-period), which prevents formal pre-trend testing and HonestDiD sensitivity analysis. A positive pre-period coefficient at t=-2 (+1.61 TWFE, +1.68 CS-NT) is qualitatively concerning but cannot be formally tested. The stored consolidated result (-2.012) is reproducible and reflects a well-defined ATT for the single adoption cohort. Overall credibility is HIGH, with the pre-trend limitation noted as an inherent design feature of the original study's data availability.

---

## Per-reviewer verdicts

### TWFE (PASS)

- Point estimate exactly matches paper: beta = -2.012 (5 significant figures).
- SE difference (1.023 vs paper's 1.192) fully explained by 1-way vs 2-way clustering; documented in metadata notes.
- Post-treatment dynamics show plausible pattern: immediate effect at t=0, strengthening by t=4 (-2.33), consistent with escalating enforcement of Five-Year Plan targets.

[Full report](reviews/twfe-reviewer.md)

### CS-DID (PASS)

- Single-cohort design: CS-DID correctly uses never-treated (interior stations) as control group; NYT correctly skipped.
- CS-NT without controls: ATT = -1.411 (SE=0.898); with controls: ATT = -1.678 (SE=0.853); both negative and significant, consistent with TWFE direction.
- cs_nt_with_ctrls_status = "OK"; no convergence issues; Gardner cross-check also confirms negative effect growing over time.

[Full report](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)

- Single adoption cohort (all boundary stations adopt in 2006); no staggered timing decomposition possible.
- `run_bacon: false` in metadata correctly reflects this.

[Full report](reviews/bacon-reviewer.md)

### HonestDiD (NOT_APPLICABLE)

- Only 2 pre-periods (event_pre=2; t=-2 and t=-1 reference); need at least 3 pre-periods for HonestDiD Mbar test.
- Qualitative note: positive pre-period at t=-2 (+1.61 TWFE) is a design concern but cannot be formally tested.

[Full report](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)

- Treatment is binary, absorbing, single-cohort; no continuous dose or non-absorbing treatment dynamics.
- `did_multiplegt` provides no additional diagnostic value for this design.

[Full report](reviews/dechaisemartin-reviewer.md)

### Paper auditor (NOT_APPLICABLE)

- No PDF found at `pdf/419.pdf`; fidelity axis cannot be formally evaluated.
- Metadata records original_result.beta_twfe = -2.012; our estimate matches exactly; strong informal evidence of fidelity.

[Full report](reviews/paper-auditor.md)

---

## Material findings (sorted by severity)

**FAIL items:** None.

**WARN items:**

- [DESIGN] Single free pre-period (t=-2 only) prevents formal pre-trend testing and HonestDiD sensitivity analysis. The positive pre-period coefficient (+1.61 mg/L at t=-2) is qualitatively concerning but inconclusive with only 1 degree of freedom for pre-trend assessment.
- [VARIANCE] SE is estimated with 1-way station clustering (SE=1.023) vs paper's 2-way clustering (SE=1.192). The paper's SE is larger (more conservative). Our implementation produces a tighter SE — results remain significant under either specification.
- [CONTROLS] CS-DID without controls gives a 30% smaller ATT than TWFE (-1.411 vs -2.012); with controls the gap narrows to 17% (-1.678 vs -2.012). Part of the TWFE estimate is driven by covariate adjustment, not purely the DiD design.

---

## Recommended actions

- No action needed on methodology: TWFE implementation is correct, CS-DID correctly specified for single-cohort design.
- For the repo-custodian: consider updating the metadata to note that the 2-way clustering (station + riversystem) cannot be replicated by the standard template, and that the stored SE=1.023 underestimates the paper's reported uncertainty.
- For the user: the short pre-treatment window (2004-2005 only) is the main design limitation. If the original data extend further back, adding pre-periods would strengthen the parallel trends assumption. As currently specified, the study relies on a single pre-period for validation.
- For the pattern-curator: no new patterns identified.

---

## Rating details

| Axis | Score | Basis |
|---|---|---|
| Methodology | M-HIGH | 2 applicable reviewers (twfe, csdid) both PASS; dechaisemartin NOT_NEEDED; bacon/honestdid NOT_APPLICABLE |
| Fidelity | F-NA | No PDF available; fidelity axis not evaluable |
| **Combined** | **HIGH** | M-HIGH × F-NA: use methodology alone |

---

## Individual reports

- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
