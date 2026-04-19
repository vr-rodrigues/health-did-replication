# TWFE Reviewer Report — Article 304

**Verdict:** PASS
**Date:** 2026-04-18
**Reviewer:** twfe-reviewer

---

## Checklist

### 1. Specification fidelity
- Treatment variable: `cotton_dist_post` (binary, absorbing). Correct for a classic 2x2 DiD.
- Fixed effects: unit (`unit_id`) + time (`period`). Correct TWFE structure.
- Weights: `pop_census_tot` (census population). Matches paper specification.
- Clustering: at `unit_id` level. Appropriate for district-level data.
- Controls: none (`twfe_controls = []`). Matches metadata Column 1 (baseline) specification.
- **Documented deviation:** Metadata selects Table 2 Col 1 (no controls / baseline) via Rule iii(b) rather than Col 3 (author-preferred with controls). The no-controls specification is internally consistent and the deviation is documented in the notes field.

### 2. Negative-weight risk
- Single-timing (all treated units adopt in 1861). There is exactly ONE treatment cohort.
- With a single cohort and a single post period, Goodman-Bacon decomposition reduces to a pure 2x2 DiD: (treated post - treated pre) - (control post - control pre).
- **No negative-weight problem.** TWFE is numerically identical to the canonical 2x2 DiD estimand with a single cohort and 2 periods.
- Forbidden comparisons (later-treated vs earlier-treated) cannot arise.

### 3. Numerical verification
- Stored `beta_twfe` = 2.19350070
- Re-estimated from raw data: 2.19350069 (diff = 6.99e-07, i.e. < 0.001%)
- Stored `se_twfe` = 0.46349651
- Re-estimated SE = 0.46349651
- **EXACT MATCH.**

### 4. Pre-trend assessment
- Only 2 periods (1851, 1861). Zero pre-treatment periods are available.
- Pre-trend test is structurally impossible — this is a design limitation, not an estimation failure.
- The design is a textbook 2x2 DiD; parallel trends is an untestable maintained assumption.

### 5. Treatment variable construction
- `preprocessing.construct_vars`: `df$unit_id <- as.integer(factor(df$master_name))` — correct unit ID creation.
- `cotton_dist_post` is an interaction of `cotton_dist` (24/538 districts treated) × `post` (period==1861). Correct.
- `gvar_CS = 1861` for treated, `0` for never-treated. Correct CS encoding.

### 6. Design flags
- **2x2 DiD with single cohort:** The TWFE estimator recovers the exact treatment effect for the single cohort (g=1861) post-treatment period. No heterogeneity bias possible.
- **N_treated = 24 (4.5%):** Small treated group; clustering SE at unit level is appropriate but note small cluster count (24 treated clusters). Wild bootstrap or Cameron-Miller correction may improve inference. Not a TWFE implementation failure.
- **Mortality rate outcome** (`census_mr_tot`): continuous, weighted by census population. Reasonable for district-level analysis.

---

## Summary
TWFE is correctly specified for this 2x2 single-cohort design. The stored estimate exactly matches the raw-data re-estimation. The negative-weight problem is absent by construction. The sole design concern is that parallel trends is untestable with 0 pre-periods — a structural feature of the data, not an estimation error.

**Verdict: PASS**
