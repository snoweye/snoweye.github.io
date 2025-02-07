# File name: ex_basic_serial.r
# Run: Rscript --vanilla ex_basic_serial.r

### Basic implication
my.basic <- function(x){
  ### This is the same as mean(x).
  N <- length(x)
  bar.x <- sum(x / N)

  ### This is the same as var(x).
  s.x <- sum(x^2 / (N - 1)) - bar.x^2 * (N / (N - 1))

  list(mean = bar.x, s = s.x)
} # End of my.basic().

### Main codes stat from here.
set.seed(1234)
N <- 100
x <- rnorm(N)
my.basic(x)
