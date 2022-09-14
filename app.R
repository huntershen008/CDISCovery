# Launch the ShinyApp (Do not remove this comment)
# To deploy, run: rsconnect::deployApp()
# Or use the blue button on top of this file

# golem default's to these options
# pkgload::load_all(helpers = FALSE, attach_testthat = FALSE) # export_all = FALSE # ac removed: if false, IDEAFilter fails
options( "golem.app.prod" = TRUE)
options(shiny.sanitize.errors = FALSE)
options(shiny.autoload.r=FALSE) # needed if remove R/_disable_autoload.R
# rsconnect::writeManifest() # Needed for continuous deployment

# build app
# install.packages("devtools")
# library(devtools)
# library(roxygen2)
# build()
# install()
# document()
# check()

# install("CDISCovery")
# install.packages("githubinstall")
# library(githubinstall)



# Launch the app
library(CDISCovery)
run_app() # add parameters here (if any)

# turn off any options
# options(shiny.autoload.r=NULL) # needed if remove R/_disable_autoload.R

