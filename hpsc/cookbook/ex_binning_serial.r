# File name: ex_binning_serial.r
# Run: Rscript --vanilla ex_binning_serial.r

### A famous example from help("cut") in R.
set.seed(1234)
N <- 100
y <- rnorm(N)

### Based on breaks to count data.
table(cut(y, breaks = pi / 3 * (-3:3)))
