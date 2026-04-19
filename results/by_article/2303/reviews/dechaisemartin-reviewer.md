# de Chaisemartin & D'Haultfoeuille Reviewer Report: Article 2303 — Cao & Ma (2023)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18
**Reviewer axis:** Methodology

---

## Applicability assessment

Run for completeness per protocol. Verdict expected to be NOT_NEEDED for standard absorbing-binary-staggered designs.

---

## Checklist

### 1. Treatment structure classification

- Treatment variable: `tbp` (biomass power plant operational: 1 if operational, 0 otherwise).
- Treatment is **binary and absorbing**: once a plant switches on (tbp=1), it remains treated for all subsequent periods. No reversals documented.
- Treatment is **staggered**: 125 unique cohorts enter treatment at different months between 2001m1 and 2019m12.
- Treatment dose is **uniform at adoption**: all treated plants receive tbp=1 (no heterogeneous dose at entry).
- There is no continuous treatment variable, no non-absorbing switching, and no dose variation at adoption.

### 2. de Chaisemartin relevance conditions

The de Chaisemartin & D'Haultfoeuille (2020) estimator (DCDH) is most relevant when:
(a) Treatment is non-absorbing (can switch on and off), OR
(b) Treatment is continuous or has a heterogeneous dose, OR
(c) There is explicit concern about switchers contributing as controls.

None of conditions (a)–(c) apply here. The treatment is binary, absorbing, and uniform at adoption. The DCDH estimator would reduce to the CS-DID estimator in this setting.

### 3. Verdict

**NOT_NEEDED.** This is a standard absorbing-binary-staggered design. The CS-DID (Callaway-Sant'Anna) estimator already addresses the staggered-timing negative-weight concern for this treatment structure. DCDH provides no additional methodological value over CS-DID here.

---

## Summary

**NOT_NEEDED.** Treatment tbp is binary, absorbing, and staggered with uniform dose at adoption (125 cohorts). The de Chaisemartin estimator is not required; CS-DID with never-treated comparisons is the appropriate robust estimator for this design, and it has been run.
