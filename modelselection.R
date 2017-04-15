#==== Continuous variables ====

# Train models on variations of (numeric) data:
#   s = score^2 as predictor
#   t = transformed predictors

df <- select(imdc, title, score, year, duration, gross, budget,
             criticreviews, uservotes, userreviews)

tdf <- select(imdc, title, score, year, duration, gross, budget,
              criticreviews, uservotes, userreviews) %>%
    transmute(title, score, year, durationsr = sqrt(duration),
              grosssr = sqrt(gross), budget, criticreviewssr = sqrt(criticreviews),
              uservotessr = sqrt(uservotes), userreviewssr = sqrt(userreviews))

sdf <- select(imdc, title, score, year, duration, gross, budget,
              criticreviews, uservotes, userreviews) %>%
    mutate(score = score^2) %>% rename(sqscore = score)

tsdf <- select(imdc, title, score, year, duration, gross, budget,
               criticreviews, uservotes, userreviews) %>%
    transmute(title, sqscore = (score^2), year, durationsr = sqrt(duration),
              grosssr = sqrt(gross), budget, criticreviewssr = sqrt(criticreviews),
              uservotessr = sqrt(uservotes), userreviewssr = sqrt(userreviews))

lmod <- lm(score ~ . - title, df)
tlmod <- lm(score ~ . - title, tdf)
slmod <- lm(sqscore ~ . - title, sdf)
tslmod <- lm(sqscore ~ . - title, tsdf)

# Compare RSS for the models
sum(residuals(lmod)^2)
sum((sqrt(sdf$sqscore) - sqrt(fitted(slmod)))^2)
sum(residuals(tlmod)^2)
sum((sqrt(tsdf$sqscore) - sqrt(fitted(tslmod)))^2)

# {squared score} ~ {transformed predictors} is best, as hoped!
# Check diagnostic plots of this model and compare to base model
par(mfrow = c(2, 2))
plot(lmod)
plot(tslmod)

# There are two outliers, particularly evident in Q-Q plot: rows 1415 and 3475
# Let's fit our model not including these points and look at the summary
mod <- lm(sqscore ~ . - title, tsdf, subset = -c(3475, 1415))
summary(mod)
# This has a better adjusted R^2 than tslmod too :)



#==== Factor variables ====

# Let's move on to our factor variables...

# aspect is given to us as a numeric, but really it should probably be a factor
# since it only takes certain values
summary(factor(imdc$aspect))
ggplot(imdc, aes(factor(aspect), score)) + geom_point(alpha = 0.2)

# A lot of these aspects only have 1 point... clearly a model trained on this
# factor will overfit our data!
# Let's see if we can remove this issue and simultaneously simplify our factor
# by 'collapsing' the factor i.e. collecting similar groups
imdc$standardaspect <- imdc$aspect %in% c(1.85, 2.35)

# Let's compare some models
amod <- lm(score ~ aspect - 1, imdc)
bmod <- lm(score ~ factor(aspect) - 1, imdc)
cmod <- lm(score ~ standardaspect - 1, imdc)
# Fit a constant model for comparison
nmod <- lm(score ~ 1, imdc)
BIC(amod, bmod, cmod, nmod)

# standardaspect is, perhaps surprisingly, almost as good as aspect - and it
# removes the overfitting problem


# Now let's do something similar for rating:
summary(imdc$rating)
ggplot(imdc, aes(rating, score)) + geom_point(alpha = 0.2)

# "Kid-friendly" films might get worse scores? ...
imdc$kidfriendly <- imdc$rating %in% c("G", "GP", "PG", "PG-13")

dmod <- lm(score ~ rating - 1, imdc)
emod <- lm(score ~ kidfriendly - 1, imdc)
BIC(dmod, emod, nmod)

# So the kidfriendly model has a marginally better AIC - it is much simpler too!
# Again this is likely to reduce the problem of overfitting, so this is good :)


# And now for country...
summary(imdc$country)
ggplot(imdc, aes(country, score)) + geom_point(alpha = 0.2) +
    theme(axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.5))

# LOADS of countries with only 1 film. Surefire recipe for extreme overfitting!
# Perhaps it's significant if a country has or hasn't released many films
imdc$manyfilms <- NULL
countrycounts <- group_by(imdc, country) %>%
    summarise(manyfilms = (n() > 5))

imdc <- right_join(imdc, countrycounts, by = "country")

fmod <- lm(score ~ country - 1, imdc)
gmod <- lm(score ~ manyfilms - 1, imdc)
BIC(fmod, gmod, nmod)

# That doesn't seem to be much good. It's worse than the null model!
# What about grouping countries by continent?
library(countrycode)
imdc$continent <- factor(countrycode(imdc$country, "country.name", "continent"))
summary(imdc$continent)

# We've managed to group up countries, so we shouldn't overfit too badly
hmod <- lm(score ~ continent - 1, imdc)
BIC(fmod, hmod, nmod)

# Much better than before. Still worse than the model using country, but we know
# that that model is overfitting, so this seems to be a good compromise!


# Our last factor variable is color. This is already a binary factor so we can
# happily leave it as it is!



#==== Putting it all together ====

imdc <- select(imdc, title, score, year, duration, gross, budget,
               criticreviews, uservotes, userreviews,
               standardaspect, kidfriendly, continent, color) %>%
    transmute(title, sqscore = (score^2), year, durationsr = sqrt(duration),
              grosssr = sqrt(gross), budget, criticreviewssr = sqrt(criticreviews),
              uservotessr = sqrt(uservotes), userreviewssr = sqrt(userreviews),
              standardaspect, kidfriendly, continent, color)

fullmod <- lm(sqscore ~ . - title, imdc)
summary(fullmod)
# (Notice that it looks like continent is a pretty poor predictor. We'll get to
# this shortly.)
plot(fullmod)

fullmod <- lm(sqscore ~ . - title, imdc, subset = -c(178, 1805))
summary(fullmod)
