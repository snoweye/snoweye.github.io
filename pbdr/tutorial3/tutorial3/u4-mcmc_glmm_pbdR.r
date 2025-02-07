library(nlme)
library(MASS)

### Overwrite stats::runif() to have consistant acceptance and rejection step
### for fixed effects and  sd.random.
runif <- function(n = 1, min = 0, max = 1){
  bcast(stats::runif(n, min = min, max = max))
} # End of runif().

propose.glmm.random.task.pull <- function(param, da.mcmc, tau = 1){
  f <- function(i.random){
    ### Random walk.
    random.new <- param$random
    random.new[i.random] <- rnorm(1, mean = param$random[i.random],
                                  sd = tau * da.mcmc$sd.random)
    logL.new <- logL.glmm(param$fixed, random.new, param$sd.random, da.mcmc)

    ### Acceptance and rejection step.
    alpha <- min(0, logL.new - param$logL)
    if(!is.nan(alpha) && log(stats::runif(1)) < alpha){
      ret <- random.new[i.random]
    } else{
      ret <- param$random[i.random]
    }
    ret
  } # End of f().

  ret <- task.pull(1:length(param$random), f, bcast = TRUE)
  ### Exercise: Why do I must use "bcast = TRUE" here?
                 
  param$random <- do.call("c", ret)
  ### Update logL with the new set of random effects.
  param$logL <- logL.glmm(param$fixed, param$random, param$sd.random, da.mcmc)
  param
} # End of propose.glmm.random.task.pull().
