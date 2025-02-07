dyn.load("callR.so")
set.seed(10)
out <- .C("callR")
dyn.unload("callR.so")
