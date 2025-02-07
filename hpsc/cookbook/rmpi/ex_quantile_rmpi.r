# File name: ex_quantile_spmd.r
# Run: mpiexec -np 2 Rscript --vanilla ex_quantile_spmd.r

### Load Rmpi and initial the communicator.
library(Rmpi)
invisible(mpi.comm.dup(0, 1))    # Rmpi uses comm 1 as default.
COMM.SIZE <- mpi.comm.size()
COMM.RANK <- mpi.comm.rank()

### Main codes start from here.
set.seed(1234)
N <- 100
y <- rnorm(N)

### Distributing data. Use mpi.comm.send()/mpi.comm.recv() for Master/Workers.
### Load data partially by processors if N is ultra-large.
id.per.rank <- floor(N / COMM.SIZE)
id.get <- 1:id.per.rank + COMM.RANK * id.per.rank
if(COMM.RANK == (COMM.SIZE - 1)){
  id.get <- id.get[1]:N
}
y.spmd <- y[id.get]

### A function for uniroot.
f.quantile <- function(x, data.spmd, N, prob = 0.5){
  mpi.allreduce(sum(data.spmd <= x) / N - prob, type = 2, op = "sum")
} # End of f.quantile().

### Obtain 95% quantile.
ret <- uniroot(f.quantile, c(-5, 5), y.spmd, N, prob = 0.95)

### Output from RANK 0 since mpi.reduce(...) will dump only to 0 by default.
if(COMM.RANK == 0){
  print(ret$root)
}
invisible(mpi.barrier())    # Waiting the COMM.RANK 0 to finish.

mpi.quit()

