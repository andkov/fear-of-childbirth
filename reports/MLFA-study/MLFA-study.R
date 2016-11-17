# The purpose of this script is to understand the functionality
# and properties of the MLFA function and specifically
# compare the factor pattern matrices before and after FixPattern() application

# knitr::stitch_rmd(script="./___/___.R", output="./___/___/___.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # enables piping : %>% 
library(plotrix)
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
source("./scripts/factor-pattern-plot.R") # to graph factor patterns

# ---- declare-globals ---------------------------------------------------------
sample_size <- 643

rotation_methods <- c(
  "oblimin"  
  ,"quartimin"
  ,"targetT"  
  ,"targetQ"  
  ,"pstT"     
  ,"pstQ"     
  ,"oblimax"  
  ,"entropy"  
  ,"quartimax"
  ,"Varimax"  
  ,"simplimax"
  ,"bentlerT" 
  ,"bentlerQ" 
  ,"tandemI"  
  ,"tandemII" 
  ,"geominT"  
  ,"geominQ"  
  ,"cfT"      
  ,"cfQ"      
  ,"infomaxT" 
  ,"infomaxQ" 
  ,"mccammon" 
  ,"bifactorT"
  ,"bifactorQ"
)
# ---- load-data ---------------------------------------------------------------
dto <- readRDS("./data/unshared/derived/dto.rds")
unitData <- dto$unitData
metaData <- dto$metaData 
ds <- dto$analytic

# ----- function-correlation --------------
make_cor <- function(ds,metaData,items){
  # items <- items_phase_0
  # d <- ds %>% dplyr::select(foc_01:foc_49)
  d <- ds %>% dplyr::select_(.dots=items)
  d <- sapply(d, as.numeric)
  cormat <- cor(d)
  # str(cormat)
  names <- attr(cormat,"dimnames")[[1]]
  names(names) <- names
  for(i in names){
    domain <- as.character(metaData[metaData$name_new==i,"domain"])
    label_graph <- as.character(metaData[metaData$name_new==i,"label_graph"])
    names[i] <- paste0(gsub("foc_","",names[i]),"_", domain,"_",label_graph)
  }
  names_new <- as.character(names)
  attr(cormat,"dimnames")[[1]] <- names_new
  attr(cormat,"dimnames")[[2]] <- names_new
  # str(cormat)
  return(cormat)
}

model_summary <- function(model_object){
  cat("\nRMSEA: \n")
  print(RMSEA(model_object))
  cat("\nLL:",logLik(model_object))
  cat("\nAIC:",AIC(model_object))
  cat("\nAICc:",AICc(model_object))
  cat("\nBIC:",BIC(model_object))
  cat("\n")
  GetPrettyPattern(model_object, cutoff = 0.05,sort=FALSE)
}

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
# ---- correlation-matrix --------------------
R <- R0 # R0 , R1 , R2 

# R <- cor(ds_cor) # correlation matrix R of variables in foc
# eigen <- eigen(R) # eigen decomposition of R      #  VDV' : $values -eigenvalues, $vectors
# svd <- svd(R)   # single value decomposition of R #  UDV' : $d      -eigenvalues, $u,$v
# 
# Ve<-eigen$vectors            # eigenvectors   from VDV' of R
# De<-diag(eigen$values)       # eigenvalues    from VDV' of R
# Us<-svd$u                     # eigenvectors U from UDV' of R
# Ds<-diag(svd$d)               # eigenvalues    from UDV' of R
# Vs<-svd$v                     # eigenvectors V from UDV' of R
# 
# Fe<-(Ve %*% sympower(De,1/2))      # principal component pattern F=V(D^1/2) 
# Fs<-(Vs) %*% sympower(Ds,1/2)  # same computed from UDV'

# ---- diagnostics ------------------------------------------------------
# Diagnosing number of factors
# Scree.Plot(R0)
# FA.Stats(R0,n.factors=1:15,n.obs=sample_size, RMSEA.cutoff=.08)



