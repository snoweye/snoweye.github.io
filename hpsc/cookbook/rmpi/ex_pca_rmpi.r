# File name: ex_pca_spmd.r
# Run: mpiexec -np 2 Rscript --vanilla ex_pca_spmd.r

### Load Rmpi and initial the communicator.
library(Rmpi)
invisible(mpi.comm.dup(0, 1))    # Rmpi uses comm 1 as default.
COMM.SIZE <- mpi.comm.size()
COMM.RANK <- mpi.comm.rank()

### PCA implication for workers.
my.pca.projection.spmd <- function(X.spmd, alpha = 0.5){
  ### Obtain some basic statistics.
  p <- ncol(X.spmd)
  N.spmd <- nrow(X.spmd)
  X.sum.spmd <- colSums(X.spmd)
  X.2.sum.spmd <- colSums(X.spmd^2)

  ### Obtain summarized statistics from all workers.
  N <- mpi.allreduce(as.double(N.spmd), type = 2, op = "sum")
  X.mean <- mpi.allreduce(X.sum.spmd / N, type = 2, op = "sum")
  X.2.mean <- mpi.allreduce(X.2.sum.spmd / N, type = 2, op = "sum")

  ### Standardized all workers.
  X.std <- sqrt(X.2.mean - X.mean^2)
  Y.spmd <- t((t(X.spmd) - X.mean) / X.std)

  ### Obtain Y^t * Y from all workers.
  Y.cov.spmd <- t(Y.spmd) %*% Y.spmd
  Y.cov <- matrix(mpi.allreduce(Y.cov.spmd, type = 2, op = "sum"), ncol = p)

  ### u.spmd is distributed as Y.spmd in all workers.
  Y.eigen <- eigen(Y.cov)
  d <- sqrt(Y.eigen$values)
  v <- Y.eigen$vectors
  u.spmd <- t(solve(v %*% diag(d), t(Y.spmd)))

  ### Obtain the projection onto the first two principal components.
  set.N.spmd <- t(t(u.spmd[, 1:2]) * d[1:2]^alpha)
  set.p <- t(t(v[, 1:2]) * d[1:2]^(1 - alpha))

  list(set.N = set.N.spmd, set.p = set.p)
} # End of my.pca.projection.spmd().

### Main codes start from here.
set.seed(1234)
N <- 100    # Pretend N is large.
p <- 4
X <- matrix(rnorm(N * p), ncol = p)

### Distributing data. Use mpi.comm.send()/mpi.comm.recv() for Master/Workers.
### Load data partially by processors if N is ultra-large.
id.per.rank <- floor(N / COMM.SIZE)
id.get <- 1:id.per.rank + COMM.RANK * id.per.rank
if(COMM.RANK == (COMM.SIZE - 1)){
  id.get <- id.get[1]:N
}
X.spmd <- matrix(X[id.get, ], ncol = p)
Z.spmd <- my.pca.projection.spmd(X.spmd)

### Gather all results to COMM.RANK 0 and draw Biplot.
Z <- Z.spmd
Z$set.N <- mpi.allgather.Robj(Z$set.N)
# This call should be outside of the next if(...) to avoid dead locks.

### Output.
if(COMM.RANK == 0){
  ### Biplot
  plot(NULL, NULL, type = "n", axes = FALSE, main = "PCA",
       xlab = "Principal Component 1", ylab = "Principal Component 2",
       xlim = range(c(Z$set.N[, 1], Z$set.p[, 1])),
       ylim = range(c(Z$set.N[, 2], Z$set.p[, 2])))
  points(Z$set.N[, 1], Z$set.N[, 2], col = "red")
  arrows(0, 0, Z$set.p[, 1], Z$set.p[, 2], length = 0.1, col = "blue", lwd = 1.1)
  box()
}
invisible(mpi.barrier())    # Waiting the COMM.RANK 0 to finish.

mpi.quit()
