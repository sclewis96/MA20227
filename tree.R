ymod <- lm(year ~ . - title - director - actor1 - actor2 - actor3 - genres, imdc)
summary(ymod)


library(rpart)
imde <- imdd
imde$title <- NULL
tree <- rpart(sqscore ~ ., imde)
plot(tree)
text(tree, cex = 0.8)

sum(residuals(tree)^2)
sum(residuals(rmod)^2)

tree1 <- rpart(sqscore ~ ., imde, cp = 0.001)
plot(tree1)
text(tree1, cex = 0.3)
sum(residuals(tree1)^2)
