# knitr::stitch_rmd(script="./___/___.R", output="./___/___/___.md")
#These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 

# ---- load-packages -----------------------------------------------------------
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # enables piping : %>% 
library(ggplot2)
# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2") # graphing
requireNamespace("readr")   # data input
requireNamespace("tidyr")   # data manipulation
requireNamespace("dplyr")   # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit")  # For asserting conditions meet expected patterns.
requireNamespace("corrplot")  # For asserting conditions meet expected patterns.
# requireNamespace("car")     # For it's `recode()` function.

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
source("./scripts/common-functions.R") # used in multiple reports
source("./scripts/graph-presets.R") # fonts, colors, themes 

# ---- declare-globals ---------------------------------------------------------

# ---- load-data ---------------------------------------------------------------
# the production of the dto object is now complete
# we verify its structure and content:
dto <- readRDS("./data/unshared/derived/dto.rds")
names(dto)
# 1st element - dto[["unitData"]] - unit(person) level data; all original variables
# 2nd element - dto[["metaData"]] - meta data, info about variables
meta <- dto[["metaData"]]
# 3rd element - dto[["analytic"]] - small, groomed data to be used for analysis
ds <- dto[["analytic"]]


# ---- inspect-data -------------------------------------------------------------

# ---- print-meta-1 ---------------------------

# demographic variables
cat("\n#### Demographic variables")

meta %>% 
  dplyr::filter(domain == "demographic") %>% 
  dplyr::select(name_new, label_short) %>% 
  dplyr::filter(name_new %in% names(ds)) %>% 
  knitr::kable(col.names = c("Variable name","Label"))


# Fear of Childbirth (FOC) scale variables
foc_domains <- c(
  "embarrassment", 
  "pain", 
  "meds",
  "delivery.mode", 
  "safe.baby", 
  "safe.mom",
  "body.change",
  "sex.function",
  "interventions"
)

meta %>% 
  dplyr::filter(domain %in% foc_domains) %>% 
  dplyr::mutate(domain = factor(domain, levels = foc_domains)) %>% 
  dplyr::group_by(domain) %>% 
  dplyr::summarize(n_itmes = n()) %>% 
  knitr::kable(col.names = c("Proposed Factor", "Number of items")) %>% 
  print()

for(i in foc_domains){
  cat("\n#### Fear of Childbirth factor: `",i,"`")
  meta %>% 
    dplyr::filter(domain %in% i) %>% 
    dplyr::arrange(domain) %>% 
    dplyr::filter(name_new %in% names(ds)) %>% 
    dplyr::select(domain, name_new, label_graph, label_short) %>% 
    knitr::kable(col.names = c("Factor","Code name","Short Name", "Label")) %>% 
    print()
  
}


# Interference scale
cat("\n#### Interference Scale")
meta %>% 
  dplyr::filter(domain %in% "interference") %>% 
  dplyr::select(name_new, label_graph, label_short) %>% 
  dplyr::filter(name_new %in% names(ds)) %>% 
  knitr::kable(col.names = c("Code name","Short Name","Label"))

# ---- tweak-data --------------------------------------------------------------
# prepare variables as factors
foc_levels <- c(0,1,2,3,4)
foc_labels <- c("Not at all",
                "Slightly",
                "Moderately",
                "Very",
                "Extremely")
# (varlist <- c(paste0("foc_0",1:9),paste0("foc_",10:49)))
# 
# 
# for( i in varlist){
#   ds[,i] <- as.numeric(ds[,i])-1
#   ds[,i] <- factor(ds[,i], levels = foc_levels, labels = foc_labels)
# }


# ---- basic-table --------------------------------------------------------------

# ---- basic-graph --------------------------------------------------------------



# ---- demographics -----------------------------------------
cat("\n Sample size: ")
ds$id %>% length() %>% unique()
cat("\n")

ds %>% histogram_discrete("pregnant")
ds %>% histogram_discrete("marital")
ds %>% histogram_discrete("education")
ds %>% histogram_continuous("weeks_pregnant", bin_width = 1)
ds %>% histogram_discrete("haskids")

# ---- foc -------------------------
domain_descriptives <- function(ds, meta, domain_name){
  # domain_name <- "safe.mom"
  # select meta data for current domain
  cat("\n#", toupper(domain_name),"\n")
  m <- meta %>% 
    dplyr::filter(domain ==domain_name) %>% 
    dplyr::select(name_new, label_graph, domain, label_short)
  # select the items in the selected domain
  (items_in_domain <- unique(m$name_new) %>% as.character)
  # create correlation matrix
  corrmat <- make_corr_matrix(ds,meta,items_in_domain)
  cat("\n Correlation of items in the proposed factor: \n")
  cat("\n")
  make_corr_plot(corrmat, upper="pie") %>% print()
  cat("\n")
  # print descriptives for each item
  for(i in items_in_domain){
    # i <- "foc_01"
    (item_title <- meta[meta$name_new==i, "label_short"] %>% as.character())
    (item_name  <- meta[meta$name_new==i, "label_graph"] %>% as.character())
    item_number <-  paste0(gsub("foc_", "", i))
    cat("\n##",item_number,"-", item_name,"\n") 
    cat("\n", item_title,"\n")
    cat("\n")
    ds %>% histogram_discrete(i, main_title = item_name) %>% print()
    cat("\n")
    cat("\nMean: ",round(mean(as.numeric(ds[,i]),na.rm = T),2),"\n")
    cat("\nSD: ", round(sd(as.numeric(ds[,i]), na.rm = T),2),"\n")
    cat("\nMissing: ",sum(is.na(ds[,i])),"\n")
  }
}
domain_descriptives(ds, meta, "embarrassment")
domain_descriptives(ds, meta, "pain")
domain_descriptives(ds, meta, "meds")
domain_descriptives(ds, meta, "delivery.mode")
domain_descriptives(ds, meta, "safe.baby")
domain_descriptives(ds, meta, "safe.mom")
domain_descriptives(ds, meta, "body.change")
domain_descriptives(ds, meta, "sex.function")
domain_descriptives(ds, meta, "interventions")

# ---- interventions --------------------------
domain_descriptives(ds, meta, "interventions")

# ---- reproduce ---------------------------------------
rmarkdown::render(input = "./sandbox/report-a.Rmd" ,
                  output_format="html_document", clean=TRUE)