# Paper Auditor Report: Article 65
# Akosa Antwi, Moriya & Simon (2013) — ACA Dependent-Coverage Mandate

**Verdict:** NOT_APPLICABLE

**Date:** 2026-04-18

---

## Applicability check

- PDF file required: `pdf/65.pdf`
- Status: FILE NOT FOUND. No PDF present in the `pdf/` directory for article ID 65.

The paper-auditor fidelity axis requires both:
1. `pdf/{id}.pdf` exists — NOT MET
2. `results/by_article/{id}/results.csv` has a numeric `beta_twfe` — MET (beta_twfe=0.0317)

Since condition 1 is not met, fidelity auditing cannot proceed. The fidelity axis is scored F-NA.

---

## Note on original_result

The metadata field `original_result` is an empty object `{}`. This means no reference TWFE estimate from the paper was recorded at the profiling stage. Even if the PDF were available, the absence of a stored `original_result.beta_twfe` would require manual extraction before comparison.

For reference: the paper (Akosa Antwi, Moriya & Simon 2013, AEJ:Economic Policy 5(4):514-544) reports an OLS/TWFE estimate of the ACA dependent-coverage mandate effect on any health insurance coverage of approximately 3.0–3.5 percentage points for the 19–25 age group, which is directionally consistent with our TWFE estimate of 3.17pp.

---

## Summary

No PDF available; fidelity axis not evaluable. Fidelity score: F-NA. The methodology rating will be used alone for the combined rating.

**Verdict: NOT_APPLICABLE**
