rm(list=ls(all=TRUE))
########## Production of reports from .Rmd files ###

path_eas   <- base::file.path("./reports/seeds-pulmonary/seed-eas.Rmd")
path_elsa  <- base::file.path("./reports/seeds-pulmonary/seed-elsa.Rmd")
path_hrs   <- base::file.path("./reports/seeds-pulmonary/seed-hrs.Rmd")
path_ilse  <- base::file.path("./reports/seeds-pulmonary/seed-ilse.Rmd")
path_lasa  <- base::file.path("./reports/seeds-pulmonary/seed-lasa.Rmd")
path_map   <- base::file.path("./reports/seeds-pulmonary/seed-map.Rmd")
path_nas   <- base::file.path("./reports/seeds-pulmonary/seed-nas.Rmd")
path_nuage <- base::file.path("./reports/seeds-pulmonary/seed-nuage.Rmd")
path_octo  <- base::file.path("./reports/seeds-pulmonary/seed-octo.Rmd")
path_satsa <- base::file.path("./reports/seeds-pulmonary/seed-satsa.Rmd")

#  Define groups of reports
allReports<- c(
  #  path_eas
  # , path_elsa
  # ,path_hrs
  # # path_ilse # does not have pulmonary measure
  # ,path_lasa
  # ,path_map
  path_nas
  # path_nuage # does not have pulmonary measure
  # ,path_octo
  # ,path_satsa
)
# Place report paths HERE ###########
pathFilesToBuild <- c(allReports) ##########


testit::assert("The knitr Rmd files should exist.", base::file.exists(pathFilesToBuild))
# Build the reports
for( pathFile in pathFilesToBuild ) {
  #   pathMd <- base::gsub(pattern=".Rmd$", replacement=".md", x=pathRmd)
  rmarkdown::render(input = pathFile,
                    output_format=c(
                      # "html_document" # set print_format <- "html" in seed-study.R
                       #, "pdf_document"
                      # ,"md_document"
                      "word_document" # set print_format <- "pandoc" in seed-study.R
                    ),
                    clean=TRUE)
}

# To generate the static website from the htmls that have been printed in the code above
# 1) Select the "gh-pages" branch of your project's repository in GitHub client
# 2) Open command line terminal and change directory to the root folder of your repository that you've cloned onto your hard drive using GitHub client (type "cmd" in the address line of the File Explorer opened on root folder of your repository's clone)
# 3) type "bundle install" to install Bundler if you're creating the website for the first time
# 4) type "bundle exec jekyll serve" to build site and serve to localhost:4000
