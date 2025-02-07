# File name: ex_binning_spmd.r
# Run: mpiexec -np 2 Rscript --vanilla ex_binning_spmd.r

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

### Based on breaks to count data.
bin.spmd <- table(cut(y.spmd, breaks = pi / 3 * (-3:3)))
bin <- mpi.reduce(bin.spmd, type = 1, op = "sum")
# The mpi call may fail if a bin were too big, use as.double(...) instead.
# e.g. bin <- mpi.reduce(as.double(bin.spmd), type = 2, op = "sum")

### Output from RANK 0 since mpi.reduce(...) will dump only to 0 by default.
if(COMM.RANK == 0){
  ### Change attributes.
  bin <- as.array(bin)
  dimnames(bin) <- dimnames(bin.spmd)
  class(bin) <- class(bin.spmd)
  print(bin)
}
invisible(mpi.barrier())    # Waiting the COMM.RANK 0 to finish.

mpi.quit()
