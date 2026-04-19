# de Chaisemartin & D'Haultfoeuille Reviewer Report — Article 147 (Greenstone & Hanna 2014)

**Verdict:** NOT_NEEDED
**Date:** 2026-04-18

## Applicability check
Treatment variable `catconvpolicy` is a windowed event indicator: 1 if city has adopted catalytic converter policy AND is within the event window [-7, +9] years post-adoption. Outside this window, the indicator is 0.

### Is treatment non-absorbing?
Strictly, the treatment turns off after 9 years post-adoption — but this is an artifact of the event-window specification, not a genuine treatment reversal (cities do not de-adopt the policy). Within the analysis sample (restricted to cities with ≥3 years pre and post for BOTH policies), the practical effective observation window means that for most units, the treatment is absorbing within the observed data span.

### Is treatment continuous or heterogeneous dose?
No — the treatment is binary (0/1 within the event window).

### Verdict determination
The design is effectively a staggered absorbing binary treatment within the analysis window. The de Chaisemartin estimator is designed for treatments that genuinely switch on and off or have continuous intensity variation. For this design, the standard CS-DID and TWFE approaches are the appropriate tools, and they have already been applied. Running the de Chaisemartin estimator would produce results substantively equivalent to the CS-DID analysis already conducted.

No heterogeneous treatment dose is present. The treatment is binary within each city's observation window. The CS-DID framework (already applied) is sufficient.

## Note on windowed treatment
The event-window restriction [-7, +9] in the treatment variable means TWFE is estimating an average within-window effect rather than a true post-adoption ATT. This concern is better addressed by the TWFE and HonestDiD reviewers, not by the de Chaisemartin estimator.

**Verdict: NOT_NEEDED** — Standard absorbing binary staggered design within the event window; CS-DID framework is sufficient; de Chaisemartin estimator adds no diagnostic value here.
