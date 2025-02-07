library(phyclust)

### Read Data.
data.path <- paste(.libPaths()[1], "/phyclust/data/crohn.phy", sep = "")
my.seq <- read.phylip(data.path, code.type = "SNP")
X <- my.seq$org

### Run a silly phyclust() in 2 clusters.
set.seed(1234)
EMC.SNP <- .EMControl(substitution.model = "SNP_JC69",
                      edist.model = "D_HAMMING", code.type = "SNP")
ret <- phyclust(X, 5, EMC = EMC.SNP)

### Run Neighbor-Joining.
ret.dist <- phyclust.edist(X, edist.model = "D_HAMMING")
ret.nj <- nj(ret.dist)

### Draw tree plots.
windows()
plotnj(ret.nj, X.class = ret$class.id, edge.width.class = 3,
       no.margin = TRUE)
windows()
plotnj(ret.nj, X.class = ret$class.id, edge.width.class = 10,
       no.margin = TRUE)

