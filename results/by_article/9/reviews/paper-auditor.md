# Paper Auditor Report: Article 9 — Dranove et al. (2021)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

---

## Applicability check
- `pdf/9.pdf` exists: NO — PDF not found in `pdf/` directory.
- `beta_twfe` in results.csv is numeric: YES (-0.17631).
- **Per protocol: paper-auditor requires `pdf/{id}.pdf` to exist. PDF not present → NOT_APPLICABLE.**

---

## Supplementary numerical fidelity check (from metadata.original_result)

Although the PDF is absent, the metadata contains the original paper's published estimates, enabling a partial fidelity assessment:

| Metric | Paper (original_result) | Our computation | Absolute diff | % diff |
|--------|------------------------|-----------------|---------------|--------|
| beta_twfe | -0.1763 | -0.17631 | 0.00001 | 0.003% |
| se_twfe | 0.0484 | 0.04839 | 0.00001 | 0.02% |
| att_csdid_nt | -0.2019 | -0.20840 | 0.00650 | 3.2% |
| att_csdid_nyt | -0.2084 | -0.21335 | 0.00495 | 2.4% |

- TWFE: **EXACT** match (within floating-point precision).
- CS-NT: 3.2% gap — documented in metadata notes as due to did v2.3.0 package version difference affecting cohort-dropping behavior when controls are included. Our specification (cs_controls=[]) is methodologically superior; the paper's version dropped early cohorts.
- CS-NYT: 2.4% gap — same explanation.

---

## Summary
PDF not available for page-by-page numerical audit. Based on metadata-stored original results, the TWFE estimate matches exactly (0.003%). CS-DID gaps (3.2%, 2.4%) are explained by a known package version interaction documented in the metadata notes. Fidelity axis is formally NOT_APPLICABLE per protocol but informal supplementary check shows EXACT TWFE replication.

**Verdict: NOT_APPLICABLE**
(Informal supplementary fidelity: EXACT for TWFE)
