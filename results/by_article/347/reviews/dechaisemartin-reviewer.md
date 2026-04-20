# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 347

**Verdict:** NOT_NEEDED
**Date:** 2026-04-19
**Reviewer:** dechaisemartin-reviewer

## Applicability check
- Treatment type: `law_enacted` — binary, absorbing (once enacted, calorie posting law remains in force).
- Treatment timing: staggered across 4 cohorts (2008, 2009, 2010, 2011).
- No continuous dose; no heterogeneous dose at adoption; treatment is not non-absorbing.
- **This is a standard absorbing-binary-staggered design.**

## Verdict justification
The de Chaisemartin & D'Haultfoeuille (2020) estimator (`didmultiplegt`) adds information over CS-DID specifically when:
(a) treatment is non-absorbing (can turn on and off), or
(b) treatment is continuous or has heterogeneous dose at adoption.

Neither condition applies here. Running `didmultiplegt` on this design would replicate the CS-DID analysis without adding information. CS-DID (Callaway-Sant'Anna 2021) and the Bacon decomposition (informational for RCS) provide the appropriate diagnostic tools for this specification.

**Verdict: NOT_NEEDED** (standard absorbing binary staggered design; CS-DID covers this adequately)
