# This script executes all manipulation scripts and walks you through data provisioniing chain.

# source("./manipulation/0-ellis-island.R")
# Ellis Island
knitr::stitch_rmd(
  script="./manipulation/0-ellis-island.R",
  output="./manipulation/stitched-output/0-ellis-island.md"
)



