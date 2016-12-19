# knitr::stitch_rmd(script="./___/___.R", output="./___/___/___.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 

# ---- load-packages -----------------------------------------------------------
library(magrittr) # enables piping : %>% 
library(psych)
library(ggplot2)# graphing
library(sem)
library(GPArotation)
requireNamespace("readr")   # data input
requireNamespace("tidyr")   # data manipulation
requireNamespace("dplyr")   # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit")  # For asserting conditions meet expected patterns.
requireNamespace("readxl") # for inputing Excel files

# ---- load-sources ------------------------------------------------------------
source("./shinyApp/sourced/SteigerRLibraryFunctions.txt")
source("./shinyApp/sourced/AdvancedFactorFunctions_CF.R")
source("./scripts/common-functions.R") # used in multiple reports
source("./scripts/graph-presets.R") # fonts, colors, themes 
source("./scripts/fa-utility-functions.R") # to graph factor patterns

# ---- declare-globals ---------------------------------------------------------
sample_size <- 643
opt <- options(fit.indices = c("GFI", "AGFI", "RMSEA", "NFI", "NNFI", "CFI", "RNI", "IFI", "SRMR", "AIC", "AICc", "BIC", "CAIC"))

# ---- load-data ---------------------------------------------------------------
dto <- readRDS("./data/unshared/derived/dto.rds")
unitData <- dto$unitData
metaData <- dto$metaData 
ds <- dto$analytic

# ---- tweek-data ------------------------------------------------------------
names(ds)
set.seed(2)
ids_a <- sample(ds$id,321)
ds_a <- ds %>% dplyr::filter(id %in% ids_a)
ds_b <- ds %>% dplyr::filter(!id %in% ids_a)


# ---- inspect-data -------------------------------------------------------------
dplyr::glimpse(ds)
levels(ds$foc_01)



# ---- create-correlation-matrix-0 -----------------------
# Phase 0
items_phase_0 <- c(paste0("foc_0",1:9), paste0("foc_",10:49))
R0 <- make_cor(ds, metaData, items_phase_0)

# ----- dummm -----------------------
# set up phases 
# Phase 1
drop_items_1 <- c("foc_18","foc_16")
items_phase_1 <- setdiff(items_phase_0, drop_items_1)
R1 <- make_cor(ds, metaData, items_phase_1)

# Phase 2
drop_items_2 <- c("foc_49")
items_phase_2 <- setdiff(items_phase_1, drop_items_2)
R2 <- make_cor(ds, metaData, items_phase_2)

# Phase 3
drop_items_3 <- c("foc_27")
items_phase_3 <- setdiff(items_phase_2, drop_items_3)
R3 <- make_cor(ds, metaData, items_phase_3)


# Phase 4
drop_items_4 <- c("foc_28")
items_phase_4 <- setdiff(items_phase_3, drop_items_4)
R4 <- make_cor(ds, metaData, items_phase_4)


# Phase 5
drop_items_5 <- c("foc_05")
items_phase_5 <- setdiff(items_phase_4, drop_items_5)
R5 <- make_cor(ds, metaData, items_phase_5)


# ---- create-subsamples ---------------
set.seed(1981)
ids_a <- sample(ds$id,321)
ds_a <- ds %>% dplyr::filter(id %in% ids_a)
ds_b <- ds %>% dplyr::filter(!id %in% ids_a)

sample_size_a <- length(unique(ds_a$id))
sample_size_b <- length(unique(ds_b$id))

R0a <- make_cor(ds_a, metaData, items_phase_0)
R0b <- make_cor(ds_b, metaData, items_phase_0)



# ---- diagnose-0a ------------------------------------------------------
# Diagnosing number of factors
Scree.Plot(R0)
#The first 15 eigen values
data.frame(
  eigen = c(1:nrow(R0)),
  value = eigen(R0)$values
) %>%
  dplyr::filter(eigen < 16) %>%
  print()
