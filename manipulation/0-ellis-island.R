# The purpose of this script is to create a data object (dto) 
# (dto) which will hold all data and metadata from each candidate study of the exercise
# Run the line below to stitch a basic html output. For elaborated report, run the corresponding .Rmd file
# knitr::stitch_rmd(script="./manipulation/0-ellis-island.R", output="./manipulation/stitched-output/0-ellis-island.md")
# These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # enables piping : %>% 
# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("foreign") # for importing SPSS files
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

# ---- declare-globals ---------------------------------------------------------
data_path_input  <- "./data/unshared/raw/Final Dataset NFSept 6 2015_1.sav"

# ---- load-data ------------------------------------------------
# load data objects
unitData <- foreign::read.spss(data_path_input,to.data.frame = TRUE)
# Hmisc is superior, b/c extract labels, but separates with "." not "_"
# unitData <- Hmisc::spss.get(data_path_input, use.value.labels = TRUE)

# ---- inspect-data -------------------------------------------------------------
nl <- names_labels(unitData)

# ---- basic-table --------------------------------------------------------------

# ---- basic-graph --------------------------------------------------------------

# ---- collect-meta-data-live -----------------------------------------
## we begin by extracting the names and (hopefuly their) labels of variables from each dataset
# and combine them in a single rectanguar object, long/stacked with respect to study names
nl <- names_labels(unitData)
readr::write_csv(nl,"./data/shared/meta/meta-data-live.csv")

# ----- import-meta-data-dead -----------------------------------------
# after the final version of the data files used in the excerside have been obtained
# we made a dead copy of `./data/shared/derived/meta-raw-live.csv` and named it `./data/shared/meta-data-map.csv`
# decisions on variables' renaming and classification is encoded in this map
# reproduce ellis-island script every time you make changes to `meta-data-map.csv`
metaData <- read.csv("./data/shared/meta/meta-data-dead.csv")




# ---- tweek-data ------------------------------------------------------------
# list the variables to select
select_variables <- metaData %>% 
  dplyr::filter(select==TRUE) %>% 
  dplyr::select(name)
(select_variables <- as.character(select_variables$name))
# subset selected variables
ds_small <- unitData %>% 
  dplyr::select_(.dots = select_variables)
# rename selected variables
d_rules <- metaData %>%
  dplyr::filter(name %in% names(ds_small)) %>% 
  dplyr::select(name, name_new ) # leave only collumn, which values you wish to append
names(ds_small) <- d_rules[,"name_new"]


# ---- assing-lables --------------------------------------------------------
attr(ds_small, "variable.labels")  <- NULL
attr(ds_small, "codepage")  <- NULL

for(i in unique(colnames(ds_small))){
  d_rules <- metaData %>%
    dplyr::filter(name_new %in% names(ds_small)) %>% 
    dplyr::select(name_new, label_short ) 
  attr(ds_small[,i], "label") <-  as.character(d_rules[d_rules$name_new==i,"label_short"])
}
# names_labels(ds_small)

# ---- save-to-disk ------------------------------------------------------------

dto <- list()
dto[["unitData"]] <- unitData
dto[['metaData']] <- metaData
dto[['analytic']] <- ds_small

# Save as a compress, binary R dataset.  It's no longer readable with a text editor, but it saves metadata (eg, factor information).
saveRDS(dto, file="./data/unshared/derived/dto.rds", compress="xz")


# ---- object-verification ------------------------------------------------
# the production of the dto object is now complete
# we verify its structure and content:
dto <- readRDS("./data/unshared/derived/dto.rds")
names(dto)
# 1st element - unit(person) level data
names(dto[["unitData"]])
# 2nd element - meta data, info about variables
names(dto[["metaData"]])
# 3rd element - small, groomed data to be used for analysis
names(dto[["analytic"]])


