# Paper Auditor Report — Article 254

**Article:** Gandhi et al. (2024) — The Effect of Medicaid Reimbursement Rates on Nursing Home Staffing
**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

---

## Applicability check

Paper auditor requires:
1. `pdf/{id}.pdf` exists → **NOT FOUND** (no file at pdf/254.pdf)
2. `results/by_article/254/results.csv` has numeric `beta_twfe` → TRUE (beta_twfe = 5.491)

Since condition 1 fails, numerical fidelity to the paper cannot be assessed. The paper's PDF is not available for extraction of the original regression table.

**Additional context from metadata:** The paper's `original_result` field is an empty object `{}`, confirming that no comparable original beta was recorded during profiling. This is consistent with the design mismatch: our `beta_twfe` reflects the binary high-Medicaid split, not the paper's continuous treatment coefficient, so even if the PDF were available, direct numerical comparison would require the paper to report a binary-split estimate as a headline number — which it does not.

---

**Verdict: NOT_APPLICABLE** — No PDF available; fidelity axis cannot be evaluated. Fidelity score: F-NA (not factored into combined rating).
