library(phyclust)

### Generate trees.
set.seed(1234)
K <- 3
N <- 50
N.K <- c(15, 20, 15)
X.class <- rep(1:K, N.K)

tree.K <- list()
tree.K[[1]] <- gen.unit.K(K, N.K, rate.anc = 0.1, rate.dec = 100)
tree.K[[2]] <- gen.unit.K(K, N.K, rate.anc = 100, rate.dec = 100)
tree.K[[3]] <- gen.unit.K(K, N.K, rate.anc = 0.1, rate.dec = 0.1)
tree.K[[4]] <- gen.unit.K(K, N.K, rate.anc = 100, rate.dec = 0.1)

### Layout
windows(8.5, 5.5)
mf <- matrix(0, nrow = 6, ncol = 9)
mf[1, 2:9] <- 37
mf[2, 2:9] <- 1:8
mf[3:5, 1] <- 9:11
mf[3:5, 2:9] <- matrix(12:35, nrow = 3, ncol = 8)
mf[6, 2:9] <- 36
width <- c(1.0, rep(5, 8))
height <- c(0.7, 0.5, rep(4, 3), 1.6)
nf <- layout(mf, width, height, FALSE)

### For top and left strips
par(mar = rep(0, 4), xaxs = "i", yaxs = "i")

lab <- c("(0.1,100,0.05)", "(0.1,100,0.1)", "(100,100,0.05)", "(100,100,0.1)",
         "(0.1,0.1,0.05)", "(0.1,0.1,0.1)", "(100,0.1,0.05)", "(100,0.1,0.1)")
for(j in 1:8){
  plot(NULL, NULL, xlim = c(0, 1), ylim = c(0, 1), axes = FALSE,
       xlab = "", ylab = "")
  rect(0, 0, 1, 1, col = "#ffe5cc", border = NA)
  box()
  text(0.5, 0.5, labels = lab[j], cex = 1.3)
}

lab <- c("max", "equal", "star")
for(i in 1:3){
  plot(NULL, NULL, xlim = c(0, 1), ylim = c(0, 1), axes = FALSE,
       xlab = "", ylab = "")
  rect(0, 0, 1, 1, col = "#ccffcc", border = NA)
  box()
  text(0.5, 0.5, labels = lab[i], cex = 1.3, srt = 90)
}

### Draw all panels.
par(mar = rep(0, 4), xaxs = "r", yaxs = "r")

h.s <- c(0.05, 0.1)
for(j in 1:4){
  for(k in 1:2){
    for(i in c("max", "equal", "star")){
      tree.plot <- rescale.rooted.tree(tree.K[[j]][[i]], scale.height = h.s[k])
      plotnj(tree.plot, X.class = X.class, type = "c",
              edge.width = 1.2, edge.width.class = 1.5,
              x.lim = c(-0.01, 0.11), y.lim = c(0, 51))
      abline(v = axis.at, lty = 2, lwd = 1.2, col = "lightgray")
      box()
      if(i == "star"){
        axis(1, at = seq(0, 0.1, 0.02), lab = c("", seq(0.02, 0.08, 0.02), ""),
             las = 2)
      }
    }
  }
}

### Draw labels.
par(mar = rep(0, 4), xaxs = "i", yaxs = "i")
plot(NULL, NULL, xlim = c(0, 1), ylim = c(0, 1), axes = FALSE,
     xlab = "", ylab = "")
text(0.5, 0.2, labels = "Coalescent Time", cex = 1.5)

main.text <- expression(group("(",
               list(italic(r[a]), italic(r[d]), italic(h[s])), ")"))
plot(NULL, NULL, xlim = c(0, 1), ylim = c(0, 1), axes = FALSE,
     xlab = "", ylab = "")
text(0.5, 0.5, labels = main.text, cex = 1.5)
