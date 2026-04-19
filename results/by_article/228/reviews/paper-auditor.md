# Paper Auditor Report — Article 228
# Sarmiento, Wagner & Zaklan (2023) — Air Quality and LEZ

**Verdict:** NOT_APPLICABLE
**Date:** 2026-04-18

---

## Applicability Check

The paper-auditor is applicable iff:
1. `pdf/228.pdf` exists — **NO** (file not found)
2. `results/by_article/228/results.csv` has a numeric `beta_twfe` — YES (-1.2396)
3. `original_result` in metadata has a numeric beta — **NO** (`"original_result": {}` — empty)

Both conditions for applicability (PDF available AND paper's beta reportable) are not met:
- No PDF is available for text extraction
- The metadata `original_result` field is empty — the profiler did not record the paper's headline TWFE estimate (because the paper's primary TWFE is on daily data with weather controls, which is a different regression from our yearly no-controls TWFE)

### Reason for non-comparability

The paper's primary TWFE uses daily air quality data with weather controls and station×year FE at daily resolution. Our implementation uses yearly aggregated data without weather controls. These are fundamentally different regressions intended to be compared against different estimands. Recording the paper's daily-TWFE coefficient next to our yearly-TWFE coefficient would be misleading; hence `original_result` was correctly left empty.

**NOT_APPLICABLE** — No PDF for audit; no comparable paper beta recorded (daily vs. yearly data granularity mismatch makes fidelity comparison uninformative).

---

## Fidelity score: F-NA

The fidelity axis is not evaluable for this article. The methodology axis determines the final rating alone.
