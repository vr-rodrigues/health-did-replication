# TWFE Reviewer Report: Article 25 — Carrillo, Feres (2019)

**Verdict:** PASS
**Date:** 2026-04-18

## Checklist

### 1. Specification Match
- Paper uses: `areg physician_cpta POLICY i.UF#c.date c.(controls)#c.date i.date, a(codigo) cluster(codigo)`
- Template uses: `feols` with `UF[date]` (state-specific linear trends), unit FE (`codigo`), time FE (`date`), cluster(`codigo`)
- Treatment variable: `POLICY = Treatment * post` (correctly constructed in preprocessing)
- Controls: 18 variables entered as `var*date` interactions (correctly matches paper's `c.(var)#c.date`)
- **MATCH: PASS**

### 2. Beta Reproduction
- Our `beta_twfe` = 0.115942 vs paper target = 0.116
- Absolute difference: 0.000058 → 0.05% deviation
- Within 1% tolerance: YES
- t-stat: 0.1159 / 0.00859 = 13.49 (highly significant)
- **REPRODUCTION: PASS**

### 3. Controls-Free Comparison
- `beta_twfe_no_ctrls` = 0.12808 vs `beta_twfe` = 0.11594
- Gap: +10.5% inflation without controls
- Controls pull the estimate down 10.5% — sensible for confounding
- Direction consistent; controls reduce estimate (expected for physician supply with geographic/economic confounders)

### 4. Negative Weights Check
- Treatment timing: staggered; treatment is absorbing binary
- 18 time-varying controls (interacted with date) create additional risk of negative TWFE weights
- Controls enter as linear interactions (not nonlinear), and dominant post-period pattern is growing effects
- CS-NT and SA agree closely with TWFE (0.1144 vs 0.1159, ~1.3% gap) — minimal negative-weight contamination
- **NEGATIVE WEIGHTS: LOW RISK (PASS)**

### 5. Treatment Variable Construction
- `POLICY = Treatment * post` is correctly constructed
- `gvar_CS` = first period of `POLICY==1` per unit, with 0 for never-treated
- Construction logically sound and matches the paper's intent
- **CONSTRUCTION: PASS**

### 6. Fixed Effects Structure
- Unit FE: `codigo` (municipality)
- Time FE: `date`
- State-specific linear trends: `UF[date]` — key identification lever
- Clustering: `codigo`
- SE = 0.00859 — plausible given 5565 units

### 7. Data Dimensions
- 5565 municipalities, bimonthly data, ~300k rows
- Large dataset handled correctly

## Key Findings
- TWFE beta = 0.115942 matches paper target 0.116 within 0.05% (essentially exact)
- Specification exactly mirrors paper: Stata `areg` → `feols` with identical FE structure
- 18 time-varying controls correctly entered as `var × date` interactions, not levels
- Growing event-study pattern (0 → 0.133 over 4 post periods) consistent with gradual policy diffusion
- CS-NT/SA convergence to TWFE (~1.3% gap) indicates low negative-weight contamination
