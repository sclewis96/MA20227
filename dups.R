library(dplyr)

dups <- group_by(imdb, title) %>%
    filter(n() > 1) %>%
    arrange(title, uservotes)
View(dups)

length(unique(dups$title))

# Fix?

imdb <- group_by(imdb, title, uservotes) %>%
    slice(which.max(uservotes)) %>%
    ungroup()
