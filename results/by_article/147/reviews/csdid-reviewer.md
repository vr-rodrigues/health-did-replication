# CS-DID Reviewer Report — Article 147 (Greenstone & Hanna 2014)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. CS-DID applicability
- Treatment timing: staggered — CS-DID is appropriate.
- Both NT (never-treated) and NYT (not-yet-treated) comparison groups run — correct per metadata (`run_csdid_nt: true`, `run_csdid_nyt: true`).
- gvar_CS variable: correctly specified as adoption timing variable.

### 2. ATT estimates
| Estimator | ATT | SE | Significant? |
|-----------|-----|-----|--------------|
| CS-NT (aggregated) | 6.965 | 19.941 | No (p~0.73) |
| CS-NYT (aggregated) | 6.516 | 19.195 | No (p~0.73) |
| CS-NT simple | 7.711 | 20.211 | No |
| CS-NT dynamic | 9.442 | 22.866 | No |
| CS-NYT simple | 7.191 | 18.418 | No |
| CS-NYT dynamic | 8.992 | 20.312 | No |

All CS-DID estimates are statistically insignificant. The point estimates are directionally consistent with TWFE (positive, ~7-9 µg/m³ range) but carry very wide standard errors.

### 3. Comparison with TWFE
- TWFE: 8.015 (SE=11.926) — also insignificant
- CS-NT: 6.965 (SE=19.941) — consistent direction, wider SE
- The direction agreement is reassuring, but neither estimator detects a significant effect. The wider CS-DID SEs reflect the cost of using group-time ATTs with limited sample (N=1172, unbalanced).

### 4. Control variable discrepancy
- TWFE uses 9 controls (scaprange, scappolicy, tauSCL, tauSCR, catrange, tauCATL, tauCATR, lit_urban, mean_ctrl).
- CS-DID uses NO controls (`cs_controls: []`).
- This is a known limitation documented in the notes: "CS-DID does NOT control for SCAP — results differ from TWFE by design."
- The SCAP policy controls are critical in the original specification. The CS-DID estimates are therefore measuring a different estimand — omitting concurrent policy confounders. This is a substantial comparability concern.

### 5. Pre-trends (CS event study)
| Horizon | CS-NT | SE | CS-NYT | SE |
|---------|-------|-----|--------|-----|
| h=-5 | -55.25 | 20.30 | -39.98 | 23.25 |
| h=-4 | -49.07 | 31.47 | -33.21 | 33.89 |
| h=-3 | -24.14 | 25.81 | -17.43 | 25.87 |
| h=-2 | -4.38 | 14.16 | -1.18 | 14.34 |

CS-NT pre-trends at h=-5 and h=-4 are even larger than TWFE (-55 and -49 vs -36 and -30). This exacerbates the parallel trends concern. The CS estimator, by using group-specific trends, is revealing that control cities on average had much higher SPM levels prior to treated cities' adoption timing — suggesting selection into treatment based on pre-existing pollution levels.

### 6. NOT_NEEDED check
- Not applicable here — CS-DID is always run.

### 7. Treatment group heterogeneity
- With `gvar_CS` capturing staggered adoption, group-time ATTs are computed. The aggregation to a single ATT averages across cohorts. Given the wide SEs, there is likely substantial heterogeneity across cohort-time cells, which the aggregated ATT masks.

## Summary
CS-DID and TWFE estimates are directionally consistent but both insignificant. The pre-trends in CS-DID are large (larger than in TWFE), reinforcing the parallel trends violation concern. The inability to include SCAP policy controls in CS-DID means the comparison is not clean — the CS-DID estimates are confounded by the concurrent policy.

**Verdict: WARN** — Large pre-trends across all estimators; CS-DID cannot control for concurrent SCAP policy; all estimates statistically insignificant.
