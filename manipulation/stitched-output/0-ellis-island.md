



This report was automatically generated with the R package **knitr**
(version 1.14).


```r
# The purpose of this script is to create a data object (dto) 
# (dto) which will hold all data and metadata from each candidate study of the exercise
# Run the line below to stitch a basic html output. For elaborated report, run the corresponding .Rmd file
# knitr::stitch_rmd(script="./manipulation/0-ellis-island.R", output="./manipulation/stitched-output/0-ellis-island.md")
# These first few lines run only when the file is run in RStudio, !!NOT when an Rmd/Rnw file calls it!!
rm(list=ls(all=TRUE))  #Clear the variables from previous runs.
cat("\f") # clear console 
```



```r
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
```

```r
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
source("./scripts/common-functions.R") # used in multiple reports
source("./scripts/graph-presets.R") # fonts, colors, themes 
```

```r
data_path_input  <- "./data/unshared/raw/Final Dataset NFSept 6 2015_1.sav"
```

```r
# load data objects
unitData <- foreign::read.spss(data_path_input,to.data.frame = TRUE) 
```

```
## Warning in foreign::read.spss(data_path_input, to.data.frame = TRUE): ./
## data/unshared/raw/Final Dataset NFSept 6 2015_1.sav: Unrecognized record
## type 7, subtype 14 encountered in system file
```

```
## Warning in foreign::read.spss(data_path_input, to.data.frame = TRUE): ./
## data/unshared/raw/Final Dataset NFSept 6 2015_1.sav: Unrecognized record
## type 7, subtype 18 encountered in system file
```

```
## Warning in foreign::read.spss(data_path_input, to.data.frame = TRUE): ./
## data/unshared/raw/Final Dataset NFSept 6 2015_1.sav: Unrecognized record
## type 7, subtype 21 encountered in system file
```

```
## Warning in foreign::read.spss(data_path_input, to.data.frame = TRUE): ./
## data/unshared/raw/Final Dataset NFSept 6 2015_1.sav: Unrecognized record
## type 7, subtype 24 encountered in system file
```

```r
nl <- names_labels(unitData)
```



```r
## we begin by extracting the names and (hopefuly their) labels of variables from each dataset
# and combine them in a single rectanguar object, long/stacked with respect to study names
nl <- names_labels(unitData)
readr::write_csv(nl,"./data/shared/meta/meta-data-live.csv")
```

```r
# after the final version of the data files used in the excerside have been obtained
# we made a dead copy of `./data/shared/derived/meta-raw-live.csv` and named it `./data/shared/meta-data-map.csv`
# decisions on variables' renaming and classification is encoded in this map
# reproduce ellis-island script every time you make changes to `meta-data-map.csv`
metaData <- read.csv("./data/shared/meta/meta-data-dead.csv")
```

```r
# list the variables to select
select_variables <- metaData %>% 
  dplyr::filter(select==TRUE) %>% 
  dplyr::select(name)
(select_variables <- as.character(select_variables$name))
```

```
##  [1] "RespondentID"   "Pregnant"       "Marital_status" "Education"     
##  [5] "Weeks_pregnant" "Has_kids"       "FOC1"           "FOC2"          
##  [9] "FOC3"           "FOC4"           "FOC5"           "FOC6"          
## [13] "FOC7"           "FOC8"           "FOC9"           "FOC10"         
## [17] "FOC11"          "FOC12"          "FOC13"          "FOC14"         
## [21] "FOC15"          "FOC16"          "FOC17"          "FOC18"         
## [25] "FOC19"          "FOC20"          "FOC21"          "FOC22"         
## [29] "FOC23"          "FOC24"          "FOC25"          "FOC26"         
## [33] "FOC27"          "FOC28"          "FOC29"          "FOC30"         
## [37] "FOC31"          "FOC32"          "FOC33"          "FOC34"         
## [41] "FOC35"          "FOC36"          "FOC37"          "FOC38"         
## [45] "FOC39"          "FOC40"          "FOC41"          "FOC42"         
## [49] "FOC43"          "FOC44"          "FOC45"          "FOC46"         
## [53] "FOC47"          "FOC48"          "FOC49"          "FOCI1"         
## [57] "FOCI2"          "FOCI3"          "FOCI4"          "FOCI5"         
## [61] "FOCI6"          "FOCI7"
```

```r
# subset selected variables
ds_small <- unitData %>% 
  dplyr::select_(.dots = select_variables)
# rename selected variables
d_rules <- metaData %>%
  dplyr::filter(name %in% names(ds_small)) %>% 
  dplyr::select(name, name_new ) # leave only collumn, which values you wish to append
names(ds_small) <- d_rules[,"name_new"]
```

