#!/bin/bash

DEBIAN_FRONTEND=noninteractive sudo apt-get -qq install -y r-base

Rscript -e "install.packages('deSolve', repos='http://cran.us.r-project.org')"
Rscript -e "install.packages('ggplot2',  repos='http://cran.us.r-project.org')"
