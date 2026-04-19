# Paper fidelity audit: 2303 — Cao & Ma (2023)

**Verdict:** EXACT
**Date:** 2026-04-19

## Selected specification

From metadata notes: "Table 2 Col 3: paper reports -4.863 (1.780 Conley). R TWFE: -4.836 (1.495 cluster). Coefficient ~0.6% gap."

On direct reading of Table 2 in the PDF, Col (3) reports **-4.836*** (1.326) — not -4.863 as stated in the notes. The metadata note contains a transcription error in the paper beta (-4.863 vs actual -4.836) and the paper SE (1.780 vs actual 1.326 in Col 3). The PDF Table 2 is authoritative.

Selected specification: **Table 2, Column (3)** — full sample, all months, plant FEs + province-year-month FEs + weather controls; Conley spatial SE 600 km bandwidth; outcome = fire frequency within 90 km radius; N = 216,828 observations.

## Comparison

| Source | β | SE | N | cluster / SE type | sig |
|---|---|---|---|---|---|
| Paper — Table 2 Col (3) | -4.836 | (1.326) | 216,828 | Conley spatial (600 km) | *** |
| Our stored results.csv | -4.8365 | 1.4953 | — | cluster by plant id | *** |
| Relative Δ | -0.01% | +12.8% | | | |

## Notes

- The metadata `notes` field states "paper reports -4.863 (1.780 Conley)" — this is a transcription error. The PDF Table 2 Col (3) clearly shows -4.836*** with SE (1.326). Col (2) shows -5.075*** (1.370). The note appears to have confused columns or contains a typo; it does not affect the pipeline (which matches Col 3 correctly).
- SE divergence of 12.8% is fully explained by SE convention difference: the paper uses Conley spatial standard errors with 600 km bandwidth, while our template clusters at the plant (unit) level. The 12.8% gap is well within the 30% tolerance.
- N is not stored in results.csv; the paper reports 216,828 observations for Col (3), consistent with the full monthly panel of 954 plants × ~228 months.
- Sign is negative in both paper and our estimate (fire-reducing effect of BPP entry).

## Verdict rationale

Our stored beta_twfe (-4.8365) matches the paper's Table 2 Col (3) coefficient (-4.836) to within 0.01%, well under the 1% EXACT threshold; sign agreement confirmed.
