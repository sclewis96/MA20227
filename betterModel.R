library(dplyr)
library(tidyr)
library(ggplot2)
library(grid)
library(gridExtra)

createStandardDb <- function(){
  #linearise and group the data (from modelselection.R)
  
  imdb.st <- imdc
  imdb.st$standardaspect <- imdb.st$aspect %in% c(1.85, 2.35)
  
  library(countrycode)
  imdb.st$continent <- factor(countrycode(imdb.st$country, "country.name", "continent"))
  
  imdb.st$kidfriendly <- imdb.st$rating %in% c("G", "GP", "PG", "PG-13")
  
  imdb.st <- select(imdb.st, title, score, year, duration, gross, budget,
                    criticreviews, uservotes, userreviews,
                    standardaspect, kidfriendly, continent, color) %>%
    transmute(title, sqscore = I(score^2), year, durationsr = sqrt(duration),
              grosssr = sqrt(gross), budget, criticreviewssr = sqrt(criticreviews),
              uservotessr = sqrt(uservotes), userreviewssr = sqrt(userreviews),
              standardaspect, kidfriendly, continent, color)
  #TODO optimize the power of the score
  
  return(imdb.st)
}

imdb.st = createStandardDb() #is the standard db

fullmod <- lm(sqscore ~ . - title, imdb.st)
summary(fullmod)


# we can use the interactions between predictors to improve the model:

bettermod <- lm(sqscore ~ uservotessr:grosssr + # the more gross => the more exposure => higher ranking films will get a higher proportion of votes
                uservotessr * userreviewssr + criticreviewssr : userreviewssr # the relation is obvious
                + budget * grosssr # the relation here is if a film has high gross and low budget => its good and vice versa
                + year + color + durationsr * standardaspect + continent, imdb.st)
summary(bettermod)

plot(bettermod)
























