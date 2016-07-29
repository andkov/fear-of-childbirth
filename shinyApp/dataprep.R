library(magrittr)
library(datasets)
library(ggplot2) # load ggplot
library(psych)
library(plotrix)
library(sem)
library(GPArotation)


# ---- declare-globals ---------------------------------------------------------
sample_size <- 643
# ---- load-data ---------------------------------------------------------------
dto <- readRDS("./data/unshared/derived/dto.rds")
unitData <- dto$unitData
metaData <- dto$metaData 
ds <- dto$analytic

names(ds)
names(metaData)



# ---- tweek-data ------------------------------------------------------------

# ---- inspect-data -------------------------------------------------------------
dplyr::glimpse(ds)
levels(ds$foc_01)

R <- cor(ds_cor) # correlation matrix R of variables in foc
eigen <- eigen(R) # eigen decomposition of R      #  VDV' : $values -eigenvalues, $vectors
svd <- svd(R)   # single value decomposition of R #  UDV' : $d      -eigenvalues, $u,$v

# ---- function-make-correlation-matrix ------------------------------
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

# ---- data-phase-0 ------------------
items_phase_0 <- c(paste0("foc_0",1:9), paste0("foc_",10:49))
R0 <- make_cor(ds, metaData, items_phase_0)
saveRDS(R0,"./data/shared/derived/R0.rds") 
# Phase_0 <- ds
items_0 <- R0
n.items_0 <- sample_size
p.items_0 <- nrow(R0)


# ---- data-phase-1 ------------------
drop_items_1 <- c("foc_05", "foc_30", "foc_49")
items_phase_1 <- setdiff(items_phase_0, drop_items_1)
items = items_phase_1
R1 <- make_cor(ds, metaData, items_phase_1)
# Phase_1 <- ds
items_1 <- R1
n.items_1 <- sample_size
p.items_1 <- nrow(R1)

# ---- data-phase-2 ------------------
drop_items_2 <- c("foc_09", "foc_32", "foc_45")
items_phase_2 <- setdiff(items_phase_1, drop_items_2)
items = items_phase_2
R2 <- make_cor(ds, metaData, items_phase_2)
# Phase_2 <- ds
items_2 <- R2
n.items_2 <- sample_size
p.items_2 <- nrow(R2)


# # ---- data-for-49-items ------------
# items_49 <- ds
# n.items_49 <- sample_size
# p.items_49 <- nrow(items_49)
# 
# # ---- data-for-47-items ------------
# items_47 <- ds_47 
# n.items_47 <- sample_size
# p.items_47 <- nrow(items_47)
# 
# # ---- data-for-46-items ------------
# # droping items 5, 18, 49
# items_46 <- ds_46 
# n.items_46 <- sample_size
# p.items_46 <- nrow(items_46)
# 
# # ---- data-for-35-items ------------
# items_35 <- ds[1:10,1:10]
# n.items_35 <- sample_size
# p.items_35 <- nrow(items_35)

# Harman.Holzinger: 9 x 9 correlation matrix of cognitive ability tests, N = 696.
cognitive <- Harman.Holzinger
n.cognitive <- 696
p.cognitive <- nrow(cognitive)
vars.cognitive <- c("Word.Mean",
                     "Sent.Compl",
                     "Odd.Words",
                     "Mix.Arith",
                     "Remainders",
                     "Miss.Num.",
                     "Gloves",
                     "Boots",
                     "Hatchets")
colnames(cognitive) <- vars.cognitive
rownames(cognitive) <- vars.cognitive

# Harman.Burt: a 8 x 8 correlation matrix of “emotional" items. N = 172
emotional <- Harman.Burt
vars.emotional <- c("Sociability",
                      "Sorrow",
                      "Tenderness",
                      "Joy ",
                      "Wonder",
                      "Disgust ",
                      "Anger",
                      "Fear")
colnames(emotional) <- vars.emotional
rownames(emotional) <- vars.emotional
n.emotional <- 172
p.emotional <- nrow(emotional)
# emotional matrix is not positive definity due to original typo
# see explanations in the psych package documentation under Harman.Burt
emotional["Tenderness", "Sorrow"] <- .81
emotional["Sorrow", "Tenderness"] <- .81

# Harman.8: 8 x 8 correlation matrix of physical measures of 305 girls
physical <- Harman.8
vars.physical <- c("Height",
                 "Arm span",
                 "Length of forearm",
                 "Length of lower leg",
                 "Weight",
                 "Bitrochanteric diameter",
                 "Chest girth",
                 "Ches width")
vars.physycal <- colnames(Harman.8)
colnames(physical) <- vars.physycal
rownames(physical) <- vars.physycal
n.physical <- 305
p.physical <- nrow(physical)

#  24 psychological tests, N=145, Harman p.125 
Harman74<-as.matrix(datasets::Harman74.cor$cov)
vars.Harman74<-colnames(Harman74)
n.Harman74<-145
p.Harman74<-nrow(Harman74)

AthleticsData <- read.csv("http://statpower.net/Content/319SEM/Lecture%20Notes/AthleticsData.csv")

#  from GPArotation, no information provided in the package
# data(Thurstone)
Thurstone<-AthleticsData # Change AthleticData bakc to Thurstone 
vars.Thurstone<-colnames(Thurstone)
n.Thurstone<-200 # not sure of the number
p.Thurstone<-nrow(Thurstone)


# rm(list=setdiff(ls(), c("cognitive", "emotional", "physical",
#                        "vars.cognitive", "vars.emotional","vars.physical",
#                        "n.cognitive", "n.emotional", "n.physical",
#                        "p.cognitive", "p.emotional", "p.physical")))


