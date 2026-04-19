# Paper Auditor Report — Article 271

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18
**Reviewer:** paper-auditor

---

## 1. Applicability check

- `pdf/271.pdf`: NOT FOUND. Article PDF is not available in the replication package.
- Paper-auditor requires the PDF to verify numerical fidelity against the published table.
- **Verdict: NOT_APPLICABLE** (no PDF to audit against).

## 2. Informational fidelity check (metadata reference only)

Although the PDF is unavailable, the metadata encodes the original result:
- `original_result.beta_twfe = 67.81` (Table 3, Col 2, Stata: reghdfe hyv_major d_dmaq23 pr at, absorb(i.code i.year) vce(cluster code))
- `results.csv beta_twfe = 67.8101`

Discrepancy: |67.8101 - 67.81| / 67.81 = 0.00015% — effectively exact machine-precision replication.

This is informational only; formal fidelity axis is NOT_APPLICABLE per protocol (no PDF).

## 3. Notes

- The original paper (Sekhri & Shastry 2024, AEJ:Applied) reports this as Table 3, Column 2.
- The health outcomes (Table 9, child height/weight from IHDS/NFHS) use restricted data not in the replication package. The agricultural first-stage outcome is the primary replicable result.
