# de Chaisemartin-D'Haultfoeuille Reviewer Report — Article 437 (Hausman 2014)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Applicability check
The de Chaisemartin-D'Haultfoeuille (DC-DH) estimator is relevant when:
1. Treatment is non-absorbing (can turn on and off), OR
2. Treatment is continuous (varying dose), OR
3. Treatment has heterogeneous dose at adoption.

**Assessment:**
- Treatment (`divested`) is absorbing-binary-staggered: once a nuclear facility divests, it remains divested. There is no evidence of de-divestiture.
- The treatment is binary in intent (0 = not divested, 1 = divested), though it is fractional in the divestiture year due to the monthly-to-annual collapse (mean of binary across 12 months).
- The fractional treatment in the transition year is a measurement artefact of the collapse, not a genuine continuous/heterogeneous dose. The underlying treatment event is binary and absorbing.
- There is no evidence of treatment reversal in the data.

**Conclusion:** Standard absorbing-binary-staggered design. The DC-DH estimator does not provide additional information beyond what CS-DID and Bacon decomposition already capture.

## NOT_NEEDED rationale
The DC-DH estimator is designed for switchers (units that change treatment status) in settings with non-absorbing or continuous treatment. In a purely staggered absorbing design like article 437, Callaway-Sant'Anna already identifies the same causal parameters as DC-DH. Running DC-DH would be redundant with the CS-DID results already reviewed.

Note: The fractional `divested` in the transition year has been flagged by the TWFE reviewer as a structural concern (WARN), but this is an implementation/construction issue, not a non-absorbing treatment issue warranting DC-DH.

## Recommendation
No action needed. DC-DH is NOT_NEEDED for this design. The implementation concerns related to fractional treatment in the divestiture year should be addressed at the CS-DID and TWFE levels (already flagged by those reviewers).
