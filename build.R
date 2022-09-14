# build app
library(devtools)
library(roxygen2)

# build()
install()

document()
check()

# install from github
library(devtools)
install_github("huntershen008/CDISCovery", force = T)
