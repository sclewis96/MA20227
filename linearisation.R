# Load in data
load("imdc.rda")

#=== As-given

plotdf <- select(imdc, title, score, year, duration, gross, budget,
                 criticreviews, uservotes, userreviews, country, rating, color,
                 aspect) %>%
    gather(-c(title, score, country, rating, color, aspect),
           key = "var", value = "value")

# Set up plot
p <- ggplot(plotdf, aes(x = value, y = score)) +
    geom_point(alpha = 0.1) + geom_smooth(method = "lm", col = "red") +
    facet_wrap(~ var, scales = "free") + labs(title = "Predictors vs Score") +
    theme(plot.title = element_text(face = "bold", hjust = 0.5,
                                    size = rel(1.5)))

# Actually plot it
p

#===


#=== Linearised

# Try making relationships more linear
betterplotdf <- select(imdc, title, score, year, duration, gross, budget,
                       criticreviews, uservotes, userreviews, country, rating,
                       color, aspect) %>%
    transmute(title, score, year, durationdiffsr = sqrt(abs(100 - duration)),
              grosssr = sqrt(gross), budget,
              criticreviewssr = sqrt(criticreviews),
              uservotessr = sqrt(uservotes), userreviewssr = sqrt(userreviews),
              country, rating, color, aspect) %>%
    gather(-c(title, score, country, rating, color, aspect),
           key = "var", value = "value")

bp <- ggplot(betterplotdf, aes(x = value, y = score)) +
    geom_point(alpha = 0.07) + geom_smooth(method = "lm", col = "magenta") +
    facet_wrap(~ var, scales = "free") +
    labs(title = "Linearised predictors vs Score") +
    theme(plot.title = element_text(face = "bold", hjust = 0.5,
                                    size = rel(1.5)))

bp

#===