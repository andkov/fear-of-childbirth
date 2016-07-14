# knitr::stitch_rmd(script="./___/___.R", output="./___/___/___.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # enables piping : %>% 
library(plotrix)

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2") # graphing
requireNamespace("readr")   # data input
requireNamespace("tidyr")   # data manipulation
requireNamespace("dplyr")   # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit")  # For asserting conditions meet expected patterns.
# requireNamespace("car")     # For it's `recode()` function.

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
source("./scripts/common-functions.R") # used in multiple reports
source("./scripts/graph-presets.R") # fonts, colors, themes 
source("http://statpower.net/Content/312/R%20Stuff/AdvancedFactorFunctions.txt")
source("http://www.statpower.net/Content/312/R%20Stuff/Steiger%20R%20Library%20Functions.txt")

# ---- declare-globals ---------------------------------------------------------

# ---- load-data ---------------------------------------------------------------
dto <- readRDS("./data/unshared/derived/dto.rds")
unitData <- dto$unitData
metaData <- dto$metaData 
ds <- dto$analytic

# ---- tweek-data ------------------------------------------------------------

# ---- inspect-data -------------------------------------------------------------
dplyr::glimpse(ds)
levels(ds$foc_01)

# ---- correlation-matrix --------------------
ds_cor <- ds %>% dplyr::select(contains("foc_"))
ds_cor <- sapply(ds_cor, as.numeric)
str(ds_cor)

R <- cor(ds_cor) # correlation matrix R of variables in foc
eigen <- eigen(R) # eigen decomposition of R      #  VDV' : $values -eigenvalues, $vectors
svd <- svd(R)   # single value decomposition of R #  UDV' : $d      -eigenvalues, $u,$v

Ve<-eigen$vectors            # eigenvectors   from VDV' of R
De<-diag(eigen$values)       # eigenvalues    from VDV' of R
Us<-svd$u                     # eigenvectors U from UDV' of R
Ds<-diag(svd$d)               # eigenvalues    from UDV' of R
Vs<-svd$v                     # eigenvectors V from UDV' of R

Fe<-(Ve %*% sympower(De,1/2))      # principal component pattern F=V(D^1/2) 
Fs<-(Vs) %*% sympower(Ds,1/2)  # same computed from UDV'

# ---- diagnostics ------------------------------------------------------
# Diagnosing number of factors
Scree.Plot(R)
FA.Stats(R,n.factors=1:15,n.obs=643, RMSEA.cutoff=.05)

# ---- basic-models ------------------------------
fit_1_principal <- psych::principal(R,nfactors=,rotate="promax",n.obs=643)

fit.2.principal <- principal(R,nfactors=2,rotate="promax",n.obs=100)
fit.2.factanal<-factanal(covmat=R,factors=2,rotation="promax",n.obs=100)
fit.2.Enzmann<-fa.promax(covmat=R,factors=2,n.obs=100)
fit.2.MLFA<-MLFA(Correlation.Matrix=R,n.factors=2, n.obs=100,promax.m=3)


# ---- basic-table --------------------------------------------------------------

# ---- basic-graph --------------------------------------------------------------

# ---- reproduce ---------------------------------------
rmarkdown::render(input = "./sandbox/report-a.Rmd" ,
                  output_format="html_document", clean=TRUE)