```r
dto <- list()
dto[["unitData"]] <- unitData
dto[['metaData']] <- metaData
dto[['analytic']] <- ds_small

# Save as a compress, binary R dataset.  It's no longer readable with a text editor, but it saves metadata (eg, factor information).
saveRDS(dto, file="./data/unshared/derived/dto.rds", compress="xz")
```

```r
# the production of the dto object is now complete
# we verify its structure and content:
dto <- readRDS("./data/unshared/derived/dto.rds")
names(dto)
```

```
## [1] "unitData" "metaData" "analytic"
```

```r
# 1st element - unit(person) level data
names(dto[["unitData"]])
```

```
##   [1] "RespondentID"                   "DOB"                           
##   [3] "Over_18"                        "Pregnant"                      
##   [5] "Gender"                         "Marital_status"                
##   [7] "Education"                      "Education_other"               
##   [9] "EDUCA0"                         "EDUCA1"                        
##  [11] "EDUCA2"                         "EDUCA3"                        
##  [13] "EDUCA4"                         "EDUCA5"                        
##  [15] "EDUCA6"                         "EDUCA7"                        
##  [17] "EDUCA8"                         "EDUCA9"                        
##  [19] "EDUCAA"                         "EDUCAB"                        
##  [21] "EDUCAC"                         "EDUCAD"                        
##  [23] "EDUCAE"                         "EDUCAF"                        
##  [25] "EDUCAG"                         "EDUCAH"                        
##  [27] "EDUCAI"                         "EDUCAJ"                        
##  [29] "EDUCAK"                         "EDUCAL"                        
##  [31] "EDUCAM"                         "EDUCAN"                        
##  [33] "EDUCAO"                         "EDUCAP"                        
##  [35] "EDUCAQ"                         "EDUCAR"                        
##  [37] "EDUCAS"                         "EDUCAT"                        
##  [39] "EDUCAU"                         "EDUCAV"                        
##  [41] "EDUCAW"                         "EDUCAX"                        
##  [43] "EDUCAY"                         "EDUCAZ"                        
##  [45] "EDUCA10"                        "EDUCA11"                       
##  [47] "EDUCA12"                        "EDUCA13"                       
##  [49] "EDUCA14"                        "EDUCA15"                       
##  [51] "EDUCA16"                        "EDUCA17"                       
##  [53] "EDUCA18"                        "EDUCA19"                       
##  [55] "EDUCA1A"                        "Miscarriage"                   
##  [57] "Stillbirth"                     "Terminated"                    
##  [59] "Current_complications"          "Country_Code"                  
##  [61] "Parity"                         "Current_conception"            
##  [63] "Episiotomy"                     "Current_babies"                
##  [65] "Income"                         "Weeks_pregnant"                
##  [67] "Care_Provider"                  "Very_satisfied"                
##  [69] "Birthplace"                     "INTERVENTIONSTOTM"             
##  [71] "HARMTOTM"                       "PAINTOTM"                      
##  [73] "SHYTOTM"                        "SEXTOTM"                       
##  [75] "CSTOTM"                         "FOCTOTM"                       
##  [77] "INTERFERENCE"                   "Know_trauma_vaginal"           
##  [79] "Know_trauma_cesarean"           "Know_positive_vaginal"         
##  [81] "Know_positive_cesarean"         "Births_vaginal_traumatic"      
##  [83] "Pregnancies"                    "StartDate"                     
##  [85] "Due_date"                       "EndDate"                       
##  [87] "Student_FT"                     "Student_PT"                    
##  [89] "Employed_FT"                    "Employed_PT"                   
##  [91] "Homemaker_FT"                   "Homemaker_PT"                  
##  [93] "Unemployed_FT"                  "Unemloyed_PT"                  
##  [95] "SeekingWork_FT"                 "SeekingWork_PT"                
##  [97] "Retired_FT"                     "Retired_PT"                    
##  [99] "Disabled_FT"                    "Disabled_PT"                   
## [101] "City"                           "CITY0"                         
## [103] "CITY1"                          "CITY2"                         
## [105] "CITY3"                          "CITY4"                         
## [107] "CITY5"                          "CITY6"                         
## [109] "CITY7"                          "CITY8"                         
## [111] "CITY9"                          "CITYA"                         
## [113] "CITYB"                          "CITYC"                         
## [115] "CITYD"                          "CITYE"                         
## [117] "CITYF"                          "CITYG"                         
## [119] "CITYH"                          "CITYI"                         
## [121] "CITYJ"                          "CITYK"                         
## [123] "CITYL"                          "CITYM"                         
## [125] "CITYN"                          "CITYO"                         
## [127] "CITYP"                          "CITYQ"                         
## [129] "CITYR"                          "CITYS"                         
## [131] "CITYT"                          "CITYU"                         
## [133] "CITYV"                          "CITYW"                         
## [135] "CITYX"                          "CITYY"                         
## [137] "CITYZ"                          "CITY10"                        
## [139] "CITY11"                         "CITY12"                        
## [141] "CITY13"                         "CITY14"                        
## [143] "CITY15"                         "CITY16"                        
## [145] "CITY17"                         "CITY18"                        
## [147] "CITY19"                         "CITY1A"                        
## [149] "Province"                       "PROVI0"                        
## [151] "PROVI1"                         "PROVI2"                        
## [153] "PROVI3"                         "PROVI4"                        
## [155] "PROVI5"                         "PROVI6"                        
## [157] "PROVI7"                         "PROVI8"                        
## [159] "PROVI9"                         "PROVIA"                        
## [161] "PROVIB"                         "PROVIC"                        
## [163] "PROVID"                         "PROVIE"                        
## [165] "PROVIF"                         "PROVIG"                        
## [167] "PROVIH"                         "PROVII"                        
## [169] "PROVIJ"                         "PROVIK"                        
## [171] "PROVIL"                         "PROVIM"                        
## [173] "PROVIN"                         "PROVIO"                        
## [175] "PROVIP"                         "PROVIQ"                        
## [177] "PROVIR"                         "PROVIS"                        
## [179] "PROVIT"                         "PROVIU"                        
## [181] "PROVIV"                         "PROVIW"                        
## [183] "PROVIX"                         "PROVIY"                        
## [185] "PROVIZ"                         "PROVI10"                       
## [187] "PROVI11"                        "PROVI12"                       
## [189] "PROVI13"                        "PROVI14"                       
## [191] "PROVI15"                        "PROVI16"                       
## [193] "PROVI17"                        "PROVI18"                       
## [195] "PROVI19"                        "PROVI1A"                       
## [197] "Country"                        "COUNT0"                        
## [199] "COUNT1"                         "COUNT2"                        
## [201] "COUNT3"                         "COUNT4"                        
## [203] "COUNT5"                         "COUNT6"                        
## [205] "COUNT7"                         "COUNT8"                        
## [207] "COUNT9"                         "COUNTA"                        
## [209] "COUNTB"                         "COUNTC"                        
## [211] "COUNTD"                         "COUNTE"                        
## [213] "COUNTF"                         "COUNTG"                        
## [215] "COUNTH"                         "COUNTI"                        
## [217] "COUNTJ"                         "COUNTK"                        
## [219] "COUNTL"                         "COUNTM"                        
## [221] "COUNTN"                         "COUNTO"                        
## [223] "COUNTP"                         "COUNTQ"                        
## [225] "COUNTR"                         "COUNTS"                        
## [227] "COUNTT"                         "COUNTU"                        
## [229] "COUNTV"                         "COUNTW"                        
## [231] "COUNTX"                         "COUNTY"                        
## [233] "COUNTZ"                         "COUNT10"                       
## [235] "COUNT11"                        "COUNT12"                       
## [237] "COUNT13"                        "COUNT14"                       
## [239] "COUNT15"                        "COUNT16"                       
## [241] "COUNT17"                        "COUNT18"                       
## [243] "COUNT19"                        "COUNT1A"                       
## [245] "Ethnicity"                      "Ethnicity_Other"               
## [247] "ETHNI0"                         "ETHNI1"                        
## [249] "ETHNI2"                         "ETHNI3"                        
## [251] "ETHNI4"                         "ETHNI5"                        
## [253] "ETHNI6"                         "ETHNI7"                        
## [255] "ETHNI8"                         "ETHNI9"                        
## [257] "ETHNIA"                         "ETHNIB"                        
## [259] "ETHNIC"                         "ETHNID"                        
## [261] "ETHNIE"                         "ETHNIF"                        
## [263] "ETHNIG"                         "ETHNIH"                        
## [265] "ETHNII"                         "ETHNIJ"                        
## [267] "ETHNIK"                         "ETHNIL"                        
## [269] "ETHNIM"                         "ETHNIN"                        
## [271] "ETHNIO"                         "ETHNIP"                        
## [273] "ETHNIQ"                         "ETHNIR"                        
## [275] "ETHNIS"                         "ETHNIT"                        
## [277] "ETHNIU"                         "ETHNIV"                        
## [279] "ETHNIW"                         "ETHNIX"                        
## [281] "ETHNIY"                         "ETHNIZ"                        
## [283] "ETHNI10"                        "ETHNI11"                       
## [285] "ETHNI12"                        "ETHNI13"                       
## [287] "ETHNI14"                        "ETHNI15"                       
## [289] "ETHNI16"                        "ETHNI17"                       
## [291] "ETHNI18"                        "ETHNI19"                       
## [293] "ETHNI1A"                        "Language"                      
## [295] "LANGU0"                         "LANGU1"                        
## [297] "LANGU2"                         "LANGU3"                        
## [299] "LANGU4"                         "LANGU5"                        
## [301] "LANGU6"                         "LANGU7"                        
## [303] "LANGU8"                         "LANGU9"                        
## [305] "LANGUA"                         "LANGUB"                        
## [307] "LANGUC"                         "LANGUD"                        
## [309] "LANGUE"                         "LANGUF"                        
## [311] "LANGUG"                         "LANGUH"                        
## [313] "LANGUI"                         "LANGUJ"                        
## [315] "LANGUK"                         "LANGUL"                        
## [317] "LANGUM"                         "LANGUN"                        
## [319] "LANGUO"                         "LANGUP"                        
## [321] "LANGUQ"                         "LANGUR"                        
## [323] "LANGUS"                         "LANGUT"                        
## [325] "LANGUU"                         "LANGUV"                        
## [327] "LANGUW"                         "LANGUX"                        
## [329] "LANGUY"                         "LANGUZ"                        
## [331] "LANGU10"                        "LANGU11"                       
## [333] "LANGU12"                        "LANGU13"                       
## [335] "LANGU14"                        "LANGU15"                       
## [337] "LANGU16"                        "LANGU17"                       
## [339] "LANGU18"                        "LANGU19"                       
## [341] "LANGU1A"                        "Language_Coded"                
## [343] "Has_kids"                       "Births"                        
## [345] "Births_vaginal"                 "Births_cesarean"               
## [347] "Births_cesarean_emerg"          "Births_cesarean_traumatic"     
## [349] "Assisted_vaginal"               "Current_complications_describe"
## [351] "CURRE1B"                        "CURRE1C"                       
## [353] "CURRE1D"                        "CURRE1E"                       
## [355] "CURRE1F"                        "CURRE1G"                       
## [357] "CURRE1H"                        "CURRE1I"                       
## [359] "CURRE1J"                        "CURRE1K"                       
## [361] "CURRE1L"                        "CURRE1M"                       
## [363] "CURRE1N"                        "CURRE1O"                       
## [365] "CURRE1P"                        "CURRE1Q"                       
## [367] "CURRE1R"                        "CURRE1S"                       
## [369] "CURRE1T"                        "CURRE1U"                       
## [371] "CURRE1V"                        "CURRE1W"                       
## [373] "CURRE1X"                        "CURRE1Y"                       
## [375] "CURRE1Z"                        "CURRE20"                       
## [377] "CURRE21"                        "CURRE22"                       
## [379] "CURRE23"                        "CURRE24"                       
## [381] "CURRE25"                        "CURRE26"                       
## [383] "CURRE27"                        "CURRE28"                       
## [385] "CURRE29"                        "CURRE2A"                       
## [387] "CURRE2B"                        "CURRE2C"                       
## [389] "CURRE2D"                        "CURRE2E"                       
## [391] "CURRE2F"                        "CURRE2G"                       
## [393] "CURRE2H"                        "CURRE2I"                       
## [395] "CURRE2J"                        "CURRE2K"                       
## [397] "CURRE2L"                        "Current_conception_other"      
## [399] "CURRE0"                         "CURRE1"                        
## [401] "CURRE2"                         "CURRE3"                        
## [403] "CURRE4"                         "CURRE5"                        
## [405] "CURRE6"                         "CURRE7"                        
## [407] "CURRE8"                         "CURRE9"                        
## [409] "CURREA"                         "CURREB"                        
## [411] "CURREC"                         "CURRED"                        
## [413] "CURREE"                         "CURREF"                        
## [415] "CURREG"                         "CURREH"                        
## [417] "CURREI"                         "CURREJ"                        
## [419] "CURREK"                         "CURREL"                        
## [421] "CURREM"                         "CURREN"                        
## [423] "CURREO"                         "CURREP"                        
## [425] "CURREQ"                         "CURRER"                        
## [427] "CURRES"                         "CURRET"                        
## [429] "CURREU"                         "CURREV"                        
## [431] "CURREW"                         "CURREX"                        
## [433] "CURREY"                         "CURREZ"                        
## [435] "CURRE10"                        "CURRE11"                       
## [437] "CURRE12"                        "CURRE13"                       
## [439] "CURRE14"                        "CURRE15"                       
## [441] "CURRE16"                        "CURRE17"                       
## [443] "CURRE18"                        "CURRE19"                       
## [445] "CURRE1A"                        "Painful_event"                 
## [447] "Painful_event_describe"         "PAINF0"                        
## [449] "PAINF1"                         "PAINF2"                        
## [451] "PAINF3"                         "PAINF4"                        
## [453] "PAINF5"                         "PAINF6"                        
## [455] "PAINF7"                         "PAINF8"                        
## [457] "PAINF9"                         "PAINFA"                        
## [459] "PAINFB"                         "PAINFC"                        
## [461] "PAINFD"                         "PAINFE"                        
## [463] "PAINFF"                         "PAINFG"                        
## [465] "PAINFH"                         "PAINFI"                        
## [467] "PAINFJ"                         "PAINFK"                        
## [469] "PAINFL"                         "PAINFM"                        
## [471] "PAINFN"                         "PAINFO"                        
## [473] "PAINFP"                         "PAINFQ"                        
## [475] "PAINFR"                         "PAINFS"                        
## [477] "PAINFT"                         "PAINFU"                        
## [479] "PAINFV"                         "PAINFW"                        
## [481] "PAINFX"                         "PAINFY"                        
## [483] "PAINFZ"                         "PAINF10"                       
## [485] "PAINF11"                        "PAINF12"                       
## [487] "PAINF13"                        "PAINF14"                       
## [489] "PAINF15"                        "PAINF16"                       
## [491] "PAINF17"                        "PAINF18"                       
## [493] "PAINF19"                        "PAINF1A"                       
## [495] "Care_Provider_Other"            "CARE_0"                        
## [497] "CARE_1"                         "CARE_2"                        
## [499] "CARE_3"                         "CARE_4"                        
## [501] "CARE_5"                         "CARE_6"                        
## [503] "CARE_7"                         "CARE_8"                        
## [505] "CARE_9"                         "CARE_A"                        
## [507] "CARE_B"                         "CARE_C"                        
## [509] "CARE_D"                         "CARE_E"                        
## [511] "CARE_F"                         "CARE_G"                        
## [513] "CARE_H"                         "CARE_I"                        
## [515] "CARE_J"                         "CARE_K"                        
## [517] "CARE_L"                         "CARE_M"                        
## [519] "CARE_N"                         "CARE_O"                        
## [521] "CARE_P"                         "CARE_Q"                        
## [523] "CARE_R"                         "CARE_S"                        
## [525] "CARE_T"                         "CARE_U"                        
## [527] "CARE_V"                         "CARE_W"                        
## [529] "CARE_X"                         "CARE_Y"                        
## [531] "CARE_Z"                         "CARE_10"                       
## [533] "CARE_11"                        "CARE_12"                       
## [535] "CARE_13"                        "CARE_14"                       
## [537] "CARE_15"                        "CARE_16"                       
## [539] "CARE_17"                        "CARE_18"                       
## [541] "CARE_19"                        "CARE_1A"                       
## [543] "Care_Provider_Present"          "Care_Provider_Satisfaction"    
## [545] "Present_Partner"                "Present_Physician"             
## [547] "Present_OB"                     "Present_Mother"                
## [549] "Present_Father"                 "Present_Midwife"               
## [551] "Present_Doula"                  "Present_Partner_Parents"       
## [553] "Present_Sibling"                "Present_Children"              
## [555] "Present_Friends"                "Present_Other"                 
## [557] "Present_Other_specify"          "PRESE0"                        
## [559] "PRESE1"                         "PRESE2"                        
## [561] "PRESE3"                         "PRESE4"                        
## [563] "PRESE5"                         "PRESE6"                        
## [565] "PRESE7"                         "PRESE8"                        
## [567] "PRESE9"                         "PRESEA"                        
## [569] "PRESEB"                         "PRESEC"                        
## [571] "PRESED"                         "PRESEE"                        
## [573] "PRESEF"                         "PRESEG"                        
## [575] "PRESEH"                         "PRESEI"                        
## [577] "PRESEJ"                         "PRESEK"                        
## [579] "PRESEL"                         "PRESEM"                        
## [581] "PRESEN"                         "PRESEO"                        
## [583] "PRESEP"                         "PRESEQ"                        
## [585] "PRESER"                         "PRESES"                        
## [587] "PRESET"                         "PRESEU"                        
## [589] "PRESEV"                         "PRESEW"                        
## [591] "PRESEX"                         "PRESEY"                        
## [593] "PRESEZ"                         "PRESE10"                       
## [595] "PRESE11"                        "PRESE12"                       
## [597] "PRESE13"                        "PRESE14"                       
## [599] "PRESE15"                        "PRESE16"                       
## [601] "PRESE17"                        "PRESE18"                       
## [603] "PRESE19"                        "PRESE1A"                       
## [605] "Birthplace_other"               "BIRTH0"                        
## [607] "BIRTH1"                         "BIRTH2"                        
## [609] "BIRTH3"                         "BIRTH4"                        
## [611] "BIRTH5"                         "BIRTH6"                        
## [613] "BIRTH7"                         "BIRTH8"                        
## [615] "BIRTH9"                         "BIRTHA"                        
## [617] "BIRTHB"                         "BIRTHC"                        
## [619] "BIRTHD"                         "BIRTHE"                        
## [621] "BIRTHF"                         "BIRTHG"                        
## [623] "BIRTHH"                         "BIRTHI"                        
## [625] "BIRTHJ"                         "BIRTHK"                        
## [627] "BIRTHL"                         "BIRTHM"                        
## [629] "BIRTHN"                         "BIRTHO"                        
## [631] "BIRTHP"                         "BIRTHQ"                        
## [633] "BIRTHR"                         "BIRTHT"                        
## [635] "BIRTHU"                         "BIRTHV"                        
## [637] "BIRTHW"                         "BIRTHX"                        
## [639] "BIRTHY"                         "BIRTHZ"                        
## [641] "BIRTH10"                        "BIRTH11"                       
## [643] "BIRTH12"                        "BIRTH13"                       
## [645] "BIRTH14"                        "BIRTH15"                       
## [647] "BIRTH16"                        "BIRTH17"                       
## [649] "BIRTH18"                        "BIRTH19"                       
## [651] "BIRTH1A"                        "BIRTH1B"                       
## [653] "Birth_preference"               "Birth_preference_dichotomized" 
## [655] "FOC1"                           "FOC2"                          
## [657] "FOC3"                           "FOC4"                          
## [659] "FOC5"                           "FOC6"                          
## [661] "FOC7"                           "FOC8"                          
## [663] "FOC9"                           "FOC10"                         
## [665] "FOC11"                          "FOC12"                         
## [667] "FOC13"                          "FOC14"                         
## [669] "FOC15"                          "FOC16"                         
## [671] "FOC17"                          "FOC18"                         
## [673] "FOC19"                          "FOC20"                         
## [675] "FOC21"                          "FOC22"                         
## [677] "FOC23"                          "FOC24"                         
## [679] "FOC25"                          "FOC26"                         
## [681] "FOC27"                          "FOC28"                         
## [683] "FOC29"                          "FOC30"                         
## [685] "FOC31"                          "FOC32"                         
## [687] "FOC33"                          "FOC34"                         
## [689] "FOC35"                          "FOC36"                         
## [691] "FOC37"                          "FOC38"                         
## [693] "FOC39"                          "FOC40"                         
## [695] "FOC41"                          "FOC42"                         
## [697] "FOC43"                          "FOC44"                         
## [699] "FOC45"                          "FOC46"                         
## [701] "FOC47"                          "FOC48"                         
## [703] "FOC49"                          "FOC_OTHER"                     
## [705] "FOC_O0"                         "FOC_O1"                        
## [707] "FOC_O2"                         "FOC_O3"                        
## [709] "FOC_O4"                         "FOC_O5"                        
## [711] "FOC_O6"                         "FOC_O7"                        
## [713] "FOC_O8"                         "FOC_O9"                        
## [715] "FOC_OA"                         "FOC_OB"                        
## [717] "FOC_OC"                         "FOC_OD"                        
## [719] "FOC_OE"                         "FOC_OF"                        
## [721] "FOC_OG"                         "FOC_OH"                        
## [723] "FOC_OI"                         "FOC_OJ"                        
## [725] "FOC_OK"                         "FOC_OL"                        
## [727] "FOC_OM"                         "FOC_ON"                        
## [729] "FOC_OO"                         "FOC_OP"                        
## [731] "FOC_OQ"                         "FOC_OR"                        
## [733] "FOC_OS"                         "FOC_OT"                        
## [735] "FOC_OU"                         "FOC_OV"                        
## [737] "FOC_OW"                         "FOC_OX"                        
## [739] "FOC_OY"                         "FOC_OZ"                        
## [741] "FOC_O10"                        "FOC_O11"                       
## [743] "FOC_O12"                        "FOC_O13"                       
## [745] "FOC_O14"                        "FOC_O15"                       
## [747] "FOC_O16"                        "FOC_O17"                       
## [749] "FOC_O18"                        "FOC_O19"                       
## [751] "FOC_O1A"                        "FOCI1"                         
## [753] "FOCI2"                          "FOCI3"                         
## [755] "FOCI4"                          "FOCI5"                         
## [757] "FOCI6"                          "FOCI7"                         
## [759] "FOCI_OTHER"                     "FOCI_0"                        
## [761] "FOCI_1"                         "FOCI_2"                        
## [763] "FOCI_3"                         "FOCI_4"                        
## [765] "FOCI_5"                         "FOCI_6"                        
## [767] "FOCI_7"                         "FOCI_8"                        
## [769] "FOCI_9"                         "FOCI_A"                        
## [771] "FOCI_B"                         "FOCI_C"                        
## [773] "FOCI_D"                         "FOCI_E"                        
## [775] "FOCI_F"                         "FOCI_G"                        
## [777] "FOCI_H"                         "FOCI_I"                        
## [779] "FOCI_J"                         "FOCI_K"                        
## [781] "FOCI_L"                         "FOCI_M"                        
## [783] "FOCI_N"                         "FOCI_O"                        
## [785] "FOCI_P"                         "FOCI_Q"                        
## [787] "FOCI_R"                         "FOCI_S"                        
## [789] "FOCI_T"                         "FOCI_U"                        
## [791] "FOCI_V"                         "FOCI_W"                        
## [793] "FOCI_X"                         "FOCI_Y"                        
## [795] "FOCI_Z"                         "FOCI_10"                       
## [797] "FOCI_11"                        "FOCI_12"                       
## [799] "FOCI_13"                        "FOCI_14"                       
## [801] "FOCI_15"                        "FOCI_16"                       
## [803] "FOCI_17"                        "FOCI_18"                       
## [805] "FOCI_19"                        "FOCI_1A"                       
## [807] "WDEQ1_LABOUR_FANTASTIC"         "WDEQ1_R"                       
## [809] "WDEQ2_LABOUR_FRIGHTFUL"         "WDEQ3_LABOUR_LONELY"           
## [811] "WDEQ4_LABOUR_STRONG"            "WDEQ4_R"                       
## [813] "WDEQ5_LABOUR_CONFIDENT"         "WEDQ5_R"                       
## [815] "WDEQ6_LABOUR_AFRAID"            "WDEQ7_LABOUR_DESERTED"         
## [817] "WDEQ8_LABOUR_WEAK"              "WDEQ9_LABOUR_SAFE"             
## [819] "WDEQ9_R"                        "WDEQ10_LABOUR_INDEPENDENT"     
## [821] "WDEQ10_R"                       "WDEQ11_LABOUR_DESOLATE"        
## [823] "WDEQ12_LABOUR_TENSE"            "WDEQ13_LABOUR_GLAD"            
## [825] "WDEQ13_R"                       "WDEQ14_LABOUR_PROUD"           
## [827] "WDEQ14_R"                       "WDEQ15_LABOUR_ABANDONED"       
## [829] "WDEQ16_LABOUR_COMPOSED"         "WDEQ16_R"                      
## [831] "WDEQ17_LABOUR_RELAXED"          "WDEQ17_R"                      
## [833] "WDEQ18_LABOUR_HAPPY"            "WDEQ18_R"                      
## [835] "WDEQ19_LABOUR_PANIC"            "WDEQ20_LABOUR_HOPELESSNESS"    
## [837] "WDEQ21_LABOUR_LONGING"          "WDEQ21_R"                      
## [839] "WDEQ22_LABOUR_CONFIDENCE"       "WDEQ22_R"                      
## [841] "WDEQ23_LABOUR_TRUST"            "WDEQ23_R"                      
## [843] "WDEQ24_LABOUR_PAIN"             "WDEQ25_LABOUR_BEHAVBADLY"      
## [845] "WDEQ26_LABOUR_SURRENDER"        "WDEQ26_R"                      
## [847] "WDEQ27_LABOUR_LOSECONTROL"      "WDEQ28_DELIVERY_ENJOYABLE"     
## [849] "WDEQ28_R"                       "WDEQ29_DELIVERY_NATURAL"       
## [851] "WDEQ29_R"                       "WDEQ30_DELIVERY_COURSE"        
## [853] "WDEQ30_R"                       "WDEQ31_DELIVERY_DANGEROUS"     
## [855] "WDEQ32_FANTASY_DEATH"           "WDEQ33_FANTASY_INJURY"         
## [857] "EPDS1_LAUGH"                    "EPDS2_ENJOYMENT"               
## [859] "EPDS3_BLAME"                    "EPDS4_ANXIOUS"                 
## [861] "EPDS5_SCARED"                   "EPDS6_COPING"                  
## [863] "EPDS7_SLEEPING"                 "EPDS8_MISERABLE"               
## [865] "EPDS9_CRYING"                   "EPDS10_SELFHARM"               
## [867] "MQ1"                            "MQ2"                           
## [869] "MQ3"                            "MQ4"                           
## [871] "MQ5"                            "MQ6"                           
## [873] "MQ7"                            "MQ8"                           
## [875] "MQ9"                            "MQ10"                          
## [877] "MQ11"                           "MQ12"                          
## [879] "MQ13"                           "MQ14"                          
## [881] "MQ15"                           "MQ16"                          
## [883] "MQ17"                           "MQ18"                          
## [885] "MQ19"                           "MQ20"                          
## [887] "MQ21"                           "MQ22"                          
## [889] "MQ23"                           "MQ24"                          
## [891] "MQ25"                           "MQ26"                          
## [893] "MQ27"                           "MQ28"                          
## [895] "MQ29"                           "MQ30"                          
## [897] "INCLUDE_RESPONSES"              "filter_."                      
## [899] "EPDS3_R"                        "EPDS5_R"                       
## [901] "EPDS6_R"                        "EPDS7_R"                       
## [903] "EPDS8_R"                        "EPDS9_R"                       
## [905] "EPDS10_R"                       "EPDSTOTM"                      
## [907] "MQ5R"                           "MQ9R"                          
## [909] "MQ14R"                          "MQ18R"                         
## [911] "MQ21R"                          "MQ28R"                         
## [913] "MQTOTM"                         "WDEQA_TOTM"                    
## [915] "WDEQA_TOT"                      "WDEQA_SCALED_0_TO_5"           
## [917] "Singletons_yes"                 "Income_recoded"                
## [919] "Country_recode"                 "Episiotomy_yes"                
## [921] "Painful_event_yes"              "Emergency_CS"                  
## [923] "Traumatic_CS"                   "Assisted_vag"                  
## [925] "Test"                           "Traumatic_vaginal"             
## [927] "Previous_CS"                    "Previous_vag_delivery"         
## [929] "Maternal_age"                   "Age_35_or_older"               
## [931] "Age_40_or_older"                "Age_three_categories"          
## [933] "Education_recode"               "Stillbirth_yes"                
## [935] "Termination_yes"                "Miscarriage_yes"
```

