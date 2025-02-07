#include<R.h>
#include<Rinternals.h>

void vitamin_c(SEXP R_n, int **C_n){
    *C_n = INTEGER(R_n);
}

SEXP poison(SEXP R_n){
    int i, *C_n_1, *C_n_2;
    double *C_new_1, *C_new_2;
    SEXP new_1, new_2, ret, ret_names;
    char *names[2] = {"new.1", "new.2"};

    /* Both have the same results. */
    vitamin_c(R_n, &C_n_1);
    C_n_2 = INTEGER(R_n);

    /* protect R objects in C. */
    PROTECT(new_1 = allocVector(REALSXP, 1));
    PROTECT(new_2 = allocVector(REALSXP, 1));
    PROTECT(ret = allocVector(VECSXP, 2));
    PROTECT(ret_names = allocVector(STRSXP, 2));
  
    /* set a list object for R. */
    SET_VECTOR_ELT(ret, 0, new_1);
    SET_VECTOR_ELT(ret, 1, new_2);

    /* set list's names for R. */
    for(i = 0; i < 2; i++){
      SET_STRING_ELT(ret_names, i, mkChar(names[i])); 
    }
    setAttrib(ret, R_NamesSymbol, ret_names);

    /* assign points to R objects. */
    C_new_1 = REAL(new_1);
    C_new_2 = REAL(new_2);

    /* update for return to R. */
    *C_new_1 = (double) (*C_n_1 + 1);
    *C_new_2 = (double) (*C_n_2 + 1);
  
    /* unprotect for R. */
    UNPROTECT(4);
    return(ret);
}
