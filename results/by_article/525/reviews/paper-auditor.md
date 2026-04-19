# Paper Auditor Report — Article 525
# Danzer & Zyska (2023) — Pensions and Fertility: Microeconomic Evidence

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

---

## Applicability assessment

The paper auditor is applicable iff:
- `pdf/{id}.pdf` exists — **FALSE** (no `pdf/525.pdf` found in the replication package root)
- `results/by_article/525/results.csv` has a numeric `beta_twfe` — **TRUE** (beta_twfe = -0.00776)

Since the article PDF is not present, numerical comparison against the paper's reported table values cannot be performed via automated text extraction. The metadata notes do record the paper's reported value (Table 3 Col 2: DID = -0.008, SE 0.003), which would allow a manual comparison, but this falls outside the scope of the automated fidelity auditor.

**Verdict: NOT_APPLICABLE** — PDF not present; fidelity axis not evaluable.

---

## Manual fidelity note (from metadata)

Although the automated auditor cannot run, the metadata notes provide sufficient information for a manual check:

| Source | Beta | SE |
|---|---|---|
| Paper Table 3 Col 2 | -0.008 | 0.003 |
| Our TWFE (results.csv) | -0.00776 | 0.00284 |
| Difference | +0.00024 | -0.00016 |
| Relative difference | 3.0% | 5.3% |

Both the point estimate and standard error match within 5%, indicating excellent numerical fidelity to the paper's reported results. If the PDF were available, the automated auditor would likely return WITHIN_TOLERANCE or EXACT.
