# Paper Auditor Report — Article 380
## Kuziemko, Meckel & Rossin-Slater (2018)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

---

## Reason

The PDF file `pdf/380.pdf` does not exist in the replication package. Without the PDF, numerical fidelity between the paper's reported Table 3 estimate and our computed `beta_twfe` cannot be assessed.

The `original_result` field in metadata.json references "Table 3 (after on Black mortality, with county-year controls)" but no numeric value is stored in `original_result.beta`. Fidelity auditing is therefore not possible.

---

## Stored TWFE Estimate

For reference, our computed TWFE estimate is:
- `beta_twfe` = 0.0683 (SE = 0.0733)
- `beta_twfe_no_ctrls` = 0.0613 (SE = 0.0697)

These are not compared to the paper because no PDF is available.

---

*Fidelity axis: F-NA. Not factored into combined rating.*
