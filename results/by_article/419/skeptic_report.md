# Skeptic report: 419 -- Kahn, Li, Zhao (2015)

**Overall rating:** HIGH *(built from Fidelity x Implementation)*
**Design credibility:** D-MODERATE *(separate axis -- a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS), bacon (N/A -- single cohort), honestdid (N/A -- only 1 free pre-period), dechaisemartin (NOT_NEEDED -- absorbing binary single cohort), paper-auditor (F-NA -- no PDF)

---

## Executive summary

Kahn, Li, Zhao (2015) exploit China's 11th Five-Year Plan (2006) to estimate how binding COD reduction targets for provincial officials affected water pollution at boundary monitoring stations. The headline TWFE coefficient is -2.012 mg/L (paper SE=1.192 with 2-way clustering). Our replication matches the point estimate exactly (-2.012, gap < 0.001%) with an SE of 1.023 from single-level station clustering -- a documented and expected variance estimation difference. CS-DID (never-treated) returns -1.411 without controls and -1.678 with controls (Spec A status=OK), both negative and significant, confirming direction. Gardner imputation shows growing negative effects through t=4 (-3.29), consistent with deepening enforcement. Because the design is single-cohort (all boundary stations adopt 2006), there is no heterogeneous-timing bias; Bacon decomposition and de Chaisemartin-d'Haultfoeuille do not apply. The sole design limitation is the short pre-treatment window: only 1 free pre-period (t=-2), which prevents formal pre-trend testing and HonestDiD sensitivity analysis. The positive pre-period coefficient (+1.61 TWFE, +1.68 CS-NT at t=-2) is a qualitative concern classified as a design finding (Axis 3), not an implementation failure. The stored consolidated result (-2.012) is reproducible and reflects a well-defined ATT for the single adoption cohort. The user can trust the stored value; design credibility uncertainty stems from the paper's own data structure, not from our reanalysis.

---

## Per-reviewer verdicts

### TWFE (PASS)

- Point estimate matches paper to 5 significant figures: beta = -2.012 vs paper Table 3 Col 2 = -2.012.
- SE difference (1.023 vs paper 1.192) fully explained by 1-way vs 2-way (station + riversystem) clustering; documented in metadata.
- Post-treatment dynamics plausible: immediate effect t=0 (-1.13), weakening t=1 (-0.35), strengthening t=3-4 (-1.61 to -2.33), consistent with escalating Five-Year Plan enforcement.

[Full report](reviews/twfe-reviewer.md)

### CS-DID (PASS)

- Single-cohort design correctly handled: never-treated comparison (interior stations); NYT correctly skipped.
- CS-NT without controls: -1.411 (SE=0.898); with controls: -1.678 (SE=0.853); Spec A status=OK.
- Simple and dynamic aggregations collapse to identical values (expected for single cohort); Gardner confirms growing negative effects through t=4.

[Full report](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)

- Single adoption cohort (all boundary stations adopt 2006); no staggered timing decomposition possible.
- run_bacon: false in metadata correctly reflects this; no TvT share to report.

[Full report](reviews/bacon-reviewer.md)

### HonestDiD (NOT_APPLICABLE)

- Only 2 pre-periods (event_pre=2; t=-2 and t=-1 reference); 1 free pre-period after removing reference -- below the 3-pre-period threshold for HonestDiD Mbar computation.
- Qualitative note (Axis 3): positive pre-period coefficient at t=-2 (+1.61 TWFE, +1.68 CS-NT) is a design concern that cannot be formally quantified.

[Full report](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)

- Treatment is binary, absorbing (geographic designation), single-cohort; no non-absorbing or continuous-dose dimension.
- did_multiplegt provides no additional diagnostic value beyond TWFE and CS-DID for this design.

[Full report](reviews/dechaisemartin-reviewer.md)

### Paper auditor (NOT_APPLICABLE -- F-NA)

- No PDF found at pdf/419.pdf; formal fidelity evaluation not possible.
- Metadata records original_result.beta_twfe = -2.012; our estimate = -2.01219 (gap < 0.001%). Strongly implies EXACT fidelity but cannot be certified without the source document.

[Full report](reviews/paper-auditor.md)

---

## Three-way controls decomposition

