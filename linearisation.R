# Load in data
load("imdc.rda")

#==== As-given ====

plotdf <- select(imdc, title, score, year, duration, gross, budget,
                 criticreviews, uservotes, userreviews, country, rating, color,
                 aspect) %>%
    mutate(score = (score^2)) %>%
    gather(-c(title, score, country, rating, color, aspect),
           key = "var", value = "value")

# Set up plot
p <- ggplot(plotdf, aes(x = value, y = score)) +
    geom_point(alpha = 0.1) + geom_smooth(method = "lm", col = "red") +
    facet_wrap(~ var, scales = "free") + labs(title = "Predictors vs Squared Score") +
    theme(plot.title = element_text(face = "bold", hjust = 0.5,
                                    size = rel(1.5)))

# Actually plot it
p


#==== Linearised ====

# Try making relationships more linear
betterplotdf <- select(imdc, title, score, year, duration, gross, budget,
                       criticreviews, uservotes, userreviews, country, rating,
                       color, aspect) %>%
    transmute(title, sqscore = (score^2), year, durationsr = sqrt(duration),
              grosssr = sqrt(gross), budget,
              criticreviewssr = sqrt(criticreviews),
              uservotessr = sqrt(uservotes), userreviewssr = sqrt(userreviews),
              country, rating, color, aspect) %>%
    gather(-c(title, sqscore, country, rating, color, aspect),
           key = "var", value = "value")

bp <- ggplot(betterplotdf, aes(x = value, y = sqscore)) +
    geom_point(alpha = 0.07) + geom_smooth(method = "lm", col = "magenta") +
    facet_wrap(~ var, scales = "free") +
    labs(title = "Linearised Predictors vs Squared Score") +
    theme(plot.title = element_text(face = "bold", hjust = 0.5,
                                    size = rel(1.5)))

bp


#==== Aside: how did we decide on linearisation transformations? ====

# Mostly empirical! Looking at plots and trying to spot trends

# One predictor is hard to linearise: duration. How should we transform it?

#   Base:
m1 <- lm((score^2) ~ duration - 1, imdc)
#   Square root:
m2 <- lm((score^2) ~ sqrt(duration) - 1, imdc)
#   Square root of distance from most common duration:
m3 <- lm((score^2) ~ sqrt(abs(duration-90)) - 1, imdc)

# Compare RSS for these models
anova(m1, m2, m3)
# m2 is smallest, so we'll square-root duration
