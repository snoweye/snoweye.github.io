# File name: loop_dyn.r

dyn.load("loop_dyn.so")
# For Windows will like this
# dyn.load("C:/Windows/Desktop/loop_dyn.dll")

my.loop <- 20
m.dim <- list(nrow = 200000, ncol = 10)
m <- matrix(1, nrow = m.dim$nrow, ncol = m.dim$ncol)
ret <- 0

dynsum.f <- function(m) {
  ret <- .Fortran("dynsum", nrow = nrow(m), ncol = ncol(m),
           m = as.double(m), ret = as.double(m))
  ret$ret
}

start <- Sys.time()
for(k in 1 : my.loop){
  ret <- ret + dynsum.f(m)
}
Sys.time() - start

dyn.unload("loop_dyn.so")
# For Windows will like this
# dyn.unload("C:/Windows/Desktop/loop_dyn.dll")

