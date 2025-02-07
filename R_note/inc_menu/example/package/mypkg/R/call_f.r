# File name: call_f.r

# dyn.load("call_f.so")
# For Windows will like this
# dyn.load("C:/Windows/Desktop/call_f.dll")

# symbol.For("hello")
# is.loaded(symbol.For("hello"))

# a <- 1 : 9

test.f <- function(a) {
  b <- a
  d <- vector(mode = "numeric", length = length(a))
  e <- vector(mode = "numeric", length = 1)
  ret <- .Fortran("hello", m = length(a), a = as.double(a),
           b = as.double(b), d = as.double(d), e = as.double(e))
  ret
}

# test.f(a)

# dyn.unload("call_f.so")
# For Windows will like this
# dyn.unload("C:/Windows/Desktop/call_f.dll")

