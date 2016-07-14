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
filePath <- "./data/unshared/Final Dataset NFSept 6 2015_1.sav"

# ---- load-data ---------------------------------------------------------------
ds0 <- Hmisc::spss.get(filePath, use.value.labels = TRUE) 

# ---- inspect-data -------------------------------------------------------------
nl <- names_labels(ds0)


# ---- basic-table --------------------------------------------------------------

# ---- basic-graph --------------------------------------------------------------


# ---- collect-meta-data -----------------------------------------
## we begin by extracting the names and (hopefuly their) labels of variables from each dataset
# and combine them in a single rectanguar object, long/stacked with respect to study names
nl <- names_labels(ds0)
readr::write_csv(nl,"./data/shared/meta/meta-data-live.csv")

# ----- import-meta-data-dead -----------------------------------------
# after the final version of the data files used in the excerside have been obtained
# we made a dead copy of `./data/shared/derived/meta-raw-live.csv` and named it `./data/shared/meta-data-map.csv`
# decisions on variables' renaming and classification is encoded in this map
# reproduce ellis-island script every time you make changes to `meta-data-map.csv`
meta <- read.csv("./data/shared/meta/meta-data-dead.csv")
meta <- meta %>% dplyr::filter(select==TRUE)
variable_names <- as.character(meta[,"name"])

ds <- ds0 %>% 
  dplyr::select_(.dots = variable_names)
names(ds) <- as.character(meta[,"name_new"])
names(ds) 

# ---- tweak-data --------------------------------------------------------------


# ---- save-to-disk ------------------------------------------------------------

dto <- list()
dto[["UnitData"]] <- ds
dto[['MetaData']] <- meta
# Save as a compress, binary R dataset.  It's no longer readable with a text editor, but it saves metadata (eg, factor information).
saveRDS(dto, file="./data/unshared/derived/dto.rds", compress="xz")





