# de Chaisemartin Reviewer Report — Article 125
**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Applicability Assessment
de Chaisemartin & D'Haultfoeuille (2020) `did_multiplegt` is most relevant when:
- Treatment is non-absorbing (can switch on/off), OR
- Treatment is continuous or has heterogeneous dose at adoption, OR
- Standard Callaway-Sant'Anna is unavailable or misconfigured.

This paper uses a **standard absorbing binary staggered treatment**: state parental coverage mandate (`law`) switches ON once and stays ON. This is the canonical case where CS-DID is the preferred robust estimator and de Chaisemartin's `did_multiplegt` is redundant.

Additional factors:
- `treatment_timing == "staggered"` (5 cohorts), `data_structure == "repeated_cross_section"`.
- No evidence of treatment reversal or dose variation in the metadata or original paper.
- The original paper (Levine, McKnight & Heep 2011) is a 2011 AEJ:Policy paper predating these modern estimators; the design is a straightforward binary-staggered adoption DiD.

## Decision
Standard absorbing-binary-staggered design. CS-DID fully covers this case. `did_multiplegt` adds no incremental information.

**Verdict: NOT_NEEDED**
