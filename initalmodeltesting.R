# Load in data
load("imdb.rda")

# Create linear model with all predictors
lmod1=lm(score~color+criticreviews+duration+gross+uservotes+
           userreviews+country+rating+budget+year+aspect,data=imdb)

# Run diagnostics
qqnorm(residuals(lmod1))
qqline(residuals(lmod1))
plot(residuals(lmod1)~fitted(lmod1))

msel=regsubsets(score~color+criticreviews+duration+gross+uservotes+
                  userreviews+country+rating+budget+year+aspect,data=imdb,nvmax=11,really.big=T)

lmod2=lm(score~criticreviews+duration+uservotes+budget+year,data=imdb)