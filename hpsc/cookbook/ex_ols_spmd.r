# File name: ex_ols_spmd.r
# Run: mpiexec -np 2 Rscript --vanilla ex_ols_spmd.r

### Load pbdMPI and initial the communicator.
library(pbdMPI, quiet = TRUE)
init()

### Main codes start from here.
set.seed(1234)
N <- 100                # Pretend N is large.
p <- 2
X <- matrix(rnorm(N * p), ncol = p)
beta <- c(1, 2)
epsilon <- rnorm(N)
Y <- X %*% beta + epsilon

### Load data partially by processors if N is ultra-large.
id.get <- get.jid(N)
X.spmd <- X[id.get,]
Y.spmd <- Y[id.get]

### Obtain beta hat.
t.X.spmd <- t(X.spmd)
A <- allreduce(t.X.spmd %*% X.spmd, op = "sum")
B <- allreduce(t.X.spmd %*% Y.spmd, op = "sum")
beta.hat <- solve(matrix(A, ncol = p)) %*% B

### Output.
comm.print(beta.hat)
finalize()
