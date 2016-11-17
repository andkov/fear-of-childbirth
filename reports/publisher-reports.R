rm(list=ls(all=TRUE))
########## Production of reports from .Rmd files ###

path_01   <- base::file.path("./reports/01-review-variables/review-variables.Rmd")

#  Define groups of reports
allReports<- c(
  path_01
)
# Place report paths HERE ###########
pathFilesToBuild <- c(allReports) ##########


testit::assert("The knitr Rmd files should exist.", base::file.exists(pathFilesToBuild))
# Build the reports
for( pathFile in pathFilesToBuild ) {
  #   pathMd <- base::gsub(pattern=".Rmd$", replacement=".md", x=pathRmd)
  rmarkdown::render(input = pathFile,
                    output_format=c(
                      "html_document" # set print_format <- "html" in source R script
                       #, "pdf_document"
                      # ,"md_document"
                      # "word_document" # set print_format <- "pandoc" in source R script
                    ),
                    clean=TRUE)
}

