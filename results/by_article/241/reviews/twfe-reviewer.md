# TWFE Reviewer Report — Article 241 (Soliman 2025)

**Verdict:** PASS
**Date:** 2026-04-19
**Re-run reason:** Fix applied 2026-04-19 — sample_filter now includes `(rel_year >= -3 & rel_year <= 3) | gvar_CS == 0` globally, matching paper line 239 of Manuscript Code.R.

## Checklist

### 1. Specification alignment
- Paper uses county + state*year FEs. Metadata correctly encodes `additional_fes: ["state^year"]` with no controls in main spec (`twfe_controls: []`). Alignment: PASS.
- Treatment variable: binary absorbing indicator `treatment`. PASS.

### 2. Sample filter / window restriction
- Paper restricts TWFE estimation to `rel_year in [-3, 3]` (line 239 of Manuscript Code.R), dropping treated-county observations far from treatment. Never-treated counties have rel_year=0 so always pass filter.
- **FIX APPLIED 2026-04-19:** `sample_filter = "(rel_year >= -3 & rel_year <= 3) | gvar_CS == 0"` now applied in metadata. The stored `beta_twfe` = **-31.5232** exactly reproduces the paper's Table 1 Col 1 = -31.52. Relative gap = 0.01%. PASS.
- Previous WARN (2026-04-18) was due to the filter being absent from the TWFE run (stored estimate was -33.65, 6.76% gap). That mismatch is now resolved.
- `cs_sample_filter = ""` correctly exempts CS-DID from the TWFE window filter; CS runs on the full 9-year panel to avoid the `did` package C-code segfault on the resulting unbalanced panel.

### 3. Heterogeneity in treatment timing (staggered TWFE bias)
- 8 cohorts (2007–2014), 95 treated counties, 2,911 never-treated. Staggered design.
- Bacon decomposition confirms treated-vs-untreated weight ≈ 98.7%; forbidden later-vs-earlier comparisons ≈ 1.3% — negligible contamination. PASS.
- TWFE event-study diverges from CS post-treatment: by t=+3, TWFE = -48.72 vs CS-NT = -60.95 vs Gardner = -48.49. Divergence is consistent with negative weighting on later cohort-periods in TWFE (Lesson 8 pattern); CS-DID corrects this. This is a design finding (Axis 3), not an implementation flaw.
- Pre-trend: TWFE at t=-3: +2.23 (SE=6.03), t=-2: +0.64 (SE=3.95). Neither significant at 5%. PASS.

### 4. FE structure
- county + state*year FEs appropriate for this county-year panel. State*year absorbs aggregate state-level time shocks. PASS.

### 5. Clustering
- Clustering at county level (`cluster: county_fips`). Standard for within-county treatment variation. PASS.

### 6. Pattern-50 sample-mismatch invariant
- TWFE and CS-DID intentionally run on DIFFERENT samples (TWFE: filtered; CS: full panel). This is documented in metadata and required by the `did` package stability constraint. The split is the correct resolution, not a bug. Pattern-50 invariant: the mismatch is documented and intentional. PASS.

## Implementation findings
None. The sample-filter fix resolves all implementation concerns flagged in the prior run.

## Design findings (Axis 3)
- CS-NT dynamic ATT (-40.96) is 30% larger in magnitude than TWFE (-31.52), consistent with TWFE attenuation when treatment effects grow over time (Lesson 8). This is a finding about the paper's design, not a flaw in our implementation.
- The 2012 cohort shows a positive bacon estimate (+3.19), creating cohort heterogeneity that TWFE masks but CS-DID resolves.

**Overall:** PASS
