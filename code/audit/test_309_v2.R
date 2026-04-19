suppressPackageStartupMessages({ library(haven); library(dplyr); library(did); library(jsonlite) })
meta <- fromJSON("data/metadata/309.json")
df <- haven::read_dta(meta$data$file) %>% filter(year >= 1979 & year <= 2005)
df$state_code <- as.numeric(df$state_code); df$year <- as.numeric(df$year); df$first_year_full_wdlapY <- as.numeric(df$first_year_full_wdlapY)

full_coverage_states <- df %>% count(state_code) %>% filter(n == 27) %>% pull(state_code)
cat("Full-coverage states (all 27 yrs):", length(full_coverage_states), "\n")
df_bal <- df %>% filter(state_code %in% full_coverage_states)
cat("Balanced rows:", nrow(df_bal), "\n")
cat("Cohorts in balanced:"); print(table(df_bal$first_year_full_wdlapY))

r <- tryCatch(att_gt(yname="ln_acc_rateY_matt", tname="year", idname="state_code",
  gname="first_year_full_wdlapY", data=as.data.frame(df_bal),
  control_group="nevertreated", panel=TRUE,
  allow_unbalanced_panel=FALSE, base_period="universal"),
  error=function(e) list(err=conditionMessage(e)))
if (!is.null(r$err)) cat("ERR:",r$err,"\n") else {
  a <- tryCatch(aggte(r,type="simple",na.rm=TRUE), error=function(e) list(err=conditionMessage(e)))
  cat("simple:", if(!is.null(a$err)) a$err else a$overall.att, "\n")
  ad <- tryCatch(aggte(r,type="dynamic",na.rm=TRUE), error=function(e) list(err=conditionMessage(e)))
  cat("dynamic:", if(!is.null(ad$err)) ad$err else ad$overall.att, "\n")
}