```r
# 2nd element - meta data, info about variables
names(dto[["metaData"]])
```

```
## [1] "name"        "label"       "select"      "name_new"    "label_graph"
## [6] "label_short" "domain"
```

```r
# 3rd element - small, groomed data to be used for analysis
names(dto[["analytic"]])
```

```
##  [1] "id"             "pregnant"       "marital"        "education"     
##  [5] "weeks_pregnant" "haskids"        "foc_01"         "foc_02"        
##  [9] "foc_03"         "foc_04"         "foc_05"         "foc_06"        
## [13] "foc_07"         "foc_08"         "foc_09"         "foc_10"        
## [17] "foc_11"         "foc_12"         "foc_13"         "foc_14"        
## [21] "foc_15"         "foc_16"         "foc_17"         "foc_18"        
## [25] "foc_19"         "foc_20"         "foc_21"         "foc_22"        
## [29] "foc_23"         "foc_24"         "foc_25"         "foc_26"        
## [33] "foc_27"         "foc_28"         "foc_29"         "foc_30"        
## [37] "foc_31"         "foc_32"         "foc_33"         "foc_34"        
## [41] "foc_35"         "foc_36"         "foc_37"         "foc_38"        
## [45] "foc_39"         "foc_40"         "foc_41"         "foc_42"        
## [49] "foc_43"         "foc_44"         "foc_45"         "foc_46"        
## [53] "foc_47"         "foc_48"         "foc_49"         "itf_1"         
## [57] "itf_2"          "itf_3"          "itf_4"          "itf_5"         
## [61] "itf_6"          "itf_7"
```

