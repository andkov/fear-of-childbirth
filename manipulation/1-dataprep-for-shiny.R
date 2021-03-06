
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

R <- cor(ds_cor) # correlation matrix R of variables in foc
eigen <- eigen(R) # eigen decomposition of R      #  VDV' : $values -eigenvalues, $vectors
svd <- svd(R)   # single value decomposition of R #  UDV' : $d      -eigenvalues, $u,$v

# # ---- correlation-matrix --------------------
# ds_cor <- ds %>% dplyr::select(contains("foc_"))
# ds_cor <- sapply(ds_cor, as.numeric)
# str(ds_cor)


# ---- data-phase-0 ------------------

items_phase_0 <- c(paste0("foc_0",1:9), paste0("foc_",10:49))


make_cor <- function(ds,metaData,items){
  
  # d <- ds %>% dplyr::select(foc_01:foc_49)
  d <- ds %>% dplyr::select_(.dots=items)
 
  rownames <- metaData %>% 
    dplyr::filter(name_new %in% items) %>% 
       dplyr::mutate(name_ = paste0(gsub("foc_", "", items),"---",domain, "---", label_graph))
       # dplyr::mutate(name_ = paste0(gsub("foc_", "", vars_49),"-",domain, "-",label_graph))
       # dplyr::mutate(name_ = paste0(gsub("foc_", "", vars_49),"-",label_graph))
  rownames <- rownames[,"name_"]
  
  d <- sapply(d, as.numeric)
  cormat <- cor(d)
  colnames(cormat) <- rownames; rownames(cormat) <- rownames
  return(cormat)
}
R0 <- make_cor(ds, metaData, items_phase_0)
saveRDS(R47,"./data/shared/derived/R0.rds") 



# ---- data-phase-1 ------------------
drop_items_1 <- c("foc_05", "foc_30", "foc_49")
items_phase_1 <- setdiff(items_phase_0, drop_items_1)
items = items_phase_1
R1 <- make_cor(ds, metaData, items_phase_1)


# ---- data-phase-2 ------------------
drop_items_2 <- c("foc_05", "foc_30", "foc_49")
items_phase_2 <- setdiff(items_phase_1, drop_items_2)
items = items_phase_2
R2 <- make_cor(ds, metaData, items_phase_2)


# ---- data-phase-3 ------------------


# ---- data-version-47 ------------------

ds_cor <- ds %>% dplyr::select(foc_01:foc_49, -foc_41, -foc_49)
ds_cor <- sapply(ds_cor, as.numeric)

ds_47 <- ds %>% dplyr::select(foc_01:foc_49, -foc_41, -foc_49)
vars_47 <- names(ds_47)

vars_47 <- metaData %>% 
  dplyr::filter(name_new %in% vars_47) %>% 
  # dplyr::mutate(name_ = paste0(gsub("foc_", "_", vars_49),"-",label_graph,"-",domain))
  # dplyr::mutate(name_ = label_short)
  dplyr::mutate(name_ = paste0(gsub("foc_", "", vars_47),"---",domain, "---", label_graph))
# dplyr::mutate(name_ = paste0(gsub("foc_", "", vars_49),"-",domain, "-",label_graph))
# dplyr::mutate(name_ = paste0(gsub("foc_", "", vars_49),"-",label_graph))
vars_47 <- vars_47[,"name_"] 

ds_47 <- sapply(ds_47, as.numeric) 
R47 <- cor(ds_47) 
colnames(R47) <- vars_47 
rownames(R47) <- vars_47 
saveRDS(R47,"./data/shared/derived/cor47.rds") 

# ---- data-phase-v ------------------

ds_cor <- ds %>% dplyr::select(foc_01:foc_49, -foc_05, -foc_18, -foc_49)
ds_cor <- sapply(ds_cor, as.numeric)

ds_46 <- ds %>% dplyr::select(foc_01:foc_49, -foc_05, -foc_18, -foc_49)
vars_46 <- names(ds_46)

vars_46 <- metaData %>% 
  dplyr::filter(name_new %in% vars_46) %>% 
  # dplyr::mutate(name_ = paste0(gsub("foc_", "_", vars_49),"-",label_graph,"-",domain))
  # dplyr::mutate(name_ = label_short)
  dplyr::mutate(name_ = paste0(gsub("foc_", "", vars_46),"---",domain, "---", label_graph))
# dplyr::mutate(name_ = paste0(gsub("foc_", "", vars_49),"-",domain, "-",label_graph))
# dplyr::mutate(name_ = paste0(gsub("foc_", "", vars_49),"-",label_graph))
vars_46 <- vars_46[,"name_"] 

ds_46 <- sapply(ds_46, as.numeric) 
R46 <- cor(ds_46) 
colnames(R46) <- vars_46 
rownames(R46) <- vars_46 
saveRDS(R46,"./data/shared/derived/cor_phase_1.rds") 



### ----  adlkfjakdf -------------------


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


