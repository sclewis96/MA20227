bars <- gsub("[^|]", "", imdc$genres)
imdc$ngen <- sapply(bars, nchar) + 1

gens <- strsplit(imdc$genres, "[|]")

head(gens)

summary(factor(unlist(gens)))

genscores <- data.frame("score" = imdc$score)

for (i in 1:nrow(imdc)) {
    for (j in 1:length(gens[[i]])) {
        genscores[i, j+1] <- gens[[i]][j]
    }
}

keyvalue <- tidyr::gather(genscores, key = score, value = genre, na.rm = TRUE)
head(keyvalue)

plot(score ~ factor(genre), keyvalue, las = 2)



gendurs <- data.frame("dur" = imdc$duration)

for (i in 1:nrow(imdc)) {
    for (j in 1:length(gens[[i]])) {
        gendurs[i, j+1] <- gens[[i]][j]
    }
}

keyvaluedur <- tidyr::gather(gendurs, key = dur, value = genre, na.rm = TRUE)
head(keyvaluedur)
plot(dur ~ factor(genre), keyvaluedur, las = 2)



plot(score ~ country, imdc, subset = grepl("Comedy", genres), las = 2, type = "p")
plot(score ~ country, imdc, subset = grepl("Romance", genres), las = 2)



ymod <- lm(year ~ . - title, imdc)
