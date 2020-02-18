# File name: loop_for_2.r

my.loop <- 20
m.dim <- list(nrow = 200000, ncol = 10)
m <- matrix(1, nrow = m.dim$nrow, ncol = m.dim$ncol)
ret <- 0

start <- Sys.time()
for(k in 1 : my.loop){
  for (j in 1 : m.dim$ncol){
    for (i in 1 : m.dim$nrow){
      ret <- ret + m[i, j]
    }
  }
}
Sys.time() - start

