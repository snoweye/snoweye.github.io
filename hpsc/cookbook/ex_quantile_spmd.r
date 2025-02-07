# File name: ex_quantile_spmd.r
# Run: mpiexec -np 2 Rscript --vanilla ex_quantile_spmd.r

### Load pbdMPI and initial the communicator.
library(pbdMPI, quiet = TRUE)
init()

### Main codes start from here.
set.seed(1234)
N <- 100
y <- rnorm(N)

### Load data partially by processors if N is ultra-large.
id.get <- get.jid(N)
y.spmd <- y[id.get]

### A function for uniroot.
f.quantile <- function(x, data.spmd, N, prob = 0.5){
  allreduce(sum(data.spmd <= x), op = "sum") / N - prob
} # End of f.quantile().

### Obtain 95% quantile.
ret <- uniroot(f.quantile, c(1.5, 2), y.spmd, N, prob = 0.95)

### Output from RANK 0 since mpi.reduce(...) will dump only to 0 by default.
comm.print(ret$root)
finalize()
