### MCMC for the GLMM model of Deer Ecervi L1 data set.

rm(list = ls())
source("u0-deer.r")         # Load data.
source("u3-mcmc_glmm.r")    # Load library and utility.
source("u4-mcmc_glmm_mclapply.r")
library(parallel)

### MCMC.
n.iters <- 1000
id.thin <- seq(500, n.iters, by = 10)

### Setup initial step.
da.mcmc <- get.glmm.initial(da)
logL.curr <- logL.glmm(da.mcmc$fixed, da.mcmc$random, da.mcmc$sd.random,
                       da.mcmc)
param <- list(fixed = da.mcmc$fixed, random = da.mcmc$random,
              sd.random = da.mcmc$sd.random, logL = logL.curr)

### Run M-H.
set.seed(1234)
ret.fixed <- list()
ret.random <- list()
ret.sd.random <- list()
for(i.iter in 1:n.iters){
  ### Update fixed effects.
  param <- propose.glmm.fixed(param, da.mcmc)
  ret.fixed[[i.iter]] <- param$fixed    # Save parameters.

  ### Update random effects.
  param <- propose.glmm.random.mclapply(param, da.mcmc)
  ret.random[[i.iter]] <- param$random    # Save parameters.

  ### Update sd.random.
  param <- propose.glmm.sd.random(param, da.mcmc)
  ret.sd.random[[i.iter]] <- param$sd.random    # Save parameters.
}

### Collapse results.
ret.fixed.thin <- do.call("cbind", ret.fixed[id.thin])
ret.random.thin <- do.call("cbind", ret.random[id.thin])
ret.sd.random.thin <- do.call("c", ret.sd.random[id.thin])

### Posterior mean and it's standard error.
post.fixed <- rowMeans(ret.fixed.thin)
post.fixed.stderr <- apply(ret.fixed.thin, 1, sd) / sqrt(length(id.thin))
m.mcmc <- cbind(post.fixed, post.fixed.stderr)
rownames(m.mcmc) <- names(da.mcmc$fixed)
colnames(m.mcmc) <- c("Estimate", "Std. Error")
cat("fixed effects:\n")
print(m.mcmc)

### Posterior mean of sd.random.
m.mcmc.sd.random <- c(mean(ret.sd.random.thin),
                      sd(ret.sd.random.thin) / sqrt(length(id.thin)))
names(m.mcmc.sd.random) <- c("Estimate", "Std. Error")
cat("\nsigma of random effect:\n")
print(m.mcmc.sd.random)
