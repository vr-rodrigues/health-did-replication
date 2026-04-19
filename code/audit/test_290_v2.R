suppressPackageStartupMessages({ library(haven); library(dplyr); library(did) })
df <- haven::read_dta("data/raw/290/Data/Clean/Cleaned_Policy_Data.dta") %>% filter(year >= 2014 & year <= 2020)
df$st <- as.numeric(df$st); df$newdate <- as.numeric(df$newdate); df$newpolicydate <- as.numeric(df$newpolicydate)

cat("=== allow_unbalanced_panel=TRUE ===\n")
r1 <- tryCatch(att_gt(yname="mchiprate", tname="newdate", idname="st", gname="newpolicydate",
  data=as.data.frame(df), control_group="nevertreated", panel=TRUE,
  allow_unbalanced_panel=TRUE, base_period="universal"),
  error=function(e) list(err=conditionMessage(e)))
if (!is.null(r1$err)) cat("ERR:",r1$err,"\n") else {
  a <- tryCatch(aggte(r1,type="simple",na.rm=TRUE), error=function(e) list(err=conditionMessage(e)))
  cat("aggte simple:", if(!is.null(a$err)) a$err else a$overall.att, "\n")
  a2 <- tryCatch(aggte(r1,type="dynamic",na.rm=TRUE), error=function(e) list(err=conditionMessage(e)))
  cat("aggte dynamic:", if(!is.null(a2$err)) a2$err else a2$overall.att, "\n")
}

cat("\n=== panel=FALSE ===\n")
r2 <- tryCatch(att_gt(yname="mchiprate", tname="newdate", idname="st", gname="newpolicydate",
  data=as.data.frame(df), control_group="nevertreated", panel=FALSE,
  allow_unbalanced_panel=FALSE, base_period="universal"),
  error=function(e) list(err=conditionMessage(e)))
if (!is.null(r2$err)) cat("ERR:",r2$err,"\n") else {
  a <- tryCatch(aggte(r2,type="simple",na.rm=TRUE), error=function(e) list(err=conditionMessage(e)))
  cat("aggte simple:", if(!is.null(a$err)) a$err else a$overall.att, "\n")
}