# ---- diagnose-0b -------------------------
# MAP
psych::nfactors(R0,n.obs = 643)
# ---- diagnose-0c -------------------------
pa_results <- psych::fa.parallel(R0,643,fm = "ml",fa="fa")
ds_pa <- data.frame(
  observed_eigens = pa_results$fa.values,
  simulated_eigens = pa_results$fa.sim
) %>% head(15) %>% print()
# ---- diagnose-0d ------------------------------------------------------
ls_solution <- solve_factors(R0,min=1,max=15,sample_size = 643)
ds_index <- get_indices(ls_solution)

# ---- diagnose-0e -------------------------
FA.Stats(Correlation.Matrix = R0,n.obs = 643,n.factors = 1:15,RMSEA.cutoff = .08)

# ---- estimate-0 ---------------------------------
fit_efa_0 <- MLFA(
  Correlation.Matrix = R0,
  n.factors = 6,
  n.obs = 643,
  sort = FALSE
)
#Loadings from the EFA solution\n")
f_pattern <- fit_efa_0[['Bifactor']]$F 
f_pattern %>% plot_factor_pattern(factor_width = 6)
# Loadings above threashold (.3) are masked to see the simpler structure
f_pattern[f_pattern<.30] <- NA
f_pattern %>% plot_factor_pattern(factor_width = 6)

# ----- confirm-0 ------------------------
# These values are translated into CFA model and used as starting values
model_0 <- FAtoSEM(
  x                 = fit_efa_0[["Bifactor"]] ,
  cutoff            = 0.30,
  factor.names      = c("General","Interventions","Safety","Pain","Sex & Body","Shame"),
  make.start.values = TRUE,
  cov.matrix        = FALSE, # TRUE - oblique, FALSE - orthogonal
  num.digits        = 4
)
# the model is estimated using sem package
fit_0 <- sem::sem(model_0,R0,sample_size)
# the pattern of the solution
m <- GetPattern(fit_0)$F
m[m==0] <- NA
m %>% plot_factor_pattern(factor_width=6)
# Summary of the fitted model
sem_model_summary(fit_0)
#Relative contribudion of items 
sort(summary(fit_0)$Rsq) %>% dot_plot()


# ---- PHASE-1-PHASE-1-PHASE-1-PHASE-1-PHASE-1-PHASE-1 ----------

# ---- create-correlation-matrix-1 -----------------------
drop_items_1 <- c("foc_18","foc_16")
items_phase_1 <- setdiff(items_phase_0, drop_items_1)
R1 <- make_cor(ds, metaData, items_phase_1)

# ---- diagnose-1a -----------------------------------
# Diagnosing number of factors
Scree.Plot(R1)
#The first 15 eigen values
data.frame(
  eigen = c(1:nrow(R1)),
  value = eigen(R1)$values
) %>%
  dplyr::filter(eigen < 16) %>%
  print()
# ---- diagnose-1b -------------------------
# MAP
psych::nfactors(R1,n.obs = 643)
# ---- diagnose-1c -------------------------
pa_results <- psych::fa.parallel(R1,643,fm = "ml",fa="fa")
ds_pa <- data.frame(
  observed_eigens = pa_results$fa.values,
  simulated_eigens = pa_results$fa.sim
) %>% head(15) %>% print()
# ---- diagnose-1d -----------------------------------
ls_solution <- solve_factors(R1,min=1,max=15,sample_size = 643)
ds_index <- get_indices(ls_solution)
ds_index
# ---- diagnose-1e -------------------------
FA.Stats(Correlation.Matrix = R1,n.obs = 643,n.factors = 1:15,RMSEA.cutoff = .08)

