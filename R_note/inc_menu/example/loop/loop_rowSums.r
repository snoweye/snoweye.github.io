# File name: loop_rowSums.r

my.loop <- 20
m.dim <- list(nrow = 200000, ncol = 10)
m <- matrix(1, nrow = m.dim$nrow, ncol = m.dim$ncol)
ret <- 0

start <- Sys.time()
for(k in 1 : my.loop){
  ret <- ret + sum(rowSums(m))
}
Sys.time() - start

