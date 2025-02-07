# File name: ex_pi_spmd.r
# Run: mpiexec -np 2 Rscript --vanilla ex_pi_spmd.r

### Load Rmpi and initial the communicator.
library(Rmpi)
invisible(mpi.comm.dup(0, 1))    # Rmpi uses comm 1 as default.
COMM.SIZE <- mpi.comm.size()
COMM.RANK <- mpi.comm.rank()

### Compute pi.
n <- 1000
totalcpu <- COMM.SIZE 
id <- COMM.RANK + 1
mypi <- 4*sum(1/(1+((seq(id,n,totalcpu)-.5)/n)^2))/n    # The example from Rmpi.
mypi <- mpi.reduce(mypi, type = 2, op = "sum")

### Output from RANK 0 since mpi.reduce(...) will dump only to 0 by default.
if(COMM.RANK == 0){
  print(mypi)
}
invisible(mpi.barrier())    # Waiting the COMM.RANK 0 to finish.

mpi.quit()
