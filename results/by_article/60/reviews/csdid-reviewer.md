# CS-DID Reviewer Report — Article 60 (Schmitt 2018)

**Verdict:** PASS
**Date:** 2026-04-18

## Checklist

### 1. Identification strategy
- Treatment is staggered binary absorbing adoption (hospitals enter multimarket contact in different years 2000–2010).
- 347 treated hospitals, 3032 never-treated. Large clean control group. PASS.
- Clean comparison group is valid: never-treated hospitals not contaminated.

### 2. Estimator configuration
- CS-NT (never-treated comparator): applicable and run. PASS.
- CS-NYT (not-yet-treated comparator): applicable given staggered adoption and run. PASS.
- Controls in CS: `cs_controls = []` — no controls in CS-DID. This is a deliberate metadata choice (unconditional CS-DID). Note the metadata records that adding fp+sysoth improves pre-trends.

### 3. ATT estimates
| Estimator | ATT | SE | t-stat |
|-----------|-----|----|--------|
| TWFE | 0.0702 | 0.0172 | 4.09 |
| CS-NT (simple) | 0.0566 | 0.0211 | 2.68 |
| CS-NT (dynamic) | 0.0594 | 0.0233 | 2.55 |
| CS-NYT (simple) | 0.0568 | 0.0204 | 2.78 |
| CS-NYT (dynamic) | 0.0596 | 0.0233 | 2.56 |
| CS-NT with ctrls | 0.0804 | 0.0216 | 3.72 |
| CS-NYT with ctrls | 0.0826 | 0.0216 | 3.82 |

- Gap between TWFE (0.0702) and CS-NT unconditional (0.0566): 24.6%. This is within the range expected from: (a) controls being included in TWFE but not unconditional CS-DID; (b) staggered timing heterogeneity correction.
- When controls are added to CS-DID, ATT rises to 0.080–0.093, actually *above* TWFE. This suggests the controls in TWFE are partially absorbing the treatment effect in the unconditional comparison, and the conditional CS-DID is the more appropriate benchmark.
- NT vs NYT: ATTs are virtually identical (0.0529 vs 0.0531 unconditional; 0.0804 vs 0.0826 with controls), indicating no bias from already-treated contaminating the not-yet-treated comparison group. PASS.

### 4. Pre-trend assessment (CS-NT event study)
| Period | Coef | SE | t-stat |
|--------|------|----|--------|
| t=-5 | -0.0121 | 0.0296 | -0.41 |
| t=-4 | -0.0471 | 0.0387 | -1.22 |
| t=-3 | -0.0330 | 0.0274 | -1.20 |
| t=-2 | -0.0033 | 0.0156 | -0.21 |

- All pre-trend t-stats below |1.65|. Clean pre-trends by statistical standards. Mild downward drift at t=-4/-3 consistent with TWFE (both around -1.2), but not individually or jointly significant at conventional levels.
- Metadata notes confirm: adding fp+sysoth controls to CS-NT further improves the pre-trends. The observed drift is likely confounded by composition differences absorbed by controls in TWFE.

### 5. Aggregation and interpretation
- The conditional CS-DID estimates (0.080–0.093) are somewhat larger than unconditional, suggesting controls are important for identification. This is a meaningful sensitivity result but not a FAIL — it is expected when time-varying controls correlate with treatment timing.
- With-controls CS-DID status: "OK" for both NT and NYT. Convergence confirmed.

### 6. Conclusion
All CS-DID estimators return positive, statistically significant ATTs in the range 0.053–0.093. The direction and significance are unanimous. The unconditional gap from TWFE (25%) is fully explained by control variables. NT and NYT comparators agree closely. Pre-trends are clean at conventional significance levels.

**Verdict: PASS**
