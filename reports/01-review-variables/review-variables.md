# Review Variables

<!-- These two chunks should be added in the beginning of every .Rmd that you want to source an .R script -->
<!--  The 1st mandatory chunck  -->
<!--  Set the working directory to the repository's base directory -->


<!--  The 2nd mandatory chunck  -->
<!-- Set the report-wide options, and point to the external code file. -->


# Exposition
This section established the working environment and introduces the data.

## Environment
<!-- Load 'sourced' R files.  Suppress the output when loading packages. --> 

```r
# Attach these packages so their functions don't need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
library(magrittr) # enables piping : %>% 
# Verify these packages are available on the machine, but their functions need to be qualified: http://r-pkgs.had.co.nz/namespace.html#search-path
requireNamespace("ggplot2") # graphing
requireNamespace("readr")   # data input
requireNamespace("tidyr")   # data manipulation
requireNamespace("dplyr")   # Avoid attaching dplyr, b/c its function names conflict with a lot of packages (esp base, stats, and plyr).
requireNamespace("testit")  # For asserting conditions meet expected patterns.
# requireNamespace("car")     # For it's `recode()` function.
```

<!-- Load the sources.  Suppress the output when loading sources. --> 

```r
# Call `base::source()` on any repo file that defines functions needed below.  Ideally, no real operations are performed.
source("./scripts/common-functions.R") # used in multiple reports
source("./scripts/graph-presets.R") # fonts, colors, themes 
```

<!-- Load any Global functions and variables declared in the R file.  Suppress the output. --> 


<!-- Declare any global functions specific to a Rmd output.Suppress the output. --> 

```r
#Put code in here.  It doesn't call a chunk in the codebehind file.
```
## Data


<!-- Load the datasets.   -->

```r
# the production of the dto object is now complete
# we verify its structure and content:
dto <- readRDS("./data/unshared/derived/dto.rds")
names(dto)
```

```
[1] "unitData" "metaData" "analytic"
```

```r
# 1st element - unit(person) level data
names(dto[["unitData"]])
```

