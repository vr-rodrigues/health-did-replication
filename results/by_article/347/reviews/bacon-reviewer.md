# Bacon Decomposition Reviewer Report — Article 347

**Verdict:** NOT_APPLICABLE (formal) / Informational diagnostic available
**Date:** 2026-04-19
**Reviewer:** bacon-reviewer

## Applicability check
- `treatment_timing == "staggered"`: YES
- `data_structure == "repeated_cross_section"`: YES — NOT "panel"
- `allow_unbalanced`: N/A (not a panel)
- Bacon decomposition requires balanced panel data structure.
- **Decision: NOT_APPLICABLE — formal Bacon invalid for RCS data.**

## Informational diagnostic (from bacon.csv)
An informational Bacon-style decomposition on the county-year aggregate panel (44 counties) is available:

| Treated | Untreated | Estimate | Weight | Type |
|---------|-----------|----------|--------|------|
| 2008 | Never (99999) | −0.408 | 51.4% | TvU |
| 2010 | Never (99999) | −0.331 | 35.2% | TvU |
| 2009 | Never (99999) | −0.692 | 8.8% | TvU |
| 2008 | 2010 | −0.166 | 3.1% | Earlier vs Later (LvE) |
| 2009 | 2010 | −0.481 | 0.3% | Earlier vs Later (LvE) |
| 2010 | 2008 | −0.062 | 0.7% | Later vs Earlier (EvL) |
| 2009 | 2008 | +0.021 | 0.09% | Later vs Earlier (EvL) |
| 2010 | 2009 | −0.108 | 0.07% | Later vs Earlier (EvL) |
| 2008 | 2009 | +0.311 | 0.3% | Earlier vs Later (LvE) |

**Summary:**
- TvU (valid, never-treated comparison) weight = 95.4%. Very clean.
- Timing (forbidden) comparisons = 4.6% combined. Minimal.
- All TvU estimates negative and directionally consistent (range: −0.331 to −0.692).
- Cohort 2009 largest per-cohort ATT (−0.692) but smallest TvU weight (8.8%) — reflects near-singleton status.
- Positive EvL estimates for cohort pairs (2009 vs 2008: +0.021; 2008 vs 2009: +0.311) suggest some heterogeneity in effects across cohorts, but these carry trivial weights (<0.4% combined).

**Design finding:** TWFE attenuation (TWFE = −0.174 vs TvU-weighted aggregate ~−0.400) is NOT driven by negative Bacon weights — the 4.6% timing comparisons are negligible. The attenuation mechanism is county-specific linear trends (`fips[tt]`) absorbing treatment-period variation in the TWFE. This is confirmed by the informational decomposition: the pure TvU estimates (−0.33 to −0.69) are already 2–4× the TWFE, before any timing-comparison contamination.

**TvT share = 4.6%** — this is the relevant design-credibility diagnostic. At 4.6%, it is well below the 30% D-MODERATE threshold. The Bacon mechanism is clean; the attenuation is from trend controls, not forbidden comparisons.

**Verdict: NOT_APPLICABLE** (formal Bacon inapplicable to RCS); informational TvT share = 4.6% (clean; well below 30% threshold)
