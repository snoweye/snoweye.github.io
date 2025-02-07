# File name: ex_basic_spmd.r
# Run: mpiexec -np 2 Rscript --vanilla ex_basic_spmd.r

### Load pbdMPI and initial the communicator.
library(pbdMPI, quiet = TRUE)
init()

### Basic implication for workers.
my.basic.spmd <- function(x.spmd){
  ### For mean(x).
  N <- allreduce(length(x.spmd), op = "sum")
  bar.x.spmd <- sum(x.spmd / N)
  bar.x <- allreduce(bar.x.spmd, op = "sum")

  ### For var(x).
  s.x.spmd <- sum(x.spmd^2 / (N - 1))
  s.x <- allreduce(s.x.spmd, op = "sum") - bar.x^2 * (N / (N - 1))

  list(mean = bar.x, s = s.x)
} # End of my.basic.spmd().

### Main codes start from here.
set.seed(1234)
N <- 100                # Pretend N is large.
x <- rnorm(N)

### Load data partially by processors if N is ultra-large.
id.get <- get.jid(N)
x.spmd <- x[id.get]
ret.spmd <- my.basic.spmd(x.spmd)

### Output.
comm.print(ret.spmd)
finalize()
