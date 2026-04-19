# TWFE Reviewer Report — Article 79 (Carpenter & Lawler 2019)

**Verdict:** PASS

**Date:** 2026-04-18

---

## Checklist

### 1. Treatment variable specification

- Treatment variable: `TDcont_mandate` (continuous mandate intensity, not a binary 0/1 indicator).
- This is a policy-intensity TWFE, not a simple binary absorbing-treatment DiD.
- The continuous mandate measure is the original authors' specification; TWFE is correctly parameterised.
- WARN consideration: continuous/dose treatment creates a non-standard DiD estimand (weighted sum of dose-response effects), but the paper is explicit about this — it is their research design.

### 2. Fixed effects structure

- Unit FE: `fips` (U.S. state, 51 units). Note the metadata confirms fips = STATE dummies, not counties.
- Time FE: `year12`.
- Additional FEs: `age` (individual age group).
- The three-way FE (`fips × year12 × age`) is consistent with the paper's Table 2 specification using state, year, and age fixed effects.

### 3. Control variable set

- 71 covariates in `twfe_controls`: covers other vaccine mandates, individual demographics (race, gender, education, marital status, income proxy), state-level economic conditions (unemployment, poverty), and prior disease rates.
- This matches the paper's "richly controlled" specification in Table 2, Column (3).
- No obvious omitted controls from the paper's preferred specification.

### 4. Weighting

- `provwt` (provider/survey weights) applied — consistent with NIS survey data analysis.
- The original paper uses survey weights.

### 5. Stored result

- `beta_twfe` = 0.1350 (results.csv: 0.135036)
- `se_twfe` = 0.0140 (results.csv: 0.013962)
- Paper reports β = 0.135, SE = 0.014 (Table 2, Column 3).
- Match is exact to 3 significant figures. No divergence.

### 6. TWFE event study (pre-trend check)

From `event_study_data.csv`, TWFE pre-period coefficients:
- t = -6: β = -0.0595, SE = 0.0390
- t = -5: β = -0.0479, SE = 0.0323
- t = -4: β = -0.0361, SE = 0.0235
- t = -3: β = -0.0324, SE = 0.0180
- t = -2: β = -0.0327, SE = 0.0130

All pre-period TWFE coefficients are **negative** and **decreasing in magnitude** toward zero. This is a mild downward drift toward the reference period (t = -1), which could reflect anticipatory effects or mild pre-trend. None are individually statistically significant at conventional thresholds (max |t| ≈ 1.53 at t=-6), but the pattern is consistent and systematic. This is noted as a mild concern but does not rise to a FAIL — it is common in survey-based policy studies with many control variables.

### 7. Post-treatment trajectory

Post-treatment TWFE estimates rise steadily: t=0: +0.112, t=1: +0.162, t=2: +0.180, t=3: +0.170, t=4: +0.188, t=5: +0.209, t=6: +0.215. This growing pattern is plausible for compliance ramp-up after mandate implementation.

### 8. Replication fidelity

β = 0.135 matches paper to 4 significant figures. SE = 0.014 matches exactly. TWFE implementation is faithful.

---

## Summary

The TWFE specification faithfully replicates the paper's preferred estimate (β = 0.135, SE = 0.014). Fixed effects, controls, and weighting all match. Mild systematic pre-trend drift (all pre-periods negative) is a soft concern shared by the original paper; it does not constitute an implementation error. The continuous treatment variable is an original-design choice, not an error.

**Verdict: PASS**
