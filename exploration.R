# Load in data
load("imdb.rda")

# Check for NAs
sum(is.na(imdb))

# Load packages for analysis (you might need to install these:
# install.packages("dplyr", "tidyr", "ggplot2", "gridExtra")
library(dplyr)
library(tidyr)
library(ggplot2)
library(gridExtra)

# Select relevant columns from imdb; take numeric columns and put into "long"
# data format, ready for plotting
plotdf <- select(imdb, title, score, year, duration, gross, budget, criticreviews,
             uservotes, userreviews, country, rating, color, aspect) %>%
    gather(-c(title, score, country, rating, color, aspect),
           key = "var", value = "value")

# Set up plot
p <- ggplot(plotdf, aes(x = value, y = score)) + geom_point(alpha = 0.07) +
    #geom_density_2d() + ## This puts on contour lines but I think it's clearer without
    facet_wrap(~ var, scales = "free") + geom_smooth(method = "lm", col = "red")

# Actually plot it
p

# Plot the non-numeric things
p1 <- qplot(country, score, data = imdb, alpha = I(0.07)) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
p2 <- qplot(rating, score, data = imdb, alpha = I(0.07))
p3 <- qplot(color, score, data = imdb, alpha = I(0.07))
p4 <- qplot(aspect, score, data = imdb, alpha = I(0.07))
grid.arrange(p1, p2, p3, p4, ncol = 2)

# Strange point in the aspect plot... incorrect value?
imdb[imdb$aspect == 16, ]
# Double-check this on IMDB website - turns out it should be 16:9
imdb$aspect[3539] <- 16/9
p4 <- qplot(aspect, score, data = imdb, alpha = I(0.07))
grid.arrange(p1, p2, p3, p4, ncol = 2)


# Have a look at some other potentially interesting relationships
qplot(country, budget, data = imdb, colour = factor(rating)) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))
qplot(budget, gross, data = imdb)
qplot(duration, criticreviews, data = imdb)
qplot(year, color, data = imdb)

# Aside: Do films with long titles have better scores?
df2 <- mutate(imdb, words = sapply(gregexpr("[[:alnum:][:punct:]]+", title), function(x) sum(x > 0)))
qplot(factor(words), score, data = df2, geom = "boxplot")
