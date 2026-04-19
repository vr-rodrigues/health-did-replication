# Paper Auditor Report — Article 210 (Li et al. 2026)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability assessment
Applicability rule: `pdf/{id}.pdf` exists AND `results/by_article/{id}/results.csv` has numeric `beta_twfe`.

- PDF at `pdf/210.pdf`: **NOT FOUND**
- `beta_twfe` in results.csv: 0.01854 (numeric) — YES

Applicability gate FAILS: PDF not present at canonical path. Cannot perform automated text extraction and comparison against paper table.

**Verdict: NOT_APPLICABLE** — fidelity axis not evaluable via automated auditor.

## Manual fidelity note (informational only)
Despite NOT_APPLICABLE status, fidelity can be assessed manually from metadata:
- Paper (Table 3 Col 3): TWFE = 0.019, SE = 0.006
- Our TWFE: 0.01854, SE = 0.00574
- Deviation: 2.44% on point estimate, 4.3% on SE
- This would qualify as **WITHIN_TOLERANCE** (< 5% deviation) if the PDF auditor were run

- Paper CS result (csdid simple): 0.012
- Our CS-NYT simple: -0.00649
- Deviation: 154% with sign reversal — NOT a rounding difference, reflects balancing/specification gap

The TWFE fidelity is excellent; the CS divergence is a design/balancing implementation issue, not a paper transcription error. If F-score is applied from this manual check: F-HIGH on TWFE fidelity; the CS discrepancy is a methodology issue (covered by csdid-reviewer), not a paper text transcription error.
