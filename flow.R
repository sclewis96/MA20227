# Load required library=ies
library(dplyr)
library(tidyr)
library(ggplot2)
library(gridExtra)

# Remove duplicates from imdb: resulting data frame is called imdc
source("dups.R")

# Have a look at the data: see exploration.R

# Remove outliers which become obvious from plots
imdc <- filter(imdc, aspect < 10, budget < 3.5e+08)

# Try to linearise data: see linearisation.R

# Justify the decisions we made to transform our data: see modelselection.R