```
  [1] "RespondentID"                   "DOB"                            "Over_18"                       
  [4] "Pregnant"                       "Gender"                         "Marital_status"                
  [7] "Education"                      "Education_other"                "EDUCA0"                        
 [10] "EDUCA1"                         "EDUCA2"                         "EDUCA3"                        
 [13] "EDUCA4"                         "EDUCA5"                         "EDUCA6"                        
 [16] "EDUCA7"                         "EDUCA8"                         "EDUCA9"                        
 [19] "EDUCAA"                         "EDUCAB"                         "EDUCAC"                        
 [22] "EDUCAD"                         "EDUCAE"                         "EDUCAF"                        
 [25] "EDUCAG"                         "EDUCAH"                         "EDUCAI"                        
 [28] "EDUCAJ"                         "EDUCAK"                         "EDUCAL"                        
 [31] "EDUCAM"                         "EDUCAN"                         "EDUCAO"                        
 [34] "EDUCAP"                         "EDUCAQ"                         "EDUCAR"                        
 [37] "EDUCAS"                         "EDUCAT"                         "EDUCAU"                        
 [40] "EDUCAV"                         "EDUCAW"                         "EDUCAX"                        
 [43] "EDUCAY"                         "EDUCAZ"                         "EDUCA10"                       
 [46] "EDUCA11"                        "EDUCA12"                        "EDUCA13"                       
 [49] "EDUCA14"                        "EDUCA15"                        "EDUCA16"                       
 [52] "EDUCA17"                        "EDUCA18"                        "EDUCA19"                       
 [55] "EDUCA1A"                        "Miscarriage"                    "Stillbirth"                    
 [58] "Terminated"                     "Current_complications"          "Country_Code"                  
 [61] "Parity"                         "Current_conception"             "Episiotomy"                    
 [64] "Current_babies"                 "Income"                         "Weeks_pregnant"                
 [67] "Care_Provider"                  "Very_satisfied"                 "Birthplace"                    
 [70] "INTERVENTIONSTOTM"              "HARMTOTM"                       "PAINTOTM"                      
 [73] "SHYTOTM"                        "SEXTOTM"                        "CSTOTM"                        
 [76] "FOCTOTM"                        "INTERFERENCE"                   "Know_trauma_vaginal"           
 [79] "Know_trauma_cesarean"           "Know_positive_vaginal"          "Know_positive_cesarean"        
 [82] "Births_vaginal_traumatic"       "Pregnancies"                    "StartDate"                     
 [85] "Due_date"                       "EndDate"                        "Student_FT"                    
 [88] "Student_PT"                     "Employed_FT"                    "Employed_PT"                   
 [91] "Homemaker_FT"                   "Homemaker_PT"                   "Unemployed_FT"                 
 [94] "Unemloyed_PT"                   "SeekingWork_FT"                 "SeekingWork_PT"                
 [97] "Retired_FT"                     "Retired_PT"                     "Disabled_FT"                   
[100] "Disabled_PT"                    "City"                           "CITY0"                         
[103] "CITY1"                          "CITY2"                          "CITY3"                         
[106] "CITY4"                          "CITY5"                          "CITY6"                         
[109] "CITY7"                          "CITY8"                          "CITY9"                         
[112] "CITYA"                          "CITYB"                          "CITYC"                         
[115] "CITYD"                          "CITYE"                          "CITYF"                         
[118] "CITYG"                          "CITYH"                          "CITYI"                         
[121] "CITYJ"                          "CITYK"                          "CITYL"                         
[124] "CITYM"                          "CITYN"                          "CITYO"                         
[127] "CITYP"                          "CITYQ"                          "CITYR"                         
[130] "CITYS"                          "CITYT"                          "CITYU"                         
[133] "CITYV"                          "CITYW"                          "CITYX"                         
[136] "CITYY"                          "CITYZ"                          "CITY10"                        
[139] "CITY11"                         "CITY12"                         "CITY13"                        
[142] "CITY14"                         "CITY15"                         "CITY16"                        
[145] "CITY17"                         "CITY18"                         "CITY19"                        
[148] "CITY1A"                         "Province"                       "PROVI0"                        
[151] "PROVI1"                         "PROVI2"                         "PROVI3"                        
[154] "PROVI4"                         "PROVI5"                         "PROVI6"                        
[157] "PROVI7"                         "PROVI8"                         "PROVI9"                        
[160] "PROVIA"                         "PROVIB"                         "PROVIC"                        
[163] "PROVID"                         "PROVIE"                         "PROVIF"                        
[166] "PROVIG"                         "PROVIH"                         "PROVII"                        
[169] "PROVIJ"                         "PROVIK"                         "PROVIL"                        
[172] "PROVIM"                         "PROVIN"                         "PROVIO"                        
[175] "PROVIP"                         "PROVIQ"                         "PROVIR"                        
[178] "PROVIS"                         "PROVIT"                         "PROVIU"                        
[181] "PROVIV"                         "PROVIW"                         "PROVIX"                        
[184] "PROVIY"                         "PROVIZ"                         "PROVI10"                       
[187] "PROVI11"                        "PROVI12"                        "PROVI13"                       
[190] "PROVI14"                        "PROVI15"                        "PROVI16"                       
[193] "PROVI17"                        "PROVI18"                        "PROVI19"                       
[196] "PROVI1A"                        "Country"                        "COUNT0"                        
[199] "COUNT1"                         "COUNT2"                         "COUNT3"                        
[202] "COUNT4"                         "COUNT5"                         "COUNT6"                        
[205] "COUNT7"                         "COUNT8"                         "COUNT9"                        
[208] "COUNTA"                         "COUNTB"                         "COUNTC"                        
[211] "COUNTD"                         "COUNTE"                         "COUNTF"                        
[214] "COUNTG"                         "COUNTH"                         "COUNTI"                        
[217] "COUNTJ"                         "COUNTK"                         "COUNTL"                        
[220] "COUNTM"                         "COUNTN"                         "COUNTO"                        
[223] "COUNTP"                         "COUNTQ"                         "COUNTR"                        
[226] "COUNTS"                         "COUNTT"                         "COUNTU"                        
[229] "COUNTV"                         "COUNTW"                         "COUNTX"                        
[232] "COUNTY"                         "COUNTZ"                         "COUNT10"                       
[235] "COUNT11"                        "COUNT12"                        "COUNT13"                       
[238] "COUNT14"                        "COUNT15"                        "COUNT16"                       
[241] "COUNT17"                        "COUNT18"                        "COUNT19"                       
[244] "COUNT1A"                        "Ethnicity"                      "Ethnicity_Other"               
[247] "ETHNI0"                         "ETHNI1"                         "ETHNI2"                        
[250] "ETHNI3"                         "ETHNI4"                         "ETHNI5"                        
[253] "ETHNI6"                         "ETHNI7"                         "ETHNI8"                        
[256] "ETHNI9"                         "ETHNIA"                         "ETHNIB"                        
[259] "ETHNIC"                         "ETHNID"                         "ETHNIE"                        
[262] "ETHNIF"                         "ETHNIG"                         "ETHNIH"                        
[265] "ETHNII"                         "ETHNIJ"                         "ETHNIK"                        
[268] "ETHNIL"                         "ETHNIM"                         "ETHNIN"                        
[271] "ETHNIO"                         "ETHNIP"                         "ETHNIQ"                        
[274] "ETHNIR"                         "ETHNIS"                         "ETHNIT"                        
[277] "ETHNIU"                         "ETHNIV"                         "ETHNIW"                        
[280] "ETHNIX"                         "ETHNIY"                         "ETHNIZ"                        
[283] "ETHNI10"                        "ETHNI11"                        "ETHNI12"                       
[286] "ETHNI13"                        "ETHNI14"                        "ETHNI15"                       
[289] "ETHNI16"                        "ETHNI17"                        "ETHNI18"                       
[292] "ETHNI19"                        "ETHNI1A"                        "Language"                      
[295] "LANGU0"                         "LANGU1"                         "LANGU2"                        
[298] "LANGU3"                         "LANGU4"                         "LANGU5"                        
[301] "LANGU6"                         "LANGU7"                         "LANGU8"                        
[304] "LANGU9"                         "LANGUA"                         "LANGUB"                        
[307] "LANGUC"                         "LANGUD"                         "LANGUE"                        
[310] "LANGUF"                         "LANGUG"                         "LANGUH"                        
[313] "LANGUI"                         "LANGUJ"                         "LANGUK"                        
[316] "LANGUL"                         "LANGUM"                         "LANGUN"                        
[319] "LANGUO"                         "LANGUP"                         "LANGUQ"                        
[322] "LANGUR"                         "LANGUS"                         "LANGUT"                        
[325] "LANGUU"                         "LANGUV"                         "LANGUW"                        
[328] "LANGUX"                         "LANGUY"                         "LANGUZ"                        
[331] "LANGU10"                        "LANGU11"                        "LANGU12"                       
[334] "LANGU13"                        "LANGU14"                        "LANGU15"                       
[337] "LANGU16"                        "LANGU17"                        "LANGU18"                       
[340] "LANGU19"                        "LANGU1A"                        "Language_Coded"                
[343] "Has_kids"                       "Births"                         "Births_vaginal"                
[346] "Births_cesarean"                "Births_cesarean_emerg"          "Births_cesarean_traumatic"     
[349] "Assisted_vaginal"               "Current_complications_describe" "CURRE1B"                       
[352] "CURRE1C"                        "CURRE1D"                        "CURRE1E"                       
[355] "CURRE1F"                        "CURRE1G"                        "CURRE1H"                       
[358] "CURRE1I"                        "CURRE1J"                        "CURRE1K"                       
[361] "CURRE1L"                        "CURRE1M"                        "CURRE1N"                       
[364] "CURRE1O"                        "CURRE1P"                        "CURRE1Q"                       
[367] "CURRE1R"                        "CURRE1S"                        "CURRE1T"                       
[370] "CURRE1U"                        "CURRE1V"                        "CURRE1W"                       
[373] "CURRE1X"                        "CURRE1Y"                        "CURRE1Z"                       
[376] "CURRE20"                        "CURRE21"                        "CURRE22"                       
[379] "CURRE23"                        "CURRE24"                        "CURRE25"                       
[382] "CURRE26"                        "CURRE27"                        "CURRE28"                       
[385] "CURRE29"                        "CURRE2A"                        "CURRE2B"                       
[388] "CURRE2C"                        "CURRE2D"                        "CURRE2E"                       
[391] "CURRE2F"                        "CURRE2G"                        "CURRE2H"                       
[394] "CURRE2I"                        "CURRE2J"                        "CURRE2K"                       
[397] "CURRE2L"                        "Current_conception_other"       "CURRE0"                        
[400] "CURRE1"                         "CURRE2"                         "CURRE3"                        
[403] "CURRE4"                         "CURRE5"                         "CURRE6"                        
[406] "CURRE7"                         "CURRE8"                         "CURRE9"                        
[409] "CURREA"                         "CURREB"                         "CURREC"                        
[412] "CURRED"                         "CURREE"                         "CURREF"                        
[415] "CURREG"                         "CURREH"                         "CURREI"                        
[418] "CURREJ"                         "CURREK"                         "CURREL"                        
[421] "CURREM"                         "CURREN"                         "CURREO"                        
[424] "CURREP"                         "CURREQ"                         "CURRER"                        
[427] "CURRES"                         "CURRET"                         "CURREU"                        
[430] "CURREV"                         "CURREW"                         "CURREX"                        
[433] "CURREY"                         "CURREZ"                         "CURRE10"                       
[436] "CURRE11"                        "CURRE12"                        "CURRE13"                       
[439] "CURRE14"                        "CURRE15"                        "CURRE16"                       
[442] "CURRE17"                        "CURRE18"                        "CURRE19"                       
[445] "CURRE1A"                        "Painful_event"                  "Painful_event_describe"        
[448] "PAINF0"                         "PAINF1"                         "PAINF2"                        
[451] "PAINF3"                         "PAINF4"                         "PAINF5"                        
[454] "PAINF6"                         "PAINF7"                         "PAINF8"                        
[457] "PAINF9"                         "PAINFA"                         "PAINFB"                        
[460] "PAINFC"                         "PAINFD"                         "PAINFE"                        
[463] "PAINFF"                         "PAINFG"                         "PAINFH"                        
[466] "PAINFI"                         "PAINFJ"                         "PAINFK"                        
[469] "PAINFL"                         "PAINFM"                         "PAINFN"                        
[472] "PAINFO"                         "PAINFP"                         "PAINFQ"                        
[475] "PAINFR"                         "PAINFS"                         "PAINFT"                        
[478] "PAINFU"                         "PAINFV"                         "PAINFW"                        
[481] "PAINFX"                         "PAINFY"                         "PAINFZ"                        
[484] "PAINF10"                        "PAINF11"                        "PAINF12"                       
[487] "PAINF13"                        "PAINF14"                        "PAINF15"                       
[490] "PAINF16"                        "PAINF17"                        "PAINF18"                       
[493] "PAINF19"                        "PAINF1A"                        "Care_Provider_Other"           
[496] "CARE_0"                         "CARE_1"                         "CARE_2"                        
[499] "CARE_3"                         "CARE_4"                         "CARE_5"                        
[502] "CARE_6"                         "CARE_7"                         "CARE_8"                        
[505] "CARE_9"                         "CARE_A"                         "CARE_B"                        
[508] "CARE_C"                         "CARE_D"                         "CARE_E"                        
[511] "CARE_F"                         "CARE_G"                         "CARE_H"                        
[514] "CARE_I"                         "CARE_J"                         "CARE_K"                        
[517] "CARE_L"                         "CARE_M"                         "CARE_N"                        
[520] "CARE_O"                         "CARE_P"                         "CARE_Q"                        
[523] "CARE_R"                         "CARE_S"                         "CARE_T"                        
[526] "CARE_U"                         "CARE_V"                         "CARE_W"                        
[529] "CARE_X"                         "CARE_Y"                         "CARE_Z"                        
[532] "CARE_10"                        "CARE_11"                        "CARE_12"                       
[535] "CARE_13"                        "CARE_14"                        "CARE_15"                       
[538] "CARE_16"                        "CARE_17"                        "CARE_18"                       
[541] "CARE_19"                        "CARE_1A"                        "Care_Provider_Present"         
[544] "Care_Provider_Satisfaction"     "Present_Partner"                "Present_Physician"             
[547] "Present_OB"                     "Present_Mother"                 "Present_Father"                
[550] "Present_Midwife"                "Present_Doula"                  "Present_Partner_Parents"       
[553] "Present_Sibling"                "Present_Children"               "Present_Friends"               
[556] "Present_Other"                  "Present_Other_specify"          "PRESE0"                        
[559] "PRESE1"                         "PRESE2"                         "PRESE3"                        
[562] "PRESE4"                         "PRESE5"                         "PRESE6"                        
[565] "PRESE7"                         "PRESE8"                         "PRESE9"                        
[568] "PRESEA"                         "PRESEB"                         "PRESEC"                        
[571] "PRESED"                         "PRESEE"                         "PRESEF"                        
[574] "PRESEG"                         "PRESEH"                         "PRESEI"                        
[577] "PRESEJ"                         "PRESEK"                         "PRESEL"                        
[580] "PRESEM"                         "PRESEN"                         "PRESEO"                        
[583] "PRESEP"                         "PRESEQ"                         "PRESER"                        
[586] "PRESES"                         "PRESET"                         "PRESEU"                        
[589] "PRESEV"                         "PRESEW"                         "PRESEX"                        
[592] "PRESEY"                         "PRESEZ"                         "PRESE10"                       
[595] "PRESE11"                        "PRESE12"                        "PRESE13"                       
[598] "PRESE14"                        "PRESE15"                        "PRESE16"                       
[601] "PRESE17"                        "PRESE18"                        "PRESE19"                       
[604] "PRESE1A"                        "Birthplace_other"               "BIRTH0"                        
[607] "BIRTH1"                         "BIRTH2"                         "BIRTH3"                        
[610] "BIRTH4"                         "BIRTH5"                         "BIRTH6"                        
[613] "BIRTH7"                         "BIRTH8"                         "BIRTH9"                        
[616] "BIRTHA"                         "BIRTHB"                         "BIRTHC"                        
[619] "BIRTHD"                         "BIRTHE"                         "BIRTHF"                        
[622] "BIRTHG"                         "BIRTHH"                         "BIRTHI"                        
[625] "BIRTHJ"                         "BIRTHK"                         "BIRTHL"                        
[628] "BIRTHM"                         "BIRTHN"                         "BIRTHO"                        
[631] "BIRTHP"                         "BIRTHQ"                         "BIRTHR"                        
[634] "BIRTHT"                         "BIRTHU"                         "BIRTHV"                        
[637] "BIRTHW"                         "BIRTHX"                         "BIRTHY"                        
[640] "BIRTHZ"                         "BIRTH10"                        "BIRTH11"                       
[643] "BIRTH12"                        "BIRTH13"                        "BIRTH14"                       
[646] "BIRTH15"                        "BIRTH16"                        "BIRTH17"                       
[649] "BIRTH18"                        "BIRTH19"                        "BIRTH1A"                       
[652] "BIRTH1B"                        "Birth_preference"               "Birth_preference_dichotomized" 
[655] "FOC1"                           "FOC2"                           "FOC3"                          
[658] "FOC4"                           "FOC5"                           "FOC6"                          
[661] "FOC7"                           "FOC8"                           "FOC9"                          
[664] "FOC10"                          "FOC11"                          "FOC12"                         
[667] "FOC13"                          "FOC14"                          "FOC15"                         
[670] "FOC16"                          "FOC17"                          "FOC18"                         
[673] "FOC19"                          "FOC20"                          "FOC21"                         
[676] "FOC22"                          "FOC23"                          "FOC24"                         
[679] "FOC25"                          "FOC26"                          "FOC27"                         
[682] "FOC28"                          "FOC29"                          "FOC30"                         
[685] "FOC31"                          "FOC32"                          "FOC33"                         
[688] "FOC34"                          "FOC35"                          "FOC36"                         
[691] "FOC37"                          "FOC38"                          "FOC39"                         
[694] "FOC40"                          "FOC41"                          "FOC42"                         
[697] "FOC43"                          "FOC44"                          "FOC45"                         
[700] "FOC46"                          "FOC47"                          "FOC48"                         
[703] "FOC49"                          "FOC_OTHER"                      "FOC_O0"                        
[706] "FOC_O1"                         "FOC_O2"                         "FOC_O3"                        
[709] "FOC_O4"                         "FOC_O5"                         "FOC_O6"                        
[712] "FOC_O7"                         "FOC_O8"                         "FOC_O9"                        
[715] "FOC_OA"                         "FOC_OB"                         "FOC_OC"                        
[718] "FOC_OD"                         "FOC_OE"                         "FOC_OF"                        
[721] "FOC_OG"                         "FOC_OH"                         "FOC_OI"                        
[724] "FOC_OJ"                         "FOC_OK"                         "FOC_OL"                        
[727] "FOC_OM"                         "FOC_ON"                         "FOC_OO"                        
[730] "FOC_OP"                         "FOC_OQ"                         "FOC_OR"                        
[733] "FOC_OS"                         "FOC_OT"                         "FOC_OU"                        
[736] "FOC_OV"                         "FOC_OW"                         "FOC_OX"                        
[739] "FOC_OY"                         "FOC_OZ"                         "FOC_O10"                       
[742] "FOC_O11"                        "FOC_O12"                        "FOC_O13"                       
[745] "FOC_O14"                        "FOC_O15"                        "FOC_O16"                       
[748] "FOC_O17"                        "FOC_O18"                        "FOC_O19"                       
[751] "FOC_O1A"                        "FOCI1"                          "FOCI2"                         
[754] "FOCI3"                          "FOCI4"                          "FOCI5"                         
[757] "FOCI6"                          "FOCI7"                          "FOCI_OTHER"                    
[760] "FOCI_0"                         "FOCI_1"                         "FOCI_2"                        
[763] "FOCI_3"                         "FOCI_4"                         "FOCI_5"                        
[766] "FOCI_6"                         "FOCI_7"                         "FOCI_8"                        
[769] "FOCI_9"                         "FOCI_A"                         "FOCI_B"                        
[772] "FOCI_C"                         "FOCI_D"                         "FOCI_E"                        
[775] "FOCI_F"                         "FOCI_G"                         "FOCI_H"                        
[778] "FOCI_I"                         "FOCI_J"                         "FOCI_K"                        
[781] "FOCI_L"                         "FOCI_M"                         "FOCI_N"                        
[784] "FOCI_O"                         "FOCI_P"                         "FOCI_Q"                        
[787] "FOCI_R"                         "FOCI_S"                         "FOCI_T"                        
[790] "FOCI_U"                         "FOCI_V"                         "FOCI_W"                        
[793] "FOCI_X"                         "FOCI_Y"                         "FOCI_Z"                        
[796] "FOCI_10"                        "FOCI_11"                        "FOCI_12"                       
[799] "FOCI_13"                        "FOCI_14"                        "FOCI_15"                       
[802] "FOCI_16"                        "FOCI_17"                        "FOCI_18"                       
[805] "FOCI_19"                        "FOCI_1A"                        "WDEQ1_LABOUR_FANTASTIC"        
[808] "WDEQ1_R"                        "WDEQ2_LABOUR_FRIGHTFUL"         "WDEQ3_LABOUR_LONELY"           
[811] "WDEQ4_LABOUR_STRONG"            "WDEQ4_R"                        "WDEQ5_LABOUR_CONFIDENT"        
[814] "WEDQ5_R"                        "WDEQ6_LABOUR_AFRAID"            "WDEQ7_LABOUR_DESERTED"         
[817] "WDEQ8_LABOUR_WEAK"              "WDEQ9_LABOUR_SAFE"              "WDEQ9_R"                       
[820] "WDEQ10_LABOUR_INDEPENDENT"      "WDEQ10_R"                       "WDEQ11_LABOUR_DESOLATE"        
[823] "WDEQ12_LABOUR_TENSE"            "WDEQ13_LABOUR_GLAD"             "WDEQ13_R"                      
[826] "WDEQ14_LABOUR_PROUD"            "WDEQ14_R"                       "WDEQ15_LABOUR_ABANDONED"       
[829] "WDEQ16_LABOUR_COMPOSED"         "WDEQ16_R"                       "WDEQ17_LABOUR_RELAXED"         
[832] "WDEQ17_R"                       "WDEQ18_LABOUR_HAPPY"            "WDEQ18_R"                      
[835] "WDEQ19_LABOUR_PANIC"            "WDEQ20_LABOUR_HOPELESSNESS"     "WDEQ21_LABOUR_LONGING"         
[838] "WDEQ21_R"                       "WDEQ22_LABOUR_CONFIDENCE"       "WDEQ22_R"                      
[841] "WDEQ23_LABOUR_TRUST"            "WDEQ23_R"                       "WDEQ24_LABOUR_PAIN"            
[844] "WDEQ25_LABOUR_BEHAVBADLY"       "WDEQ26_LABOUR_SURRENDER"        "WDEQ26_R"                      
[847] "WDEQ27_LABOUR_LOSECONTROL"      "WDEQ28_DELIVERY_ENJOYABLE"      "WDEQ28_R"                      
[850] "WDEQ29_DELIVERY_NATURAL"        "WDEQ29_R"                       "WDEQ30_DELIVERY_COURSE"        
[853] "WDEQ30_R"                       "WDEQ31_DELIVERY_DANGEROUS"      "WDEQ32_FANTASY_DEATH"          
[856] "WDEQ33_FANTASY_INJURY"          "EPDS1_LAUGH"                    "EPDS2_ENJOYMENT"               
[859] "EPDS3_BLAME"                    "EPDS4_ANXIOUS"                  "EPDS5_SCARED"                  
[862] "EPDS6_COPING"                   "EPDS7_SLEEPING"                 "EPDS8_MISERABLE"               
[865] "EPDS9_CRYING"                   "EPDS10_SELFHARM"                "MQ1"                           
[868] "MQ2"                            "MQ3"                            "MQ4"                           
[871] "MQ5"                            "MQ6"                            "MQ7"                           
[874] "MQ8"                            "MQ9"                            "MQ10"                          
[877] "MQ11"                           "MQ12"                           "MQ13"                          
[880] "MQ14"                           "MQ15"                           "MQ16"                          
[883] "MQ17"                           "MQ18"                           "MQ19"                          
[886] "MQ20"                           "MQ21"                           "MQ22"                          
[889] "MQ23"                           "MQ24"                           "MQ25"                          
[892] "MQ26"                           "MQ27"                           "MQ28"                          
[895] "MQ29"                           "MQ30"                           "INCLUDE_RESPONSES"             
[898] "filter_."                       "EPDS3_R"                        "EPDS5_R"                       
[901] "EPDS6_R"                        "EPDS7_R"                        "EPDS8_R"                       
[904] "EPDS9_R"                        "EPDS10_R"                       "EPDSTOTM"                      
[907] "MQ5R"                           "MQ9R"                           "MQ14R"                         
[910] "MQ18R"                          "MQ21R"                          "MQ28R"                         
[913] "MQTOTM"                         "WDEQA_TOTM"                     "WDEQA_TOT"                     
[916] "WDEQA_SCALED_0_TO_5"            "Singletons_yes"                 "Income_recoded"                
[919] "Country_recode"                 "Episiotomy_yes"                 "Painful_event_yes"             
[922] "Emergency_CS"                   "Traumatic_CS"                   "Assisted_vag"                  
[925] "Test"                           "Traumatic_vaginal"              "Previous_CS"                   
[928] "Previous_vag_delivery"          "Maternal_age"                   "Age_35_or_older"               
[931] "Age_40_or_older"                "Age_three_categories"           "Education_recode"              
[934] "Stillbirth_yes"                 "Termination_yes"                "Miscarriage_yes"               
```

