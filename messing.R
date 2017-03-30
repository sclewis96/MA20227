df <- select(imdc, title, score, year, duration, gross, budget, criticreviews,
             uservotes, userreviews, country, rating, color, aspect)
lmod <- lm(score ~ . - title, data = df)
summary(lmod)
plot(lmod)
hist(residuals(lmod))
# Model is under-predicting high scores

# Try making relationships more linear
betterplotdf <- select(imdc, title, score, year, duration, gross, budget, criticreviews,
                 uservotes, userreviews, country, rating, color, aspect) %>%
    transmute(title, score, year,
              sqrtduration = sqrt(duration), gross, budget,
              srcriticreviews = sqrt(criticreviews), sruservotes = sqrt(uservotes), sruserreviews = sqrt(userreviews),
              country, rating, color, aspect) %>%
    gather(-c(title, score, country, rating, color, aspect),
           key = "var", value = "value")

bp <- ggplot(betterplotdf, aes(x = value, y = score)) + geom_point(alpha = 0.07) +
    facet_wrap(~ var, scales = "free") + geom_smooth(method = "lm", col = "red")

bp


# Train a model on this new data
df2 <- select(imdc, title, score, year, duration, gross, budget, criticreviews,
                       uservotes, userreviews, country, rating, color, aspect) %>%
    transmute(title, score, mmyear = ((year-min(year)) / (max(year)-min(year))),
              duration, gross, budget,
              sqrtcriticreviews = sqrt(criticreviews), luservotes = log(uservotes), luserreviews = log(userreviews),
              country, rating, color, aspect)

lmod2 <- lm(score ~ . - title, data = df2, subset = -c(2502))
summary(lmod2)
plot(lmod2)

hist(residuals(lmod), breaks = 30)
hist(residuals(lmod2), breaks = 30)
# Still some problems with underpredicting high scores
# Let's look at scores
hist(imdb$score)
hist(imdb$score^2)

df3 <- mutate(df2, score = score^2) %>%
    rename(sqscore = score)
    
lmod3 <- lm(sqscore ~ . - title, data = df3, subset = -c(2502))
summary(lmod3)
plot(lmod3)

hist(residuals(lmod3), breaks = 30)



nmod <- lm(score ~ 1, data = df)

step(nmod, scope = list(lower = nmod, upper = lmod), direction = "forward")



plot(residuals(lmod) ~ fitted(lmod))
abline(h = 0, col = "red")
plot(residuals(lmod2) ~ fitted(lmod2))




library(leaps)
msel <- regsubsets(score ~ (.-title), data = df, nvmax = 8, really.big = TRUE)
summsel <- summary(msel)

sqrt(summsel$rss/(3638 - (2:9)))

lmodsmall <- lm(score ~ uservotes + duration + budget + criticreviews + year,
                data = df)

summary(lmodsmall)
summary(lmod)

nmod <- step(lmod)
