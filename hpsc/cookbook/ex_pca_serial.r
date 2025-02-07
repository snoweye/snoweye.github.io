# File name: ex_pca_serial.r
# Run: Rscript --vanilla ex_pca_serial.r

### PCA implication
my.pca.projection <- function(X, alpha = 0.5){
  ### Standardized.
  X.mean <- colMeans(X)
  X.std <- apply(X, 2, function(x) sqrt(var(x)))
  Y <- t((t(X) - X.mean) / X.std)

  ### Apply SVD.
  # Y.svd <- svd(Y)
  # u <- Y.svd$u
  # d <- Y.svd$d
  # v <- Y.svd$v

  ### The followings are equivalent to svd(Y), here I want to show how to think
  ### in parallel and what may be a good way to parallelize a original method.

  ### Use eigen values decomposition on Y^t %*% Y to get singular values and v.
  ### Then, solve system V %*% D %*% U^t = Y^t as AX = B to get u.
  ### Note: the results may have a sign change and differ to that of svd()
  ###       since the orthogonal basis is not unique.
  Y.cov <- t(Y) %*% Y
  Y.eigen <- eigen(Y.cov)
  d <- sqrt(Y.eigen$values)
  v <- Y.eigen$vectors
  u <- t(solve(v %*% diag(d), t(Y)))

  ### Obtain the projection onto the first two principal components.
  set.N <- t(t(u[, 1:2]) * d[1:2]^alpha)
  set.p <- t(t(v[, 1:2]) * d[1:2]^(1 - alpha))

  list(set.N = set.N, set.p = set.p)
} # End of my.pca.projection().

### Main codes start from here.
set.seed(1234)
N <- 100
p <- 4
X <- matrix(rnorm(N * p), ncol = p)
Z <- my.pca.projection(X)

### Biplot
plot(NULL, NULL, type = "n", axes = FALSE, main = "PCA",
     xlab = "Principal Component 1", ylab = "Principal Component 2",
     xlim = range(c(Z$set.N[, 1], Z$set.p[, 1])),
     ylim = range(c(Z$set.N[, 2], Z$set.p[, 2])))
points(Z$set.N[, 1], Z$set.N[, 2], col = "red")
arrows(0, 0, Z$set.p[, 1], Z$set.p[, 2], length = 0.1, col = "blue", lwd = 1.1)
box()
