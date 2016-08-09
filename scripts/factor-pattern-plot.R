# a copy of this script has been created on 2016-07-30 and called ./scripts/factor_pattern_plot.R
# TODO: point to the script creating the object FPM.matrix, the source object
# fpmFunction is used to create output$ objects in server.R
fpmFunction <- function( FPM.matrix, mainTitle=NULL ) {   
  roundingDigits <- 3 #Let the caller define in the future (especially with observed values that aren't close to 1.0).
  stripSize <- 11  #Let the caller define in the future?
  valuelabelSize <- 4 #7 # the values of the factor loadings
  axisTitleFontSize <- 12
  axisTextFontSize <- 12
  legendTextFontSize <- 6 # 
  keep_factors <- paste0("F",1:10) # number of columns to show
  show_factors <- paste0("F",1:k) # number of factors to print
  titleSize <- 14 # 
  # Data prep for ggplot
  dsFORp <- reshape2::melt(FPM.matrix, id.vars=rownames(FPM.matrix))  ## id.vars declares MEASURED variables (as opposed to RESPONSE variable)
  dsFORp <- plyr::rename(dsFORp, replace=c(Var1="Variable", Var2="Factor", value="Loading"))
 # browser()
  dsFORp$Positive <- ifelse(dsFORp$Loading >= 0, "Positive", "Negative") #Or see Recipe 10.8
  dsFORp$LoadingAbs <- abs(dsFORp$Loading) # Long form
#   dsFORp$LoadingPretty <- round(abs(dsFORp$Loading), roundingDigits) # Long form
  dsFORp$LoadingPretty <- round(dsFORp$Loading, roundingDigits) # Long form
  
  dsFORp$LoadingPretty <- paste0(ifelse(dsFORp$Loading>=0, "+", "-"), dsFORp$LoadingPretty)
  #   dsFORp$VariablePretty <- gsub(pattern="_", replacement="\n", x=dsFORp$Variable)
  dsFORp$VariablePretty <- gsub(pattern=" ", replacement="\n", x=dsFORp$Variable)
  # colors <- c("FALSE"="darksalmon" ,"TRUE"="lightskyblue") # The colors for negative and positve values of factor loadings for ggplot

  # Colors for fill and font
  {
  # positive Green, negative Purple
  colorsFill <- c("Positive"="#A6DBA0" ,"Negative"="#C2A5CF") # The colors for negative and positve values of factor loadings for ggplot
  colorFont <- c("Positive"="#008837" ,"Negative"="#7B3294") # The colors for negative and positve values of factor loadings for ggplot
  
#   # positive Organge,negative Purple
#   colorsFill <- c("Positive"="#FDB863" ,"Negative"="#B2ABD2") # The colors for negative and positve values of factor loadings for ggplot
#   colorFont <- c("Positive"="#E66101" ,"Negative"="#5E3C99") # The colors for negative and positve values of factor loadings for ggplot
  
#   # Positive Teal,Negative Brown
#   colorsFill <- c("Positive"="#80CDC1" ,"Negative"="#DFC27D") # The colors for negative and positve values of factor loadings for ggplot
#   colorFont <- c("Positive"="#018571" ,"Negative"="#A6611A") # The colors for negative and positve values of factor loadings for ggplot
  
#   # Positive Teal,Negative Brown
#   colorsFill <- c("Positive"="#80CDC1" ,"Negative"="#DFC27D") # The colors for negative and positve values of factor loadings for ggplot
#   colorFont <- c("Positive"="#018571" ,"Negative"="#A6611A") # The colors for negative and positve values of factor loadings for ggplot
  
#   # Positive Blue, Negative Red
#   colorsFill <- c("Positive"="#92C5DE" ,"Negative"="#F4A582") # The colors for negative and positve values of factor loadings for ggplot
#   colorFont <- c("Positive"="#0571B0" ,"Negative"="#CA0020") # The colors for negative and positve values of factor loadings for ggplot
  
  
  } # close color theme selection
  
  # browser()
  # keep_factors <- paste0("F",1:10)
  # show_factors <- paste0("F",1:k)
  # vjust_ <- 2.2#1.3
  # stripSize <- 12 #24
  # valuelabelSize <- 4 #  7
  dsFORp_ <- dsFORp %>% dplyr::filter(Factor %in% keep_factors)# %>% dplyr::slice(1:20)
  # Graph definition
  pp <- ggplot(dsFORp_,aes(x=Factor,y=LoadingAbs,fill=Positive,color=Positive,label=LoadingPretty)) +
    geom_bar(stat="identity", na.rm=T) +
    geom_text(y=0, vjust=-.1,size=valuelabelSize, na.rm=T) +
    scale_color_manual(values=colorFont, guide="none") +
    scale_fill_manual(values=colorsFill) +
    #   scale_fill_discrete(h=c(0,360)+15, c=100, l=65, h.start=0, direction=1, na.value="grey50") + #http://docs.ggplot2.org/0.9.3/scale_hue.html
    # scale_y_continuous(limits=c(0,1.1), breaks=c(.5,1), expand=c(0,0)) +
    scale_y_continuous(limits=c(0,1.1), breaks=c(0), expand=c(0,0)) +
    # scale_x_discrete(breaks = show_factors)+
    facet_grid(VariablePretty ~ .) +
    labs(title=mainTitle, x="Weights", y="Loadings (Absolute)", fill=NULL) + 
    theme_minimal() +
    # theme_tufte()+
    theme(panel.grid.minor=element_blank()) + 
    theme(axis.title=element_text(color="gray30", size=axisTitleFontSize)) + #The labels (eg, 'Weights' & 'Loadings') 
    theme(axis.text.x=element_text(color="gray50", size=axisTextFontSize, vjust=1.2)) + #(eg, V1, V2,...)
    # theme(axis.text.y=element_text(color="gray50", size=axisTextFontSize)) + #(eg, 0.5, 1.0)
    theme(axis.text.y=element_blank()) + #(eg, 0.5, 1.0)
    theme(strip.text.y=element_text(angle=0, size=stripSize,hjust = 0, vjust=1)) + 
    theme(plot.title = element_text(size=titleSize, hjust=1, vjust=1)) +
    theme(legend.position="blank")
  pp
#     theme(legend.text=element_text(size=legendTextFontSize))
  
#   if( k < p ) { #If there's space in the lower right corner of the plot area, then use it.
#     pp <- pp + theme(legend.position=c(1, 0), legend.justification=c(1, 0)) 
#     pp <- pp + theme(legend.background=element_rect(fill="gray70"))
#   }
#   else { #Otherwise, put it outside the plot area.
#     pp <- pp + theme(legend.position="left")
#   } 

  return( pp )
}

