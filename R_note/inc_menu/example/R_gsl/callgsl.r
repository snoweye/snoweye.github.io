# File name: callgsl.r

dyn.load("/usr/lib/libgslcblas.so", local = FALSE, now = FALSE)
dyn.load("/usr/lib/libgsl.so", local = FALSE, now = FALSE)
dyn.load("gsltools.so")
### For MS Windows, they will be like these
# dyn.load("C:/PROGRA~1/RTOOLS/MINGW/BIN/LIBGSLCBLAS.DLL")
# dyn.load("C:/PROGRA~1/RTOOLS/MINGW/BIN/LIBGSL.DLL")
# dyn.load("gsltools.dll")

allpermu <- function(n){
#  if(n > 10) stop("allpermu: n <= 10")
  ncol <- as.integer(factorial(n))
  nrow <- as.integer(n)
  all <- vector(mode = "integer", length = nrow * ncol)
  ret <- .C("allpermu", nrow, all)[[2]]
  matrix(ret, nrow = nrow) + 1
}

allpermu(3)

dyn.unload("gsltools.so")
dyn.unload("/usr/lib/libgsl.so")
dyn.unload("/usr/lib/libgslcblas.so")
### For MS Windows, they will be like these
# dyn.unload("gsltools.dll")
# dyn.unload("C:/PROGRA~1/RTOOLS/MINGW/BIN/LIBGSL.DLL")
# dyn.unload("C:/PROGRA~1/RTOOLS/MINGW/BIN/LIBGSLCBLAS.DLL")
