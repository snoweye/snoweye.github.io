### CAUTION: Run this script in batch/shell mode with the command
###          SHELL> mpiexec -np 4 Rscript 23-mcmc_glm_pbdR.r

rm(list = ls())
source("u0-deer.r")        # Load data.
source("u2-mcmc_glm.r")    # Load library and utility.
library(pbdMPI, quietly = TRUE)
init()

### MCMC.
n.chains <- 2
n.iters <- 1000
id.thin <- seq(500, n.iters, by = 10)

### Setup initial step.
da.mcmc <- get.glm.initial(da)
logL.curr <- logL.glm(da.mcmc$beta, da.mcmc)
param <- list(beta = da.mcmc$beta, logL = logL.curr)

### Function for pbdR.
f <- function(i.chain){
  ### Run M-H.
  set.seed(1234 + i.chain)
  ret.beta <- list()
  for(i.iter in 1:n.iters){
    param <- propose.glm.beta(param, da.mcmc)
    ret.beta[[i.iter]] <- param$beta    # Save parameters.
  }
  ret.beta.thin <- do.call("cbind", ret.beta[id.thin])
  ret.beta.thin
} # End of f().

ret.beta.thin <- task.pull(1:n.chains, f, bcast = TRUE)
### Exercise: Try pbdLapply() and discuss it's dis-/advantage.
# ret.beta.thin <- pbdLapply(1:n.chains, f, bcast = TRUE)

### Collapse results.
ret.beta.thin <- do.call("cbind", ret.beta.thin)

### Posterior mean and it's standard error.
post.beta <- rowMeans(ret.beta.thin)
post.beta.stderr <- apply(ret.beta.thin, 1, sd) / sqrt(length(id.thin))
m.mcmc <- cbind(post.beta, post.beta.stderr)
rownames(m.mcmc) <- names(da.mcmc$beta)
colnames(m.mcmc) <- c("Estimate", "Std. Error")
if(comm.rank() == 0){
  print(m.mcmc)
}

finalize()
