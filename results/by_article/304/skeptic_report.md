# Skeptic report: 304 — Arthi, Beach & Hanlon (2022)

**Overall rating:** HIGH  *(built from Fidelity × Implementation)*
**Design credibility:** D-NA — structurally untestable (0 pre-periods; no event study)
**Date:** 2026-04-19
**Reviewers run:** twfe (impl=PASS), csdid (impl=PASS), bacon (N/A — single cohort), honestdid (N/A — 0 pre-periods), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE — no PDF)

---

## Executive summary

Arthi, Beach & Hanlon (2022) study the Lancashire Cotton Famine shock of 1861 on total mortality rates across 538 English registration districts, of which 24 are cotton-producing. The headline result is a textbook 2×2 DiD TWFE estimate of β = 2.1935 (SE = 0.4635), indicating roughly 2.2 additional deaths per population unit in cotton districts following the supply disruption. Our reanalysis exactly reproduces this estimate (< 0.001% difference) and the CS-NT ATT converges to 2.2418 — a 2.2% gap, well within one SE, with no sign reversal. All applicable implementation checks return PASS. Because the design has only two census periods (1851 pre, 1861 post) and a single cohort of treated districts, Bacon decomposition, HonestDiD sensitivity analysis, and pre-trend testing are all structurally infeasible — these are data constraints, not estimation failures. The stored consolidated result (TWFE = 2.1935) is trustworthy within the no-controls baseline specification. The principal caveat for users is that parallel trends is a fully maintained, untestable assumption, and that the stored result reflects Column 1 (no controls), not the authors' preferred Column 3 specification.

---

## Per-reviewer verdicts

### TWFE — PASS
- Estimate reproduced exactly: stored 2.19350070 vs re-estimated 2.19350069 (diff = 6.99e-07, < 0.001%). Exact match.
- No negative-weight problem: single cohort + 2 periods → pure 2×2 DiD, 100% TvU weight, no timing groups to compare.
- Pre-trend test structurally impossible (0 pre-periods); this is a data constraint, not a TWFE failure.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID — PASS
- CS-NT ATT = 2.2418 (simple = dynamic, as expected with a single (g,t) cell). 2.2% gap from TWFE; no sign reversal.
- Control group: 514 never-treated districts — large, unambiguous, correct.
- `cs_nt_with_ctrls_status = "N/A_no_twfe_controls"`: correct, no controls run on either arm.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon — NOT_APPLICABLE
- Applicability gate fails: `treatment_timing = "single"`. All 24 treated districts adopt simultaneously in 1861; no staggered timing groups exist. Decomposition collapses to a single 100% TvU component — no TvT share to report.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD — NOT_APPLICABLE
- Applicability gate fails on both criteria: `has_event_study = false` AND 0 pre-periods available.
- M̄ cannot be computed; no breakdown values to report. The parallel-trends assumption is entirely maintained with no sensitivity analysis possible. This is a structural feature of the 2-period historical data, not an estimation failure.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin — NOT_NEEDED
- Absorbing binary treatment, single cohort, 2 periods. No non-absorbing or continuous treatment variation. Returns NOT_NEEDED immediately.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper Auditor — NOT_APPLICABLE
- No PDF at `pdf/304.pdf`. Fidelity axis not formally evaluable via document extraction.
- Metadata records `original_result = {beta_twfe: 2.1935, se_twfe: 0.4635}`, which matches the re-estimated value exactly. The metadata reference is treated as proxy-EXACT but cannot be independently verified from the source PDF in this run.
- Full report: [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

---

## Three-way controls decomposition

N/A — paper has no original covariates in the baseline specification; unconditional comparison only. `twfe_controls = []`, `cs_controls = []`. `cs_nt_with_ctrls_status = "N/A_no_twfe_controls"`.

Note: the authors' preferred specification (Table 2, Col 3) includes district-level controls (log population density, linkable share, age structure shares). The metadata documents a Rule iii(b) deviation selecting Col 1 (no controls) for this reanalysis. The Col 1 and Col 3 estimates are reportedly near-identical, but a formal Spec A decomposition would require re-running with the author-preferred covariate set — currently outside scope.

---

## Three-axis rating derivation

| Axis | Score | Basis |
|---|---|---|
| Fidelity (Axis 1) | F-NA | No PDF; formal fidelity not evaluable. Metadata proxy = EXACT. |
| Implementation (Axis 2) | I-HIGH | All applicable reviewers PASS (twfe, csdid). Zero WARN, zero FAIL. |
| Design credibility (Axis 3) | D-NA | 0 pre-periods, no event study, Bacon N/A (single cohort). Parallel trends entirely untestable. Not D-BROKEN — the test was never run, not failed. |

**Final rating: HIGH** (F-NA × I-HIGH → use Implementation alone → HIGH).

**Design credibility is a separate axis and a finding about the paper, not a demerit against our reanalysis.** D-NA means the data do not permit design-credibility diagnostics, which is a known limitation of 2-period historical census designs. It does not imply that parallel trends is violated — merely that it cannot be assessed.

---

## Material findings (sorted by severity)

No FAIL items.

No WARN items.

Design observations (Axis 3 — informational):
- **Untestable parallel trends (structural):** 0 pre-periods means HonestDiD and pre-trend tests cannot be applied. This is the binding design limitation of the paper. Users should treat the causal estimate as conditional on the maintained parallel-trends assumption.
- **Small treated cluster count (N=24):** 24 treated districts out of 538. Cluster-robust SE inference may be imprecise at this cluster count. Wild-cluster bootstrap or Cameron-Miller correction would improve inference, but this is outside the standard template scope.
- **Rule iii(b) deviation — no-controls baseline:** Metadata selects Col 1 (no controls) rather than the author-preferred Col 3 (with controls). Point estimates are reportedly near-identical, but the stored result is not the author-preferred specification.

---

## Recommended actions

- No action needed on the stored TWFE result (2.1935) — it exactly reproduces the baseline specification and passes all applicable implementation checks.
- If `pdf/304.pdf` becomes available: re-run paper-auditor to formally close the fidelity axis.
- Optional: extend metadata to capture Col 3 (with controls) as a secondary `original_result_preferred` field, enabling a future Spec A decomposition.
- Pattern-curator note: this paper is a clean HIGH-rated 2×2 DiD with D-NA design credibility — useful as a calibration anchor for the "untestable parallel trends" category.

---

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
