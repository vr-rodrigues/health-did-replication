###############################################################################
# render_readme_pdf.R -- create top-level README.pdf without external tooling
#
# AEA/DCAS asks for a README in PDF format in the uppermost directory. This
# renderer intentionally uses only base R graphics so the package does not depend
# on pandoc, quarto, or a LaTeX installation just to create README.pdf.
###############################################################################

base_dir <- getwd()
readme_md <- file.path(base_dir, "README.md")
readme_pdf <- file.path(base_dir, "README.pdf")

if (!file.exists(readme_md)) {
  stop("README.md not found at package root.", call. = FALSE)
}

lines <- readLines(readme_md, warn = FALSE, encoding = "UTF-8")

wrap_line <- function(x, width = 92) {
  if (!nzchar(x)) return("")
  if (grepl("^```", x)) return(x)
  if (grepl("^\\s", x)) return(strwrap(x, width = width, exdent = 2))
  if (grepl("^[-*] ", x)) return(strwrap(x, width = width, exdent = 2))
  strwrap(x, width = width)
}

wrapped <- unlist(lapply(lines, wrap_line), use.names = FALSE)
wrapped <- gsub("\t", "  ", wrapped, fixed = TRUE)

lines_per_page <- 58
pages <- split(wrapped, ceiling(seq_along(wrapped) / lines_per_page))

grDevices::pdf(readme_pdf, width = 8.5, height = 11, onefile = TRUE,
               family = "Courier")
on.exit(grDevices::dev.off(), add = TRUE)

for (i in seq_along(pages)) {
  graphics::plot.new()
  graphics::par(mar = c(0, 0, 0, 0))
  y <- 0.96
  graphics::text(0.05, y, sprintf("README.md (page %d of %d)",
                                  i, length(pages)),
                 adj = c(0, 1), cex = 0.72, font = 2)
  y <- y - 0.035
  for (line in pages[[i]]) {
    graphics::text(0.05, y, line, adj = c(0, 1), cex = 0.62)
    y <- y - 0.0155
  }
}

cat("Wrote", readme_pdf, "\n")
