# File name: loop_for_1.r

my.loop <- 20
m.dim <- list(nrow = 200000, ncol = 10)
m <- matrix(1, nrow = m.dim$nrow, ncol = m.dim$ncol)
ret <- 0

start <- Sys.time()
for(k in 1 : my.loop){
  for (i in 1 : m.dim$nrow){
    for (j in 1 : m.dim$ncol){
      ret <- ret + m[i, j]
    }
  }
}
Sys.time() - start