# ---- estimate-1 ---------------------------------
fit_efa_1 <- MLFA(
  Correlation.Matrix = R1,
  n.factors = 6,
  n.obs = 643,
  sort = FALSE
)
#Loadings from the EFA solution\n")
f_pattern <- fit_efa_1[['Bifactor']]$F 
f_pattern %>% plot_factor_pattern(factor_width = 6)
# Loadings above threashold (.3) are masked to see the simpler structure
f_pattern[f_pattern<.30] <- NA
f_pattern %>% plot_factor_pattern(factor_width = 6)

# ----- confirm-1 ------------------------
# These values are translated into CFA model and used as starting values
model_1 <- FAtoSEM(
  x                 = fit_efa_1[["Bifactor"]] ,
  cutoff            = 0.30,
  factor.names      = c("General","Interventions","Safety","Pain","Sex & Body","Shame"),
  make.start.values = TRUE,
  cov.matrix        = FALSE, # TRUE - oblique, FALSE - orthogonal
  num.digits        = 4
)
# the model is estimated using sem package
fit_1 <- sem::sem(model_1,R1,sample_size)
# the pattern of the solution
m <- GetPattern(fit_1)$F
m[m==0] <- NA
m %>% plot_factor_pattern(factor_width=6)
# Summary of the fitted model
sem_model_summary(fit_1)
#Relative contribudion of items 
sort(summary(fit_1)$Rsq) %>% dot_plot()



# ---- PHASE-2-PHASE-2-PHASE-2-PHASE-2-PHASE-2-PHASE-2 ----------



# ---- create-correlation-matrix-2 -----------------------
drop_items_2 <- c("foc_49")
items_phase_2 <- setdiff(items_phase_1, drop_items_2)
R2 <- make_cor(ds, metaData, items_phase_2)

# ---- diagnose-2a -----------------------------------
# Diagnosing number of factors
Scree.Plot(R2)
#The first 15 eigen values
data.frame(
  eigen = c(1:nrow(R2)),
  value = eigen(R2)$values
) %>%
  dplyr::filter(eigen < 16) %>%
  print()
# ---- diagnose-2b -------------------------
# MAP
psych::nfactors(R2,n.obs = 643)
# ---- diagnose-2c -------------------------
pa_results <- psych::fa.parallel(R2,643,fm = "ml",fa="fa")
ds_pa <- data.frame(
  observed_eigens = pa_results$fa.values,
  simulated_eigens = pa_results$fa.sim
) %>% head(15) %>% print()
# ---- diagnose-2d -----------------------------------
ls_solution <- solve_factors(R2,min=1,max=15,sample_size = 643)
ds_index <- get_indices(ls_solution)
ds_index %>% print()
ds_index %>% plot_fit_indices()
# ---- diagnose-2e -------------------------
FA.Stats(Correlation.Matrix = R2,n.obs = 643,n.factors = 1:15,RMSEA.cutoff = .08)

# ---- estimate-2 ---------------------------------
fit_efa_2 <- MLFA(
  Correlation.Matrix = R2,
  n.factors = 6,
  n.obs = 643,
  sort = FALSE
)
#Loadings from the EFA solution\n")
f_pattern <- fit_efa_2[['Bifactor']]$F 
f_pattern %>% plot_factor_pattern(factor_width = 6)
# Loadings above threashold (.3) are masked to see the simpler structure
f_pattern[f_pattern<.30] <- NA
f_pattern %>% plot_factor_pattern(factor_width = 6)

# ----- confirm-2 ------------------------
# These values are translated into CFA model and used as starting values
model_2 <- FAtoSEM(
  x                 = fit_efa_2[["Bifactor"]] ,
  cutoff            = 0.30,
  factor.names      = c("General","Interventions","Safety","Pain","Sex & Body","Shame"),
  make.start.values = TRUE,
  cov.matrix        = FALSE, # TRUE - oblique, FALSE - orthogonal
  num.digits        = 4
)
# the model is estimated using sem package
fit_2 <- sem::sem(model_2,R2,sample_size)
# the pattern of the solution
m <- GetPattern(fit_2)$F
m[m==0] <- NA
m %>% plot_factor_pattern(factor_width=6)
# Summary of the fitted model
sem_model_summary(fit_2)
#Relative contribudion of items 
sort(summary(fit_2)$Rsq) %>% dot_plot()



