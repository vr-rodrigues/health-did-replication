###############################################################################
# panel_csdid_controls_133.R
# 2-panel: CS-DID unconditional vs CS-DID conditional (no TWFE)
# Aesthetic matches event_study originals (Kresch-style green tones)
###############################################################################
suppressPackageStartupMessages({
  library(haven); library(dplyr); library(did); library(ggplot2)
  library(grid)
})

# WARNING: Requires original Hoynes, Miller & Simon (2015) replication data.
# See data_availability_statement.md. Run from replication package root.
base_dir <- getwd()

# ── Load & prepare ──────────────────────────────────────────────────────────
df <- as.data.frame(read_dta(file.path(base_dir, "data", "raw", "133", "id_21.dta"))) %>%
  filter(effective >= 1991 & effective <= 1998,
         dmeducgrp <= 2, marital == 2) %>%
  mutate(
    lowbirth   = lowbirth * 100,
    gvar_CS    = as.numeric(ifelse(parvar >= 2, 1994, 0)),
    row_id     = seq_len(n()),
    stateres_f = factor(stateres)
  )

did_ctrl_cs <- c("other","black","age2","age3","high","hispanic","hispanicmiss")

# ── 1. CS-NT unconditional ──────────────────────────────────────────────────
cat("[1] CS-NT unconditional\n")
cs_uncond <- att_gt(
  yname="lowbirth", tname="effective", idname="row_id",
  gname="gvar_CS", weightsname="cellnum", xformla=~1,
  clustervars="stateres", base_period="universal",
  control_group="nevertreated", panel=FALSE,
  allow_unbalanced_panel=TRUE, data=df
)
dyn_uncond <- aggte(cs_uncond, type="dynamic")

# ── 2. CS-NT conditional ────────────────────────────────────────────────────
cat("[2] CS-NT conditional\n")
xf_ctrl <- as.formula(paste("~ stateres_f +", paste(did_ctrl_cs, collapse=" + ")))
cs_cond <- att_gt(
  yname="lowbirth", tname="effective", idname="row_id",
  gname="gvar_CS", weightsname="cellnum", xformla=xf_ctrl,
  est_method="dr", clustervars="stateres", base_period="universal",
  control_group="nevertreated", panel=FALSE,
  allow_unbalanced_panel=TRUE, data=df
)
dyn_cond <- aggte(cs_cond, type="dynamic")

# ── Build data frames ────────────────────────────────────────────────────────
make_es <- function(dyn) {
  data.frame(
    time = c(dyn$egt, -1L),
    coef = c(dyn$att.egt, 0),
    se   = c(dyn$se.egt, 0),
    stringsAsFactors = FALSE
  ) %>%
    mutate(ci_lo = coef - 1.96*se, ci_hi = coef + 1.96*se) %>%
    arrange(time)
}

es_uncond <- make_es(dyn_uncond)
es_cond   <- make_es(dyn_cond)

# ── Shared y-limits ──────────────────────────────────────────────────────────
all_vals <- bind_rows(es_uncond, es_cond)
ylim <- c(min(all_vals$ci_lo, na.rm=TRUE) * 1.08,
          max(all_vals$ci_hi, na.rm=TRUE) * 1.08)

# ── ATT labels ───────────────────────────────────────────────────────────────
att_u <- aggte(cs_uncond, type="simple")
att_c <- aggte(cs_cond,   type="simple")

# ── Panel plot function (Kresch-style aesthetic) ─────────────────────────────
make_panel <- function(data, title, subtitle, pt_color, pt_shape, pt_size) {
  ggplot(data, aes(x=time, y=coef)) +
    geom_hline(yintercept=0, color="grey70", linetype="dashed", linewidth=0.3) +
    geom_vline(xintercept=-0.5, color="grey60", linetype="dotted", linewidth=0.3) +
    geom_errorbar(aes(ymin=ci_lo, ymax=ci_hi),
                  width=0.12, linewidth=0.7, color=pt_color) +
    geom_point(size=pt_size+0.5, color=pt_color, shape=pt_shape, stroke=1.2) +
    scale_x_continuous(breaks=seq(-3, 4)) +
    coord_cartesian(ylim=ylim) +
    labs(title=title, subtitle=subtitle,
         x="Relative Time to Treatment", y="ATT") +
    theme_classic(base_size=15) +
    theme(
      plot.title    = element_text(size=15, face="bold"),
      plot.subtitle = element_text(size=12, color="grey40", face="italic"),
      axis.title    = element_text(size=13),
      axis.text     = element_text(size=12)
    )
}

# Colors/shapes matching Kresch: dark green X vs light green open circle
att_u_d <- aggte(cs_uncond, type="dynamic")
att_c_d <- aggte(cs_cond,   type="dynamic")
# Dynamic ATT = mean of post-treatment dynamic coefficients
dyn_att_u <- mean(dyn_uncond$att.egt[dyn_uncond$egt >= 0])
dyn_se_u  <- sqrt(mean(dyn_uncond$se.egt[dyn_uncond$egt >= 0]^2))
dyn_att_c <- mean(dyn_cond$att.egt[dyn_cond$egt >= 0])
dyn_se_c  <- sqrt(mean(dyn_cond$se.egt[dyn_cond$egt >= 0]^2))

pa <- make_panel(es_uncond,
  "(a) CS-DID unconditional",
  sprintf("ATT(dynamic) = %.3f (%.3f)", att_u$overall.att, att_u$overall.se),
  "forestgreen", 4, 2.0)   # X, dark green

pb <- make_panel(es_cond,
  "(b) CS-DID conditional",
  sprintf("ATT(dynamic) = %.3f (%.3f)", att_c$overall.att, att_c$overall.se),
  "#7BBF6A", 1, 2.0)       # open circle, lighter green

# ── Compose 2-panel PDF (viewport approach) ─────────────────────────────────
out_dir <- file.path(base_dir, "output", "figures")
dir.create(out_dir, recursive = TRUE, showWarnings = FALSE)
out_path <- file.path(out_dir, "figure_4_8_panel_controls_133.pdf")
W <- 11; H <- 5.5
pdf(out_path, width=W, height=H)

pw <- 0.47; ph <- 0.94
gap_h <- 0.03
left  <- 0.02
top   <- 0.98

print(pa, vp=viewport(x=left, y=top-ph, width=pw, height=ph,
                       just=c("left","bottom")))
print(pb, vp=viewport(x=left+pw+gap_h, y=top-ph, width=pw, height=ph,
                       just=c("left","bottom")))

dev.off()
cat(sprintf("\nSaved: %s\n", out_path))

# ── Summary ──────────────────────────────────────────────────────────────────
cat("\n=== SUMMARY ===\n")
cat(sprintf("CS-DID unconditional: ATT = %.3f (SE = %.3f)\n", att_u$overall.att, att_u$overall.se))
cat(sprintf("CS-DID conditional:   ATT = %.3f (SE = %.3f)\n", att_c$overall.att, att_c$overall.se))
cat(sprintf("Attenuation:          %.0f%%\n", (1 - abs(att_c$overall.att)/abs(att_u$overall.att))*100))
cat("\nPre-trends:\n")
cat(sprintf("  %-25s t=-3: %+.4f   t=-2: %+.4f\n", "CS-DID unconditional",
    dyn_uncond$att.egt[dyn_uncond$egt==-3], dyn_uncond$att.egt[dyn_uncond$egt==-2]))
cat(sprintf("  %-25s t=-3: %+.4f   t=-2: %+.4f\n", "CS-DID conditional",
    dyn_cond$att.egt[dyn_cond$egt==-3], dyn_cond$att.egt[dyn_cond$egt==-2]))
