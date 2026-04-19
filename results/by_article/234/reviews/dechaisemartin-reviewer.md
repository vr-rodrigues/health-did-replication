# de Chaisemartin & D'Haultfoeuille Reviewer Report: Article 234 — Myers (2017)

**Verdict:** WARN
**Date:** 2026-04-18

## Applicability check
- Treatment is continuous (fractional dose 0–1): YES — de Chaisemartin applies.
- Treatment is non-absorbing / has heterogeneous dose at adoption: YES — continuous values allow for partial/incremental treatment.
- Standard absorbing-binary-staggered: NO — treatment is continuous.
- APPLICABLE (not NOT_NEEDED due to continuous treatment).

## Checklist

### 1. Treatment absorption
- `epillconsent18` takes values {0, 0.25, 0.50, 0.75, 1.00} — it is a continuous dose, not a binary absorbing indicator.
- In principle, a state could move from 0.50 to 0.75 across cohorts, making this a "dose switcher" design.
- From the metadata: 9 treatment cohorts (1942–1956), 3 never-treated. The gvar_CS (group variable for CS) is binary — implying at least some states transition discretely to "ever treated."
- The metadata excludes 2 non-absorbing states (28, 30), suggesting most states have absorbing treatment but at least 2 do not.

### 2. Did for continuous treatments (de Chaisemartin 2020, 2024)
- de Chaisemartin & D'Haultfoeuille (2020) extend DiD to continuous treatments via the "fuzzy DiD" framework.
- Our TWFE slope estimate can be interpreted as a local average treatment effect (LATE-type) for compliers around the treatment intensity margin.
- WARN: With only 5 discrete dose levels (0, 0.25, 0.50, 0.75, 1.00), the "continuous" treatment effectively becomes an ordered categorical variable. The TWFE slope is a dose-response weighted average but the linearity assumption may not hold.

### 3. Heterogeneous doses at adoption
- States adopting pill consent laws at different cohorts may adopt at different dose intensities.
- If dose heterogeneity at adoption is substantial, the TWFE slope conflates timing effects with dose effects.
- With a null result across all estimators, this conflation does not change the policy conclusion.

### 4. Non-absorbing treatment concern
- The 2 excluded non-absorbing states (IDs 28, 30) were removed. This is appropriate for binary TWFE but means the sample excludes states with time-varying treatment intensity — potentially introducing selection bias.
- WARN: Excluding non-absorbing states may bias estimates if those states differ systematically from the included sample.

### 5. TWFE with dose response
- TWFE with a continuous regressor estimates β in: Y_it = α_i + γ_t + β * D_it + ε_it.
- This β is identified from within-unit variation in dose over cohorts.
- With 5 discrete dose levels and staggered adoption, most variation is binary (0→positive dose), so β approximates a binary treatment effect weighted by adoption intensity.
- This is not a standard DiD setup and the interpretation requires care.

### 6. Recommendation
- For a fully rigorous analysis, the de Chaisemartin (2024) continuous DiD estimator (`did_multiplegt_dyn` with a continuous treatment) should be applied.
- Given the universal null result, this is unlikely to change the conclusion but would strengthen methodological rigor.

## Summary
- Continuous treatment with 5 discrete levels makes this a fuzzy DiD design.
- 2 non-absorbing states were excluded — selection concern.
- TWFE slope interpretation as dose-response ATT is approximate.
- Null result is robust to these concerns but the estimand is not well-defined without a formal continuous DiD estimator.

**Verdict: WARN** — continuous treatment requires a fuzzy DiD framework not implemented here; excluding non-absorbing states introduces potential selection; all null but estimand is imprecise.