# ---- PHASE-2-PHASE-2-PHASE-2-PHASE-2-PHASE-2-PHASE-2 ----------



# ---- create-correlation-matrix-2 -----------------------
drop_items_2 <- c("foc_49")
items_phase_2 <- setdiff(items_phase_1, drop_items_2)
R2 <- make_cor(ds, metaData, items_phase_2)

# ---- diagnose-2a -----------------------------------
# Diagnosing number of factors
Scree.Plot(R2)
#The first 15 eigen values
data.frame(
  eigen = c(1:nrow(R2)),
  value = eigen(R2)$values
) %>%
  dplyr::filter(eigen < 16) %>%
  print()
# ---- diagnose-2b -------------------------
# MAP
psych::nfactors(R2,n.obs = 643)
# ---- diagnose-2c -------------------------
pa_results <- psych::fa.parallel(R2,643,fm = "ml",fa="fa")
ds_pa <- data.frame(
  observed_eigens = pa_results$fa.values,
  simulated_eigens = pa_results$fa.sim
) %>% head(15) %>% print()
# ---- diagnose-2d -----------------------------------
ls_solution <- solve_factors(R2,min=1,max=15,sample_size = 643)
ds_index <- get_indices(ls_solution)
ds_index %>% print()
ds_index %>% plot_fit_indices()
# ---- diagnose-2e -------------------------
FA.Stats(Correlation.Matrix = R2,n.obs = 643,n.factors = 1:15,RMSEA.cutoff = .08)

# ---- estimate-2 ---------------------------------
fit_efa_2 <- MLFA(
  Correlation.Matrix = R2,
  n.factors = 6,
  n.obs = 643,
  sort = FALSE
)
#Loadings from the EFA solution\n")
f_pattern <- fit_efa_2[['Bifactor']]$F 
f_pattern %>% plot_factor_pattern(factor_width = 6)
# Loadings above threashold (.3) are masked to see the simpler structure
f_pattern[f_pattern<.30] <- NA
f_pattern %>% plot_factor_pattern(factor_width = 6)

# ----- confirm-2 ------------------------
# These values are translated into CFA model and used as starting values
model_2 <- FAtoSEM(
  x                 = fit_efa_2[["Bifactor"]] ,
  cutoff            = 0.30,
  factor.names      = c("General","Interventions","Safety","Pain","Sex & Body","Shame"),
  make.start.values = TRUE,
  cov.matrix        = FALSE, # TRUE - oblique, FALSE - orthogonal
  num.digits        = 4
)
# the model is estimated using sem package
fit_2 <- sem::sem(model_2,R2,sample_size)
# the pattern of the solution
m <- GetPattern(fit_2)$F
m[m==0] <- NA
m %>% plot_factor_pattern(factor_width=6)
# Summary of the fitted model
sem_model_summary(fit_2)
#Relative contribudion of items 
sort(summary(fit_2)$Rsq) %>% dot_plot()



# ---- PHASE-3-PHASE-3-PHASE-3-PHASE-3-PHASE-3-PHASE-3 ----------



# ---- create-correlation-matrix-3 -----------------------
drop_items_3 <- c("foc_27")
items_phase_3 <- setdiff(items_phase_2, drop_items_3)
R3 <- make_cor(ds, metaData, items_phase_3)

# ---- diagnose-3a -----------------------------------
# Diagnosing number of factors
Scree.Plot(R3)
#The first 15 eigen values
data.frame(
  eigen = c(1:nrow(R3)),
  value = eigen(R3)$values
) %>%
  dplyr::filter(eigen < 16) %>%
  print()
