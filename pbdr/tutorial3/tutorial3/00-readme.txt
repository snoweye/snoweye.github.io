### GLMM Model for Dear Ecervi L1 data.
###
### Y_{ij} ~ B(1, p_{ij})
### logit(p_{ij}) = beta_0 + beta_1 * Length_{ij} + beta_2 * Sex_{ij} +
###                 beta_3 * Length_{ij} * Sex_{ij} + a_i
### a_i ~ N(0, sigma^2_a)
### 
### Y_{ij} is 1 if deer j in farm i has E. cervi L1 and 0 otherwise.
###
### a_i is the random intercept.
###
### Sex = 1 for female deer, and 2 for male deer.

- 01-max_pql.r:
  (depends on u0-deer.r)
  Maximum penalized quasi-likelihood

- 1*-npbs_*.r:
  (depends on u0-deer.r and u1-npbs.r)
  Non-parametric bootstrap for confidence intervals.
  Independent Monte Carlo.
  Parallelization at the job level.

- 2*-mcmc_glm*.r:
  (depends on u0-deer.r and u2-mcmc_glm.r)
  MCMC approach for generalized linear models.
  Dependent iterations and independent chains.
  Parallelization at the chain level.

- 31-mcmc_glmm.r:
  (depends on u0-deer.r and u3-mcmc_glmm.r)
  MCMC approach for generalized linear mixed-effect models.

- 4*-mcmc_glmm*.r:
  (depends on u0-deer.r, u3-mcmc_glmm.r, and u4-mcmc_glmm.r)
  MCMC approach for generalized linear mixed-effect models.
  Dependent iterations.
  Parallelization within iterations.
