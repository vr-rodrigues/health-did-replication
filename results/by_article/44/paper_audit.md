# Paper fidelity audit: 44 — Bosch, Campos-Vazquez (2014)

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-19

## Selected specification
Step 0 applicability gate triggered: `pdf/44.pdf` does not exist in the repository. Cannot extract the paper's headline number.

Secondary note: even if the PDF were available, the metadata `notes` field documents that the paper reports only a distributed lag event-study (Figure 4 Panel D) and no pooled static ATT coefficient — `collapse=1` in the pipeline. There is no single scalar TWFE coefficient in the paper to compare against our stored `beta_twfe`.

## Comparison

| Source | β | SE | N | cluster | sig |
|---|---|---|---|---|---|
| Paper (Figure 4 Panel D) | not extractable — no PDF | — | — | — | — |
| Our stored results.csv | -0.006650 | 0.003954 | — | cvemun | — |
| Relative Δ | N/A | N/A | | | |

## Notes
- PDF not present at `pdf/44.pdf`; applicability gate triggers at Step 0.
- Metadata confirms `collapse=1`: paper's main evidence is a distributed lag event-study (Figure 4 Panel D), not a pooled static TWFE scalar.
- Our stored `beta_twfe` = -0.00665 is the template's collapsed post-indicator coefficient (useful for internal cross-paper comparisons) but does not directly correspond to any single published figure.
- SA disabled (Pattern 36); CS-NYT (not-yet-treated) used instead of never-treated because all municipalities eventually receive Seguro Popular.

## Verdict rationale
No PDF available to extract the paper's published value; fidelity comparison cannot be performed.