# ---- diagnose-3b -------------------------
# MAP
psych::nfactors(R3,n.obs = 643)
# ---- diagnose-3c -------------------------
pa_results <- psych::fa.parallel(R3,643,fm = "ml",fa="fa")
ds_pa <- data.frame(
  observed_eigens = pa_results$fa.values,
  simulated_eigens = pa_results$fa.sim
) %>% head(15) %>% print()
# ---- diagnose-3d -----------------------------------
ls_solution <- solve_factors(R3,min=1,max=15,sample_size = 643)
ds_index <- get_indices(ls_solution)
ds_index %>% print()
ds_index %>% plot_fit_indices()
# ---- diagnose-3e -------------------------
FA.Stats(Correlation.Matrix = R3,n.obs = 643,n.factors = 1:15,RMSEA.cutoff = .08)

# ---- estimate-3 ---------------------------------
fit_efa_3 <- MLFA(
  Correlation.Matrix = R3,
  n.factors = 6,
  n.obs = 643,
  sort = FALSE
)
#Loadings from the EFA solution\n")
f_pattern <- fit_efa_3[['Bifactor']]$F 
f_pattern %>% plot_factor_pattern(factor_width = 6)
# Loadings above threashold (.3) are masked to see the simpler structure
f_pattern[f_pattern<.30] <- NA
f_pattern %>% plot_factor_pattern(factor_width = 6)

# ----- confirm-3 ------------------------
# These values are translated into CFA model and used as starting values
model_3 <- FAtoSEM(
  x                 = fit_efa_3[["Bifactor"]] ,
  cutoff            = 0.31,
  factor.names      = c("General","Interventions","Safety","Pain","Sex & Body","Shame"),
  make.start.values = TRUE,
  cov.matrix        = FALSE, # TRUE - oblique, FALSE - orthogonal
  num.digits        = 4
)
# the model is estimated using sem package
fit_3 <- sem::sem(model_3,R3,sample_size)
# the pattern of the solution
m <- GetPattern(fit_3)$F
m[m==0] <- NA
m %>% plot_factor_pattern(factor_width=6)
# Summary of the fitted model
sem_model_summary(fit_3)
#Relative contribudion of items 
sort(summary(fit_3)$Rsq) %>% dot_plot()



# ---- PHASE-4-PHASE-4-PHASE-4-PHASE-4-PHASE-4-PHASE-4 ----------



# ---- create-correlation-matrix-4 -----------------------
drop_items_4 <- c("foc_28")
items_phase_4 <- setdiff(items_phase_3, drop_items_4)
R4 <- make_cor(ds, metaData, items_phase_4)

# ---- diagnose-4a -----------------------------------
# Diagnosing number of factors
Scree.Plot(R4)
#The first 15 eigen values
data.frame(
  eigen = c(1:nrow(R4)),
  value = eigen(R4)$values
) %>%
  dplyr::filter(eigen < 16) %>%
  print()
# ---- diagnose-4b -------------------------
# MAP
psych::nfactors(R4,n.obs = 643)
# ---- diagnose-4c -------------------------
pa_results <- psych::fa.parallel(R4,643,fm = "ml",fa="fa")
ds_pa <- data.frame(
  observed_eigens = pa_results$fa.values,
  simulated_eigens = pa_results$fa.sim
) %>% head(15) %>% print()
# ---- diagnose-4d -----------------------------------
ls_solution <- solve_factors(R4,min=1,max=15,sample_size = 643)
ds_index <- get_indices(ls_solution)
ds_index %>% print()
ds_index %>% plot_fit_indices()
# ---- diagnose-4e -------------------------
FA.Stats(Correlation.Matrix = R4,n.obs = 643,n.factors = 1:15,RMSEA.cutoff = .08)

