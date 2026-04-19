# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 309

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18
**Reviewer:** dechaisemartin-reviewer

---

## Checklist

### 1. Treatment structure assessment

- Treatment variable: wdlapY (whistle-blower protection law, public policy exception)
- Notes: "wdlapY is fractional (0-1) in adoption year" — partial implementation in first year
- gvar variable: first_year_full_wdlapY — year of full (=1) implementation; 0 for never-treated states
- After full adoption: treatment absorbs at 1 permanently

### 2. de Chaisemartin applicability criteria

The de Chaisemartin-D'Haultfoeuille (DCDH) estimator is designed for:
- Non-absorbing treatment (treatment can switch on and off): NOT the case here
- Continuous/multi-valued treatment with heterogeneous dose: Marginally relevant (fractional first year)
- Staggered adoption where groups switch simultaneously: Addressed by CS-DID

### 3. Assessment

The fractional adoption-year value (wdlapY = 0 to 1 in year of first adoption) is a transitional state, not a stable non-absorbing regime. Once fully adopted (wdlapY = 1), the treatment is permanent and absorbing. The authors correctly use first_year_full_wdlapY as the gvar to mark the cohort-defining event (full adoption), treating the fractional year as a pre-treatment ramp rather than a separate treatment level.

Under this specification:
- Treatment is effectively binary absorbing after full adoption
- The transitional fractional year is implicitly absorbed into the first post-period or treated as negligible
- CS-DID with first_year_full_wdlapY correctly handles this structure

The DCDH heterogeneous treatment estimator (de Chaisemartin & D'Haultfoeuille 2020) is NOT required for this design.

### 4. Verdict rationale

Standard absorbing binary staggered adoption with well-defined gvar. CS-DID and SA estimators are appropriate. DCDH adds no additional insight and is not warranted for this design structure.

**Verdict: NOT_NEEDED**
