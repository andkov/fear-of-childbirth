# knitr::stitch_rmd(script="./___/___.R", output="./___/___/___.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # enables piping : %>% 
library(plotrix)
library(ggplot2)
library(ggplot2)# graphing
library(sem)
library(GPArotation)

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
# requireNamespace("ggplot2") # graphing
requireNamespace("readr")   # data input
requireNamespace("tidyr")   # data manipulation
requireNamespace("dplyr")   # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit")  # For asserting conditions meet expected patterns.
# requireNamespace("car")     # For it's `recode()` function.

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
source("./shinyApp/sourced/SteigerRLibraryFunctions.txt")
source("./shinyApp/sourced/AdvancedFactorFunctions_CF.R")
# source("./shinyApp/sourced/original/AdvancedFactorFunctions.R")
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
source("./scripts/common-functions.R") # used in multiple reports
source("./scripts/graph-presets.R") # fonts, colors, themes 
source("./scripts/fa-utility-functions.R") # to graph factor patterns

# ---- declare-globals ---------------------------------------------------------
sample_size <- 643

# ---- load-data ---------------------------------------------------------------
dto <- readRDS("./data/unshared/derived/dto.rds")
unitData <- dto$unitData
metaData <- dto$metaData 
ds <- dto$analytic

# ---- tweek-data ------------------------------------------------------------

# ---- inspect-data -------------------------------------------------------------
dplyr::glimpse(ds)
levels(ds$foc_01)


# ---- data-phase-0 -----------------------
items_phase_0 <- c(paste0("foc_0",1:9), paste0("foc_",10:49))
R0 <- make_cor(ds, metaData, items_phase_0)
str(R0)
R <- R0

# ---- data-phase-1 -------------------
# no loading: 5, 16, 18, 20, 28, 45
# only G : 31, 32, 33, 46, 49
drop_items_1 <-c("foc_05", "foc_16", "foc_18","foc_20","foc_28","foc_45",
                 "foc_31","foc_32","foc_33", "foc_46","foc_49")
items_phase_1 <- setdiff(items_phase_0, drop_items_1)
items = items_phase_1
R1 <- make_cor(ds, metaData, items_phase_1)
# Phase_1 <- ds
items_1 <- R1
n.items_1 <- sample_size
p.items_1 <- nrow(R1)
R <- R1

# ---- data-phase-2 -------------------
drop_items_2 <- c("foc_31", "foc_32", "foc_46")
items_phase_2 <- setdiff(items_phase_1, drop_items_2)
items = items_phase_2
R2 <- make_cor(ds, metaData, items_phase_2)
# Phase_2 <- ds
items_2 <- R2
n.items_2 <- sample_size
p.items_2 <- nrow(R2)
R <- R2

# ---- diagnostics ------------------------------------------------------
# Diagnosing number of factors
# Scree.Plot(R0)
# FA.Stats(R0,n.factors=1:15,n.obs=sample_size, RMSEA.cutoff=.08)

# ----- analysis-0 ---------------------

fit0 <- MLFA(
  Correlation.Matrix = R0,
  n.factors = 6,
  n.obs = 643,
  sort = FALSE
)
fit0$Bifactor$F %>% plot_factor_pattern()

print.MLFA(fit0, sort=TRUE,cutoff = .4)

print.FLS(fit0$Unrotated, sort=FALSE,cutoff = .5)
print.FLS(fit0$Varimax, sort=FALSE)
print.FLS(fit0$Promax, sort=FALSE)
print.FLS(fit0$Bifactor, sort=FALSE)
print.FLS(fit0$BifactorOblique, sort=FALSE)


x <- MLFA(R,n.factors,n.obs,cutoff=cutoff,num.digits=num.digits,promax.m=promax.m)   
x <- fit0$Bifactor
rotation = "Bifactor"
cstring <- paste(  c("rot.pattern <-x$",rotation),collapse="")
eval(parse(text=cstring))

# transform EFA model into SEM
rot.pattern = fit0$Bifactor
model <- FAtoSEM(
  x                 = rot.pattern ,
  model.name        = "./analysis/m0_bifactor",
  cutoff            = 0.30,
  factor.names      = colnames(rot.pattern$F),
  make.start.values = TRUE,
  cov.matrix        = TRUE,
  num.digits        = 4
)
fit <- sem(model,R0,sample_size)
RMSEA(fit)
model_summary(fit)

summary(fit)


