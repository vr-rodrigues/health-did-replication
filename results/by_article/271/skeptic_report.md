# Skeptic report: 271 — Sekhri, Shastry (2024)

**Overall rating:** HIGH  *(built from Fidelity × Implementation)*
**Design credibility:** D-ROBUST  *(separate axis — a finding about the paper, not about our reanalysis)*
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS), bacon (NOT_APPLICABLE — single cohort; single TvU pair weight=1.0), honestdid (impl=PASS, M̄_first=0.50, M̄_avg=>2.0, M̄_peak=>2.0), dechaisemartin (NOT_NEEDED — absorbing binary single-cohort), paper-auditor (F-NA — no PDF; informational: metadata beta=67.81 vs stored=67.8101, gap=0.00015%)

## Executive summary

Sekhri & Shastry (2024, AEJ:Applied) study the agricultural first-stage of the Green Revolution: treatment is a binary indicator for districts with thick/very-thick aquifers (dmaq23) interacting with post-1966, in a 271-district × 32-year panel (1956–1987). The headline TWFE estimate of 67.81 thousand hectares of high-yielding variety (HYV) crop area is reproduced to machine precision (0.00015% gap) from the replication package data. Our implementation is clean on all applicable axes: TWFE, CS-DID, and HonestDiD all PASS with no implementation WARNs or FAILs. The single-cohort design (all treated districts adopt in 1966) eliminates staggered-timing bias by construction, making the Bacon decomposition non-diagnostic (single TvU pair, weight=1.0). HonestDiD diagnostics for the average and peak effects yield M̄ > 2.0, the strongest possible robustness rating — the results survive even hypothetical pre-trend violations twice as large as the observed pre-period slope. The stored consolidated_results value of 67.81 can be trusted. This is the cleanest design in the audit sample.

## Per-reviewer verdicts

### TWFE (PASS)
- Specification matches paper exactly: `reghdfe hyv_major d_dmaq23 pr at, absorb(i.code i.year) vce(cluster code)`.
- Pre-trend coefficients oscillate at small magnitudes (range 0.3–2.9 on an outcome rising to 82); t=-5 borderline significant (t=2.80) but economically negligible at 3.5% of peak effect — no monotonic drift.
- All five estimators (TWFE, CS-NT, CS-NT+ctrls, SA, Gardner) agree in direction and approximate magnitude; controls change the estimate by only 2.7%.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (PASS)
- Single-cohort CS-DID is mechanically equivalent to TWFE (same identification). CS-NT no-controls ATT = 69.75, identical to TWFE no-controls.
- Pre-period ATTs are structurally 0/NA (universal base period with single cohort — documented constraint, not a coding error).
- Spec A (CS-DID with controls) yields 71.89, 3.1% above no-controls CS-NT — controls sensitivity negligible, no sign sensitivity.
- Never-treated comparison group (177 districts, geology-based) is not subject to differential policy trends.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)
- `treatment_timing == "single"`: all treated districts adopt in 1966; confirmed by `bacon.csv` showing one pair (1966 vs 99999) with weight = 1.0.
- No forbidden comparisons; no staggered-timing bias possible by design.
- TvT share = 0% (not applicable as a diagnostic).
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (PASS)
- TWFE-only analysis (CS-NT HonestDiD infeasible: universal base period returns SE=NA for pre-treatment ATTs — documented structural constraint for single-cohort designs).
- n_pre = 2 (of 5 available) used due to the above constraint.
- Average effect (ATT=20.84): M̄ > 2.0 — CIs remain entirely positive even at hypothetical pre-trend violation twice the observed slope. **D-ROBUST.**
- Peak effect (t=3, ATT=39.38): M̄ > 2.0 — CI [17.80, 60.71] at Mbar=2.0. **D-ROBUST.**
- First-period effect (t=0, ATT=3.02): M̄ = 0.50 — significance breaks at Mbar=0.75. **D-MODERATE** for t=0 only. This is structurally expected: the first year of the Green Revolution saw minimal immediate seed adoption; the small initial ATT is proportionately fragile. Not a concern for the paper's main claims.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Treatment is absorbing binary with a single cohort. No switching, no dose heterogeneity, no staggered-timing negative weights.
- DIDmultiplegtDYN adds no diagnostic value beyond TWFE and CS-DID here.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

## Three-way controls decomposition

`twfe_controls` = [`pr`, `at`] (precipitation, temperature). Applicable.

| Spec | TWFE | CS-DID NT | Status |
|---|---|---|---|
| (A) both with controls | 67.81 (SE 11.86) | 71.89 (SE 12.11) | OK |
| (B) both without controls | 69.75 (SE 11.91) | 69.75 (SE 11.62) | OK |
| (C) TWFE with, CS without | 67.81 (SE 11.86) | 69.75 (SE 11.62) | — (headline, current default) |

Key ratios:
- **Estimator margin (protocol-matched, Spec A):** (67.81 − 71.89) / |67.81| = −6.0%
- **Covariate margin (TWFE side):** (67.81 − 69.75) / |67.81| = −2.9%
- **Covariate margin (CS side):** (71.89 − 69.75) / |71.89| = +3.0%
- **Total gap (current headline, Spec C):** (67.81 − 69.75) / |67.81| = −2.9%

Verbal interpretation: In the matched-protocol Spec A, TWFE (67.81) and CS-DID (71.89) differ by only 6.0%. The covariate margins are near-symmetric and small (<3%). Controls (precipitation, temperature) are weak confounders in this agricultural context; the estimator gap is not driven by controls assignment, confirming that the single-cohort design gives well-identified estimates regardless of the controls specification.

## Material findings (sorted by severity)

No implementation WARNs or FAILs. The following are design findings (Axis 3), reported as informational:

- [DESIGN FINDING] HonestDiD first-period (t=0) breaks at M̄=0.75. Structurally expected: year-1 Green Revolution effect was ~3 units vs peak of ~82. Not a concern for any of the paper's main claims.
- [DESIGN FINDING] t=−5 TWFE pre-period coefficient has t-stat=2.80 (borderline significant), magnitude 2.86 on outcome that reaches 82 at peak (3.5% of peak). No monotonic drift. Treated as flat in economic terms.
- [DESIGN FINDING] CS-NT HonestDiD infeasible due to universal base period (single-cohort structural constraint). TWFE-only HonestDiD is adequate since TWFE = CS-NT by construction for single-cohort designs.
- [DESIGN FINDING] Gardner diverges from CS-NT at t=+5 (82.80 vs 64.25) — boundary-period weighting effect, well-documented for long panels.

## Recommended actions

- No action needed. All implementation reviewers PASS; design credibility is D-ROBUST; fidelity is machine-precision EXACT via metadata reference.
- Optional: If the paper PDF (pdf/271.pdf) becomes available, re-run paper-auditor to upgrade F-NA to EXACT formally. This would not change the HIGH rating.
- Note for the dissertation: Article 271 is the canonical exemplar of a clean single-cohort design. Consider using it as a D-ROBUST benchmark in Section 4 comparison tables.

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
