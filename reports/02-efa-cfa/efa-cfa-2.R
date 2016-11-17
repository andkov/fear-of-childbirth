# knitr::stitch_rmd(script="./___/___.R", output="./___/___/___.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # enables piping : %>% 
library(plotrix)
library(ggplot2)# graphing

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
# source("./shinyApp/sourced/AdvancedFactorFunctions_CF.R")
source("./shinyApp/sourced/original/AdvancedFactorFunctions.R")
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
Scree.Plot(R0)
FA.Stats(R0,n.factors=1:15,n.obs=sample_size, RMSEA.cutoff=.08)


# ----- fitting-function ----------------------------
fit_rotate <- function(
  R,             # correlation matrix
  k,             # number of factors 
  sample_size,   # number of observations
  rotation,     # method
  save_file = F, # save the factor pattern matrix?
  folder = NULL  # location for saving files
){
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
  
  rotated_solution <- eval(parse(text=paste0(rotation,rotation_string)))  
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
str(solution)

plot_solution <- function(
  solution,
  mainTitle = NULL
){
  p <- dim(solution$loadings)[1]
  k <- dim(solution$loadings)[2]
 
  FPM <- solution$loadings # FPM - Factor Pattern Matrix
  FPM <- cbind(FPM, matrix(numeric(0), p, p-k)) # appends empty columns to have p columns
  colnames(FPM) <- paste0("F", 1:p) # renames for better presentation in tables and graphs
  
  Phi <- solution$Phi # factor correlation matrix
  if( is.null(Phi)) {Phi <- diag(k)} else{Phi}
  colnames(Phi) <- paste0("F", 1:k)
  rownames(Phi) <- paste0("F", 1:k)    
  # load the function to gread the graph, needs k value
  # source("./scripts/factor-pattern-plot.R") # to graph factor patterns
  g <- fpmFunction(FPM.matrix=FPM, mainTitle=mainTitle) #Call/execute the function defined above.
  return(g)
}
# Usage
# plot_solution(solution)

# combined usage
# fit_rotate(
#   R           = R0,          # correlation matrix
#   k           = 6,          # number of factors 
#   sample_size = 643,        # number of observations
#   rotation    = "bifactorQ",   
#   save_file   = F,          # save the factor pattern matrix?
#   folder      = NULL        # location for saving files
# ) %>% plot_solution()



# ---- basic-models ------------------------------
model_object <- QuickEFAtoCFA(
  R                 = R0,
  n.factors         = 6, 
  n.obs             = sample_size,
  rotation          = "Bifactor",
  model.name        = "model.0",
  cutoff            = 0.30,
  alpha             = 0.05,
  make.start.values = TRUE,
  cov.matrix        = FALSE, # FALSE - orthogonal; TRUE - oblique
  num.digits        = 4,
  promax.m          = 3
)
GetPrettyPattern(model_object, cutoff = 0.05,sort=FALSE)
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
model_summary(model_object)

# ---- estimate-models -------------------------------
varimax_5 <- QuickEFAtoCFA(
  R                 = R,
  n.factors         = 5,
  n.obs             = sample_size,
  rotation          = "Varimax",
  model.name        = "model.0",
  cutoff            = 0.30,
  alpha             = 0.05,
  make.start.values = TRUE,
  cov.matrix        = FALSE, # FALSE - orthogonal; TRUE - oblique
  num.digits        = 4,
  promax.m          = 3
)

varimax_6 <- QuickEFAtoCFA(
  R                 = R,
  n.factors         = 6,
  n.obs             = sample_size,
  rotation          = "Varimax",
  model.name        = "model.0",
  cutoff            = 0.30,
  alpha             = 0.05,
  make.start.values = TRUE,
  cov.matrix        = FALSE, # FALSE - orthogonal; TRUE - oblique
  num.digits        = 4,
  promax.m          = 3
)

promax_5 <- QuickEFAtoCFA(
  R                 = R0,
  n.factors         = 5,
  n.obs             = sample_size,
  rotation          = "Promax",
  model.name        = "model.0",
  cutoff            = 0.30,
  alpha             = 0.05,
  make.start.values = TRUE,
  cov.matrix        = TRUE, # FALSE - orthogonal; TRUE - oblique
  num.digits        = 4,
  promax.m          = 3
)

promax_6 <- QuickEFAtoCFA(
  R                 = R,
  n.factors         = 6,
  n.obs             = sample_size,
  rotation          = "Promax",
  model.name        = "model.0",
  cutoff            = 0.30,
  alpha             = 0.05,
  make.start.values = TRUE,
  cov.matrix        = TRUE, # FALSE - orthogonal; TRUE - oblique
  num.digits        = 4,
  promax.m          = 3
)


bifactorT_6 <- QuickEFAtoCFA(
  R                 = R,
  n.factors         = 6, 
  n.obs             = sample_size,
  rotation          = "Bifactor",
  model.name        = "model.0",
  cutoff            = 0.30,
  alpha             = 0.05,
  make.start.values = TRUE,
  cov.matrix        = FALSE, # FALSE - orthogonal; TRUE - oblique
  num.digits        = 4,
  promax.m          = 3
)

bifactorT_7 <- QuickEFAtoCFA(
  R                 = R,
  n.factors         = 7, 
  n.obs             = sample_size,
  rotation          = "Bifactor",
  model.name        = "model.0",
  cutoff            = 0.30,
  alpha             = 0.05,
  make.start.values = TRUE,
  cov.matrix        = FALSE, # FALSE - orthogonal; TRUE - oblique
  num.digits        = 4,
  promax.m          = 3
)

bifactorQ_6 <- QuickEFAtoCFA(
  R                 = R,
  n.factors         = 6, 
  n.obs             = sample_size,
  rotation          = "BifactorOblique",
  model.name        = "model.0",
  cutoff            = 0.30,
  alpha             = 0.05,
  make.start.values = TRUE,
  cov.matrix        = TRUE, # FALSE - orthogonal; TRUE - oblique
  num.digits        = 4,
  promax.m          = 3
)

bifactorQ_7 <- QuickEFAtoCFA(
  R                 = R,
  n.factors         = 7, 
  n.obs             = sample_size,
  rotation          = "BifactorOblique",
  model.name        = "model.0",
  cutoff            = 0.30,
  alpha             = 0.05,
  make.start.values = TRUE,
  cov.matrix        = TRUE, # FALSE - orthogonal; TRUE - oblique
  num.digits        = 4,
  promax.m          = 3
)

# ---- print-solution --------------------------------------------------------------
cat("\n# Varimax - 5")
model_summary(varimax_5)
cat("\n# Varimax - 6")
model_summary(varimax_6)

cat("\n# Promax - 5")
model_summary(promax_5)
cat("\n# Promax - 6")
model_summary(promax_6)

cat("\n# BifactorT - 6")
model_summary(bifactorT_6)
cat("\n# BifactorT - 7")
model_summary(bifactorT_7)

cat("\n# BifactorQ - 6")
model_summary(bifactorQ_6)
cat("\n# BifactorQ - 7")
model_summary(bifactorQ_7)

# ---- basic-graph --------------------------------------------------------------
CheckMod(bifactorT_6)
# ---- reproduce ---------------------------------------
rmarkdown::render(input = "./reports/02-efa-cfa/efa-cfa-0.Rmd" ,
                  output_format="word_document", clean=TRUE)
rmarkdown::render(input = "./reports/02-efa-cfa/efa-cfa-1.Rmd" ,
                  output_format="word_document", clean=TRUE)
rmarkdown::render(input = "./reports/02-efa-cfa/efa-cfa-2.Rmd" ,
                  output_format="word_document", clean=TRUE)