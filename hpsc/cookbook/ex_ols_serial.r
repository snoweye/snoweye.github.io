# File name: ex_ols_serial.r
# Run: Rscript --vanilla ex_ols_serial.r

### Main codes stat from here.
set.seed(1234)
N <- 100
p <- 2
X <- matrix(rnorm(N * p), ncol = p)
beta <- c(1, 2)
epsilon <- rnorm(N)
Y <- X %*% beta + epsilon

### Obtain beta hat.
(beta.hat <- solve(t(X) %*% X) %*% t(X) %*% Y)
