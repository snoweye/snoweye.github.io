# File name: rmpi_for_2.r

loop.fun <- function(){
  ##
  # Modify from loop_for_2.r
  ##
  m.dim <- list(nrow = 200000, ncol = 10)
  m <- matrix(1, nrow = m.dim$nrow, ncol = m.dim$ncol)
  ret <- 0

  for (j in 1 : m.dim$ncol){
    for (i in 1 : m.dim$nrow){
      ret <- ret + m[i, j]
    }
  }
}

call.mpi.master <- function(){
  library(Rmpi)
  mpi.spawn.Rslaves(needlog = FALSE)
  mpi.bcast.Robj2slave(call.mpi.slave)
  mpi.bcast.cmd(call.mpi.slave())
  mpi.bcast.Robj(loop.fun)

  my.size <- mpi.universe.size()
  my.loop <- 20 
  my.split <- data.frame(loop = 1 : my.loop,
                         rank = sort(c(rep(1 : my.size, my.loop %/% my.size),
                                if(my.loop %% my.size > 0)
                                (my.size : 2)[1 : (my.loop %% my.size)])))

  for(i in 1 : my.size){
    mpi.send.Robj(my.split$loop[my.split$rank == i], dest = i, tag = 1)
  }

  ret <- 0
  for(i in 1 : my.size){
    ret <- ret + mpi.recv(integer(1), type = 1, source = i, tag = 2)
  }
  ret
}

call.mpi.slave <- function(){
  loop.fun <- eval(mpi.bcast.Robj())
  my.loop <- mpi.recv.Robj(source = 0, tag = 1)

  ret <- 0
  for(i in my.loop){
    ret <- ret + loop.fun()
  }
  mpi.send(as.integer(ret), type = 1, dest = 0, tag = 2)
}

start <- Sys.time()
call.mpi.master()
Sys.time() - start