The R session information (including the OS info, R version and all
packages used):


```r
sessionInfo()
```

```
## R version 3.3.1 (2016-06-21)
## Platform: x86_64-w64-mingw32/x64 (64-bit)
## Running under: Windows >= 8 x64 (build 9200)
## 
## locale:
## [1] LC_COLLATE=English_United States.1252 
## [2] LC_CTYPE=English_United States.1252   
## [3] LC_MONETARY=English_United States.1252
## [4] LC_NUMERIC=C                          
## [5] LC_TIME=English_United States.1252    
## 
## attached base packages:
## [1] stats     graphics  grDevices utils     datasets  methods   base     
## 
## other attached packages:
## [1] magrittr_1.5 psych_1.6.9  shiny_0.14.1
## 
## loaded via a namespace (and not attached):
##  [1] Rcpp_0.12.7        RColorBrewer_1.1-2 formatR_1.4       
##  [4] plyr_1.8.4         tools_3.3.1        extrafont_0.17    
##  [7] digest_0.6.10      evaluate_0.10      tibble_1.2        
## [10] gtable_0.2.0       DBI_0.5-1          parallel_3.3.1    
## [13] Rttf2pt1_1.3.4     dplyr_0.5.0        stringr_1.1.0     
## [16] knitr_1.14         grid_3.3.1         R6_2.2.0          
## [19] foreign_0.8-67     rmarkdown_1.1      tidyr_0.6.0       
## [22] ggplot2_2.1.0      readr_1.0.0        extrafontdb_1.0   
## [25] scales_0.4.0       htmltools_0.3.5    rsconnect_0.5     
## [28] assertthat_0.1     dichromat_2.0-0    mnormt_1.5-5      
## [31] testit_0.5         mime_0.5           xtable_1.8-2      
## [34] colorspace_1.2-7   httpuv_1.3.3       stringi_1.1.2     
## [37] lazyeval_0.2.0     munsell_0.4.3
```

```r
Sys.time()
```

```
## [1] "2016-11-06 13:31:53 EST"
```

