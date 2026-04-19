# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 133 (Hoynes et al. 2015)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Applicability assessment

This reviewer checks whether the treatment variable is:
- Non-absorbing (units can switch in and out of treatment)
- Continuous (treatment intensity varies)
- Has heterogeneous dose at adoption

### Design assessment
- Treatment variable: binary indicator `Post_avg = treat1 × after`
- `treat1` is a fixed group indicator (high-parity mothers vs. low-parity mothers) — groups are pre-determined by parity, not stochastic switching
- Treatment is absorbing: once the 1994 EITC expansion occurs, the treated group (high-parity mothers) remains treated through 1998
- Treatment is binary (0/1), not continuous
- No heterogeneous dose at adoption: all treated units receive the same policy change in 1994
- Single treatment cohort: no variation in timing across units

### Conclusion
The de Chaisemartin–D'Haultfoeuille estimator (DID_M, Wooldridge-style) addresses concerns specific to:
1. Non-binary or non-absorbing treatments where Bacon decomposition identifies negative-weighted comparisons from switchers
2. Continuous treatment DiD where heterogeneous dose creates bias

Neither concern applies here. This is a standard 2×2 DiD with binary, absorbing, single-timing treatment. The de Chaisemartin estimator would reduce to the same 2×2 comparison and offers no additional insight.

## Overall de Chaisemartin verdict: NOT_NEEDED
