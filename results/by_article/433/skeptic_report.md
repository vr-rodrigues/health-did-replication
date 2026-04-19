# Skeptic report: 433 — DeAngelo, Hansen (2014)

**Overall rating:** LOW
**Date:** 2026-04-18
**Reviewers run:** twfe (PASS), csdid (WARN), bacon (N/A — single timing), honestdid (WARN), dechaisemartin (NOT_NEEDED), paper-auditor (NOT_APPLICABLE — no PDF)

---

## Executive summary

DeAngelo & Hansen (2014) estimate the causal effect of an Oregon State Police mass layoff (February 2003) on traffic fatalities per VMT using a state-month panel (2000–2005, 47 states). The paper's headline TWFE coefficient is 0.7103 (SE=0.1281), interpreted as a ~5% semi-elasticity on fatalities. Our replication produces 0.6999 (SE=0.1329) — a 1.46% gap attributable to the missing Vermont observation in the replication package. The direction and significance of the main result are confirmed. However, two methodological concerns reduce confidence in the stored consolidated result: (1) three of five pre-periods in the CS-DID event study are statistically significant at conventional levels (t=-2, t=-4, t=-6), suggesting possible parallel-trends violations that cannot be resolved with a single treated unit; and (2) HonestDiD sensitivity analysis shows the average and first-period ATTs are D-FRAGILE (robust only at Mbar=0 — any linear pre-trend violation eliminates significance), while the peak-period effect (t=+1) is D-MODERATE (robust through Mbar≈0.25). The stored consolidated value (0.6999) is a reliable reproduction of the paper's TWFE, but causal interpretation rests on the untestable assumption of exact parallel trends for Oregon — an assumption that the CS-DID event study calls into question. Users should treat the peak-period finding (large immediate jump at t=+1) as the most credible feature of the result, while applying caution to the average ATT.

---

## Per-reviewer verdicts

### TWFE (PASS)

- Specification correctly matches the paper: `fat_vmt ~ treatment + precip + temp + un_rate + max_speed | fips + year + month`, with state-level clustering. Equivalent to the paper's `areg` with absorbed FIPS FEs.
- Stored coefficient 0.6999 is within 1.46% of the paper's 0.7103; gap is fully explained by the missing Vermont observation (original data file absent from package).
- Pre-trend pattern in TWFE event study is oscillatory (not monotone), with only t=-4 individually significant at 5%; not indicative of a systematic confounding trend.
- Full report: [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)

### CS-DID (WARN)

- CS-NT ATT (no controls) = 0.6979, virtually identical to TWFE (0.28% gap) — expected and reassuring for a single-treated-unit design.
- CS-NT SE is 2.72× larger than TWFE SE (0.3613 vs 0.1329), correctly reflecting true imprecision with 1 treated unit; t-stat drops from 5.27 (TWFE) to 1.89 (CS-NT) — marginally significant.
- CS-NT pre-trend violations: t=-6 (t-stat 4.49), t=-4 (t-stat 6.29), t=-2 (t-stat 2.83) — 3 of 5 pre-periods statistically significant.
- CS-NT with controls = 1.7327 (2.47× TWFE) — flagged as anomaly likely due to propensity-score instability with a single treated unit.
- Full report: [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)

### Bacon (N/A)

- Single treatment timing (Oregon, Feb 2003; 46 never-treated controls). Bacon decomposition is trivial with 100% Treated-vs-Untreated weight and no forbidden comparisons. Correctly skipped.
- Full report: [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)

### HonestDiD (WARN)

- Design credibility: D-FRAGILE for average ATT (rm_avg_Mbar=0; CI includes zero at Mbar=0.25) and first-period ATT (rm_first_Mbar=0; CI includes zero even at Mbar=0).
- Design credibility: D-MODERATE for peak ATT (rm_peak_Mbar≈0.25–0.50; robust through Mbar=0.25 for both TWFE and CS-NT).
- The observed significant pre-periods in CS-NT (Mbar effectively > 0 for this paper) mean the D-FRAGILE avg/first findings are realistic, not hypothetical.
- Full report: [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)

