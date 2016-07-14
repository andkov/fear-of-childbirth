# 6 June 2016
# Childbirth Fear Questionnaire
# Fairbrother, Thordarson, and Stoll

library(foreign)

dat <- read.spss("Final Dataset NFSept 6 2015_1.sav", to.data.frame = T) # 643 by 936

foc <- dat[,655:703] # 643 by 49, no missings
foc <- matrix(as.numeric(unlist(foc)), nrow=nrow(foc), ncol=ncol(foc)) # turn it into a matrix

eigen(cor(foc))$values
sum(eigen(cor(foc))$values>1) # suggests nine factors

# based on Kaiser’s (1960) eigen-value-greater-than-one rule
# Ruscio and Roche’s (2012) simulation study finds K1 is not great... PA works better

library(psych)

fa.parallel(foc) # "Parallel analysis suggests that the number of factors =  9" (from "psych" package)

library(nFactors)

ev <- eigen(cor(foc))$values
nScree(x=ev, model="factors")
plotnScree(nScree(x=ev, model="factors")) # from nFactors package

# Optimal Coordinates: 8
# Acceleration Factor: 1 (number before the point at which the line bends the most)
# Parallel Analysis: 9 (from Horn 1965)
# Eigenvalues: 9
