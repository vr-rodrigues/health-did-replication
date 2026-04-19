# de Chaisemartin Reviewer Report — Article 267
# Bhalotra, Clarke, Gomes, Venkataramani (2022)

**Verdict:** NOT_NEEDED

**Date:** 2026-04-18

## Applicability assessment
- Treatment variable: quotaRes (binary reserved-seat indicator).
- Treatment is absorbing: once a country adopts reserved-seat quotas, it does not reverse (the legislation is constitutionally embedded in most cases). No cases of treatment reversal are documented in the paper or replication data.
- Treatment is binary (not continuous, not heterogeneous-dose).
- Design is standard absorbing binary staggered adoption.

## Verdict rationale
- The de Chaisemartin & D'Haultfoeuille (2020) estimator (did_multiplegt) is designed for non-absorbing, continuous, or dose-heterogeneous treatments.
- For a standard binary absorbing staggered design, it reduces to a variant of Callaway-Sant'Anna and adds no additional methodological insight beyond what CS-DiD already provides.
- Note: the paper itself uses did_multiplegt_dc as a robustness check (mentioned in metadata notes). This is the authors' own choice and is appropriate as a robustness check given the non-binary nature of some quota specifications in other columns of their paper. For the baseline binary quotaRes specification under audit, NOT_NEEDED is the correct verdict.

## NOT_NEEDED
No additional review required for standard absorbing binary treatment.
