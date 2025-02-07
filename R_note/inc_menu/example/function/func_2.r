# File name: func_2.r

hello <- function(a, ...){
  ret <- paste(a, ...)
  ret
}

test <- function(input = "molas") {
  a <- c("Hello", "world", input, "!")
  input <- NULL
  molas <- "molas"
  ret <- hello(a, collapse = " ")
  ret
}

molas <- "MOLAS"
input <- c("again,", molas)
input
test(input)
molas
input
test()
test(NULL)

