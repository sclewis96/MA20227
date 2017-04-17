load("imdc.rda")
# Set up a data frame with transformed predictors
imdd <- select(imdc, title, score, year, duration, gross, budget,
               criticreviews, uservotes, userreviews, color, aspect, country, rating) %>%
    transmute(title, sqscore = (score^2), year, durationsr = sqrt(duration),
              grosssr = sqrt(gross), budget, criticreviewssr = sqrt(criticreviews),
              uservotessr = sqrt(uservotes), userreviewssr = sqrt(userreviews),
              color, aspect, country, rating)

# Let's find the best model of each size up to 25 predictors
library(leaps)
msel <- regsubsets(sqscore ~ . - title + grosssr:uservotessr + criticreviewssr:userreviewssr +
                       grosssr:budget, imdd, nvmax = 25, really.big = TRUE)

# What does it look like if we plot the AIC of each model?
plot(1:25, 3539*log(summary(msel)$rss/3539) + 2*(2:26), type = "o")

# Adding predictors consistently improves AIC. We want a smaller model though!
# What seems to be a reasonable "cut-off point"?
# There are "elbows" at 3 and 9 predictors (including intercept).
# Let's look at both - 9 first!

which(summary(msel)$which[9, ])

# We need to make a binary variable
imdd$ratingPG13 <- as.numeric(imdd$rating == "PG-13")

rmod <- lm(sqscore ~ year + durationsr + grosssr + budget + criticreviewssr +
               uservotessr + userreviewssr + grosssr:budget + ratingPG13, imdd)
summary(rmod)

# Now 3 predictors
which(summary(msel)$which[3, ])
tmod <- lm(sqscore ~ budget + uservotessr + durationsr, imdd)
summary(tmod)

# Compare AIC of models against:
fullmod <- lm(sqscore ~ . - title - ratingPG13, imdd)
nullmod <- lm(sqscore ~ 1, imdd)

AIC(fullmod, rmod, tmod, nullmod)

# Common-sense check that AIC() is doing what we think it is: difference between
# hand-calculated values for tmod and rmod
3539*log(summary(msel)$rss[3]/3539) + 2*4 -
    (3539*log(summary(msel)$rss[9]/3539) + 2*10)
# Difference between AIC() values
AIC(tmod) - AIC(rmod)
# All is well! Only difference is in positive constant in definition of AIC


# Since we have a large number of observations maybe we should consider BIC
plot(1:25, 3539*log(summary(msel)$rss/3539) + log(3539)*(2:26), type = "o")

# Now we can see a minimum...
which.min(3539*log(summary(msel)$rss/3539) + log(3539)*(2:26))
# ... corresponding to the model with 16 predictors (+ intercept)
which(summary(msel)$which[16, ])
# Add binary predictors for variables we need
imdd$countryUK <- as.numeric(imdd$country == "UK")
imdd$countryNZ <- as.numeric(imdd$country == "New Zealand")
imdd$ratingG <- as.numeric(imdd$rating == "G")
imdd$ratingR <- as.numeric(imdd$rating == "R")
imdd$ratingUnrated <- as.numeric(imdd$rating == "Unrated")
# Fit a medium-sized model
mmod <- lm(sqscore ~ year + durationsr + grosssr + budget + criticreviewssr +
               uservotessr + userreviewssr + color + countryNZ + countryUK +
               ratingG + ratingPG13 + ratingR + ratingUnrated +
               criticreviewssr:userreviewssr + grosssr:budget, imdd)
summary(mmod)

# Compare BICs
BIC(fullmod, mmod, rmod, tmod, nullmod)
# Notice mmod, rmod have better BICs than fullmod! tmod only marginally worse

