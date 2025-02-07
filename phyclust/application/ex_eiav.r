library(phyclust)

### Read Data.
data.path <- paste(.libPaths()[1], "/phyclust/data/pony524.phy", sep = "")
my.524 <- read.phylip(data.path)
data.path <- paste(.libPaths()[1], "/phyclust/data/pony625.fas", sep = "")
my.625 <- read.fasta(data.path)
X <- rbind(my.524$org, my.625$org[, -406])

### Run a silly phyclust() in 2 clusters.
set.seed(1234)
ret <- phyclust(X, 2)

### Draw Dots plots.
windows()
plothist(X, X.class = ret$class.id, Mu = ret$Mu)

### Draw Histogram.
windows()
plotdots(X, X.class = ret$class.id)