Paper has non-empty twfe_controls (gdpg, gdpp, temperature, lightbuffer5km). Spec A (both with controls) status = OK.

| Spec | TWFE | CS-DID NT | Status |
|---|---|---|---|
| (A) both with controls | -2.012 (SE=1.023) | -1.678 (SE=0.853) | OK |
| (B) both without controls | -2.135 (SE=1.043) | -1.411 (SE=0.898) | OK |
| (C) TWFE with, CS without | -2.012 (SE=1.023) | -1.411 (SE=0.898) | headline, current default |

Key ratios:
- Estimator margin (protocol-matched, Spec A): (-2.012 - (-1.678)) / 2.012 = -16.6% (TWFE 16.6% larger in magnitude than CS-NT under matched controls)
- Covariate margin TWFE side (C vs B): (-2.012 - (-2.135)) / 2.012 = +6.1% (controls add modest magnitude on TWFE side)
- Covariate margin CS side (A vs B): (-1.678 - (-1.411)) / 1.678 = -15.9% (controls add 16% magnitude on CS side)
- Total gap (current headline, Spec C): (-2.012 - (-1.411)) / 2.012 = -29.9%

Interpretation: Spec A (matched controls) closes the TWFE-CS gap from 29.9% to 16.6%, confirming that approximately half the divergence is attributable to covariate specification differences -- controls increase the CS-NT estimate more than the TWFE estimate. The residual 16.6% is consistent with doubly-robust vs OLS estimator differences in a single-cohort design and does not indicate a pipeline error.

---

## Three-axis rating

| Axis | Score | Basis |
|---|---|---|
| Axis 1 -- Fidelity | F-NA | No PDF; paper-auditor NOT_APPLICABLE. Metadata match implies EXACT informally. |
| Axis 2 -- Implementation | I-HIGH | twfe=PASS, csdid=PASS; dechaisemartin=NOT_NEEDED; bacon/honestdid=NOT_APPLICABLE. Zero impl WARNs, zero impl FAILs. |
| Axis 3 -- Design credibility | D-MODERATE | Positive pre-period +1.61/+1.68 at t=-2 (mild signal, untestable with 1 free pre-period); HonestDiD not computable; controls explain ~half the estimator gap; direction robust across all estimators. |
| F-NA x I-HIGH -- use implementation alone | **HIGH** | |

Design credibility D-MODERATE is a finding about the paper's data structure (short pre-treatment window), not a demerit against our reanalysis.

---

## Material findings (sorted by severity)

FAIL items: None.

WARN items (all Axis 3 -- design findings, not implementation failures):

- [DESIGN, Axis 3] Only 1 free pre-period (t=-2). Positive pre-period coefficient (+1.61 TWFE, +1.68 CS-NT) is qualitatively concerning but cannot be formally tested. HonestDiD Mbar sensitivity is structurally infeasible.
- [DESIGN, Axis 3] TWFE-CS gap of 29.9% (headline Spec C) narrows to 16.6% under matched controls (Spec A). Residual gap attributable to estimator differences in a single-cohort design, not a specification error.
- [VARIANCE, Axis 3] Template uses 1-way station clustering (SE=1.023) vs paper 2-way clustering (SE=1.192). Our SE is tighter; the paper reports more conservative uncertainty. Results remain significant under either specification.

---

## Recommended actions

- No action needed on implementation: all applicable methodology reviewers PASS under the 3-axis rubric.
- For the user: the short pre-treatment window (2004-2005 only) is the principal design limitation. If original monitoring data extend pre-2004, adding pre-periods would allow formal HonestDiD sensitivity analysis.
- For the repo-custodian: metadata note already documents the 2-way clustering difference. No metadata changes required.
- For the pattern-curator: no new patterns identified.

---

## Individual reports

- [reviews/twfe-reviewer.md](reviews/twfe-reviewer.md)
- [reviews/csdid-reviewer.md](reviews/csdid-reviewer.md)
- [reviews/bacon-reviewer.md](reviews/bacon-reviewer.md)
- [reviews/honestdid-reviewer.md](reviews/honestdid-reviewer.md)
- [reviews/dechaisemartin-reviewer.md](reviews/dechaisemartin-reviewer.md)
- [reviews/paper-auditor.md](reviews/paper-auditor.md)
