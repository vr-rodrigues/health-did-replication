# Bacon Decomposition Reviewer Report — Article 347

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18
**Reviewer:** bacon-reviewer

## Applicability check
- `treatment_timing == "staggered"`: YES
- `data_structure == "repeated_cross_section"`: YES (NOT "panel")
- Bacon decomposition requires a balanced panel data structure. The data is repeated cross-section (individual-level BRFSS survey data aggregated to county-year means for CS-DID purposes).

**Decision: SKIP — data_structure is repeated_cross_section, not panel. Bacon decomposition is not valid for RCS data.**

## Informational note (from bacon.csv)
A Bacon-style decomposition was run on the county-year aggregate panel (44 counties) as an informational diagnostic. Results are available in `bacon.csv`:

| Treated | Untreated | Estimate | Weight | Type |
|---------|-----------|----------|--------|------|
| 2010 | Never (99999) | -0.331 | 35.2% | TVU |
| 2008 | Never (99999) | -0.408 | 51.4% | TVU |
| 2009 | Never (99999) | -0.692 | 8.8% | TVU |
| 2008 | 2010 | -0.166 | 3.1% | Earlier vs Later |
| 2009 | 2010 | -0.481 | 0.3% | Earlier vs Later |
| 2010 | 2008 | -0.062 | 0.7% | Later vs Earlier |
| 2009 | 2008 | +0.021 | 0.09% | Later vs Earlier |
| 2010 | 2009 | -0.108 | 0.07% | Later vs Earlier |
| 2008 | 2009 | +0.311 | 0.3% | Earlier vs Later |

- TVU weight = 95.4%, forbidden (timing) comparisons = 4.6%. Very clean decomposition.
- All TVU estimates are negative and directionally consistent (range: -0.331 to -0.692).
- Cohort 2009 drives the largest per-cohort ATT (-0.692) with small weight.
- Negative cohort-pair weights are minimal (<1% combined).
- **This informational decomposition suggests TWFE attenuation is not primarily driven by negative weights** (only 4.6% timing comparisons, and the TVU estimates are themselves 2-4x the TWFE). The gap is more likely from county-specific trend absorption.

**Verdict: NOT_APPLICABLE** (formal Bacon not applicable to RCS; informational decomposition shown above)
