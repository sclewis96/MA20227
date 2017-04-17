df <- select(imdc, title, score, year, duration, gross, budget, criticreviews,
             uservotes, userreviews, country, rating, color, aspect)
lmod <- lm(score ~ . - title, data = df)
summary(lmod)
plot(lmod)
hist(residuals(lmod), breaks = 60)
# Model is under-predicting high scores

# Try making relationships more linear
source("linearisation.R")

# Train a model on this new data
df2 <- select(imdc, title, score, year, duration, gross, budget,
                              criticreviews, uservotes, userreviews, country, rating,
                              color, aspect) %>%
  transmute(title, score, year, durationdiffsr = sqrt(abs(100 - duration)),
            grosssr = sqrt(gross), budget,
            criticreviewssr = sqrt(criticreviews),
            uservotessr = sqrt(uservotes), userreviewssr = sqrt(userreviews),
            country, rating, color, aspect)

lmod2 <- lm(score ~ . - title, data = df2, subset = -c(1441))
summary(lmod2)
plot(lmod2)

hist(residuals(lmod), breaks = 30)
hist(residuals(lmod2), breaks = 30)
# Still some problems with underpredicting high scores
# Let's look at scores
hist(imdc$score)
hist(imdc$score^2)

df3 <- mutate(df2, score = score^2) %>%
    rename(sqscore = score)
    
lmod3 <- lm(sqscore ~ . - title, data = df3)
summary(lmod3)
plot(lmod3)

hist(residuals(lmod3), breaks = 30)



nmod <- lm(sqscore ~ 1, data = df3)

step(lmod3, scope = list(lower = nmod, upper = lmod3), direction = "backward",
     k = log(11))



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

lmodsm <- drop1(lmod3) #%>%
    drop1() %>%
    drop1()
