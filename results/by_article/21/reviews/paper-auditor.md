# Paper Auditor Report — Article 21 (Buchmueller & Carey 2018)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18
**Reviewer:** paper-auditor

---

## Applicability assessment

The paper auditor requires:
- `pdf/{id}.pdf` exists — NOT MET (no file at `pdf/21.pdf`)
- `results/by_article/{id}/results.csv` has a numeric `beta_twfe` — MET (beta_twfe = -0.00187)

Because the PDF is not available, direct numerical comparison against the paper's reported table is not possible from the PDF. However, the metadata `original_result` field records the paper's reported values:

- Paper's TWFE beta: -0.0019 (SE 0.0008)
- Paper's CS-DID ATT: -0.0018 (SE 0.0013)
- Our TWFE beta: -0.00187 (SE 0.000832)
- Our CS-NT ATT (dynamic): -0.001888 (SE 0.000809)

**Verdict: NOT_APPLICABLE** — PDF not present for automated fidelity audit.

---

## Informational note (from metadata original_result field)

Despite NOT_APPLICABLE status, the metadata records that our TWFE estimate (-0.00187) matches the paper's reported value (-0.0019) to within 1.6% — essentially exact given rounding conventions. The CS-NT dynamic estimate (-0.001888) matches the paper's CS-DID value (-0.0018) to within 4.9%. Both are well within standard tolerance thresholds. If a PDF were available, the audit would likely return WITHIN_TOLERANCE or EXACT for both estimates.