```r
# 2nd element - meta data, info about variables
names(dto[["metaData"]])
```

```
[1] "name"        "label"       "select"      "name_new"    "label_graph" "label_short" "domain"     
```

```r
# 3rd element - small, groomed data to be used for analysis
names(dto[["analytic"]])
```

```
 [1] "id"             "pregnant"       "marital"        "education"      "weeks_pregnant" "haskids"       
 [7] "foc_01"         "foc_02"         "foc_03"         "foc_04"         "foc_05"         "foc_06"        
[13] "foc_07"         "foc_08"         "foc_09"         "foc_10"         "foc_11"         "foc_12"        
[19] "foc_13"         "foc_14"         "foc_15"         "foc_16"         "foc_17"         "foc_18"        
[25] "foc_19"         "foc_20"         "foc_21"         "foc_22"         "foc_23"         "foc_24"        
[31] "foc_25"         "foc_26"         "foc_27"         "foc_28"         "foc_29"         "foc_30"        
[37] "foc_31"         "foc_32"         "foc_33"         "foc_34"         "foc_35"         "foc_36"        
[43] "foc_37"         "foc_38"         "foc_39"         "foc_40"         "foc_41"         "foc_42"        
[49] "foc_43"         "foc_44"         "foc_45"         "foc_46"         "foc_47"         "foc_48"        
[55] "foc_49"         "itf_1"          "itf_2"          "itf_3"          "itf_4"          "itf_5"         
[61] "itf_6"          "itf_7"         
```

<!-- Inspect the datasets.   -->


<!-- Tweak the datasets.   -->


<!-- Basic table view.   -->


<!-- Basic graph view.   -->





