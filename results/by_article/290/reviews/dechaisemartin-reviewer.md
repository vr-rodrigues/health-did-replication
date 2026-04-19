# de Chaisemartin-D'Haultfoeuille Reviewer Report — Article 290 (Arbogast et al. 2022)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Applicability check
- Treatment variable: Adminburden — administrative burden policy adoption indicator
- Treatment type: Binary (0/1), absorbing (once adopted, states remain treated)
- Adoption pattern: Staggered across 15 treated states, 12 distinct cohorts
- Continuous treatment: No
- Non-absorbing treatment: No (standard absorbing adoption)
- Heterogeneous dose at adoption: No (all treated states adopt the same binary policy change)

## Assessment
This is a standard absorbing binary staggered design — exactly the case for which Callaway-Sant'Anna (2021) was designed. The de Chaisemartin-D'Haultfoeuille (2020) estimator adds value over CS-DiD primarily when:
1. Treatment is non-absorbing (can switch in and out)
2. Treatment is continuous with heterogeneous doses
3. Multiple simultaneous treatment changes make it hard to isolate a clean 2x2

None of these conditions apply here. The CS-DiD framework is the appropriate choice.

**Conclusion: NOT_NEEDED** — Standard absorbing binary staggered design is fully covered by CS-DiD methodology. De Chaisemartin-D'Haultfoeuille adds no additional diagnostic value beyond what CS-DID would provide (noting CS-DID itself failed due to data reconstruction issues).
