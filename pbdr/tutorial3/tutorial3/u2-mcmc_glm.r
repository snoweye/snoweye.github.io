library(nlme)
library(MASS)

get.glm.initial <- function(da){
  m.glm <- glm(Y ~ Length * Sex, family = binomial, data = da)
  ret <- list(y = da$Y,
              X = cbind(1, da$Length, da$Sex, da$Length * da$Sex),
              beta = m.glm$coefficients,
              Sigma = summary(m.glm)$cov.unscaled)
  ret
} # End of get.glm.initial().

propose.glm.beta <- function(param, da.mcmc, tau = 1){
  ### Random walk.
  beta.new <- mvrnorm(1, param$beta, tau * da.mcmc$Sigma)
  logL.new <- logL.glm(beta.new, da.mcmc)

  ### Acceptance and rejection step.
  alpha <- min(0, logL.new - param$logL)
  if(!is.nan(alpha) && log(runif(1)) < alpha){
    param <- list(beta = beta.new, logL = logL.new)
  }
  param
} # End of propose.glm.beta().

logL.glm <- function(beta, da.mcmc){
  num <- exp(da.mcmc$X %*% beta)
  P <- num / (1 + num)
  ret <- sum(da.mcmc$y * log(P) + (1 - da.mcmc$y) * log(1 - P))
  ret
} # End of logL.glm().

