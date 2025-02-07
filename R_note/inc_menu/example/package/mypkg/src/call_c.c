/*
  File name: call_c.c
  For dynamical load compile by gcc.
  SHELL> gcc -c call_c.c ; gcc -shared -o call_c.so call_c.o
*/

void hello(int *m, double *a, double *b, double *c, double *d){
  int i;

  *d = 0;
  for(i = 0; i < *m; i++){
    c[i] = a[i] + b[i];
    *d += c[i];
    a[i] = 0;
  }
}

/* Output is a shared library "call_c.so" can called by R. */
