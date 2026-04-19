# Skeptic report: 304 — Arthi, Beach & Hanlon (2022)

**Overall rating:** HIGH
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (PASS), bacon (NOT_APPLICABLE), honestdid (NOT_APPLICABLE), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE)

---

## Executive summary

Arthi, Beach & Hanlon (2022) examine the Lancashire Cotton Famine shock of 1861 on total mortality rates across 538 English registration districts. The headline result is a 2x2 DiD TWFE estimate of beta = 2.1935 (SE = 0.4635), indicating that cotton-producing districts experienced roughly 2.2 additional deaths per population unit following the supply shock. The design is a textbook absorbing-binary single-cohort DiD with 24 treated and 514 never-treated districts. All applicable methodological reviewers returned PASS: the TWFE estimate reproduces the stored value to within 0.001%, the CS-NT ATT (2.2418) converges with TWFE within 2.2% with no sign reversal, and the single-cohort 2-period structure eliminates all negative-weight and staggered-timing concerns. The design's principal limitation — that parallel trends cannot be tested or subjected to HonestDiD sensitivity analysis due to zero pre-treatment periods — is a structural feature of the historical census data, not an estimation failure. The metadata documents a deliberate Rule iii(b) deviation (Column 1, no controls, instead of the author-preferred Column 3 with controls), which is internally consistent and transparently recorded. The stored consolidated result (TWFE = 2.1935) is trustworthy within the no-controls baseline specification.

**Note on metadata deviation:** The paper's preferred specification (Table 2 Col 3) includes district-level controls (log population density, linkable share, age structure). The no-controls baseline (Col 1) produces a nearly identical point estimate, suggesting controls have minimal influence on the headline result. However, users wishing to replicate the author-preferred specification should note that col 3 controls were not incorporated into the reanalysis.

---

## Per-reviewer verdicts

### TWFE (PASS)
- Estimate exactly reproduced: 2.19350070 vs stored 2.19350070 (diff = 6.99e-07, < 0.001%).
- No negative-weight problem: single cohort + 2 periods = pure 2x2 DiD with 100% TVU weight.
- Pre-trend test structurally impossible with 0 pre-periods; this is a data constraint, not a TWFE failure.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (PASS)
- CS-NT ATT = 2.2418 (simple and dynamic identical, as expected with single (g,t) cell).
- 2.2% gap from TWFE — negligible, within one SE; no sign reversal.
- Control group (never-treated, 514 districts) is large and unambiguous.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)
- Single-timing design: all treated units adopt simultaneously in 1861.
- No staggered adoption means no TVT (timing) component; Bacon decomposition collapses to a trivial 100% TVU 2x2 DiD.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (NOT_APPLICABLE)
- Zero pre-treatment periods (T=2: 1851 pre, 1861 post). Event study structurally impossible.
- Parallel trends is a fully maintained, untestable assumption.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Absorbing binary treatment, single cohort, 2 periods. No non-absorbing or continuous treatment variation to decompose.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper Auditor (NOT_APPLICABLE)
- No PDF found at pdf/304.pdf. Fidelity axis not evaluable from document extraction.
- Metadata records original_result = {beta_twfe: 2.1935, se_twfe: 0.4635}, which matches the reestimated value exactly.
- Full report: [`reviews/paper-auditor.md`](reviews/paper-auditor.md)

---

## Material findings (sorted by severity)

No FAIL items.

No WARN items.

Design observations (informational, not methodology failures):

- **Untestable parallel trends (structural):** With only 2 census periods (1851, 1861), the parallel-trends assumption cannot be tested through pre-trend analysis or HonestDiD sensitivity. This is a fundamental limitation of the historical data availability, not a study design error.
- **Small treated cluster count (N=24):** With only 24 treated districts, cluster-robust SE inference at the unit level may be imprecise. Wild-cluster bootstrap or bias-corrected SE would be preferable but are outside the scope of the standard template.
- **Documented Rule iii(b) deviation:** Metadata selects Column 1 (no controls) rather than Column 3 (author-preferred with controls). The estimates are nearly identical but users should be aware the stored result is not the author-preferred specification.

---

## Recommended actions

- No action needed on the stored TWFE result (2.1935) — it exactly reproduces the baseline specification and passes all applicable methodology checks.
- Consider updating metadata to also capture the author-preferred beta (Table 2 Col 3 with controls) as a secondary reference, to enable future fidelity comparison if the PDF is obtained.
- If the PDF (pdf/304.pdf) becomes available, re-run paper-auditor to formally validate the Column 1 reference value and enable the fidelity axis.
- Inform the pattern-curator: this paper is a clean example of a HIGH-rated 2x2 DiD — suitable as a calibration anchor (analogous to article 68, Tanaka 2014).

---

## Rating derivation

| Axis | Score |
|---|---|
| Methodology | M-HIGH (2 PASS, 0 WARN, 0 FAIL; 3 reviewers NOT_APPLICABLE or NOT_NEEDED) |
| Fidelity | F-NA (no PDF available) |
| **Combined** | **HIGH** (M-HIGH × F-NA: use methodology alone) |

---

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
