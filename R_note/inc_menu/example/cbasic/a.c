#include<stdio.h>

int main(void){
  int a1 = 1 , a2 = 1 , a3 = 1;
  int b1 = 1 , b2 = 1, b3 = 1;
  int *c1, *c2;
  int d1[3] = {3, 2, 1}, *d2;

  printf("\nTest 1\n");
  printf("MSG: Initial value: a1 = %d, a2 = %d\n", a1, a2);
  a2 = fcn_aa(a1);
  printf("MSG: after a change: a1 = %d, a2 = %d\n", a1, a2);

  printf("------------\n\nTest 2\t");
  printf("(Pass \"the address of b1\" to function bb)\n");
  printf("MSG: Initial value: b1 = %d, b2 = %d\n", b1, b2);
  printf("MSG: Address of b1 (&b1): %x\n", &b1);
  b2 = fcn_bb(&b1);
  printf("MSG: after a change: b1 = %d, b2 = %d\n", b1, b2);
  printf("\t(These should be equal to *bb1)\n");

  c1 = &b1;
  printf("------------\n\nTest 3\n");
  printf("MSG: Initial value: c1 = &b1 = %x\n", c1);
  printf("\t(This should be equal to the address of b1)\n");
  printf("     c1 point to b1 which has same value *c1 = b1 = %d\n", *c1);
  printf("\t(This should be equal to the value of b2)\n");
  printf("     c1 is at address = %x\n\n", &c1);

  printf("(As Test2, but pass \"c1\" to function bb)\n");
  b3 = fcn_bb(c1);
  printf("(This should be twice of b1 in the first Test 2)\n");
  printf("MSG: after a change: b1 = %d, b2 = %d\n", b1, b2);
  printf("\t(These should be equal to *bb1)\n\n");

  printf("(As Test1, but pass \"*c1\" to function aa)\n");
  a3 = fcn_aa(*c1);
  printf("MSG: After a change: *c1 = %d (no changed), a3 = %d\n", *c1, a3);

  fcn_dd(d1);
  printf("------------\n\nTest 4\n");
  printf("MSG: array d1 = {%d %d %d}\n", d1[0], d1[1], d1[2]);

  return(0);
}

int fcn_aa(int aa1){
  printf("\taa MSG: Value of aa1: %x\n", aa1);
  aa1 = aa1 * 2;
  printf("\taa MSG: After a change, value: aa1 = %d\n", aa1);
  return(aa1);
}

int fcn_bb(int *bb1){
  printf("\tbb MSG: Value of bb1: %x\n", bb1);
  printf("\t\t(This should be the address of b1)\n");
  printf("\tbb MSG: Address of bb1 (&bb1): %x\n", &bb1);
  *bb1 = *bb1 * 2;
  printf("\tbb MSG: After a change, value: *bb1 = %d (changed)\n", *bb1);

  return(*bb1);
/*
  This is redundance. Replace by return(0) is enough.
  But it is a trick for some situation.  e.g. dynamic array, tree structure
*/
}

int fcn_dd(int *dd1){
  int i;

  for(i = 0; i < 3; i++){
    dd1[i] = dd1[i] * 2;
  }

  return(0);
}

