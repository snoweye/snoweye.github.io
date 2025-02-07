# File name: ex_basic_spmd.r
# Run: mpiexec -np 2 Rscript --vanilla ex_basic_spmd.r

### Load Rmpi and initial the communicator.
library(Rmpi)
invisible(mpi.comm.dup(0, 1))    # Rmpi uses comm 1 as default.
COMM.SIZE <- mpi.comm.size()
COMM.RANK <- mpi.comm.rank()

### Basic implication for workers.
my.basic.spmd <- function(x.spmd){
  ### For mean(x).
  N.spmd <- length(x.spmd)    # Return an integer
  N <- mpi.allreduce(as.double(N.spmd), type = 2, op = "sum")
  bar.x.spmd <- sum(x.spmd / N)
  bar.x <- mpi.allreduce(bar.x.spmd, type = 2, op = "sum")

  ### For var(x).
  s.x.spmd <- sum(x.spmd^2 / (N - 1))
  s.x <- mpi.allreduce(s.x.spmd, type = 2, op = "sum") -
         bar.x^2 * (N / (N - 1))

  list(mean = bar.x, s = s.x)
} # End of my.basic.spmd().

### Main codes start from here.
set.seed(1234)
N <- 100    # Pretend N is large.
x <- rnorm(N)

### Distributing data. Use mpi.comm.send()/mpi.comm.recv() for Master/Workers.
### Load data partially by processors if N is ultra-large.
id.per.rank <- floor(N / COMM.SIZE)
id.get <- 1:id.per.rank + COMM.RANK * id.per.rank
if(COMM.RANK == (COMM.SIZE - 1)){
  id.get <- id.get[1]:N
}
x.spmd <- x[id.get]
ret.spmd <- my.basic.spmd(x.spmd)

### Output.
if(COMM.RANK == 0){
  print(ret.spmd)
}
invisible(mpi.barrier())    # Waiting the COMM.RANK 0 to finish.

mpi.quit()
