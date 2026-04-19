# Paper Auditor Report — Article 242

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

## Applicability check

- PDF at `pdf/242.pdf`: NOT FOUND
- `original_result` in metadata.json: `{}` (empty — no paper-reported numeric TWFE coefficient recorded)

## Reason

No PDF is available for automated extraction of the paper's reported coefficient. Additionally, the `original_result` field in metadata.json is empty, indicating no paper-reported TWFE estimate was pre-loaded for comparison. Fidelity comparison cannot be performed.

## Note on available results

The computed beta_twfe = 0.01944 (SE = 0.00756) is available in results.csv. If the paper-reported coefficient is later added to metadata.json under `original_result.beta`, a fidelity check can be performed by comparing against the Stata specification in the metadata notes (reghdfe with shale_play×year FEs, baseline-×-year controls, balanced sample).

**Verdict:** NOT_APPLICABLE — fidelity axis not evaluable.