# ----- fitting-function ----------------------------
fit_rotate <- function(
  R,             # correlation matrix
  k,             # number of factors 
  sample_size,   # number of observations
  rotation,      # method
  save_file = F, # save the factor pattern matrix?
  folder = NULL  # location for saving files
){
  # Values for testing and development
  # R = R0
  # k = 6
  # sample_size = 643
  # rotation = "quartimin"
  # 
  A <- stats::factanal(factors = k, covmat=R, rotation="none", control=list(rotate=list(normalize=TRUE)))
  L <- A$loadings
  if(rotation=="oblimin"  ){rotation_string <- "(L, Tmat=diag(ncol(L)), gam=0,               normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="quartimin"){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="targetT"  ){rotation_string <- "(L, Tmat=diag(ncol(L)),         Target=NULL, normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="targetQ"  ){rotation_string <- "(L, Tmat=diag(ncol(L)),         Target=NULL, normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="pstT"     ){rotation_string <- "(L, Tmat=diag(ncol(L)), W=NULL, Target=NULL, normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="pstQ"     ){rotation_string <- "(L, Tmat=diag(ncol(L)), W=NULL, Target=NULL, normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="oblimax"  ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="entropy"  ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="quartimax"){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="Varimax"  ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="simplimax"){rotation_string <- "(L, Tmat=diag(ncol(L)),           k=nrow(L), normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="bentlerT" ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="bentlerQ" ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="tandemI"  ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="tandemII" ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="geominT"  ){rotation_string <- "(L, Tmat=diag(ncol(L)),           delta=.01, normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="geominQ"  ){rotation_string <- "(L, Tmat=diag(ncol(L)),           delta=.01, normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="cfT"      ){rotation_string <- "(L, Tmat=diag(ncol(L)),             kappa=0, normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="cfQ"      ){rotation_string <- "(L, Tmat=diag(ncol(L)),             kappa=0, normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="infomaxT" ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="infomaxQ" ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="mccammon" ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="bifactorT"){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation=="bifactorQ"){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}

  rotated_solution <- base::eval(base::parse(text=paste0(rotation,rotation_string)))  
  return(rotated_solution)
}
# Usage
# solution <- fit_rotate(
#   R           = R0,          # correlation matrix
#   k           = 6,          # number of factors
#   sample_size = 643,        # number of observations
#   rotation    = "oblimin",
#   save_file   = F,          # save the factor pattern matrix?
#   folder      = NULL        # location for saving files
# )
# str(solution)

# ----- inspecting-functions ----------------------
model_summary <- function(model_object){
  cat("\nRMSEA: \n")
  print(RMSEA(model_object))
  cat("\nLL:",logLik(model_object))
  cat("\nAIC:",AIC(model_object))
  cat("\nAICc:",AICc(model_object))
  cat("\nBIC:",BIC(model_object))
  cat("\n")
  GetPrettyPattern(model_object, cutoff = 0.05,sort=FALSE)
}

quick_save <- function(g,name){
  ggplot2::ggsave(
    filename= paste0(name,".png"), 
    plot=g,
    device = png,
    path = "./reports/MLFA-study/images/",
    width = 500,
    height = 960,
    # units = "cm",
    dpi = 400,
    limitsize = FALSE
  )
}
# -----  ------------
fit <- MLFA(Correlation.Matrix = R0,n.factors = 6,n.obs = 643)

fit$Unrotated$F %>% plot_factor_pattern()
fit$BifactorOblique$F %>% plot_factor_pattern(factor_width = 8)
fit$Varimax$F %>% plot_factor_pattern(factor_width = 8)

print.FLS(fit$Unrotated, sort=FALSE)
# ----- understand-MLFA -----------------------------
# MLFA starts with a basuc facanal solution
R         = R0
n.obs     = 643
n.factors = 6
maxit     = 1000
p         = dim(R)[1]
promax.m  =3
random.starts=15

# get the matrix of factor loadings (factor pattern matrix)
solution <- factanal(covmat=R,n.obs=n.obs,factors=n.factors,maxit=maxit,rotation="none")
A <- solution$loadings[1:p,]
m         = dim(A)[2]
factor.labels <- paste("F",1:m,sep="")
plot_factor_pattern(A, factor_width = 8) %>% quick_save("01-unrotated")

###### Varimax ##################
# now we rotate the initial matrix of factor patterns
A.varimax <- varimax(A)$loadings[1:p,]
# examine the rotated matrix
plot_factor_pattern(A.varimax, factor_width = 8) %>% quick_save("02-varimax-a")
# Variamx
res <- list(Lh=A.varimax,orthogonal=TRUE)
res <- FixPattern(res, sort=F)
A.varimax <- list(F=res$Lh)
# A <- A.varimax$F
plot_factor_pattern(A.varimax$F, factor_width = 8) %>% quick_save("02-varimax-b")


###### Promax ###############
res <- GPromax(A,pow=promax.m)
plot_factor_pattern(res$Lh, factor_width = 8) %>% quick_save("03-promax-a")
res <- list(Lh=res$Lh,Phi=res$Phi,orthogonal=FALSE)
res <- FixPattern(res)
Phi.promax <- res$Phi
A.promax <- list(F=res$Lh,Phi=Phi.promax,orthogonal=FALSE)
plot_factor_pattern(A.promax$F, factor_width = 8) %>% quick_save("03-promax-b")
cat(".")

###### Quartimin ###################
res <- FindBestPattern(A,"quartimin",reps=random.starts,is.oblique=TRUE)
plot_factor_pattern(res$Lh, factor_width = 8) %>% quick_save("04-quartimin-a")
res <- list(Lh=res$Lh,Phi=res$Phi,orthogonal=FALSE)
res <- FixPattern(res)
Phi.quartimin <- res$Phi
A.quartimin <- list(F=res$Lh,Phi = Phi.quartimin)
plot_factor_pattern(A.quartimin$F, factor_width = 8) %>% quick_save("04-quartimin-b")
cat(".")

# Bifactor
res <- FindBestPattern(A,"bifactor",reps=random.starts)
plot_factor_pattern(res$Lh, factor_width = 8) %>% quick_save("05-bifactorT-a")
orthogonal=TRUE
res <- list(Lh=res$Lh,Phi=res$Phi,orthogonal=orthogonal)
res <- FixPattern(res)
Phi=NULL
A.bifactor <- list(F=res$Lh,Phi=Phi)
plot_factor_pattern(A.bifactor $F, factor_width = 8) %>% quick_save("05-bifactorT-b")
cat(".")


# Bifactor Oblique
res <- FindBestPattern(A,"bifactor",reps=random.starts,is.oblique=TRUE)
res <- list(Lh=res$Lh,Phi=res$Phi,orthogonal=FALSE)
res <- FixPattern(res)
cat(".")
Phi.bifactor.oblique <- res$Phi
A.bifactor.oblique <- list(F=res$Lh,Phi=Phi.bifactor.oblique)
cat(".")


# ---- compare-with-FindBestPattern ----------------------
solution_A <- fit_rotate(
    R           = R0,          # correlation matrix
    k           = 6,          # number of factors
    sample_size = 643,        # number of observations
    rotation    = "bifactorT",
    save_file   = F,          # save the factor pattern matrix?
    folder      = NULL        # location for saving files
  )
plot_factor_pattern(solution_A$loadings, factor_width = 8) %>% quick_save("solution_A")

R         = R0
n.obs     = 643
n.factors = 6
maxit     = 1000
p         = dim(R)[1]
promax.m  =3
random.starts=15

# get the matrix of factor loadings (factor pattern matrix)
solution <- factanal(covmat=R,n.obs=n.obs,factors=n.factors,maxit=maxit,rotation="none")
A <- solution$loadings[1:p,]
m         = dim(A)[2]
factor.labels <- paste("F",1:m,sep="")

# Bifactor
res <- FindBestPattern(A,"bifactor",reps=random.starts)
plot_factor_pattern(res$Lh, factor_width = 8) %>% quick_save("solution_B")
orthogonal=TRUE
res <- list(Lh=res$Lh,Phi=res$Phi,orthogonal=orthogonal)
res <- FixPattern(res,sort = TRUE)
Phi=NULL
A.bifactor <- list(F=res$Lh,Phi=Phi)
plot_factor_pattern(A.bifactor $F, factor_width = 8) %>% quick_save("solution_C")
cat(".")


#--------  ------------------