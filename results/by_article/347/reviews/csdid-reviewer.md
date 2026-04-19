# CS-DID Reviewer Report — Article 347

**Verdict:** WARN
**Date:** 2026-04-18
**Reviewer:** csdid-reviewer

## Checklist

### 1. Group variable construction
- `gvar_cs = "gvar_yr"` — cohort year of first treatment. Values: 2008, 2009, 2010, 2011, and 0/Inf for never-treated.
- 4 cohorts present; 63 never-treated counties.
- **Note:** notes field flags that cohort 2009 has only 2 treated counties in the raw data, and after balancing the CS-DID yearly panel, drops to ~1 county with a full panel. This is a near-singleton cohort.

### 2. Panel construction (RCS → yearly county panel)
- CS-DID requires a panel structure; BRFSS is repeated cross-section.
- Implementation collapses individual responses to county-year means (weighted by `swt`) for the 44 of 89 counties that appear in all survey years.
- **WARN:** RCS-to-panel collapse loses individual-level variation and control variables (`cs_controls = []`). CS-DID is estimated without controls, meaning the identifying assumption is parallel trends in unconditional means rather than conditional means as in TWFE. This estimand mismatch can explain part of the TWFE/CS-DID divergence.

### 3. CS-NT estimate
- CS-NT ATT = -0.448 (SE = 0.099). Significant.
- TWFE = -0.174. Gap = 157% of TWFE magnitude. Direction consistent.
- **WARN:** The 2.5x gap between CS-NT and TWFE is outside the typical range for implementation artefacts. Possible causes:
  a. County-specific linear trends in TWFE absorb pre-treatment variation that CS-DID attributes to the treatment.
  b. Compositional differences: CS-DID uses 44/89 counties (balanced); TWFE uses all 89 counties weighted by population (survey weight `swt`).
  c. Negative weights: Bacon decomposition shows TVT pairs (earlier vs later, later vs earlier) exist. Earlier-vs-later weighted -0.166 (wt 3.1%), later-vs-earlier -0.061 (wt 0.67%), i.e., small forbidden comparison weights. The bulk of the gap is more likely attributable to (a) and (b).

### 4. CS-NYT estimate
- CS-NYT ATT = -0.439 (SE = 0.100). Consistent with CS-NT; minimal sensitivity to control group definition.

### 5. Cohort-specific ATTs (from Bacon decomposition proxies)
- Bacon TVU weights: 2010 cohort (wt 35.2%, est -0.331), 2008 cohort (wt 51.4%, est -0.408), 2009 cohort (wt 8.8%, est -0.692).
- 2009 cohort has the largest effect (-0.692) and smallest weight (8.8%), consistent with near-singleton status driving noisy estimates.

### 6. Pre-trend assessment (from event study)
- Event study spans [-7, +4] yearly.
- Pre-trend evidence not formally tested here (no pre-trend statistics in the files), but the event study PDF shows the pre-period dynamics.

### 7. Summary flags
- WARN: CS-DID without controls (RCS collapse) vs TWFE with 12 controls — estimand mismatch.
- WARN: CS-NT 2.5x TWFE in magnitude; gap attributable primarily to trend controls + sample composition difference.
- WARN: Cohort 2009 near-singleton after panel balancing — `did` package flags this.

**Verdict: WARN** (3 concerns; CS-DID direction confirms TWFE but magnitude diverges substantially)
