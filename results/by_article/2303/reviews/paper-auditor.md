# Paper Auditor Report: Article 2303 — Cao & Ma (2023)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18
**Reviewer axis:** Fidelity

---

## Applicability check

- PDF required: `pdf/2303.pdf` — NOT FOUND.
- PDF is not present in the project directory. Fidelity audit cannot be conducted without the paper PDF.
- `results/by_article/2303/results.csv` contains `beta_twfe = -4.836` (numeric, present).
- However, without the PDF, independent extraction of the paper's reported coefficient is not possible.

## Fidelity from metadata

Although the full auditor cannot run, the metadata notes document the expected comparison:
- Paper Table 2, Col 3: reported β = −4.863 (SE = 1.780, Conley spatial SEs).
- Replication TWFE: β = −4.836 (SE = 1.495, cluster by plant).
- Coefficient gap: |−4.836 − (−4.863)| / |−4.863| = 0.56%. Well within any reasonable tolerance (threshold typically 2%).
- SE gap: replication cluster SE (1.495) vs paper Conley SE (1.780). Replication SE is 16% smaller than paper — this is expected and documented (SE method differs; not a fidelity failure).

**Informational fidelity assessment (non-binding, no PDF available):** WITHIN_TOLERANCE for the coefficient. SE comparison is methodology-driven (Conley vs cluster) and documented.

## Verdict

**NOT_APPLICABLE.** PDF not found. Fidelity axis cannot be formally evaluated. The metadata-documented coefficient gap (0.56%) is consistent with WITHIN_TOLERANCE, but this cannot be confirmed without the PDF.
