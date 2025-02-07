library(phyclust)

### Read Data.
data.path <- paste(.libPaths()[1], "/phyclust/data/pony625.fas", sep = "")
my.625 <- read.fasta(data.path)
X <- my.625$org

### Run a silly phyclust() in 4 clusters.
set.seed(1234)
K <- 4
EMC <- .EMControl(init.procedure = "emEM")
ret <- phyclust(X, K, EMC = EMC)

### Run paml.baseml on central sequences to obtain the stem tree.
ret.stem <- paml.baseml(ret$Mu)

### Run paml.baseml on every clusters.
opts <- paml.baseml.control(clock = 1)
ret.leaves <- NULL
for(k in 1:K){
  ### Warning: this loop may take several minutes.
  id <- ret$class.id == k
  if(sum(id) > 1){
    X.sub <- matrix(X[id,], nrow = sum(id))
    ret.leaves[[k]] <- paml.baseml(X.sub, opts = opts)
  } else{
    ret.leaves[[k]] <- list(best.tree = paste("(1: ", ret$QA$Tt, ");", sep = ""))
    class(ret.leaves[[k]]) <- "baseml"
  }
}

### Joint the leaves to the stem.
tree.stem <- read.tree(text = ret.stem$best.tree)
tree.est <- tree.stem
tree.sub <- NULL
for(k in 1:K){
  tree.sub[[k]] <- read.tree(text = ret.leaves[[k]]$best.tree)
  org.height <- get.rooted.tree.height(tree.sub[[k]])
  if(org.height > 0){
    scale.height <- ret$QA$Tt / org.height
  } else{
    scale.height <- 1
  }
  tree.sub[[k]] <-
    rescale.rooted.tree(tree.sub[[k]], scale.height = scale.height)
  tree.sub[[k]]$tip.label <-
    my.625$seqname[ret$class.id == k][as.numeric(tree.sub[[k]]$tip.label)]

  tree.est <- bind.tree(tree.est, tree.sub[[k]],
                        where = which(tree.est$tip.label == as.character(k)))
}

### Plot trees.
K <- as.numeric(tree.stem$tip.label)
windows()
layout(matrix(c(rep(1, 4), 2:5, rep(6, 4)), nrow = 3, byrow = TRUE))
par(mar = c(1, 0, 2, 1))
tree.stem$tip.label <- paste("k = ", K, sep = "")
plot(tree.stem, direction = "downwards", tip.color = .Color[K], cex = 1.2)
title(main = "stem")
for(k in K){
  plot(tree.sub[[k]], direction = "downwards", tip.color = .Color[k], cex = 1.2)
  title(main = paste("k = ", k, sep = ""))
}
y <- data.frame(seqname = my.625$seqname, id = ret$class.id)
x <- data.frame(seqname = tree.est$tip.label)
z <- merge(x, y, sort = FALSE)
plot(tree.est, direction = "downwards", tip.color = .Color[z$id], cex = 1.2)
title(main = "full")