FA.StatsGG <- function(Correlation.Matrix, n.obs, n.factors, conf=.90, maxit=1000, RMSEA.cutoff=NULL, main="RMSEA Plot", sub=NULL) {
  #This function is a ggplot2 adaption for the function written by James H. Steiger (2013): Advanced Factor Functions V1.05  2013/03/20
  runs <- length(n.factors)  
  R <- Correlation.Matrix
  maxfac <- max(n.factors)
  res <- matrix(NA, runs,8)
  roots <- eigen(R)$values
  for( i in 1:runs ) {
    output <- factanal(covmat=R, n.obs=n.obs, factors=n.factors[i], maxit=maxit)
    X2 <- output$STATISTIC
    df <- output$dof
    ci <- rmsea.ci(X2, df ,n.obs,conf)
    pvar <- sum(roots[1:n.factors[i]])
    v <- c(n.factors[i], pvar, X2, df, 1-pchisq(X2,df), ci$Point.Estimate, ci$Lower.Limit, ci$Upper.Limit)      
    res[i, ] <- v
  }
  colnames(res)=c("Factors","Cum.Eigen","Chi-Square","Df","p.value", "RMSEA.Pt","RMSEA.Lo","RMSEA.Hi")
  ds <- data.frame(FactorID=n.factors, Rmsea=res[,6], Lower=res[,7], Upper=res[,8])
  g <- ggplot(ds, aes(x=FactorID, y=Rmsea, ymin=Lower, ymax=Upper)) +
    annotate("rect", ymax=RMSEA.cutoff, ymin=-Inf, xmin=-Inf, xmax=Inf, fill="#F4A58255") +
    geom_line(size=1.5, color="#0571B0", na.rm = TRUE) +
    geom_errorbar(width=0.05, size=1.5, color="#92C5DE", na.rm = TRUE) +
    scale_x_continuous(breaks=n.factors) +
    scale_y_continuous(expand=c(0,0)) + 
    labs(title=main, x="Number of Factors", y="RMSEA") +
    theme_bw() +
    theme(panel.grid.minor=element_blank()) + 
    theme(plot.title=element_text(color="gray30", size=30)) + #The labels (eg, 'Eigenvalue' & 'Component Number') 
    theme(axis.title=element_text(color="gray30", size=18)) + #The labels (eg, 'Eigenvalue' & 'Component Number') 
    theme(axis.text.x=element_text(color="gray50", size=18, vjust=1.3)) + #(eg, V1, V2,...)
    theme(axis.text.y=element_text(color="gray50", size=18))  #(eg, 0.5, 1.0)
  
  print(g)
  
  return(res)
}


Scree.PlotGG <- function(R, main="Scree Plot", sub=NULL){
  #This function is a ggplot2 adaption for the function written by James H. Steiger (2013): Advanced Factor Functions V1.05  2013/03/20
  roots <- eigen(R)$values
  x <- 1:dim(R)[1]    
  ds <- data.frame(x=x, roots=roots)
  g <- ggplot(ds, aes(x=x, y=roots)) +
    annotate("rect", ymax=1, ymin=-Inf, xmin=-Inf, xmax=Inf, fill="#F4A58255") +#rgb(1, 0, 0, alpha=.1,maxColorValue=1)) +
    geom_line(size=1.5, color="#0571B0", na.rm = TRUE) +
    geom_point(size=5, color="#92C5DE", na.rm = TRUE)+
    scale_x_continuous(breaks=x) +
    scale_y_continuous(expand=c(0,0)) +
    labs(title=main, x="Component Number", y="Eigenvalue") +
    theme_bw() +
    theme(panel.grid.minor=element_blank()) + 
    theme(plot.title=element_text(color="gray30", size=30)) + #The labels (eg, 'Eigenvalue' & 'Component Number') 
    theme(axis.title=element_text(color="gray30", size=18)) + #The labels (eg, 'Eigenvalue' & 'Component Number') 
    theme(axis.text.x=element_text(color="gray50", size=18, vjust=1.3)) + #(eg, V1, V2,...)
    theme(axis.text.y=element_text(color="gray50", size=18))  #(eg, 0.5, 1.0)
  
  print(g)
}