# Paper Auditor Report — Article 305 (Brodeur & Yousaf 2020)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability check
- PDF at `pdf/305.pdf`: NOT FOUND
- Numeric `beta_twfe` in results.csv: -1.348 (present)

The paper-auditor requires both the PDF and a numeric beta_twfe to run a fidelity check. Since the PDF is not available, the fidelity axis cannot be evaluated.

## Note on specification mismatch
Even if the PDF were available, there is a known specification discrepancy:
- `original_result.beta_twfe` in metadata = -2.658 (Col 1, no division FEs)
- Stored results.csv beta_twfe = -1.348 (Col 3, with division×year FEs)

The implementation chose Col 3 because it is the specification used for the paper's event study (Figure 2) and avoids spurious pre-trends. If the paper-auditor were run against the stored value of -1.348 and the paper's Col 3 value (-1.348, SE=0.523), the match would be exact. Against Col 1 (-2.658), the mismatch would trigger FAIL. This ambiguity would need resolution before a fidelity verdict could be issued.

## Fidelity score: F-NA
Not factored into final rating.
