# File name: call_c.r

# dyn.load("call_c.so")
# For Windows will like this
# dyn.load("C:/Windows/Desktop/call_c.dll")

# symbol.C("hello")
# is.loaded(symbol.C("hello"))

# a <- 1 : 9

test.c <- function(a) {
  b <- a
  d <- vector(mode = "numeric", length = length(a))
  e <- vector(mode = "numeric", length = 1)
  ret <- .C("hello", m = length(a), a = as.double(a),
           b = as.double(b), d = as.double(d), e = as.double(e))
  ret
}

# test.c(a)

# dyn.unload("call_c.so")
# For Windows will like this
# dyn.unload("C:/Windows/Desktop/call_c.dll")

