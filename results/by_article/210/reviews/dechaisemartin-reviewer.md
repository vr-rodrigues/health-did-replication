# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 210 (Li et al. 2026)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Applicability assessment

Applicability rule: applicable iff treatment is non-absorbing OR continuous OR has heterogeneous dose at adoption. For standard absorbing-binary-staggered designs, returns NOT_NEEDED.

- Treatment variable: treat1 (binary, absorbing — units adopt and stay treated permanently)
- Treatment type: standard absorbing binary staggered adoption
- No heterogeneous dose: treatment is 0/1 at adoption, no continuous treatment intensity variable

**Verdict: NOT_NEEDED** — Standard absorbing binary staggered design. The de Chaisemartin & D'Haultfoeuille estimator (DID_M) is designed for cases where treatment switches on AND off, or where treatment intensity varies. This paper uses a clean one-time policy adoption (drug distribution reform in Chinese provinces), which is the canonical use case for Callaway-Sant'Anna.

## Informational note
While the dCdH estimator is not needed here, the all-eventually-treated feature does raise a concern that dCdH would also flag: in an all-eventually-treated panel, even the not-yet-treated comparison group eventually becomes "contaminated" by policy adoption. This is the core reason CS-NYT (not-yet-treated) is used rather than CS-NT (never-treated). The dCdH DID_M estimator handles this by looking at switchers between consecutive periods, which would be equivalent to the CS approach in this binary absorbing case. No additional action needed beyond what CS-NYT already provides.
