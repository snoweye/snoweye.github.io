  dev.off.wrap <- function(){
    dev.off()
    invisible()
  }

  bitmap(file = "%stdout", type="png256")
  pie(rep(1, 24), col = rainbow(24))
  title(sub = paste("It is ", date(), " at Taiwan", sep = ""))
  dev.off.wrap()
