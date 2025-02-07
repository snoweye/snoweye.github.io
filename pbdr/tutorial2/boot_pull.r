# File name: boot_pull.r
# Run: mpiexec -np 4 Rscript boot_pull.r

rm(list = ls())                                       # Clean environment
library(pbdMPI, quiet = TRUE)                         # Load library
comm.set.seed(123, diff = TRUE)                       # set seed
if(comm.size() != 4)
  comm.stop("4 processors are required.")

### Load data
X <- as.matrix(iris[, -5])                            # Dimension 150 by 4
N <- nrow(X)
p <- ncol(X)

### Distribute job tasks
N.jobs <- 1000
FUN <- function(jid){
  id <- sample(1:N, N, replace = TRUE)
  ret.boot <- colMeans(X[id,])
  ret.boot
}
ret <- task.pull(1:N.jobs, FUN)

### Summary jobs
if(comm.rank() == 0){
  ret.jobs <- unlist(ret)
  ret.jobs <- ret.jobs[names(ret.jobs) != "jid"]
  ret.boot <- matrix(ret.jobs, nrow = 4)
  rownames(ret.boot) <- colnames(X)
  ret.ci <- apply(ret.boot, 1,
                  quantile, probs = c(0.025, 0.975))    # 95% CI
  print(ret.ci)
}

### Finish
finalize()
