# knitr::stitch_rmd(script="./manipulation/car-ellis.R", output="./manipulation/stitched-output/car-ellis.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # cleans console

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
source("./scripts/common-function.R")
# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) #Pipes

# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2")
requireNamespace("dplyr") #Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit")
# requireNamespace("magrittr") # pipes

# ---- declare-globals ---------------------------------------------------------
path_input  <- "./data-unshared/derived/ds0.rds"
# figure_path <- 'manipulation/stitched-output/te/'

# ---- load-data ---------------------------------------------------------------
ds <- readRDS(path_input)
str(ds)

# ---- nl_function -----------------------------------------------------------
# Create function that inspects names and labels
names.labels <- function(ds){
  # ds <- dsDemo
  nl <- data.frame(matrix(NA, nrow=ncol(ds), ncol=2))
  names(nl) <- c("name","label")
  for (i in seq_along(names(ds))){
    nl[i,"name"] <- names(ds[i])
    if(is.null(attr(ds[[i]], "label")) ){
      nl[i,"label"] <- NA}else{
        nl[i,"label"] <- attr(ds[[i]], "label")
      }
  }
  return(nl)
}
# (nl <- names.labels(ds))

# ---- load_varnames ---------------------------------------------------------
(nl <- names.labels(ds)) # nl for (n)ame and (l)ables

write.csv(nl, file="./data-unshared/derived/nl_raw.csv")

# augment the names with classifications  by editing the .csv directly
nl_augmentedPath <- "./data-phi-free/raw/nl_augmented.csv" # input file with your manual classification

varnames <- read.csv(nl_augmentedPath, stringsAsFactors = F)
varnames$X <- NULL
varnames

dplyr::arrange(varnames, type)

# ----- select_subset ------------------------------------
# select variables you will need for modeling
selected_items <- c(
  "id", # personal identifier
  "age_bl", #Age at baseline
  "htm", # Height(meters)
  "msex", # Gender
  "race", # Participant's race
  "educ", # Years of education
  
  "dementia", # Dementia diagnosis
  
  # time-invariant above
  "fu_year", # Follow-up year ------------------------------------------------
  # time-variant below
  
  "age_at_visit", #Age at cycle - fractional
  
  "cts_bname", # Boston naming - 2014
  "cts_catflu", # Category fluency - 2014
  "cts_nccrtd", #  Number comparison - 2014
  
  "fev", # forced expiratory volume
  "gait_speed", # Gait Speed - MAP
  "gripavg" # Extremity strength
)

d <- ds[ , selected_items]
table(d$fu_year)

# ---- export_data -------------------------------------
# At this point we would like to export the data in .dat format
# to be fed to Mplus for any subsequent modeling
write.csv(d,"./sandbox/report-name/data/unshared/long_dataset.csv", row.names=F)
write.table(d,"./sandbox/report-name/data/unshared/long_dataset.dat", row.names=F, col.names=F)
write(names(d), "./sandbox/syntax-creator/data/unshared/long_dataset_varnames.txt", sep=" ")


str(ds$agreeableness)
sum(ds$conscientiousness)
