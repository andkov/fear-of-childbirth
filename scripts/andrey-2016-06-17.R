# 6 June 2016
# Childbirth Fear Questionnaire
# Fairbrother, Thordarson, and Stoll

library(foreign)
source("http://statpower.net/Content/312/R%20Stuff/AdvancedFactorFunctions.txt")
source("http://www.statpower.net/Content/312/R%20Stuff/Steiger%20R%20Library%20Functions.txt")


dat <- read.spss("./data/Final Dataset NFSept 6 2015_1.sav", to.data.frame = T) # 643 by 936

foc <- dat[,655:703] # 643 by 49, no missings
foc <- matrix(as.numeric(unlist(foc)), nrow=nrow(foc), ncol=ncol(foc)) # turn it into a matrix

eigen(cor(foc))$values
sum(eigen(cor(foc))$values>1) # suggests nine factors

# based on Kaiser’s (1960) eigen-value-greater-than-one rule
# Ruscio and Roche’s (2012) simulation study finds K1 is not great... PA works better

library(psych)

pa_result <- psych::fa.parallel(
  foc, 
  fm = "uls",
  fa = "both",
  se.bars = TRUE
) # "Parallel analysis suggests that the number of factors =  9" (from "psych" package)

str(pa_result)
library(nFactors) 

observed_ev <- eigen(cor(foc))$values
nFactors::nScree(x=observed_ev, model="factors")
nFactors::plotnScree(nFactors::nScree(x=observed_ev, model="factors")) # from nFactors package

# Optimal Coordinates: 8
# Acceleration Factor: 1 (number before the point at which the line bends the most)
# Parallel Analysis: 9 (from Horn 1965)
# Eigenvalues: 9


simulated_ev <- read.csv("./data/simulated_eigens.csv", header=T, stringsAsFactors = F)
compare_eignes <- cbind(observed_ev,simulated_ev )


write.csv(compare_eignes, "./data/compare_eignes.csv")
# from "Modern Factor Analysis" - Harman, 1974 

R <- cor(foc) # correlation matrix R of variables in foc
eigen <- eigen(R) # eigen decomposition of R      #  VDV' : $values -eigenvalues, $vectors
svd<-svd(R)   # single value decomposition of R #  UDV' : $d      -eigenvalues, $u,$v

Ve<-eigen$vectors            # eigenvectors   from VDV' of R
De<-diag(eigen$values)       # eigenvalues    from VDV' of R
Us<-svd$u                     # eigenvectors U from UDV' of R
Ds<-diag(svd$d)               # eigenvalues    from UDV' of R
Vs<-svd$v                     # eigenvectors V from UDV' of R

Fe<-(Ve %*% sympower(De,1/2))      # principal component pattern F=V(D^1/2) 
Fs<-(Vs) %*% sympower(Ds,1/2)  # same computed from UDV'

