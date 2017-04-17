# Investigation after discovery of potentially duplicated entries

load("imdb.rda")

library(dplyr)

dups <- group_by(imdb, title) %>%
    summarise(count = n()) %>%
    filter(count > 1)
nrow(dups)
# So there are 93 titles appearing more than once...

# See if uservotes is only difference between duplicates
setdiff(dups$title,
        imdb$title[select(imdb, -c(uservotes)) %>%
                       duplicated()])

# No, it isn't in two cases!

filter(imdb, title == "Brothers" |  title == "Cinderella")
# Brothers: uservotes, actor3 are different
# Cinderella: uservotes, userreviews are different

# We'll remove duplicates by taking the record with largest uservotes for each
# title
imdc <- group_by(imdb, title) %>%
    slice(which.max(uservotes)) %>%
    ungroup()