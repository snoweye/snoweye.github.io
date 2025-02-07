# File name: ex_ols_spmd.r
# Run: mpiexec -np 2 Rscript --vanilla ex_ols_spmd.r

### Load Rmpi and initial the communicator.
library(Rmpi)
invisible(mpi.comm.dup(0, 1))    # Rmpi uses comm 1 as default.
COMM.SIZE <- mpi.comm.size()
COMM.RANK <- mpi.comm.rank()

### Main codes start from here.
set.seed(1234)
N <- 100    # Pretend N is large.
p <- 2
X <- matrix(rnorm(N * p), ncol = p)
beta <- c(1, 2)
epsilon <- rnorm(N)
Y <- X %*% beta + epsilon

### Distributing data. Use mpi.comm.send()/mpi.comm.recv() for Master/Workers.
### Load data partially by processors if N is ultra-large.
id.per.rank <- floor(N / COMM.SIZE)
id.get <- 1:id.per.rank + COMM.RANK * id.per.rank
if(COMM.RANK == (COMM.SIZE - 1)){
  id.get <- id.get[1]:N
}
X.spmd <- X[id.get,]
Y.spmd <- Y[id.get]

### Obtain beta hat.
t.X.spmd <- t(X.spmd)
A <- mpi.allreduce(t.X.spmd %*% X.spmd, type = 2, op = "sum")
B <- mpi.allreduce(t.X.spmd %*% Y.spmd, type = 2, op = "sum")
beta.hat <- solve(matrix(A, ncol = p)) %*% B

### Output.
if(COMM.RANK == 0){
  print(beta.hat)
}
invisible(mpi.barrier())    # Waiting the COMM.RANK 0 to finish.

mpi.quit()