# ---- estimate-4 ---------------------------------
fit_efa_4 <- MLFA(
  Correlation.Matrix = R4,
  n.factors = 6,
  n.obs = 643,
  sort = FALSE
)
#Loadings from the EFA solution\n")
f_pattern <- fit_efa_4[['Bifactor']]$F 
f_pattern %>% plot_factor_pattern(factor_width = 6)
# Loadings above threashold (.3) are masked to see the simpler structure
f_pattern[f_pattern<.30] <- NA
f_pattern %>% plot_factor_pattern(factor_width = 6)

# ----- confirm-4 ------------------------
# These values are translated into CFA model and used as starting values
model_4 <- FAtoSEM(
  x                 = fit_efa_4[["Bifactor"]] ,
  cutoff            = 0.31,
  factor.names      = c("General","Interventions","Safety","Pain","Sex & Body","Shame"),
  make.start.values = TRUE,
  cov.matrix        = FALSE, # TRUE - oblique, FALSE - orthogonal
  num.digits        = 4
)
# the model is estimated using sem package
fit_4 <- sem::sem(model_4,R4,sample_size)
# the pattern of the solution
m <- GetPattern(fit_4)$F
m[m==0] <- NA
m %>% plot_factor_pattern(factor_width=6)
# Summary of the fitted model
sem_model_summary(fit_4)
#Relative contribudion of items 
sort(summary(fit_4)$Rsq) %>% dot_plot()




# ---- PHASE-5-PHASE-5-PHASE-5-PHASE-5-PHASE-5-PHASE-5 ----------



# ---- create-correlation-matrix-5 -----------------------
drop_items_5 <- c("foc_05")
items_phase_5 <- setdiff(items_phase_4, drop_items_5)
R5 <- make_cor(ds, metaData, items_phase_5)


# ---- diagnose-5a -----------------------------------
# Diagnosing number of factors
Scree.Plot(R5)
#The first 15 eigen values
data.frame(
  eigen = c(1:nrow(R5)),
  value = eigen(R5)$values
) %>%
  dplyr::filter(eigen < 16) %>%
  print()
# ---- diagnose-5b -------------------------
# MAP
psych::nfactors(R5,n.obs = 643)
# ---- diagnose-5c -------------------------
pa_results <- psych::fa.parallel(R5,643,fm = "ml",fa="fa")
ds_pa <- data.frame(
  observed_eigens = pa_results$fa.values,
  simulated_eigens = pa_results$fa.sim
) %>% head(15) %>% print()
# ---- diagnose-5d -----------------------------------
ls_solution <- solve_factors(R5,min=1,max=15,sample_size = 643)
ds_index <- get_indices(ls_solution)
ds_index %>% print()
ds_index %>% plot_fit_indices()

 
# ---- diagnose-5e -------------------------
FA.Stats(Correlation.Matrix = R5,n.obs = 643,n.factors = 1:15,RMSEA.cutoff = .08)

# ---- estimate-5 ---------------------------------
fit_efa_5 <- MLFA(
  Correlation.Matrix = R5,
  n.factors = 6,
  n.obs = 643,
  sort = FALSE
)
#Loadings from the EFA solution\n")
f_pattern <- fit_efa_5[['Bifactor']]$F 
f_pattern %>% plot_factor_pattern(factor_width = 6)
# Loadings above threashold (.3) are masked to see the simpler structure
f_pattern[f_pattern<.30] <- NA
f_pattern %>% plot_factor_pattern(factor_width = 6)

# ----- confirm-5 ------------------------
# These values are translated into CFA model and used as starting values
model_5 <- FAtoSEM(
  x                 = fit_efa_5[["Bifactor"]] ,
  cutoff            = 0.315,
  factor.names      = c("General","Interventions","Safety","Pain","Sex & Body","Shame"),
  make.start.values = TRUE,
  cov.matrix        = FALSE, # TRUE - oblique, FALSE - orthogonal
  num.digits        = 4
)
# the model is estimated using sem package
fit_5 <- sem::sem(model_5,R5,sample_size)
# the pattern of the solution
m <- GetPattern(fit_5)$F
m[m==0] <- NA
m %>% plot_factor_pattern(factor_width=6)
# Summary of the fitted model
sem_model_summary(fit_5)
#Relative contribudion of items 
sort(summary(fit_5)$Rsq) %>% dot_plot()


