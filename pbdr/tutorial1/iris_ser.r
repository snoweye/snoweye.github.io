rm(list = ls())                                       # Clean environment

### Load data
X <- as.matrix(iris[, -5])                            # Dimension 150 by 4
X.cid <- as.numeric(iris[, 5])                        # True id

### Transformation and check
X.std <- scale(X)                                     # Standardize
mu <- colMeans(X.std)                                 # Columns means are near 0
cov <- cov(X.std)                                     # Diagonals are near 1
print(mu)
print(cov)

### SVD
X.svd <- svd(X.std)

### Project on column space of singular vectors
A <- X.svd$u %*% diag(X.svd$d)
B <- X.std %*% X.svd$v                                # A ~ B
X.prj <- A[, 1:2]

### Clustering
set.seed(1234)                                        # Set overall seed
X.kms <- kmeans(X.std, 3)                             # K-means
X.kms
X.kms.cid <- X.kms$cluster                            # Classification

library(EMCluster)                                    # Model-based clustering
X.mbc <- init.EM(X.std, 3)                            # Initial by em-EM
X.mbc
X.mbc.cid <- X.mbc$class                              # Classification

### Validation
(X.kms.adjR <- RRand(X.cid, X.kms.cid)$adjRand)       # Adjusted Rand index
(X.mbc.adjR <- RRand(X.cid, X.mbc.cid)$adjRand)

### Swap classification id
tmp <- X.kms.cid
X.kms.cid[tmp == 2] <- 3
X.kms.cid[tmp == 3] <- 2
tmp <- X.mbc.cid
X.mbc.cid[tmp == 2] <- 3
X.mbc.cid[tmp == 3] <- 2

### Display on first 2 components
par(mfrow = c(2, 2))
plot(X.prj, col = X.cid + 1, pch = X.cid,
     main = "iris (true)", xlab = "PC1", ylab = "PC2")
plot(X.prj, col = X.kms.cid + 1, pch = X.kms.cid,
     main = paste("iris (kmeans)", sprintf("%.4f", X.kms.adjR)),
     xlab = "PC1", ylab = "PC2")
plot(X.prj, col = X.mbc.cid + 1, pch = X.mbc.cid,
     main = paste("iris (model-based)", sprintf("%.4f", X.mbc.adjR)),
     xlab = "PC1", ylab = "PC2")
