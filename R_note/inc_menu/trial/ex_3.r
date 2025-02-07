  dev.off.wrap <- function(){
    dev.off()
    invisible()
  }

  plot.lowess <- function(){
    data(cars)
    plot(cars, main = "lowess(cars)")
    lines(lowess(cars), col = 2)
    lines(lowess(cars, f=.2), col = 3)
    legend(5, 120, c(paste("f = ", c("2/3", ".2"))), lty = 1, col = 2:3)
    invisible()
  }

  plot.kmeans <- function(){
    library(mva)
    # a 2-dimensional example
    x <- rbind(matrix(rnorm(100, sd = 0.3), ncol = 2),
               matrix(rnorm(100, mean = 1, sd = 0.3), ncol = 2))
    cl <- kmeans(x, 2, 20)
    plot(x, col = cl$cluster)
    points(cl$centers, col = 1:2, pch = 8)
    title(main = "Kmeans")
    invisible()
  }

  plot.hierarchical <- function(){
    library(mva)
    data(USArrests)
    hc <- hclust(dist(USArrests), "ave")
    plot(hc)
    plot(hc, hang = -1)
    invisible()
  }

  plot.survival <- function(){
    library(survival)
    data(aml)
    leukemia.surv <- survfit(Surv(time, status) ~ x, data = aml)
    plot(leukemia.surv,lty=1:2,legend.pos=0,col=c("Red","Blue"),legend.text=c("Maintenance", "No Maintenance"))
  }

  plot.pairs <- function(){
    data(iris)
    pairs(iris[1:4], main = "Anderson's Iris Data -- 3 species", 
          pch = 21, bg = c("red", "green3", "blue")[unclass(iris$Species)])
  }


  bitmap(file = "%stdout", type="png256", width = 10, height = 8)
  par(ps = 14)
  eval(call(paste("plot.", item, sep = ""))) 
  title(sub = paste("It is ", date(), " at Taiwan", sep = ""))
  dev.off.wrap()

