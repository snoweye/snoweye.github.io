#define MATHLIB_STANDALONE
#include <Rmath.h>

int main(){
  int i;
  unsigned int SEED1, SEED2;
  double mu, sigma, PHI_X, *X;

  mu = 0;
  sigma = 1;
  SEED1 = 12345;
  SEED2 = 67890;
  set_seed(SEED1, SEED2);

  X = (double *) malloc(10);
  for(i = 0; i < 10; i++){
    X[i] = rnorm(mu, sigma);
    PHI_X = pnorm(X[i], mu, sigma, 1, 0);
    printf("X: %f, PHI(X): %f\n", X[i], PHI_X);
  }
}
