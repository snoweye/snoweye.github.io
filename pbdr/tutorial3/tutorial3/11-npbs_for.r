### Non-parametric bootstrap for the confidence interval for the
### GLMM model of Deer Ecervi L1 data set.

rm(list = ls())
source("u0-deer.r") # Load data.
source("u1-npbs.r") # Load library and utility.

### Bootstrap.
n.boot <- 100
set.seed(1234)

ret.sigma <- NULL
ret.a.i <- NULL
for(i.boot in 1:n.boot){
  da.new <- gen.new.data(da)
  m.glmm <- glmmPQL(Y ~ Length * Sex, random = ~ 1 | Farm,
                    family = binomial, data = da.new, verbose = FALSE)

  ### Collapse results.
  ret.sigma <- cbind(ret.sigma, as.numeric(VarCorr(m.glmm)[, 2]))
  ret.a.i <- cbind(ret.a.i, m.glmm$coefficient$random$Farm)
}

### Find C.I.
probs <- c(0.025, 0.975)
ci.sigma <- apply(ret.sigma, 1, quantile, probs = probs)
colnames(ci.sigma) <- c("std.a", "std.Res")
ci.a.i <- apply(ret.a.i, 1, quantile, probs = probs)
print(ci.sigma)
print(ci.a.i)

### Exercise: Estimate mean and median of variation.
