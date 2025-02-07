# File name: ex_mvn_spmd.r
# Run: mpiexec -np 2 Rscript --vanilla ex_mvn_spmd.r

### Load Rmpi and initial the communicator.
library(Rmpi)
invisible(mpi.comm.dup(0, 1))    # Rmpi uses comm 1 as default.
COMM.SIZE <- mpi.comm.size()
COMM.RANK <- mpi.comm.rank()

### MVN implication for workers.

### Main codes start from here.
set.seed(1234)
N <- 100
p <- 2
X <- matrix(rnorm(N * p), ncol = p)
mu <- c(0.1, 0.2)
Sigma <- matrix(c(0.9, 0.1, 0.1, 0.9), ncol = p)

### Distributing data. Use mpi.comm.send()/mpi.comm.recv() for Master/Workers.
### Load data partially by processors if N is ultra-large.
id.per.rank <- floor(N / COMM.SIZE)
id.get <- 1:id.per.rank + COMM.RANK * id.per.rank
if(COMM.RANK == (COMM.SIZE - 1)){
  id.get <- id.get[1]:N
}
X.spmd <- matrix(X[id.get, ], ncol = p)

### Cholesky decomposition.
U <- chol(Sigma)
logdet <- sum(log(abs(diag(U))))
B.spmd <- t(X.spmd) - mu
A.spmd <- backsolve(U, B.spmd, upper.tri = TRUE, transpose = TRUE)
distval.spmd <- colSums(A.spmd * A.spmd)

### The following two ways have equivalent results, but meanings are different.
# distval <- mpi.allgather(distval.spmd, type = 2, double(N))
# total.logL <- -0.5 * (N * (p * log(2 * pi) + logdet * 2) + sum(distval))
sum.distval <- mpi.allreduce(sum(distval.spmd), type = 2, op = "sum")
total.logL <- -0.5 * (N * (p * log(2 * pi) + logdet * 2) + sum.distval)

### Output.
if(COMM.RANK == 0){
  print(total.logL)
}
invisible(mpi.barrier())    # Waiting the COMM.RANK 0 to finish.

mpi.quit()

