# Paper Auditor Report — Article 323

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18
**Article:** Prem, Vargas, Mejia (2023) — "The Rise and Persistence of Illegal Crops"

---

## Applicability assessment

The paper auditor requires:
1. `pdf/{id}.pdf` to exist — `pdf/323.pdf` does NOT exist in the working directory.
2. `results/by_article/{id}/results.csv` to have a numeric `beta_twfe` — confirmed: `beta_twfe = 0.6427`.

Condition 1 fails. The PDF is not available for direct numerical verification.

---

## Fidelity notes (from metadata alone)

The `original_result` in metadata records:
- `beta_twfe = 0.300`, `se_twfe = 0.120` (Table 1, Column 1, continuous treatment specification)
- The stored `beta_twfe = 0.6427` in results.csv is from the **binarized** replication specification (high vs. low suitability municipalities), NOT the paper's continuous treatment.

This discrepancy is **by design and fully documented**: the paper's coefficient is in continuous-treatment units (per unit of suitability index), while the replication uses a binary high/low split. These are not comparable numbers.

Even if the PDF were available, a direct numerical fidelity check would require identifying the paper's ATT for the binarized specification (which is not reported in the paper) or the paper's continuous-treatment coefficient scaled to binary units. Neither is straightforward.

**Verdict: NOT_APPLICABLE** — PDF not available; and even if it were, the estimand mismatch (continuous vs. binary treatment) makes direct numerical fidelity comparison ill-defined. Fidelity axis not evaluable.
