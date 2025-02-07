da <- read.table("DeerEcervi.txt", sep = "\t", quote = "", header = TRUE)
### Add responses according to if Ecervi observed.
da$Y <- rep(0, length(da$Ecervi))
da$Y[da$Ecervi > 0] <- 1

# da$Sex <- as.factor(da$Sex)
da$Sex <- da$Sex - 1
da$Length <- da$Length - mean(da$Length)

da$Farm.id <- as.integer(da$Farm)