### de Chaisemartin (NOT_NEEDED)

- Binary absorbing single-timing treatment. No staggered adoption, no continuous dose, no non-absorbing switching. DCM offers no additional insight over TWFE/CS-DID for this design.
- Full report: [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)

---

## Material findings (sorted by severity)

**WARN items:**

1. **CS-NT pre-trend violations** (csdid-reviewer): Three of five pre-periods in the CS-DID event study are statistically significant at 5% (t=-2: t-stat 2.83; t=-4: t-stat 6.29; t=-6: t-stat 4.49). The oscillatory pattern reduces concern about a monotone confounding trend, but the significance cannot be dismissed with only 1 treated unit.

2. **HonestDiD D-FRAGILE average ATT** (honestdid-reviewer): The average ATT (TWFE avg = 2.14; CS-NT avg = 1.16) is robust only under the assumption of exactly parallel pre-trends (Mbar=0). At Mbar=0.25, both TWFE and CS-NT average confidence intervals include zero. Given the CS-NT pre-trend violations above, the plausible Mbar for this paper is likely above 0.25.

3. **CS-NT with-controls anomaly** (csdid-reviewer): DR-CS-DID with controls returns 1.7327, 2.47× larger than TWFE. Likely a propensity-score instability artifact in the single-treated-unit setting. The no-controls CS-NT (0.6979) is the reliable comparison.

---

## Recommended actions

- **For the peak-period finding (t=+1, ~3–4 fatalities/VMT increase in the first month)**: This is the most credible element of the paper. HonestDiD is robust through Mbar≈0.25 for the peak. Users may cite this with moderate confidence.
- **For the average ATT interpretation**: Flag as D-FRAGILE. The paper's aggregate interpretation depends on months t=3 and t=5 (large spikes in event study); these are not robust to even mild pre-trend violations.
- **For the repo-custodian**: The original data file `fatal_analysis_file_2014.dta` is missing; `synth_file_2014.dta` (47 states, excl. VT) was used as substitute. If the original file becomes available, re-run to check whether Vermont's inclusion changes results materially.
- **For the pattern-curator**: Consider documenting Pattern 51 — "Single-treated-unit propensity score instability in DR-CS-DID": when there is exactly 1 treated unit, the doubly-robust CS-DID estimator can return inflated ATTs (here: 2.47× TWFE) due to propensity score near-separation. The no-controls CS-NT is the reliable comparator in this design.
- **For the user**: The design is methodologically sound (single-timing, absorbing binary, balanced panel, 46 never-treated controls), but identification ultimately rests on Oregon-specific parallel trends — an assumption that the CS-DID event study's significant pre-periods challenge. Wild cluster bootstrap (or randomization inference with only 1 treated unit) would be a more appropriate uncertainty quantification than clustered SEs.

---

## Rating derivation

| Axis | Score |
|---|---|
| twfe-reviewer | PASS |
| csdid-reviewer | WARN |
| bacon-reviewer | NOT_APPLICABLE (excluded) |
| honestdid-reviewer | WARN |
| dechaisemartin-reviewer | NOT_NEEDED (excluded) |
| **Methodology count** | 1 PASS, 2 WARN, 0 FAIL |
| **M-score** | M-LOW (≥ 2 WARN, no FAIL) |
| paper-auditor | NOT_APPLICABLE (no PDF; F-NA) |
| **F-score** | F-NA |
| **Combined** | M-LOW × F-NA → use methodology alone = **LOW** |

---

## Individual reports

- [`reviews/twfe-reviewer.md`](reviews/twfe-reviewer.md)
- [`reviews/csdid-reviewer.md`](reviews/csdid-reviewer.md)
- [`reviews/bacon-reviewer.md`](reviews/bacon-reviewer.md)
- [`reviews/honestdid-reviewer.md`](reviews/honestdid-reviewer.md)
- [`reviews/dechaisemartin-reviewer.md`](reviews/dechaisemartin-reviewer.md)
- [`reviews/paper-auditor.md`](reviews/paper-auditor.md)