# ---- conclusion -------------------
f_pattern <- fit_efa_5[['Bifactor']]$F 
f_pattern[f_pattern<.315] <- NA
f_pattern %>% plot_factor_pattern(factor_width = 6)

# in tabular form with trival loading masked
f_pattern %>% 
  knitr::kable(
    format = "pandoc",
    col.names = c("General","Interventions","Safety","Pain","Sex & Body","Shame")
    ) %>% 
  print()

# in tabular form with trival loading not masked
fit_efa_5[['Bifactor']]$F  %>% 
  knitr::kable()

# ----- publisher --------------------
path <- "./reports/appendix-a/appendix-a.Rmd"
rmarkdown::render(
  input = path ,
  output_format=c(
    "html_document" 
    ,"word_document"
  ),
  clean=TRUE
)







# ----- dummmm -----------------------

# Phase 1
drop_items_1 <- c("foc_18","foc_16")
items_phase_1 <- setdiff(items_phase_0, drop_items_1)
R1 <- make_cor(ds, metaData, items_phase_1)

# Phase 2
drop_items_2 <- c("foc_49")
items_phase_2 <- setdiff(items_phase_1, drop_items_2)
R2 <- make_cor(ds, metaData, items_phase_2)

# Phase 3
drop_items_3 <- c("foc_27")
items_phase_3 <- setdiff(items_phase_2, drop_items_3)
R3 <- make_cor(ds, metaData, items_phase_3)


# Phase 4
drop_items_4 <- c("foc_28")
items_phase_4 <- setdiff(items_phase_3, drop_items_4)
R4 <- make_cor(ds, metaData, items_phase_4)


# Phase 5
drop_items_5 <- c("foc_05")
items_phase_5 <- setdiff(items_phase_4, drop_items_5)
R5 <- make_cor(ds, metaData, items_phase_5)



# ---- diagnostics-1 ------------------------------------------------------
Scree.Plot(R1)
FA.Stats(R1,n.factors=1:15,n.obs=sample_size, RMSEA.cutoff=.08)

# ---- diagnostics-2 ------------------------------------------------------
Scree.Plot(R2)
FA.Stats(R2,n.factors=1:15,n.obs=sample_size, RMSEA.cutoff=.08)

# ---- diagnostics-2a ------------------------------------------------------
Scree.Plot(R2a)
FA.Stats(R2a,n.factors=1:15,n.obs=sample_size, RMSEA.cutoff=.08)


# ---- diagnostics-3 ------------------------------------------------------
Scree.Plot(R3)
FA.Stats(R3,n.factors=1:15,n.obs=sample_size, RMSEA.cutoff=.08)



# ---- estimate-models-1 ---------------------------------
fit_efa_1 <- MLFA(
  Correlation.Matrix = R1,
  n.factors = 6,
  n.obs = 643,
  sort = FALSE
)

# ---- estimate-models-2 ---------------------------------
fit_efa_2 <- MLFA(
  Correlation.Matrix = R2,
  n.factors = 6,
  n.obs = 643,
  sort = FALSE
)

# ---- estimate-models-2a ---------------------------------
fit_efa_2a <- MLFA(
  Correlation.Matrix = R2a,
  n.factors = 6,
  n.obs = 643,
  sort = FALSE
)

# ---- estimate-models-3 ---------------------------------
fit_efa_3 <- MLFA(
  Correlation.Matrix = R3,
  n.factors = 6,
  n.obs = 643,
  sort = FALSE
)

# ---- estimate-models-4 ---------------------------------
fit_efa_4 <- MLFA(
  Correlation.Matrix = R4,
  n.factors = 6,
  n.obs = 643,
  sort = FALSE
)






