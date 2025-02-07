### Non-parametric bootstrap for the confidence interval for the
### GLMM model of Deer Ecervi L1 data set.

rm(list = ls())
source("u0-deer.r") # Load data.
source("u1-npbs.r") # Load library and utility.

### Bootstrap.
n.boot <- 100
set.seed(1234)

f <- function(i.boot){
  da.new <- gen.new.data(da)
  m.glmm <- glmmPQL(Y ~ Length * Sex, random = ~ 1 | Farm,
                    family = binomial, data = da.new, verbose = FALSE)
  ### Use list for returns.
  list(sigma = as.numeric(VarCorr(m.glmm)[, 2]),
       a.i = m.glmm$coefficient$random$Farm)
} # End of f().

ret <- lapply(1:n.boot, f)

### Collapse results.
ret.sigma <- do.call("cbind", lapply(ret, function(x){ x$sigma }))
ret.a.i <- do.call("cbind", lapply(ret, function(x){ x$a.i }))

### Find C.I.
probs <- c(0.025, 0.975)
ci.sigma <- apply(ret.sigma, 1, quantile, probs = probs)
colnames(ci.sigma) <- c("std.a", "std.Res")
ci.a.i <- apply(ret.a.i, 1, quantile, probs = probs)
print(ci.sigma)
print(ci.a.i)

### Exercise: Find C.I. for beta. 
