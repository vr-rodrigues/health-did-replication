# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 347

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18
**Reviewer:** dechaisemartin-reviewer

## Applicability check
- Treatment type: `law_enacted` — binary, absorbing (once enacted, calorie posting law remains).
- Treatment timing: staggered across 4 cohorts (2008, 2009, 2010, 2011).
- No continuous dose; no heterogeneous dose at adoption; treatment is not non-absorbing.
- **This is a standard absorbing-binary-staggered design.** The de Chaisemartin & D'Haultfoeuille (2020) estimator (`didmultiplegt`) is designed for non-absorbing/time-varying treatments or continuous dose settings.

## Verdict justification
- For absorbing-binary-staggered treatment, CS-DID (Callaway-Sant'Anna 2021) and the Bacon decomposition provide the appropriate diagnostic tools.
- Running `didmultiplegt` on this design would replicate the CS-DID analysis without adding information.
- The de Chaisemartin framework adds value when treatment can turn on and off or intensity varies — neither condition applies here.

**Verdict: NOT_NEEDED** (standard absorbing binary staggered design; CS-DID reviewers cover this adequately)
