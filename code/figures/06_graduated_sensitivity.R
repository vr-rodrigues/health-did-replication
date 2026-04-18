###############################################################################
# panel_graduated_sensitivity.R
# 4-panel figure showing different geographic sensitivity dynamics
# IDs: 91 (Attenuation), 25 (Overfitting), 97 (Stable), 271 (Mixed)
###############################################################################
suppressPackageStartupMessages({
  library(ggplot2); library(dplyr); library(grid); library(gridExtra)
})

# Run from replication package root. Uses pre-computed sensitivity results.
base_dir <- getwd()

# Load graduated sensitivity data
grad <- read.csv(file.path(base_dir, "analysis", "sensitivity_graduated.csv"),
                 stringsAsFactors = FALSE)

paper_labels <- c(
  "233" = "Kresch (2020)",
  "25"  = "Carrillo & Feres (2019)",
  "97"  = "Bhalotra et al. (2021)",
  "271" = "Sekhri & Shastry (2024)"
)
diag_labels <- c(
  "233" = "Attenuation",
  "25"  = "Overfitting",
  "97"  = "Stable",
  "271" = "Mixed"
)

target_ids <- c("233", "25", "97", "271")
df <- grad %>%
  filter(article_id %in% target_ids) %>%
  filter(!grepl("\u22653", spec)) %>%
  mutate(
    spec_short = case_when(
      grepl("Baseline", spec) ~ "Baseline",
      grepl("Region", spec)  ~ "+ Region",
      grepl("full", spec)    ~ "+ State (full)",
      grepl("\u22655", spec)      ~ "+ State (overlap \u22655)",
      TRUE ~ spec
    ),
    spec_order = case_when(
      grepl("Baseline", spec) ~ 1,
      grepl("Region", spec)  ~ 2,
      grepl("full", spec)    ~ 3,
      grepl("\u22655", spec)      ~ 4,
      TRUE ~ 5
    ),
    ci_lo = att - 1.96 * se,
    ci_hi = att + 1.96 * se,
    is_failure = (att == 0 & is.na(se))
  ) %>%
  arrange(article_id, spec_order)

df$att_display <- ifelse(df$is_failure, NA, df$att)

make_panel <- function(data, title, subtitle, show_xlab = TRUE) {
  baseline <- data$att[data$spec_order == 1]
  data$spec_short <- factor(data$spec_short,
    levels = rev(unique(data$spec_short[order(data$spec_order)])))
  data$spec_color <- case_when(
    data$spec_order <= 2 ~ "Baseline / Region",
    data$spec_order == 3 ~ "State (full sample)",
    data$spec_order >= 4 ~ "State (overlap-restricted)"
  )
  color_vals <- c(
    "Baseline / Region" = "grey30",
    "State (full sample)" = "#E41A1C",
    "State (overlap-restricted)" = "#377EB8"
  )
  p <- ggplot(data, aes(x = att_display, y = spec_short, color = spec_color)) +
    geom_vline(xintercept = 0, linetype = "dashed", color = "grey60", linewidth = 0.4) +
    geom_vline(xintercept = baseline, linetype = "dotted", color = "grey40", linewidth = 0.5) +
    geom_errorbarh(aes(xmin = ci_lo, xmax = ci_hi), height = 0.18, linewidth = 0.7, na.rm = TRUE) +
    geom_point(size = 3.5, na.rm = TRUE) +
    {if (any(data$is_failure))
      annotate("text", x = baseline, y = data$spec_short[data$is_failure],
               label = "FAILURE", color = "#E41A1C", fontface = "bold", size = 4.5, hjust = 0.5)
    } +
    scale_color_manual(values = color_vals, guide = "none") +
    labs(title = title, subtitle = subtitle,
         x = if (show_xlab) "CS-DID ATT estimate" else NULL, y = NULL) +
    theme_minimal(base_size = 15) +
    theme(
      plot.title = element_text(size = 15, face = "bold"),
      plot.subtitle = element_text(size = 12, color = "grey40", face = "italic"),
      axis.text.y = element_text(size = 12),
      axis.text.x = element_text(size = 11),
      axis.title.x = element_text(size = 12),
      panel.grid.major.y = element_blank(),
      panel.grid.minor = element_blank(),
      panel.background = element_rect(fill = "white", color = NA),
      plot.background = element_rect(fill = "white", color = "grey85", linewidth = 0.4)
    )
  p
}

# Save each panel as individual PDF, then combine
d233 <- df %>% filter(article_id == "233")
d25  <- df %>% filter(article_id == "25")
d97  <- df %>% filter(article_id == "97")
d271 <- df %>% filter(article_id == "271")

pa <- make_panel(d233, "(a) Kresch (2020)", "Diagnosis: Attenuation", FALSE)
pb <- make_panel(d25,  "(b) Carrillo & Feres (2019)",        "Diagnosis: Overfitting",  FALSE)
pc <- make_panel(d97,  "(c) Bhalotra et al. (2021)",         "Diagnosis: Stable",       TRUE)
pd <- make_panel(d271, "(d) Sekhri & Shastry (2024)",        "Diagnosis: Mixed",        TRUE)

# Compose final PDF manually with explicit positioning
out_dir <- file.path(base_dir, "output", "figures")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
out_path <- file.path(out_dir, "figure_4_9_graduated_sensitivity.pdf")

# Page dimensions
W <- 14; H <- 8.5
pdf(out_path, width = W, height = H)

# Panel positions: 2x2 with explicit gaps
# Left=0.03, gap_h=0.035, right=0.03 → pw = (1 - 0.03 - 0.035 - 0.03) / 2 = 0.4525
# Top=0.98, gap_v=0.04, bottom=0.02 → ph = (0.98 - 0.04 - 0.02) / 2 = 0.46
pw <- 0.4525
ph <- 0.46
gap_h <- 0.035
gap_v <- 0.04
left  <- 0.03
top   <- 0.98

# (a) top-left
print(pa, vp = viewport(x = left, y = top - ph, width = pw, height = ph,
                         just = c("left", "bottom")))
# (b) top-right
print(pb, vp = viewport(x = left + pw + gap_h, y = top - ph, width = pw, height = ph,
                         just = c("left", "bottom")))
# (c) bottom-left
print(pc, vp = viewport(x = left, y = top - ph - gap_v - ph, width = pw, height = ph,
                         just = c("left", "bottom")))
# (d) bottom-right
print(pd, vp = viewport(x = left + pw + gap_h, y = top - ph - gap_v - ph, width = pw, height = ph,
                         just = c("left", "bottom")))

dev.off()
cat(sprintf("Saved: %s\n", out_path))

# (no temp files to clean)

# Print summary
cat("\n=== DATA SUMMARY ===\n")
for (id in target_ids) {
  cat(sprintf("\n%s \u2014 %s:\n", paper_labels[id], diag_labels[id]))
  dd <- df %>% filter(article_id == id) %>% arrange(spec_order)
  for (i in 1:nrow(dd)) {
    sig <- if (!is.na(dd$se[i]) && abs(dd$att[i]/dd$se[i]) > 1.96) "***"
           else if (!is.na(dd$se[i]) && abs(dd$att[i]/dd$se[i]) > 1.645) "**" else ""
    cat(sprintf("  %-25s  ATT=%+10.3f  SE=%8.3f  %s\n",
                dd$spec_short[i], dd$att[i],
                ifelse(is.na(dd$se[i]), NA, dd$se[i]), sig))
  }
}
