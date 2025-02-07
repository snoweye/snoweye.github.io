# File name: lam-mpi_ms.r

call.mpi.master <- function(){
  library(Rmpi)
  mpi.spawn.Rslaves(needlog = FALSE)
  mpi.bcast.Robj2slave(call.mpi.slave)
  mpi.bcast.cmd(call.mpi.slave())

  x <- 100
  mpi.bcast(as.integer(x), type = 1)

  mysize <- mpi.universe.size()
  y <- 200
  for(i in 1 : mysize){
    mpi.send(as.integer(y), type = 1, dest = i, tag = 1)
  }

  ret <- NULL
  for(i in 1 : mysize){
    ret.slave <- mpi.recv.Robj(source = i, tag = 2)
    ret <- rbind(ret, ret.slave)
  }
  ret
}

call.mpi.slave <- function(){
  x <- mpi.bcast(integer(1), type = 1)
  y <- mpi.recv(integer(1), type = 1, source = 0, tag = 1)

  myrank <- mpi.comm.rank()

  ret.slave <- c(myrank, x, y, myrank, x * myrank + y)
  mpi.send.Robj(ret.slave, dest = 0, tag = 2)
}

call.mpi.master()
