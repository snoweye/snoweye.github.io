# File name: ex_binning_spmd.r
# Run: mpiexec -np 2 Rscript --vanilla ex_binning_spmd.r

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

### Based on breaks to count data.
bin.spmd <- table(cut(y.spmd, breaks = pi / 3 * (-3:3)))
bin <- as.array(allreduce(bin.spmd, op = "sum"))
dimnames(bin) <- dimnames(bin.spmd)
class(bin) <- class(bin.spmd)

### Output from RANK 0 since reduce(...) will dump only to 0 by default.
comm.print(bin)
finalize()
