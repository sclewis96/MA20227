# Load required libraries
library(dplyr)
library(tidyr)
library(ggplot2)
library(gridExtra)

load("imdb.rda")
# Remove duplicates from imdb: resulting data frame is called imdc
source("dups.R")

# Have a look at the data: see exploration.R

# Fix outliers which become obvious from plots
imdc$aspect[imdc$aspect == 16] <- 1.78
imdc$budget[imdc$budget > 3.5e+08] <- 8.5e+07

# Try to linearise data: see linearisation.R

# Justify the decisions we made to transform our data: see modelselection.R