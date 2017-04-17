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

varRefactor <- function(dataFrame, trainingORtesting)
{
  #year bins
  dataFrame$year_BIN <- cut(dataFrame$year, breaks = c(1850, 1960, 1970, 1980, 1990, 2000, 2010, 2020))
  dataFrame$year <- NULL
  
  invisible(dataFrame)# => is not to be printed
}


imdb.st = createStandardDb() #is the standard db
imdb.st = varRefactor(imdb.st) #bins the years

iTesting <- sample(nrow(imdb.st),floor(nrow(imdb.st) * 0.1),replace = FALSE) #90-10 training-testing split
# actually do the split
testDb  <- imdb.st[iTesting,]
trainDb <- imdb.st[-iTesting,]

fullmod <- lm(sqscore ~ . - title, trainDb) #just for reference

# we can use the interactions between predictors to improve the model:
bettermod <- lm(sqscore ~ uservotessr:grosssr + # the more gross => the more exposure => higher ranking films will get a higher proportion of votes
                uservotessr * userreviewssr + criticreviewssr : userreviewssr # the relation is obvious
                + budget * grosssr # the relation here is if a film has high gross and low budget => its good and vice versa
                + year_BIN + color + durationsr * standardaspect + continent, trainDb)

#see how well we predict the result
scorePredictTr <- predict(bettermod, trainDb)
plot(abs(sqrt(trainDb$sqscore) - sqrt(scorePredictTr)))

# and now predict the tests 
scorePredict <- predict(bettermod, testDb)
plot(abs(sqrt(testDb$sqscore) - sqrt(scorePredict)))











