# File name: ex_mvn_serial.r
# Run: Rscript --vanilla ex_mvn_serial.r

### Main codes start from here.
set.seed(1234)
N <- 100
p <- 2
X <- matrix(rnorm(N * p), ncol = p)
mu <- c(0.1, 0.2)
Sigma <- matrix(c(0.9, 0.1, 0.1, 0.9), ncol = p)

### Cholesky decomposition.
U <- chol(Sigma)
logdet <- sum(log(abs(diag(U))))
B <- t(X) - mu
A <- backsolve(U, B, upper.tri = TRUE, transpose = TRUE)
distval <- colSums(A * A)

(total.logL <- -0.5 * (N * (p * log(2 * pi) + logdet * 2) + sum(distval)))

