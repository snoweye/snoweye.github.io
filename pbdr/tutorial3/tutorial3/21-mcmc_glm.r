### MCMC for the GLMM model of Deer Ecervi L1 data set.

rm(list = ls())
source("u0-deer.r")        # Load data.
source("u2-mcmc_glm.r")    # Load library and utility.

### MCMC.
n.iters <- 1000
id.thin <- seq(500, n.iters, by = 10)

### Setup initial step.
da.mcmc <- get.glm.initial(da)
logL.curr <- logL.glm(da.mcmc$beta, da.mcmc)
param <- list(beta = da.mcmc$beta, logL = logL.curr)

### Run M-H.
set.seed(1234)
ret.beta <- list()
for(i.iter in 1:n.iters){
  param <- propose.glm.beta(param, da.mcmc)
  ret.beta[[i.iter]] <- param$beta    # Save parameters.
}
ret.beta.thin <- do.call("cbind", ret.beta[id.thin])

### Posterior mean and it's standard error.
post.beta <- rowMeans(ret.beta.thin)
post.beta.stderr <- apply(ret.beta.thin, 1, sd) / sqrt(length(id.thin))
m.mcmc <- cbind(post.beta, post.beta.stderr)
rownames(m.mcmc) <- names(da.mcmc$beta)
colnames(m.mcmc) <- c("Estimate", "Std. Error")
print(m.mcmc)

### Exercise: Find 95% creditable intervals for beta.
