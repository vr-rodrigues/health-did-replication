# Paper Auditor Report — Article 304

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18
**Reviewer:** paper-auditor

---

## Applicability check

Applicability rule: `pdf/{id}.pdf` exists AND `results/by_article/{id}/results.csv` has a numeric `beta_twfe`.

- PDF check: `pdf/304.pdf` — **file not found** (no PDF directory exists in the replication package).
- `beta_twfe` in results.csv: 2.1935 — numeric, present.

Since the PDF does not exist, the paper-auditor cannot compare the stored TWFE estimate against the paper's reported value via OCR/table extraction. The fidelity axis is not evaluable.

**Note:** The metadata `original_result` field does record `beta_twfe = 2.1935` and `se_twfe = 0.4635`, and the re-estimated values match exactly (diff < 0.001%). However, since the source of this reference value cannot be independently verified against the PDF in this run, the formal fidelity verdict remains NOT_APPLICABLE.

**Verdict: NOT_APPLICABLE**
