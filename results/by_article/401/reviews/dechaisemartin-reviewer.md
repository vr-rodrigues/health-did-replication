# de Chaisemartin Reviewer Report: Article 401 — Rossin-Slater (2017)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Design Assessment

The paternity establishment treatment in Rossin-Slater (2017) is:
- **Binary**: states either have hospital paternity establishment programs or do not
- **Absorbing**: once a state adopts a hospital paternity program, it does not reverse (programs are implemented by hospitals and legislated; no evidence of de-adoption in the 1990s)
- **Staggered**: 8 cohorts adopt across 1990-1999
- **No dose variation**: any_hosp_pat is a 0/1 indicator; no continuous dose or heterogeneous intensity

For standard absorbing-binary-staggered designs, the de Chaisemartin-d'Haultfoeuille (2020) estimator (DID_M) is not the primary concern. The forbidden comparisons issue is already captured by the TWFE and CS-DID reviewers via the all-eventually-treated flag.

DID_M is specifically designed for:
1. Non-absorbing treatments (treatment can switch on and off)
2. Continuous treatments with multiple dose levels
3. Fuzzy DiD with partial compliance

None of these apply here.

## Verdict

**NOT_NEEDED** — Standard absorbing binary staggered design. The heterogeneous-treatment concerns are fully captured by the TWFE (forbidden comparisons) and CS-DID (no-NT estimator) reviewers. De Chaisemartin-d'Haultfoeuille provides no additional diagnostic value for this design.

## References
- Metadata: `data/metadata/401.json` (treatment_twfe = any_hosp_pat, binary absorbing)
