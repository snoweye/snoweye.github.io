library(nlme)
library(MASS)

### Function to generate new data set according to GLMM model fits by PQL.
gen.new.data <- function(x){
  da.new <- x
  for(i.farm in levels(da$Farm)){
    id <- which(da$Farm == i.farm)
    id.new <- sample(length(id), length(id), replace = TRUE)
    da.new[id,] <- da[id[id.new],]
  }
  da.new
} # End of gen.new.data().
