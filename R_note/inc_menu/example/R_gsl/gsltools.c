/*
  File name: gstools.c
  For Linux,
  SHELL> gcc -c gsltools.c; gcc -shared -o gsltools.so gsltools.o -lgsl -lgslcblas
  For MS Windows,
  SHELL> gcc -c gsltools.c
  SHELL> gcc -shared -o gsltools.dll gsltools.o -lgsl -lgslcblas
*/

#include<gsl/gsl_permutation.h>

int allpermu(int *nrow, int *all){
  gsl_permutation *p;
  int i, j;

  p = gsl_permutation_alloc(*nrow);
  gsl_permutation_init(p);

  i = 0;
  do{
    for(j = 0; j < *nrow; j++){
      *(all + i + j) = (int) gsl_permutation_get(p, (size_t) j);
    }
    i += *nrow;
  }
  while(gsl_permutation_next(p) == GSL_SUCCESS);

  gsl_permutation_free (p);

  return 0;
}

