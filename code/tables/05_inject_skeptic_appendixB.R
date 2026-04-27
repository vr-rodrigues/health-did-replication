##############################################################################
# 05_inject_skeptic_appendixB.R
# Injects the skeptic 3-axis rating line into each article card in
# overleaf/Appendices/AppendixB.tex and removes the three excluded papers
# (234 Myers, 242 Moorthy, 380 Kuziemko) so the appendix contains exactly 53
# cards consistent with the dissertation's comparable subsample.
#
# Idempotent: running it repeatedly produces the same output.
##############################################################################

suppressPackageStartupMessages({
  library(dplyr)
})

base_dir <- getwd()
appendix_path <- file.path(base_dir, "overleaf", "Appendices", "AppendixB.tex")

# ── 1. Load skeptic ratings ────────────────────────────────────────────────
sk <- read.csv(file.path(base_dir, "analysis", "skeptic_ratings.csv"),
               stringsAsFactors = FALSE, check.names = FALSE)
sk <- sk[, c("id", "rating", "fidelity_verdict", "design_credibility")]

# Fallback strings for missing fields
fmt_field <- function(x) ifelse(is.na(x) | x == "", "---", as.character(x))

sk$rating            <- fmt_field(sk$rating)
sk$fidelity_verdict  <- gsub("_", "\\\\_", fmt_field(sk$fidelity_verdict))
sk$design_credibility <- fmt_field(sk$design_credibility)

sk_lookup <- setNames(
  sprintf("\\textbf{Skeptic rating:} %s \\hfill \\textbf{Fidelity:} %s \\hfill \\textbf{Design:} %s",
          sk$rating, sk$fidelity_verdict, sk$design_credibility),
  sk$id
)

excluded_ids <- c("234", "242", "380")

# ── 2. Read file ───────────────────────────────────────────────────────────
lines <- readLines(appendix_path, warn = FALSE)

# ── 3. Detect card blocks ──────────────────────────────────────────────────
# A "card block" spans from a marker line to just before the next marker
# (or EOF / the card-only section header). Two marker formats:
#   % ===== Article ID N =====   (main section, includes figures)
#   % --- Article ID N ---       (tail section, no figures)
#
# We remove excluded IDs and inject the skeptic line inside the tcolorbox
# for the remaining ones.

marker_re <- "^%\\s*(=====|---)\\s*Article ID\\s+([0-9]+)\\s*(=====|---)\\s*$"
marker_idx <- grep(marker_re, lines)

if (length(marker_idx) == 0) stop("No article-card markers found in AppendixB.tex")

# Card block = marker_idx[i] .. marker_idx[i+1]-1 (last block ends at EOF)
block_end <- c(marker_idx[-1] - 1L, length(lines))

# Extract ID from each marker
marker_ids <- sub(marker_re, "\\2", lines[marker_idx])

# Pre-amble (everything above the first card) is preserved
preamble_end <- marker_idx[1] - 1L
out <- lines[seq_len(preamble_end)]

for (i in seq_along(marker_idx)) {
  id <- marker_ids[i]
  block <- lines[marker_idx[i]:block_end[i]]

  # Skip excluded cards AND the \clearpage immediately preceding them (if any)
  if (id %in% excluded_ids) {
    # Drop a trailing \clearpage from `out` if the previous non-empty line is one
    # so we don't get two \clearpage in a row or orphan \clearpage before a
    # removed card.
    j <- length(out)
    while (j > 0 && trimws(out[j]) == "") j <- j - 1
    if (j > 0 && grepl("^\\s*\\\\clearpage\\s*$", out[j])) {
      out <- out[seq_len(j - 1)]
    }
    next
  }

  # Inject skeptic line just before \end{tcolorbox}. Cards have exactly one
  # tcolorbox; we locate the line with \end{tcolorbox} and insert above it.
  tcb_end <- grep("^\\s*\\\\end\\{tcolorbox\\}\\s*$", block)
  if (length(tcb_end) == 0) {
    # no tcolorbox end found; write block unchanged
    out <- c(out, block)
    next
  }
  insert_at <- tcb_end[1]

  # Check if a skeptic line already exists in this block (idempotency)
  has_sk <- any(grepl("Skeptic rating:", block, fixed = TRUE))
  if (has_sk) {
    # Remove existing skeptic-rating block and re-insert fresh one
    sk_line_idx <- grep("Skeptic rating:", block, fixed = TRUE)
    # Also remove the \tcbline or \rule marker immediately above it, and any
    # trailing blank line right before \end{tcolorbox}.
    drop_idx <- sk_line_idx
    for (k in (sk_line_idx - 1):(sk_line_idx - 2)) {
      if (k >= 1 && grepl("\\\\tcbline|\\\\rule|\\\\hrule", block[k]) ) {
        drop_idx <- c(drop_idx, k)
      }
    }
    block <- block[-sort(unique(drop_idx))]
    tcb_end <- grep("^\\s*\\\\end\\{tcolorbox\\}\\s*$", block)
    insert_at <- tcb_end[1]
  }

  sk_str <- sk_lookup[[id]]
  if (is.null(sk_str)) {
    sk_str <- "\\textbf{Skeptic rating:} --- \\hfill \\textbf{Fidelity:} --- \\hfill \\textbf{Design:} ---"
  }

  injection <- c(
    "  \\tcbline",
    paste0("  ", sk_str)
  )

  new_block <- c(block[seq_len(insert_at - 1)], injection, block[insert_at:length(block)])
  out <- c(out, new_block)
}

# ── 4. Write output ────────────────────────────────────────────────────────
writeLines(out, appendix_path)
cat("[05_inject_skeptic_appendixB] rewrote", appendix_path, "\n")
cat("  cards originally:", length(marker_idx),
    "| excluded:", sum(marker_ids %in% excluded_ids),
    "| remaining:", length(marker_idx) - sum(marker_ids %in% excluded_ids), "\n")
