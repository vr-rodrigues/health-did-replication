# de Chaisemartin-D'Haultfoeuille Reviewer Report — Article 395 (Malkova 2018)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Checklist

### 1. Treatment type assessment
- Treatment is binary (0/1), absorbing (units enter treatment in 1981 or 1982 and remain treated through 1986), and staggered.
- No continuous dose, no non-absorbing treatment reversals, no heterogeneous treatment intensities across units within cohort.

### 2. DID_M / DID_l applicability
- DID_M estimator (de Chaisemartin & D'Haultfoeuille 2020) targets ATTs for switchers in a given period. For the standard absorbing binary staggered design in this paper, the CS-DID (Callaway-Sant'Anna) framework provides identical identification without requiring the DID_M estimator.
- No features of the treatment variable require the DID_M estimator (non-absorbing reversals, fuzzy treatment, continuous dose changes).

### 3. Treatment heterogeneity check
- Two cohorts with different sizes (1981: 32 oblasts, 1982: 50 oblasts) but both receive the same binary treatment (Soviet maternity benefit policy).
- No dose heterogeneity at adoption — all units in a cohort receive the same binary treatment.

### 4. Conclusion
- This is a standard absorbing binary staggered adoption design. The DID_M estimator is not required; CS-NYT and Gardner adequately cover the heterogeneity-robust estimation needs.

**Verdict: NOT_NEEDED** (standard absorbing binary staggered design; CS-NYT and Gardner sufficient)
