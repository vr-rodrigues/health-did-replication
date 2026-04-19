# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 305 (Brodeur & Yousaf 2020)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Applicability assessment
- Treatment type: binary absorbing (post-shooting indicator `successful`)
- Treatment is non-absorbing? No — once a county experiences a mass shooting, `successful=1` for all subsequent years.
- Treatment is continuous? No.
- Treatment has heterogeneous dose at adoption? No — all treated counties receive a single binary treatment.

This is a standard absorbing-binary-staggered design. The de Chaisemartin & D'Haultfoeuille (2020) estimator is designed specifically for cases where treatment can switch on and off (non-absorbing, two-way) or is continuous. For absorbing binary treatments, it is equivalent to CS-DID and adds no additional diagnostic value beyond what the CS-DID and Bacon reviewers have already assessed.

## Conclusion
NOT_NEEDED. The CS-DID (Callaway-Sant'Anna) and Bacon decomposition reviewers cover the relevant diagnostic space for this design. The de Chaisemartin estimator would be redundant here and is not expected to reveal concerns beyond those already flagged.

## Links
N/A
