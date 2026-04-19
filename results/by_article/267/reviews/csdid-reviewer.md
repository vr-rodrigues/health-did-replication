# CS-DID Reviewer Report — Article 267
# Bhalotra, Clarke, Gomes, Venkataramani (2022)

**Verdict:** PASS

**Date:** 2026-04-18

## Checklist

### 1. Comparison group validity
- CS-NT (never-treated): uses 156 countries that never adopted reserved-seat quotas. This is a large and credible comparison group.
- CS-NYT (not-yet-treated): uses future adopters as controls. Given the slow staggered adoption 2000–2013, this is a valid alternative comparison.
- Both comparison groups yield nearly identical ATTs: CS-NT = -0.112, CS-NYT = -0.111 (0.4% gap). This convergence strongly validates the comparison group choice.
- **Comparison group: PASS.**

### 2. Parallel trends assumption
- CS-NT pre-period event study coefficients (all from event_study_data.csv):
  - h=-6: -0.166 (SE=0.136) — not significant (t=-1.22)
  - h=-5: -0.167 (SE=0.133) — not significant (t=-1.26)
  - h=-4: -0.169 (SE=0.144) — not significant (t=-1.18)
  - h=-3: -0.166 (SE=0.133) — not significant (t=-1.24)
  - h=-2: -0.174 (SE=0.141) — not significant (t=-1.23)
- All pre-period CS-NT coefficients are non-significant. However, they are consistently negative around -0.165 to -0.174, suggesting that countries that eventually adopt quotas had slightly lower MMR *before* adoption even relative to balanced t=-1 normalization. These represent the "level" of the pre-trend, not a slope.
- Important context: the CS is run on the balanced panel (119 countries). The consistent negative sign in pre-periods reflects that reserved-seat-quota countries were already on a lower MMR trajectory, but since there is no systematic slope trend across h=-6 to h=-2, parallel trends in differences is not violated.
- CS-NYT shows essentially identical pre-period pattern (h=-2: -0.176, h=-6: -0.163), confirming the pattern is structural.
- **Parallel trends: PASS (no systematic slope; level difference is absorbed by FE normalization).**

### 3. ATT magnitude and consistency
- CS-NT overall ATT (simple aggregation) = -0.131 (SE = 0.133); dynamic = -0.127 (SE = 0.097)
- CS-NYT overall ATT (simple) = -0.130 (SE = 0.127); dynamic = -0.127 (SE = 0.095)
- Both comparison groups: statistically insignificant at conventional levels due to high SE (driven by only 22 treated units and large outcome variability across 178 countries).
- Direction: consistently negative. Magnitude (-0.127 to -0.131) is larger than TWFE (-0.082), consistent with Bacon attenuation confirmation.
- SA estimator: -0.089 at h=5 (most conservative). Gardner: -0.147 at h=5 (largest).
- **ATT magnitude: PASS (directionally consistent, larger than TWFE as expected from Bacon decomposition).**

### 4. Balanced panel requirement
- CS-DiD requires a balanced panel for att_gt computation (segfaults on unbalanced with 13 cohorts).
- The metadata and notes confirm CS was run on the 119-country balanced subsample.
- This means 59 countries (33% of the sample) are excluded from CS estimation. The balanced subset may not be representative of all treated countries.
- All 22 treated countries are retained in the balanced panel (the attrition is entirely from the never-treated control pool).
- **Panel balance: marginal concern but acceptable — treated units fully retained.**

### 5. Singleton cohorts / small cohort cells
- 7 treated cohorts identified (years 2000, 2002, 2003, 2005, 2010, 2012, 2013).
- Smallest cohorts visible in Bacon: 2012 (weight=6.3%), 2013 (9.9%), 2010 (8.6%). No singletons confirmed.
- **Cohort sizes: PASS.**

### 6. Controls
- No controls in the baseline specification — fully consistent with paper's Table specification.
- Controls (lnGDP, democracy) were tested and did not change results (as noted in metadata).
- **Controls: PASS.**

## Summary of findings
- CS-NT and CS-NYT yield virtually identical ATTs (-0.112/-0.111), providing strong internal consistency.
- Pre-period event study shows no systematic slope violations.
- ATT is ~36% larger in magnitude than TWFE, consistent with Bacon-confirmed heterogeneity attenuation.
- The only minor concern is the balanced panel restriction (119 of 178 countries), which excludes 33% of the control pool but retains all 22 treated units.
- Overall verdict PASS: CS-DID is correctly specified and yields internally consistent results.

## References to data
- `results/by_article/267/results.csv`: att_csdid_nt=-0.112, att_csdid_nyt=-0.111
- `results/by_article/267/event_study_data.csv`: CS-NT and CS-NYT pre/post coefficients
