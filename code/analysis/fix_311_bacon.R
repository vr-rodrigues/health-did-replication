###############################################################################
# fix_311_bacon.R
# Run Bacon decomposition for paper 311 (Galasso-Schankerman 2024), which
# was erroneously skipped due to a conservative 50k-row panel size limit in
# 04_bacon_all.R. The 7-cohort design requires only 49 TvT + 7 TvU = 56
# two-by-two comparisons, which is tractable even at ~80k obs.
###############################################################################
suppressPackageStartupMessages({
  library(haven); library(dplyr); library(bacondecomp); library(ggplot2)
})

base_dir <- getwd()
data_file <- file.path(base_dir, "data/raw/311/country_drugs.dta")
out_dir   <- file.path(base_dir, "results/by_article/311")

# Load data
df <- read_dta(data_file)
df <- as.data.frame(df)

# Apply metadata construct_vars
df$ID <- as.integer(factor(paste(df$country, df$product, sep = "_")))
df$product_code <- as.integer(factor(df$product))
df$country_code <- as.integer(factor(df$country))

gvar_df <- df[df$MPP == 1, c("ID", "year")]
gvar_df <- aggregate(year ~ ID, data = gvar_df, FUN = min)
names(gvar_df)[2] <- "gvar_CS"
df <- merge(df, gvar_df, by = "ID", all.x = TRUE)
df$gvar_CS[is.na(df$gvar_CS)] <- 0

# Build panel
panel <- data.frame(
  ..u = as.integer(df$ID),
  ..t = as.integer(df$year),
  y   = as.numeric(df$access),
  d   = as.integer(df$MPP)
)
panel <- panel[!is.na(panel$y) & !is.na(panel$d), ]

# Balance the panel (units present in every period)
all_times <- sort(unique(panel$..t))
units_complete <- panel %>%
  group_by(..u) %>%
  summarise(n = n_distinct(..t), .groups = "drop") %>%
  filter(n == length(all_times)) %>%
  pull(..u)
panel <- panel[panel$..u %in% units_complete, ]

cat(sprintf("Balanced panel: %d units x %d periods = %d obs\n",
            dplyr::n_distinct(panel$..u),
            dplyr::n_distinct(panel$..t),
            nrow(panel)))
cat(sprintf("Treated obs: %d (%.1f%%)\n",
            sum(panel$d == 1),
            100 * mean(panel$d == 1)))

# Run Bacon
cat("\nRunning Bacon decomposition...\n")
b <- bacon(y ~ d, data = panel, id_var = "..u", time_var = "..t", quietly = TRUE)

dd_avg <- sum(b$estimate * b$weight)
cat(sprintf("\nBacon DD avg: %.5f\n", dd_avg))

grp <- b %>% group_by(type) %>%
  summarise(n = n(),
            avg_est = round(mean(estimate), 5),
            sum_wt = round(sum(weight), 4), .groups = "drop")
cat("\n=== Decomposition by type ===\n")
print(grp)

# Identify forbidden (TvT) comparisons
tvt_wt <- sum(b$weight[b$type %in% c("Earlier vs Later Treated",
                                      "Later vs Earlier Treated")])
tvu_wt <- sum(b$weight[b$type == "Treated vs Untreated"])
cat(sprintf("\nTvT (forbidden) weight: %.4f (%.1f%%)\n", tvt_wt, 100*tvt_wt))
cat(sprintf("TvU (clean)     weight: %.4f (%.1f%%)\n", tvu_wt, 100*tvu_wt))

# Save outputs
write.csv(b, file.path(out_dir, "bacon.csv"), row.names = FALSE)
cat(sprintf("\nSaved: %s\n", file.path(out_dir, "bacon.csv")))

# Plot
b$group <- dplyr::case_when(
  b$type %in% c("Earlier vs Later Treated", "Later vs Earlier Treated") ~ "Timing groups",
  b$type == "Treated vs Untreated" ~ "Treated vs Untreated",
  TRUE ~ b$type
)

p <- ggplot(b, aes(x = weight, y = estimate, color = group)) +
  geom_point(alpha = 0.6, size = 2) +
  geom_hline(yintercept = dd_avg, linetype = "dashed", color = "red") +
  geom_hline(yintercept = 0, color = "black", linewidth = 0.2) +
  labs(title = "Galasso & Schankerman (2024) — Goodman-Bacon decomposition",
       subtitle = sprintf("DD avg = %.4f (red dashed); %d two-by-two comparisons", dd_avg, nrow(b)),
       x = "Weight", y = "Estimate", color = "Comparison type") +
  theme_minimal() +
  theme(legend.position = "bottom")

ggsave(file.path(out_dir, "bacon_decomposition.pdf"),
       plot = p, width = 7, height = 5)
cat(sprintf("Saved: %s\n", file.path(out_dir, "bacon_decomposition.pdf")))
