# File name: func_1.r

hello <- function(input){
  a <- c("Hello", "world", input, "!")
  input <- NULL
  molas <- "molas"
  ret <- paste(a, collapse = " ")
  ret
}

molas <- "MOLAS"
input <- c("again,", molas)
input
hello(input)
molas
input
hello()
hello(NULL)

