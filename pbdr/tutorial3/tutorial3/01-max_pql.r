### Maximizing penalize quasi likelihood for the GLMM model of Deer Ecervi L1
### data set.

rm(list = ls())
source("u0-deer.r")   # data.
library(nlme)         # Load library and utility.
library(MASS)

### Fit by PQL.
m.pql <- glmmPQL(Y ~ Length * Sex, random = ~ 1 | Farm,
                 family = binomial, data = da, verbose = FALSE)
summary(m.pql)

### Find sigma and sigma_a.
VarCorr(m.pql)

### Find a_{21} for TN.
id.TN <- which(rownames(m.pql$coefficient$random$Farm) == "TN")
m.pql$coefficient$random$Farm[id.TN,]
