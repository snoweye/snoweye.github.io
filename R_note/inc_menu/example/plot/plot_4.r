# File name: plot_4.r

data(cars)

layout(matrix(c(2, 4, 1, 3), nrow = 2, byrow = TRUE), c(2, 1), c(1, 2))

par(mar = c(3, 3, 1, 1))
plot(cars, xlab = "", ylab = "")

par(mar = c(3, 3, 1, 1))
hist(cars[, 1], main = "", xlab = "", ylab = "")

par(mar = c(0, 3, 1, 1))
hist(cars[, 2], nclass = 10, main = "", xlab = "", ylab = "")

par(mar = c(3, 3, 1, 1))
plot(density(cars[, 2]), main = "", xlab = "", ylab = "")
