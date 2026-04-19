d <- read.csv("results/by_article/420/results.csv", stringsAsFactors=FALSE)
cat(sprintf("beta_twfe (Spec C default, 9 twfe_ctrls): %.3f\n", d$beta_twfe[1]))
cat(sprintf("beta_twfe_no_ctrls (Spec B): %.3f\n", d$beta_twfe_no_ctrls[1]))
cat(sprintf("att_csdid_nt (default, cs_controls=1 Durb_f): %.3f\n", d$att_csdid_nt[1]))
cat(sprintf("att_nt_simple: %.3f\n", d$att_nt_simple[1]))
cat(sprintf("att_nt_dynamic: %.3f\n", d$att_nt_dynamic[1]))
cat(sprintf("att_cs_nt_with_ctrls (Spec A, with 9 twfe_ctrls): %s\n",
            format(d$att_cs_nt_with_ctrls[1], digits=4)))
cat(sprintf("att_cs_nt_with_ctrls_dyn: %s\n", format(d$att_cs_nt_with_ctrls_dyn[1], digits=4)))
