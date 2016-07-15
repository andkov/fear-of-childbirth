
# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
# library(magrittr) # enables piping : %>% 
# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
# requireNamespace("ggplot2") # graphing
# requireNamespace("readr")   # data input
# requireNamespace("tidyr")   # data manipulation
# requireNamespace("dplyr")   # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
# requireNamespace("testit")  # For asserting conditions meet expected patterns.
# requireNamespace("car")     # For it's `recode()` function.
library(magrittr)
library(ggplot2) # load ggplot
library(psych)
library(plotrix)
library(sem)
library(GPArotation)

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
source("./scripts/common-functions.R") # used in multiple reports
source("./scripts/graph-presets.R") # fonts, colors, themes 

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
ds_cor <- ds %>% dplyr::select(foc_01:foc_49)
ds_cor <- sapply(ds_cor, as.numeric)

R <- cor(ds_cor) # correlation matrix R of variables in foc
eigen <- eigen(R) # eigen decomposition of R      #  VDV' : $values -eigenvalues, $vectors
svd <- svd(R)   # single value decomposition of R #  UDV' : $d      -eigenvalues, $u,$v

# # ---- correlation-matrix --------------------
# ds_cor <- ds %>% dplyr::select(contains("foc_"))
# ds_cor <- sapply(ds_cor, as.numeric)
# str(ds_cor)


# ---- data-version-49 ------------------
ds_49 <- ds %>% dplyr::select(foc_01:foc_49)
vars_49 <- names(ds_49)
# vars_49 <- gsub("foc_", "_", vars_49)
vars_49 <- metaData %>% 
  dplyr::filter(name_new %in% vars_49) %>% 
  dplyr::mutate(name_ = paste0(gsub("foc_", "_", vars_49),"-",label_graph,"-",domain)) 
vars_49 <- vars_49[,"name_"]

ds_49 <- sapply(ds_49, as.numeric)
R49 <- cor(ds_49)
colnames(R49) <- vars_49
rownames(R49) <- vars_49
saveRDS(R49,"./data/shared/derived/cor.rds")
n.R49 <- sample_size
p.R49 <- nrow(R49)
colnames(R_49) <- vars_49
rownames(R_49) <- vars_49

# ---- data-version-10 ------------------
ds_10 <- ds %>% dplyr::select(foc_01:foc_10)
vars_10 <- names(ds_10)
vars_10 <- gsub("foc_", "", vars_10)
ds_10 <- sapply(ds_10, as.numeric)
R_10 <- cor(ds_10)
n.R_10 <- sample_size
p.R_10 <- nrow(R_10)
colnames(R_10) <- vars_10
rownames(R_10) <- vars_10

  
# ---- old-code-below ---------------------
# Harman.8: 8 x 8 correlation matrix of physical measures of 305 girls
# physical <- Harman.8
# vars.physical <- c("Height",
#                  "Arm span",
#                  "Length of forearm",
#                  "Length of lower leg",
#                  "Weight",
#                  "Bitrochanteric diameter",
#                  "Chest girth",
#                  "Ches width")
# vars.physycal <- colnames(Harman.8)
# colnames(physical) <- vars.physycal
# rownames(physical) <- vars.physycal
# n.physical <- 305
# p.physical <- nrow(physical)
# 
# #  24 psychological tests, N=145, Harman p.125 
# Harman74<-as.matrix(datasets::Harman74.cor$cov)
# vars.Harman74<-colnames(Harman74)
# n.Harman74<-145
# p.Harman74<-nrow(Harman74)
# 
# AthleticsData <- read.csv("http://statpower.net/Content/319SEM/Lecture%20Notes/AthleticsData.csv")
# 
# #  from GPArotation, no information provided in the package
# # data(Thurstone)
# Thurstone<-AthleticsData # Change AthleticData bakc to Thurstone 
# vars.Thurstone<-colnames(Thurstone)
# n.Thurstone<-200 # not sure of the number
# p.Thurstone<-nrow(Thurstone)


# rm(list=setdiff(ls(), c("cognitive", "emotional", "physical",
#                        "vars.cognitive", "vars.emotional","vars.physical",
#                        "n.cognitive", "n.emotional", "n.physical",
#                        "p.cognitive", "p.emotional", "p.physical")))


