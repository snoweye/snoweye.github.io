# File name: plot_3.r

data(cars)

par(mfrow = c(2, 2))

plot(cars, main = "Cars")
hist(cars[, 1], xlab = "speed", main = "Histogram of speed")
hist(cars[, 2], xlab = "dist", nclass = 10, main = "Histogram of dist")
plot(density(cars[, 2]), main = "Density of dist")
