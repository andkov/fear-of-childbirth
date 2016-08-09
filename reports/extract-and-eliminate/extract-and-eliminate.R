# knitr::stitch_rmd(script="./___/___.R", output="./___/___/___.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # enables piping : %>% 
# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2") # graphing
requireNamespace("readr")   # data input
requireNamespace("tidyr")   # data manipulation
requireNamespace("dplyr")   # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit")  # For asserting conditions meet expected patterns.
# requireNamespace("car")     # For it's `recode()` function.
library(datasets)
library(ggplot2) # load ggplot
library(psych)
library(plotrix)
library(sem)
library(GPArotation)

# ---- load-sources ------------------------------------------------------------
# browser()

source("./shinyApp/sourced/SteigerRLibraryFunctions.txt")
source("./shinyApp/sourced/AdvancedFactorFunctions_CF.R")


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



# ---- inspect-data -------------------------------------------------------------
names(ds)
names(metaData)

dplyr::glimpse(ds)
levels(ds$foc_01)

names_labels(ds)

# ---- tweak-data --------------------------------------------------------------






# ---- function-correlation ------------------------------
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
# ---- function-rotation -----------------

display_solution <- function(R,k, sample_size,rotation_,mainTitle=NULL){
  A <- stats::factanal(factors = k, covmat=R, rotation="none", control=list(rotate=list(normalize=TRUE)))
  L <- A$loadings
  if(rotation_=="oblimin"  ){rotation_string <- "(L, Tmat=diag(ncol(L)), gam=0,               normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="quartimin"){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="targetT"  ){rotation_string <- "(L, Tmat=diag(ncol(L)),         Target=NULL, normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="targetQ"  ){rotation_string <- "(L, Tmat=diag(ncol(L)),         Target=NULL, normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="pstT"     ){rotation_string <- "(L, Tmat=diag(ncol(L)), W=NULL, Target=NULL, normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="pstQ"     ){rotation_string <- "(L, Tmat=diag(ncol(L)), W=NULL, Target=NULL, normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="oblimax"  ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="entropy"  ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="quartimax"){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="Varimax"  ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="simplimax"){rotation_string <- "(L, Tmat=diag(ncol(L)),           k=nrow(L), normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="bentlerT" ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="bentlerQ" ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="tandemI"  ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="tandemII" ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="geominT"  ){rotation_string <- "(L, Tmat=diag(ncol(L)),           delta=.01, normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="geominQ"  ){rotation_string <- "(L, Tmat=diag(ncol(L)),           delta=.01, normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="cfT"      ){rotation_string <- "(L, Tmat=diag(ncol(L)),             kappa=0, normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="cfQ"      ){rotation_string <- "(L, Tmat=diag(ncol(L)),             kappa=0, normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="infomaxT" ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="infomaxQ" ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="mccammon" ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="bifactorT"){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  if(rotation_=="bifactorQ"){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
  
  rotated_solution <- eval(parse(text=paste0(rotation_,rotation_string)))  
  p <- nrow(R)
  
  FPM <- rotated_solution$loadings # FPM - Factor Pattern Matrix
  FPM <- cbind(FPM, matrix(numeric(0), p, p-k)) # appends empty columns to have p columns
  colnames(FPM) <- paste0("F", 1:p) # renames for better presentation in tables and graphs
  FPM  # THE OUTPUT
  Phi <- rotated_solution$Phi # factor correlation matrix
  if( is.null(Phi)) {Phi <- diag(k)} else{Phi}
  colnames(Phi) <- paste0("F", 1:k)
  rownames(Phi) <- paste0("F", 1:k)    
  Phi
  solution <- list("FPM"=FPM,"Phi"=Phi)
  # load the function to gread the graph, needs k value
  source("./scripts/factor-pattern-plot.R") # to graph factor patterns
  g <- fpmFunction(FPM.matrix=solution$FPM, mainTitle=mainTitle) #Call/execute the function defined above.
  # print(g) #Print graph with factor pattern
  file_name <- paste0("./data/shared/derived/FPM/",rotation_,"_",k,".csv")
  #browser()
  save_file <- as.data.frame(FPM[,1:k])
  readr::write_csv(save_file,file_name)
  
  return(g)
}


# data-phase-0 -----------------------
items_phase_0 <- c(paste0("foc_0",1:9), paste0("foc_",10:49))
R0 <- make_cor(ds, metaData, items_phase_0)
saveRDS(R0,"./data/shared/derived/R0.rds") 


items_0 <- R0
n.items_0 <- sample_size
p.items_0 <- nrow(R0)

# --- eigen-analysis -------------------
R <- cor(R0) # correlation matrix R of variables in foc
eigen <- eigen(R) # eigen decomposition of R      #  VDV' : $values -eigenvalues, $vectors
svd <- svd(R)   # single value decomposition of R #  UDV' : $d      -eigenvalues, $u,$v


# ---- data-phase-1 -------------------
drop_items_1 <-c("foc_05", "foc_16", "foc_18","foc_49", "foc_45")
items_phase_1 <- setdiff(items_phase_0, drop_items_1)
items = items_phase_1
R1 <- make_cor(ds, metaData, items_phase_1)
# Phase_1 <- ds
items_1 <- R1
n.items_1 <- sample_size
p.items_1 <- nrow(R1)

# ---- data-phase-2 -------------------
drop_items_2 <- c("foc_31", "foc_32", "foc_46")
items_phase_2 <- setdiff(items_phase_1, drop_items_2)
items = items_phase_2
R2 <- make_cor(ds, metaData, items_phase_2)
# Phase_2 <- ds
items_2 <- R2
n.items_2 <- sample_size
p.items_2 <- nrow(R2)

# ---- example-analysis ----------------
# R <- R0 # What dataset?
k <-5 # How many factors/latent variables?
# sample_size <- 643# How big is sample size?
# solution <- display_solution(R,k,sample_size,"oblimin")
# solution

# ---- print-solution --------------------
phase <- "2"
R <- R2 # correlation matrix for items at phase 0
sample_size <- 643
k <- 4
# for(rotation_ in c("oblimin","geominQ")){   # },"quartimin","geominQ","bifactorQ")){
for(rotation_ in c("oblimin","quartimin","geominQ","bifactorQ","Varimax","quartimax","geominT","bifactorT")){ 
  
  cat("\n\n")
  cat(paste0("## ",rotation_))
  for(nfactors_ in c(4:10)){
    # for(nfactors_ in c(4:10)){  
    mainTitle <- paste0(rotation_,", phase ",phase)
    cat("\n\n") 
    cat(paste0("### ",nfactors_));  
    cat("\n\n") 
    solution <- display_solution(R,k=nfactors_,sample_size,rotation_,mainTitle=mainTitle) %>% 
      print() 
    cat("\n\n")
    
    
  }  
}  

# ---- reason-through-elimination ---------------------------



# ---- scree-plot ---------------------

Scree.Plot(R0,main="SCREE Plot\nFear of Childbirth Questionnaire (n=643)")

# ---- FA-statistics -------------------
FA.Stats(R0,n.factors=1:16,n.obs=643,
         main="RMSEA Plot\nFear of Childbirth Questionnaire (n=643)",
         RMSEA.cutoff=0.05)


# ---- PA-psych ----------------
library(psych)
foc <- ds %>% dplyr::select_(.dots = items_phase_0)
foc <- matrix(as.numeric(unlist(foc)), nrow=nrow(foc), ncol=ncol(foc)) # turn it into a matrix

pa_result <- psych::fa.parallel(
  foc, 
  fm = "uls",
  fa = "both",
  se.bars = TRUE
) # "Parallel analysis suggests that the number of factors =  9" (from "psych" package)


# ----- PA-nFactors ---------------
library(nFactors) 

# The nScree function returns an analysis of the number of component or factors to retain in an
# exploratory principal component or factor analysis. The function also returns information about the
# number of components/factors to retain with the Kaiser rule and the parallel analysis.
nFactors::nScree(x=eigen$values, model="factors")
nFactors::plotnScree(nFactors::nScree(x=eigen(R0)$values, model="factors")) # from nFactors package

# This function gives the distribution of the eigenvalues of correlation or a covariance matrices of
# random uncorrelated standardized normal variables. The mean and a selected quantile of this distribution
# are returned.
ap <- nFactors::parallel(subject=nrow(foc),var=ncol(foc),rep=1000,cent=.05)
nS <- nScree(x=eigen$values, aparallel=ap$eigen$qevpea)
plotnScree(nS)
# Optimal Coordinates: 8
# Acceleration Factor: 1 (number before the point at which the line bends the most)
# Parallel Analysis: 9 (from Horn 1965)
# Eigenvalues: 9

# ---- MAP-paramap ---------------------
# install.packages("paramap_1.1.tar.gz", repos=NULL, type="source") 
library(paramap)
paramap::map( R0, corkind='pearson', display = 'yes' )


# ---- compare-eigens ----------------
observed_eignes <- eigen(R0)$values
simulated_eigens <- read.csv("./data/shared/raw/simulated_eigens.csv", header=T, stringsAsFactors = F)
compare_eignes <- cbind(observed_eignes,simulated_eigens )
compare_eignes



# conduction parallel analysis on the interferent scale

# ---- function-correlation-itf ------------------------------
make_cor_itf <- function(ds,metaData,items){
  
  # d <- ds %>% dplyr::select(foc_01:foc_49)
  d <- ds %>% dplyr::select_(.dots=items)
  
  rownames <- metaData %>% 
    dplyr::filter(name_new %in% items) %>% 
    dplyr::mutate(name_ = paste0(gsub("itf_", "", items),"---",domain, "---", label_graph))
  # dplyr::mutate(name_ = paste0(gsub("foc_", "", vars_49),"-",domain, "-",label_graph))
  # dplyr::mutate(name_ = paste0(gsub("foc_", "", vars_49),"-",label_graph))
  rownames <- rownames[,"name_"]
  
  d <- sapply(d, as.numeric)
  cormat <- cor(d)
  colnames(cormat) <- rownames; rownames(cormat) <- rownames
  return(cormat)
}

# data-phase-itf -----------------------
items_int <- c(paste0("itf_",1:7))
Ritf <- make_cor_itf(ds, metaData, items_int)
saveRDS(Ritf,"./data/shared/derived/Ritf.rds") 


# ---- scree-plot-itf ---------------------

Scree.Plot(Ritf,main="SCREE Plot\nFear of Interference Scale (n=643)")

# ---- FA-statistics-itf -------------------
FA.Stats(Ritf,n.factors=1:3,n.obs=643,
         main="RMSEA Plot\nFear of Childbirth Questionnaire (n=643)",
         RMSEA.cutoff=0.05)


# ---- PA-psych-itf ----------------
library(psych)
itf <- ds %>% dplyr::select_(.dots = items_int)
itf <- matrix(as.numeric(unlist(itf)), nrow=nrow(itf), ncol=ncol(itf)) # turn it into a matrix

pa_result <- psych::fa.parallel(
  itf, 
  fm = "uls",
  fa = "both",
  se.bars = TRUE
) 


# ---- reproduce ---------------------------------------
rmarkdown::render(input = "./reports/extract-and-eliminate/extract-and-eliminate-0.Rmd" ,
                  output_format="html_document", clean=TRUE) 

rmarkdown::render(input = "./reports/extract-and-eliminate/extract-and-eliminate-1.Rmd" ,
                  output_format="html_document", clean=TRUE) 

rmarkdown::render(input = "./reports/extract-and-eliminate/revision-comments.Rmd" ,
                  output_format="html_document", clean=TRUE) 


