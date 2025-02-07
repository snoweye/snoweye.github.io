library(nlme)
library(MASS)

get.glmm.initial <- function(da){
  m.glmm <- glmmPQL(Y ~ Length * Sex, random = ~ 1 | Farm,
                    family = binomial, data = da, verbose = FALSE)
  ret <- list(y = da$Y,
              X = cbind(1, da$Length, da$Sex, da$Length * da$Sex),
              n.state = as.vector(table(da$Farm)),
              fixed = m.glmm$coefficients$fixed,
              random = as.vector(m.glmm$coefficients$random[[1]]),
              Sigma.fixed = m.glmm$varFix,
              sd.random = as.numeric(VarCorr(m.glmm)[1, 2]))
  ret
} # End of get.glmm.initial().

propose.glmm.fixed <- function(param, da.mcmc, tau = 1){
  ### Random walk.
  fixed.new <- mvrnorm(1, param$fixed, tau * da.mcmc$Sigma.fixed)
  logL.new <- logL.glmm(fixed.new, param$random, param$sd.random, da.mcmc)

  ### Acceptance and rejection step.
  alpha <- min(0, logL.new - param$logL)
  if(!is.nan(alpha) && log(runif(1)) < alpha){
    param$fixed <- fixed.new
    param$logL <- logL.new
  }
  param
} # End of propose.glmm.fixed().

propose.glmm.random <- function(param, da.mcmc, tau = 1){
  for(i.random in 1:length(param$random)){
    ### Random walk.
    random.new <- param$random
    random.new[i.random] <- rnorm(1, mean = param$random[i.random],
                                  sd = tau * da.mcmc$sd.random)
    logL.new <- logL.glmm(param$fixed, random.new, param$sd.random, da.mcmc)

    ### Acceptance and rejection step.
    alpha <- min(0, logL.new - param$logL)
    if(!is.nan(alpha) && log(runif(1)) < alpha){
      param$random <- random.new
      param$logL <- logL.new
    }
  }
  param
} # End of propose.glmm.random().

propose.glmm.sd.random <- function(param, da.mcmc){
  ### Independent chain with inversed Chi-squared distribution.
  sd.random.new <- 1 / rgamma(1, da.mcmc$sd.random / 2, 2)
  logL.new <- logL.glmm(param$fixed, param$random, sd.random.new, da.mcmc)

  ### Acceptance and rejection step.
  alpha <- min(0, logL.new - param$logL)
  if(!is.nan(alpha) && log(runif(1)) < alpha){
    param$sd.random <- sd.random.new
    param$logL <- logL.new
  }
  param
} # End of propose.glmm.random().

logL.glmm <- function(fixed, random, sd.random, da.mcmc){
  num <- exp(da.mcmc$X %*% fixed + rep(random, da.mcmc$n.state))
  P <- num / (1 + num)
  ret <- sum(da.mcmc$y * log(P) + (1 - da.mcmc$y) * log(1 - P)) +
         sum(dnorm(random, mean = 0, sd = sd.random, log = TRUE))
  ret
} # End of logL.glmm().
