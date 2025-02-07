# File name: plot_2.r

data(cars)

windows()

plot(cars, axes = FALSE, xlab = "", ylab = "")
lines(cars)
points(cars, pch = 23, cex = 1.5, col = 2)

axis(1, lwd = 2, lty = 2)
axis(2, col = 3, las = 2)
box(lty = 3)
title(main = "cars", xlab = "x-axis", ylab = "y-axis")
legend(5, 100, "cars", lty = 1)

dev.list()
dev.cur()
dev.off()
