# TWFE Reviewer Report — Article 241 (Soliman 2025)

**Verdict:** WARN
**Date:** 2026-04-18

## Checklist

### 1. Specification alignment
- Paper uses county + state*year FEs. Metadata correctly encodes `additional_fes: ["state^year"]` with no controls in main spec. Alignment: PASS.
- Treatment variable: binary absorbing indicator `treatment`. PASS.

### 2. Sample filter / window restriction
- Paper restricts TWFE estimation to `rel_year in [-3, 3]` (line 239 of Manuscript Code.R), dropping 247 treated-county observations far from treatment.
- The stored `beta_twfe` in results.csv = **-33.65**, which corresponds to the UNFILTERED estimate (no window restriction applied).
- The paper's reported value = -31.52 (filtered window). Gap = 6.76%.
- The metadata `notes` acknowledge this explicitly and confirm the filter is applied only in a standalone script, not via the template. The results.csv stores the unfiltered TWFE.
- **This is a material sample-filter mismatch.** The stored result does NOT match the paper's Table 1, Col 1 headline.

### 3. Heterogeneity in treatment timing (staggered TWFE bias)
- 8 cohorts (2007–2014), 95 treated counties, 2,911 never-treated. This is a staggered design.
- TWFE with staggered timing can produce contaminated estimates (Goodman-Bacon 2021). The Bacon decomposition (run on the full unfiltered sample) shows the dominant weight is "Treated vs Untreated" (weight ~0.99 combined), which is reassuring — treated-vs-treated comparisons have negligible weight (~0.01).
- However, the TWFE event-study path diverges from CS/SA/Gardner post-treatment: by period +3, TWFE = -48.7 vs CS-NT = -60.9 vs Gardner = -48.5. This divergence suggests TWFE attenuates the dynamic effect relative to CS, consistent with some negative weighting in later cohort-periods.
- Pre-trend: TWFE at t=-3 shows +2.23 (SE=6.03), t=-2 shows +0.64 (SE=3.95). No significant pre-trend. PASS on pre-trend.

### 4. FE structure
- county + state*year FEs are appropriate for this county-year panel. state*year absorbs aggregate state-level time shocks. PASS.

### 5. Clustering
- Clustering at county level (`cluster: county_fips`). Standard for within-county treatment variation. PASS.

## Summary of concerns
- **WARN:** The stored TWFE in results.csv (-33.65) is the unfiltered estimate. The paper reports -31.52 (filtered to rel_year in [-3,3]). The mismatch is acknowledged in metadata but the stored estimate does not represent the paper's headline number. This is a fidelity concern, not a methodological flaw per se.
- **PASS:** Pre-trends flat; clustering appropriate; FE structure correct; Bacon decomposition shows treated-vs-untreated dominates (low contamination risk from late-vs-early comparisons).

**Overall:** WARN (sample filter mismatch between stored result and paper's headline).
