#include <R.h>
#include <Rmath.h>

void callR(){
  int i;
  double mu, sigma, PHI_X, *X;

  mu = 0;
  sigma = 1;

  X = (double *) R_alloc(10, sizeof(double));

  Rprintf("Before sort\n");
  GetRNGstate();
  for(i = 0; i < 10; i++){
    X[i] = rnorm(mu, sigma);
    PHI_X = pnorm(X[i], mu, sigma, 1, 0);
    Rprintf("X: %f, PHI(X): %f\n", X[i], PHI_X);
  }
  PutRNGstate();

  R_rsort(X, 10);
  Rprintf("After sort\n");
  for(i = 0; i < 10; i++){
    PHI_X = pnorm(X[i], mu, sigma, 1, 0);
    Rprintf("X: %f, PHI(X): %f\n", X[i], PHI_X);
  }
}
