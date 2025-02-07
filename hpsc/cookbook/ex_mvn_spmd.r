# File name: ex_mvn_spmd.r
# Run: mpiexec -np 2 Rscript --vanilla ex_mvn_spmd.r

### Load pbdMPI and initial the communicator.
library(pbdMPI, quiet = TRUE)
init()

### Main codes start from here.
set.seed(1234)
N <- 100
p <- 2
X <- matrix(rnorm(N * p), ncol = p)
mu <- c(0.1, 0.2)
Sigma <- matrix(c(0.9, 0.1, 0.1, 0.9), ncol = p)

### Load data partially by processors if N is ultra-large.
id.get <- get.jid(N)
X.spmd <- matrix(X[id.get, ], ncol = p)

### Cholesky decomposition.
U <- chol(Sigma)
logdet <- sum(log(abs(diag(U))))
B.spmd <- t(X.spmd) - mu
A.spmd <- backsolve(U, B.spmd, upper.tri = TRUE, transpose = TRUE)
distval.spmd <- colSums(A.spmd * A.spmd)

### The following two ways have equivalent results, but meanings are different.
# distval <- allgather(distval.spmd, double(N))
# total.logL <- -0.5 * (N * (p * log(2 * pi) + logdet * 2) + sum(distval))
sum.distval <- allreduce(sum(distval.spmd), op = "sum")
total.logL <- -0.5 * (N * (p * log(2 * pi) + logdet * 2) + sum.distval)

### Output.
comm.print(total.logL)
finalize()
