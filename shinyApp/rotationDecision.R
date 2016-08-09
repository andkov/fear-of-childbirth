{
  if( input$rotation=="svd" ) {
    V <- base::svd(R)$v
    FPM <- V[, 1:k] # FPM - Factor Pattern Matrix
    FPM <- cbind(FPM, matrix(numeric(0), p, p-k)) # appends empty columns to have p columns
    rownames(FPM) <- rownames(datasetInput())
    colnames(FPM) <- paste0("V", 1:p) #Andrey, should this be 'F' instead of 'V'?
    FPM # THE OUTPUT
    Phi <- diag(k)
    colnames(Phi) <- paste0("F", 1:k)
    rownames(Phi) <- paste0("F", 1:k)    
    Phi
  } 
  else if( input$rotation=="promax" ) {
    A <- stats::factanal(factors = k, covmat=R, rotation="none", control=list(rotate=list(normalize=TRUE)))
#     FPM <- stats::promax(A$loadings, m=3)$loadings
    Atemp <- GPromax(A$loadings, pow=3)
    FPM <- Atemp$Lh # FPM - Factor Pattern Matrix
    FPM <- cbind(FPM, matrix(numeric(0), p, p-k)) # appends empty columns to have p columns
    colnames(FPM) <- paste0("F", 1:p) # renames for better presentation in tables and graphs
    FPM # THE OUTPUT
    Phi <- Atemp$Phi
    if( is.null(Phi)) {Phi<-diag(k)} else{Phi}
    colnames(Phi) <- paste0("F", 1:k)
    rownames(Phi) <- paste0("F", 1:k)
    Phi
  }
  # else if( input$rotation=="oblimin" ) { 
  #   A <- stats::factanal(factors = k, covmat=R, rotation="none", control=list(rotate=list(normalize=TRUE)))
  #   Atemp <- GPArotation::GPFoblq(loadings(A), method="oblimin")
  #   FPM <- Atemp$loadings
  #   FPM <- cbind(FPM, matrix(numeric(0), p, p-k)) # appends empty columns to have p columns
  #   colnames(FPM) <- paste0("F", 1:p) # renames for better presentation in tables and graphs
  #   FPM # THE OUTPUT, Factor pattern
  #   Phi <- Atemp$Phi
  #   if( is.null(Phi)) {Phi<-diag(k)} else{Phi}
  #   colnames(Phi) <- paste0("F", 1:k)
  #   rownames(Phi) <- paste0("F", 1:k)    
  #   Phi # Factor Correlation
  # } 

  else if( input$rotation=="none" ) { 
    A <- stats::factanal(factors = k, covmat=R, rotation="none", control=list(rotate=list(normalize=TRUE)))
    Atemp <- A
    FPM <- Atemp$loadings # FPM - Factor Pattern Matrix
    FPM <- cbind(FPM, matrix(numeric(0), p, p-k)) # appends empty columns to have p columns
    colnames(FPM) <- paste0("F", 1:p) # renames for better presentation in tables and graphs
    FPM  # THE OUTPUT
    Phi <- Atemp$Phi
    if( is.null(Phi)) {Phi<-diag(k)} else{Phi}
    colnames(Phi) <- paste0("F", 1:k)
    rownames(Phi) <- paste0("F", 1:k)    
    Phi   
  } 

  
  # else if( input$rotation==rotationInput() ) {
  #   A <- stats::factanal(factors = k, covmat=R, rotation="none", control=list(rotate=list(normalize=TRUE)))
  #   L <- A$loadings
  #   Atemp <- eval(parse(text=paste0(rotationInput(),"(L, Tmat=diag(ncol(L)), normalize=FALSE, eps=1e-5, maxit=1000)")))
  #   FPM <- Atemp$loadings # FPM - Factor Pattern Matrix
  #   FPM <- cbind(FPM, matrix(numeric(0), p, p-k)) # appends empty columns to have p columns
  #   colnames(FPM) <- paste0("F", 1:p) # renames for better presentation in tables and graphs
  #   FPM  # THE OUTPUT
  #   Phi <- Atemp$Phi
  #   if( is.null(Phi)) {Phi <- diag(k)} else{Phi}
  #   colnames(Phi) <- paste0("F", 1:k)
  #   rownames(Phi) <- paste0("F", 1:k)
  #   Phi
  # }
  
  else if( input$rotation==rotationInput() ) {
    A <- stats::factanal(factors = k, covmat=R, rotation="none", control=list(rotate=list(normalize=TRUE)))
    L <- A$loadings
    rotation_ <- paste0(rotationInput())
    # browser()
    # rotation_ <- parse(text=paste0(rotationInput()))
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
    if(rotation_=="infomaxT" ){rotation_string <- "L, Tmat=diag(ncol(L)),                       normalize=FALSE, eps=1e-5, maxit=1000)"}
    if(rotation_=="infomaxQ" ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
    if(rotation_=="mccammon" ){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
    if(rotation_=="bifactorT"){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}
    if(rotation_=="bifactorQ"){rotation_string <- "(L, Tmat=diag(ncol(L)),                      normalize=FALSE, eps=1e-5, maxit=1000)"}

    rotated_solution <- eval(parse(text=paste0(rotation_,rotation_string)))

    FPM <- rotated_solution$loadings # FPM - Factor Pattern Matrix

    FPM <- cbind(FPM, matrix(numeric(0), p, p-k)) # appends empty columns to have p columns
    colnames(FPM) <- paste0("F", 1:p) # renames for better presentation in tables and graphs
    FPM  # THE OUTPUT
    Phi <- rotated_solution$Phi
    if( is.null(Phi)) {Phi <- diag(k)} else{Phi}
    colnames(Phi) <- paste0("F", 1:k)
    rownames(Phi) <- paste0("F", 1:k)
    Phi
  }
}
