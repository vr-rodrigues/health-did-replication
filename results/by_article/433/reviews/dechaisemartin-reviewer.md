# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 433

**Article:** DeAngelo, Hansen (2014) — "Life and Death in the Fast Lane: Police Enforcement and Traffic Fatalities"
**Reviewer:** dechaisemartin-reviewer
**Date:** 2026-04-18
**Verdict:** NOT_NEEDED

---

## Applicability Assessment

The de Chaisemartin-D'Haultfoeuille (DCM) estimator is primarily relevant when:
1. Treatment is non-absorbing (units can switch in/out)
2. Treatment is continuous or has heterogeneous dose at adoption
3. There is staggered adoption creating heterogeneous treatment timing

For this paper:
- **Treatment**: Binary absorbing indicator. Oregon (FIPS=41) is treated from mn_yr=38 (February 2003) onward. Treatment does not switch off.
- **Timing**: Single adoption date. All 46 other states are never-treated. No staggered adoption.
- **Dose**: Binary (0/1). No heterogeneous dosage.

This is a standard absorbing binary single-cohort design. The negative-weighting critique of DCM does not apply — with a single treated unit and never-treated controls, TWFE assigns exactly one 2×∞ comparison and no negative weights are possible.

The DCM estimator would produce the same estimate as TWFE and CS-DID in this design. Running it is unnecessary.

**Verdict: NOT_NEEDED**
