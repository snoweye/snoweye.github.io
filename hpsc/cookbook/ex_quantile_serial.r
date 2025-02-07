# File name: ex_quantile_serial.r
# Run: Rscript --vanilla ex_quantile_serial.r

### Main codes start from here.
set.seed(1234)
N <- 100
y <- rnorm(N)

### Obtain 95% quantile.
quantile(y, probs = 0.95, names = FALSE)

