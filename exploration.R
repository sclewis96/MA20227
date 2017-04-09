# Load in data
load("imdb.rda")

# Check for NAs
sum(is.na(imdb))

load("imdc.rda")

# Load packages for analysis (you might need to install these:
# install.packages("dplyr", "tidyr", "ggplot2", "gridExtra")
library(dplyr)
library(tidyr)
library(ggplot2)
library(gridExtra)

# Remove duplicates
source("dups.R")

# Select relevant columns from imdb; take numeric columns and put into "long"
# data format, ready for plotting
plotdf <- select(imdc, title, score, year, duration, gross, budget, criticreviews,
             uservotes, userreviews, country, rating, color, aspect) %>%
    gather(-c(title, score, country, rating, color, aspect),
           key = "var", value = "value")

# Set up plot
p <- ggplot(plotdf, aes(x = value, y = score)) + geom_point(alpha = 0.1) +
    facet_wrap(~ var, scales = "free") + geom_smooth(method = "lm", col = "red")

# Actually plot it
p

# Plot the non-numeric things
p1 <- qplot(country, score, data = imdb, alpha = I(0.1)) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
p2 <- qplot(rating, score, data = imdb, alpha = I(0.1))
p3 <- qplot(color, score, data = imdb, alpha = I(0.1))
p4 <- qplot(aspect, score, data = imdb, alpha = I(0.1))
grid.arrange(p1, p2, p3, p4, ncol = 2)

# Remove two dodgy points
imdc <- filter(imdc, aspect < 10, budget < 3.5e+08)

# #=== Do we fix values?
# 
# # Strange point in the aspect plot... incorrect value?
# imdc[imdc$aspect == 16, ]
# # Double-check this on IMDb website - turns out it should be 16:9
# imdc$aspect[imdc$aspect == 16] <- 16/9
# p4 <- qplot(aspect, score, data = imdb, alpha = I(0.1))
# p4
# # Another dodgy point on far right of budget-score plot?
# imdc[which.max(imdc$budget), ]
# 
# # This should actually be $85m
# imdc$budget[which.max(imdc$budget)] <- 8.5e+07
# 
# #===


# Have a look at some other potentially interesting relationships
qplot(country, budget, data = imdb, colour = factor(rating)) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
qplot(budget, gross, data = imdb)
qplot(duration, criticreviews, data = imdb)
qplot(year, color, data = imdb)

# Aside: Do films with long titles have better scores?
df2 <- mutate(imdb, words = sapply(gregexpr("[[:alnum:][:punct:]]+", title), function(x) sum(x > 0)))
qplot(factor(words), score, data = df2, geom = "boxplot")



psych::pairs.panels(imdc[c("score", "year", "duration", "gross", "budget", "criticreviews", "uservotes", "userreviews")])
