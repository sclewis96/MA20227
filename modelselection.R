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













summary(factor(imdc$aspect))
imdc$standardaspect <- imdc$aspect %in% c(1.85, 2.35)

amod <- lm(score ~ aspect, imdc)
bmod <- lm(score ~ standardaspect, imdc)
AIC(amod, bmod)


summary(imdc$country)


summary(imdc$rating)
imdc$kidsafe <- imdc$rating %in% c("G", "GP", "PG", "PG-13")

cmod <- lm(score ~ rating, imdc)
dmod <- lm(score ~ kidsafe, imdc)
AIC(cmod, dmod)
