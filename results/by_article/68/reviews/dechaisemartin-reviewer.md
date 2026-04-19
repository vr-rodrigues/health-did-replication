# de Chaisemartin Reviewer Report: Article 68 — Tanaka (2014)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Checklist

### 1. Treatment type assessment
- Treatment: `clinic93` (pre-policy clinic access indicator) × `post` (year == 1998). The treatment is a time-invariant group characteristic interacted with a time dummy — this is a textbook absorbing binary treatment.
- Treatment is assigned at the community (clustnum) level based on pre-policy clinic access (clinic93=1). It does not switch on and off across time.
- User fee abolition was a permanent policy change (1994), and the treated group (high-access clinics) is permanently treated from 1994 onward.

### 2. Non-absorbing / continuous / heterogeneous-dose concerns
- [x] Treatment is absorbing (once treated, always treated — no de-adoption possible).
- [x] Treatment is binary (0/1 group assignment — not continuous dose).
- [x] No evidence of heterogeneous dose at adoption.
- [x] Single timing (all treated communities adopt simultaneously in 1994).

### 3. de Chaisemartin & D'Haultfoeuille (2020) / (2023) applicability
- The DCD20 estimator is designed for settings with treatment variation within a period or across periods (non-absorbing, switchers). With a 2x2 design and perfectly absorbing binary treatment, DCD20 would return a result identical to TWFE. There is no added value from running the DCD estimator here.
- The DCD23 extension for continuous treatments is similarly inapplicable.

### 4. Verdict
This is a standard absorbing-binary-staggered-free design. The de Chaisemartin family of estimators adds no information beyond TWFE in this setting.

**Verdict: NOT_NEEDED**
