# Skeptic report: 358 — Bargain, Boutin, Champeaux (2019)

**Overall rating:** MODERATE
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (WARN), bacon (N/A — single timing), honestdid (N/A — no event study), dechaisemartin (NOT_NEEDED), paper-auditor (N/A — no PDF)

---

## Executive summary

Bargain, Boutin, Champeaux (2019) estimate the effect of exposure to women's political participation during the 2011 Egyptian Arab Spring on intrahousehold empowerment (composite index `ibp`), using a 2x2 DiD design with two survey waves (2008 and 2014) and 272 municipalities classified by protest intensity. The TWFE coefficient replicates exactly (beta = 4.181, SE = 1.053 vs. paper's 1.058 — trivially different due to degrees-of-freedom adjustment). The positive effect is corroborated by CS-DID NT (4.591), though that estimate omits the rich control set used in TWFE, making direct comparison imperfect. One anomaly warrants investigation: the "with controls" CS-DID path returns 0, which is likely a template artefact related to how `cs_controls = []` interacts with the doubly-robust estimator. The stored TWFE result is reliable; the CS-DID comparison is directionally consistent but should be read with the covariate caveat in mind.

---

## Per-reviewer verdicts

### TWFE (PASS)

- Two time periods (2008, 2014) with a single treatment event — the canonical 2x2 DiD; TWFE = clean DiD. No negative-weighting or heterogeneous timing pathology is possible.
- Coefficient replicates exactly (4.181); SE difference (1.053 vs. 1.058) is attributable to feols small-sample correction and is not a concern.
- The inability to test pre-trends is inherent to the two-period data structure, not a replication flaw.

Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (WARN)

- CS-DID NT (no controls) yields 4.591 — directionally consistent with TWFE but ~10% larger, plausibly explained by the absence of covariates in the CS-DID specification (TWFE uses 30 controls including post × covariate interactions).
- `att_cs_nt_with_ctrls` returns 0 with `cs_nt_with_ctrls_status = "OK"` — anomalous; likely a template artefact when `cs_controls = []` but the with-controls estimation path is triggered.
- Covariate mismatch between TWFE and CS-DID estimates is a methodological note, not a fatal flaw.

Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (N/A)

Skipped. `treatment_timing == "single"` — Bacon decomposition requires staggered adoption across multiple cohorts.

### HonestDiD (N/A)

Skipped. `has_event_study == false` and 0 pre-periods — HonestDiD requires an event study with at least 3 pre-periods.

### de Chaisemartin (NOT_NEEDED)

Binary absorbing treatment, single cohort, two periods — the 2x2 DiD structure is immune to negative-weight critique. DID_M diagnostics add nothing here.

Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

### Paper-auditor (N/A)

PDF not found at `pdf/358.pdf`. Fidelity axis not evaluable; rating uses methodology axis alone.

---

## Material findings (sorted by severity)

**WARN items:**

- **cs_nt_with_ctrls returns 0 (anomalous).** The doubly-robust CS-DID path with controls produces a coefficient of exactly 0 and no SE despite `cs_nt_with_ctrls_status = "OK"`. This is a template artefact, not a substantive finding, but it should be resolved to make the CS-DID comparison with covariates interpretable.
- **CS-DID vs. TWFE covariate mismatch.** CS-DID NT uses no controls while TWFE uses 30. The 10% gap (4.181 vs. 4.591) is expected given this, but the comparison is not fully apples-to-apples. If a CS-DID with controls were available and working, it would provide a cleaner methodological comparison.

---

## Recommended actions

- **Investigate `att_cs_nt_with_ctrls = 0` anomaly.** Check whether `cs_controls = []` causes the doubly-robust path in the R template to silently return 0 rather than flagging an error. If the template requires at least one control for the DR estimator, add a representative covariate (e.g., `urb` or `poorest`) to `cs_controls` and re-run.
- **Add PDF for article 358** to enable paper-auditor fidelity verification on future runs. The coefficient match is strong (exact at 3 decimals) but formal fidelity audit is not possible without the PDF.
- **No methodological reinterpretation needed.** The 2x2 DiD with single treatment event is the simplest valid DiD design; all modern robustness concerns (staggered timing, negative weights, sensitivity to pre-trend violations) are structurally inapplicable.

---

## Individual reports

- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
