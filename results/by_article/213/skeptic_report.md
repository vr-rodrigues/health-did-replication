# Skeptic report: 213 — Estrada & Lombardi (2022)

**Overall rating:** MODERATE
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (PASS), bacon (N/A — single timing), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE — no PDF/reference beta)

---

## Executive summary

Estrada & Lombardi (2022, AEJ:Applied) exploit Chile's 2014 reform that granted permanent contracts to temporary teachers with 3+ years of consecutive seniority, using a sharp seniority-cutoff DiD (3yr-seniority treated vs. 2yr-seniority control). The headline result is a ~3.7pp reduction in the probability of leaving one's school within one year (TWFE = -0.0372, SE = 0.0103, t = 3.63). The TWFE specification is correctly implemented: group + year FEs without unit FEs is the appropriate adaptation for this RCS design and matches the authors' exact specification. CS-DID (NT) returns -0.0299, directionally consistent and approximately 20% smaller — a gap attributable to RCS aggregation mechanics (Pattern 25), not misspecification. All four estimators (TWFE, CS-NT, SA, Gardner) agree on sign. The single methodological concern is HonestDiD sensitivity: the result is classified D-FRAGILE because the CI at Mbar=0 is [-0.058, -0.002], and any positive Mbar (allowing even marginal pre-trend drift) expands the CI to include zero. However, this fragility is mechanically driven by having only 1 post-period and an already-tight baseline CI; the observed pre-trends are oscillating (not drifting), which is reassuring. The sharp seniority cutoff provides additional quasi-experimental credibility not captured by HonestDiD. The stored consolidated result (TWFE = -0.0372) is a correctly specified implementation of the paper's main estimate, and the causal direction is robust across all modern estimators. The fidelity axis cannot be assessed (no PDF, no reference beta in metadata). Rating: MODERATE under the M-MOD x F-NA rubric.

---

## Per-reviewer verdicts

### TWFE (PASS)
- Specification matches Table 2, Col 1: group indicator + year FEs + school-level clustering; no controls (`unica_sem_controles`).
- Pre-trends are clean: t-4/t-3/t-2 oscillate with individual t-stats < 1.6; no monotonic drift.
- Single-timing design eliminates staggered-timing bias; Gardner/BJS replicate TWFE exactly.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (PASS)
- ATT (CS-NT) = -0.0299, direction consistent with TWFE (-0.0372); 20% gap explained by RCS aggregation (Pattern 25).
- Control group (2yr-seniority teachers) is credible: same system, differentiated only by one year of seniority at the reform cutoff.
- NYT correctly not run (single timing; NT = NYT by construction).
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (NOT_APPLICABLE)
- Single-timing design: all treated units adopt in 2014; no staggered adoption. Bacon decomposition reduces to 100% TVU and is uninformative. Correctly not run.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (WARN)
- All targets (first/avg/peak) classified D-FRAGILE: sign preserved only at Mbar=0; CI crosses zero at Mbar=0.25 for TWFE and CS-NT.
- Mitigating context: fragility is structurally driven by n_post=1 + tight baseline CI; pre-trends are oscillating (not drifting), inconsistent with a genuine parallel-trends violation.
- Sharp seniority-cutoff design provides credibility beyond what HonestDiD's Delta^RM model captures.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)
- Absorbing binary treatment, single timing, RCS data — none of the conditions for DcDH relevance are met.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

---

## Material findings (sorted by severity)

**WARN items:**
- **HonestDiD D-FRAGILE (all targets):** The headline effect is not robust to even Mbar=0.25 (marginal pre-trend assumption). The result relies on an approximate parallel-trends assumption. Mitigated by: (a) oscillating rather than drifting pre-trends; (b) sharp seniority-cutoff design; (c) unanimous directional agreement across 4 estimators.

**Informational (not warn/fail):**
- **RCS aggregation gap (TWFE vs CS-NT ~20%):** Consistent with Pattern 25. Direction unchanged. Not flagged as a warning given magnitude is well within the normal RCS divergence range and the direction is preserved.
- **Fidelity not assessable:** No PDF and no reference beta in `original_result`. The stored TWFE = -0.0372 is directionally plausible per the metadata notes but cannot be formally verified.

---

## Recommended actions

- Populate `original_result.beta_twfe` in `data/metadata/213.json` with the Table 2 Col 1 point estimate from Estrada & Lombardi (2022, AEJ:Applied) when the PDF becomes available. This will enable formal fidelity auditing and may upgrade the fidelity axis from F-NA to F-HIGH or F-MOD.
- If the PDF is accessible, add it to `pdf/213.pdf` and re-run the paper-auditor to complete the 3-axis rubric.
- No action needed on TWFE or CS-DID implementation — both are correctly specified.
- No action needed on the HonestDiD WARN: it reflects a genuine (if mechanically driven) limitation of the single-post-period design, not a correctable implementation issue. Users should note in any downstream analysis that the result depends on approximate parallel trends, and cite the sharp cutoff design as supporting evidence.
- No pattern-curator action needed: the RCS aggregation gap is already documented as Pattern 25.

---

## Individual reports
- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
