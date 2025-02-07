unit useful;

interface

TYPE
  PPOINTER = ^POINTER;
  PZPOINTER_ARRAY = ^ZPOINTER_ARRAY;
  ZPOINTER_ARRAY = ARRAY[ 0..99] OF PZPOINTER_ARRAY;
  ARRAY_1P = PZPOINTER_ARRAY;

  LONGINT_ARRAY = ARRAY[1..99] OF LONGINT;
  PLONGINT_ARRAY = ^LONGINT_ARRAY;

  ZLONGINT_array = ARRAY[ 0..99] OF LONGINT;
  PZLONGINT_array = ^ZLONGINT_array;
  BOOLEAN_ARRAY = ARRAY[ 1..99] OF BOOLEAN;
  PBOOLEAN_ARRAY = ^BOOLEAN_ARRAY;
  ZBOOLEAN_ARRAY = ARRAY[ 0..99] OF BOOLEAN;
  PZBOOLEAN_ARRAY = ^ZBOOLEAN_ARRAY;
  SINGLE_ARRAY = ARRAY[ 1..99] OF SINGLE;
  PSINGLE_ARRAY = ^SINGLE_array;
  ZSINGLE_ARRAY = ARRAY[ 0..99] OF SINGLE;
  PZSINGLE_ARRAY = ^ZSINGLE_array;

  // The preferred way of adding dimensions is:
  ARRAY_1L = PZLONGINT_ARRAY;
    ZAR_ARRAY_1L = ARRAY[ 0..99] OF ARRAY_1L;
  ARRAY_2L = ^ZAR_ARRAY_1L;
    ZAR_ARRAY_2L = ARRAY[ 0..99] OF ARRAY_2L;
  ARRAY_3L = ^ZAR_ARRAY_2L;

  DOUBLE_ARRAY = ARRAY[1..99] OF DOUBLE;
  PDOUBLE_ARRAY = ^DOUBLE_ARRAY;
  ZDOUBLE_ARRAY = ARRAY[ 0..99] OF DOUBLE;
  PZDOUBLE_ARRAY = ^ZDOUBLE_ARRAY;
  AR_PZDOUBLE_ARRAY = ARRAY[ 0..99] OF PZDOUBLE_ARRAY;
  PAR_PZDOUBLE_ARRAY = ^AR_PZDOUBLE_ARRAY;
  ARRAY_1D = PZDOUBLE_ARRAY;
  ARRAY_2D = PAR_PZDOUBLE_ARRAY;
    AR_PAR_PZDOUBLE_ARRAY = ARRAY[ 0..99] OF PAR_PZDOUBLE_ARRAY;
    PAR_PAR_PZDOUBLE_ARRAY = ^AR_PAR_PZDOUBLE_ARRAY;
  ARRAY_3D = PAR_PAR_PZDOUBLE_ARRAY;
    ZAR_PARRAY_3D = ARRAY[ 0..99] OF ARRAY_3D;
  ARRAY_4D = ^ZAR_PARRAY_3D;

  palloc_record = ^alloc_record;
  alloc_record =
    RECORD
      nb: INTEGER;
      where, nominal: POINTER;
      objptr: TObject;
      next: palloc_record;
    END;

  Teasy_alloc_object=
    CLASS( TObject)
        alloc_list: palloc_record;
        alloc_record_size: WORD;
        CONSTRUCTOR create;
        FUNCTION alloc( n_bytes: INTEGER): POINTER; OVERLOAD;
        FUNCTION alloc( n_els, size_of_el, first_el: INTEGER): POINTER; OVERLOAD;
        FUNCTION alloc( variables: ARRAY OF PPOINTER;
              n_els, size_of_el, first_el: INTEGER): POINTER; OVERLOAD;
        FUNCTION alloc( obj: TObject): POINTER; OVERLOAD;
        FUNCTION alloc_array(
              dims, first_el: ARRAY OF INTEGER;
              size_of_el: INTEGER): POINTER; OVERLOAD;
        FUNCTION alloc_array(
              nd: INTEGER;
              dims, first_el: PLONGINT_ARRAY;
              size_of_el: INTEGER): POINTER; OVERLOAD;
        FUNCTION alloc_array(
              existing_array: POINTER;
              dims, first_el: ARRAY OF INTEGER;
              size_of_el: INTEGER): POINTER; OVERLOAD;
        FUNCTION alloc_array(
              existing_array: POINTER;
              nd: INTEGER;
              dims, first_el: PLONGINT_ARRAY;
              size_of_el: INTEGER): POINTER; OVERLOAD;
       FUNCTION alloc_arrays( variables: ARRAY OF PPOINTER;
              dims, first_el: ARRAY OF INTEGER;
              size_of_el: INTEGER): POINTER; OVERLOAD;
       FUNCTION alloc_arrays( variables: ARRAY OF PPOINTER;
              nd: INTEGER;
              dims, first_el: PLONGINT_ARRAY;
              size_of_el: INTEGER): POINTER; OVERLOAD;
       FUNCTION realloc_if_existing( ar: POINTER;
           dims, first_el: ARRAY OF INTEGER; size_of_el: INTEGER; target: POINTER): POINTER;
       PROCEDURE dealloc( variables: ARRAY OF PPOINTER); OVERLOAD;
       PROCEDURE dealloc( p: POINTER); OVERLOAD;
       DESTRUCTOR destroy; OVERRIDE;
     END;

FUNCTION ifelse(
  CONST condition: BOOLEAN;
  CONST t, f: INTEGER): INTEGER; OVERLOAD;

FUNCTION ifelse(
  CONST condition: BOOLEAN;
  CONST t, f: DOUBLE): DOUBLE; OVERLOAD;

PROCEDURE zero(
  VAR ar_el: LONGINT;
  CONST n: INTEGER); OVERLOAD;

PROCEDURE zero(
  VAR ar_el: DOUBLE;
  CONST n: INTEGER); OVERLOAD;

PROCEDURE set_values(
      p: POINTER;
  CONST vals: ARRAY OF DOUBLE);

FUNCTION check_equal(
  CONST a, b;
        n_bytes: INTEGER):
  BOOLEAN;

IMPLEMENTATION
USES SysUtils;

FUNCTION ifelse(
  CONST condition: BOOLEAN;
  CONST t, f: INTEGER): INTEGER;
BEGIN
  IF condition THEN RESULT:= t ELSE RESULT:= f;
END;

FUNCTION ifelse(
  CONST condition: BOOLEAN;
  CONST t, f: DOUBLE): DOUBLE;
BEGIN
  IF condition THEN RESULT:= t ELSE result:= f;
END;

PROCEDURE zero(
  VAR ar_el: LONGINT;
  CONST n: INTEGER);
BEGIN
  FillChar( ar_el, n*SizeOf( ar_el), 0);
END;

PROCEDURE zero(
  VAR ar_el: DOUBLE;
  CONST n: INTEGER);
BEGIN
  FillChar( ar_el, n*SizeOf( ar_el), 0);
END;

PROCEDURE set_values(
      p: POINTER;
  CONST vals: ARRAY OF DOUBLE);
VAR
  i: INTEGER;
BEGIN
  FOR i:= 0 TO HIGH( vals) DO
    PZDOUBLE_ARRAY( p)[ i]:= vals[ i];
END;

FUNCTION check_equal(
  CONST a, b;
        n_bytes: INTEGER):
  BOOLEAN;
VAR
  i: INTEGER;
TYPE
  LWORD_ARRAY = ARRAY[ 1..1] OF LONGWORD;
  BYTE_ARRAY = ARRAY[ 1..1] OF BYTE;
BEGIN
  RESULT:= FALSE;
  FOR i:= 1 TO n_bytes DIV 4 DO
    IF LWORD_ARRAY( a)[ i] <> LWORD_ARRAY( b)[ i] THEN
EXIT;

  FOR i:= n_bytes - 4*(n_bytes DIV 4) TO n_bytes DO
    IF BYTE_ARRAY( a)[ i] <> BYTE_ARRAY( b)[ i] THEN
EXIT;

  RESULT:= TRUE;
END;

CONSTRUCTOR Teasy_alloc_object. create;
BEGIN
  INHERITED create;
  alloc_record_size:= SizeOf( alloc_record);
END;

FUNCTION Teasy_alloc_object. alloc( n_bytes: INTEGER): POINTER;
VAR at: POINTER;
    allocation_record: palloc_record;
BEGIN
  GetMem( at, n_bytes);
  FillChar( PPOINTER( at)^, n_bytes, 0);
  GetMem( allocation_record, alloc_record_size);
  WITH allocation_record^ DO
  BEGIN
    next:= alloc_list;
    nb:= n_bytes;
    where:= at;
    nominal:= at;
    objptr:= NIL;
  END;
  alloc_list:= allocation_record;
  alloc:= at;
END;

FUNCTION Teasy_alloc_object. alloc( n_els, size_of_el, first_el: INTEGER):
  POINTER;
VAR at: ^BYTE;
BEGIN
  at:= alloc( n_els * size_of_el);
  DEC( at, first_el * size_of_el);
  alloc_list^. nominal:= at;
  RESULT:= at;
END;

FUNCTION Teasy_alloc_object. alloc(
      variables: ARRAY OF PPOINTER;
      n_els, size_of_el, first_el: INTEGER):
  POINTER;
VAR
  i: INTEGER;
BEGIN
  variables[ 0]^:= alloc( (HIGH( variables)+1) * n_els, size_of_el, first_el);
  FOR i:= 1 TO HIGH( variables) DO
    variables[ i]^:= POINTER( LONGINT( variables[i-1]^) + n_els * size_of_el);
  RESULT:= variables[ 0]^;
END;

FUNCTION Teasy_alloc_object. alloc( obj: TObject): POINTER;
BEGIN
  alloc( 0); { create new record }
  alloc_list^. nominal:= obj;
  alloc_list^. objptr:= obj;
  RESULT:= obj;
END;


FUNCTION Teasy_alloc_object. alloc_array(
      dims, first_el: ARRAY OF INTEGER;
      size_of_el: INTEGER):
  POINTER;
BEGIN
  RESULT:= alloc_array( HIGH( dims) + 1, @dims[ 0], @first_el[ 0], size_of_el);
END;

FUNCTION sizeof_array(
      nd: INTEGER;
      dims: PLONGINT_ARRAY;
      size_of_el: INTEGER):
  INTEGER;
VAR
  d, bytes_required: INTEGER;
BEGIN
  bytes_required:= dims[ nd] * size_of_el;
  FOR d:= nd-1 DOWNTO 1 DO
  BEGIN
    INC( bytes_required, SizeOf( POINTER));
    bytes_required:= bytes_required * dims[ d];
  END;
  RESULT:= bytes_required;
END;

FUNCTION setup_array_at(
      mat: PLONGINT_ARRAY;
      nd: INTEGER;
      dims, first_el: PLONGINT_ARRAY;
      size_of_el: INTEGER):
  POINTER;
VAR
  idx: LONGINT;
  dec_offset, inc_by, dimprod, d, i, pindex: INTEGER;
BEGIN
  RESULT:= mat;
  IF nd=1 THEN
    i:= size_of_el
  ELSE
    i:= SizeOf( POINTER);
  DEC( LONGINT( RESULT), first_el[ 1] * i);

  pindex:= 1;
  idx:= LONGINT( @mat[ dims[ 1] + 1]);
  dimprod:= 1;

  FOR d:= 1 TO nd-1 DO
  BEGIN
    IF d<nd-1 THEN
      i:= SizeOf( POINTER)
    ELSE
      i:= size_of_el;
    inc_by:= dims[ d+1] * i;
    dec_offset:= first_el[ d+1] * i;
    dimprod:= dimprod * dims[ d];
    FOR i:= 1 TO dimprod DO
    BEGIN
      mat[ pindex]:= idx - dec_offset;
      INC( idx, inc_by);
      INC( pindex);
    END;
  END;
END;

FUNCTION Teasy_alloc_object. alloc_array(
      nd: INTEGER;
      dims, first_el: PLONGINT_ARRAY;
      size_of_el: INTEGER):
  POINTER;

VAR
  mat: PLONGINT_ARRAY;
  bytes_required: INTEGER;
BEGIN
  RESULT:= NIL;
  IF nd<1 THEN
EXIT;

  bytes_required:= sizeof_array( nd, dims, size_of_el);
  mat:= alloc( bytes_required);
  RESULT:= setup_array_at( mat, nd, dims, first_el, size_of_el);
  alloc_list^. nominal:= RESULT;
END;

FUNCTION Teasy_alloc_object. alloc_array(
      existing_array: POINTER;
      dims, first_el: ARRAY OF INTEGER;
      size_of_el: INTEGER):
  POINTER;
BEGIN
  RESULT:= alloc_array( existing_array, HIGH( dims) + 1, @dims[ 0], @first_el[ 0], size_of_el);
END;

FUNCTION Teasy_alloc_object. alloc_array(
      existing_array: POINTER;
      nd: INTEGER;
      dims, first_el: PLONGINT_ARRAY;
      size_of_el: INTEGER):
  POINTER;

  VAR
    mat: PLONGINT_ARRAY;
    idx: LONGINT;
    pointers_required, dec_offset, inc_by, dimprod, d, i, pindex: INTEGER;

BEGIN
  RESULT:= NIL;
  IF nd<1 THEN
EXIT;
  IF nd=1 THEN
  BEGIN
    RESULT:= POINTER( LONGINT( existing_array) - first_el[ 1] * size_of_el);
EXIT;
  END;

  pointers_required:= 0;
  FOR d:= nd-1 DOWNTO 1 DO
  BEGIN
    INC( pointers_required);
    pointers_required:= pointers_required * dims[ d];
  END;

  RESULT:= alloc( pointers_required, SizeOf( POINTER), first_el[ 1]); // avoids problems with dealloc & nominal
  mat:= POINTER( LONGINT( RESULT) + first_el[ 1] * SizeOf( POINTER)); // altered 27/2/2002

  pindex:= 1;
  idx:= LONGINT( @mat[ dims[ 1] + 1]);
  dimprod:= 1;

  FOR d:= 1 TO nd-1 DO
  BEGIN
    IF d<nd-1 THEN
      i:= SizeOf( POINTER)
    ELSE
    BEGIN
      i:= size_of_el;
      idx:= LONGINT( existing_array);
    END;

    inc_by:= dims[ d+1] * i;
    dec_offset:= first_el[ d+1] * i;
    dimprod:= dimprod * dims[ d];
    FOR i:= 1 TO dimprod DO
    BEGIN
      mat[ pindex]:= idx - dec_offset;
      INC( idx, inc_by);
      INC( pindex);
    END;
  END;
END;

FUNCTION Teasy_alloc_object. alloc_arrays( variables: ARRAY OF PPOINTER;
      dims, first_el: ARRAY OF INTEGER;
      size_of_el: INTEGER): POINTER;
VAR
  nd: INTEGER;
BEGIN
  nd:= HIGH( dims) - LOW( dims) + 1;
  RESULT:= alloc_arrays( variables, nd, @dims[ 0], @first_el[ 0], size_of_el);
END;

FUNCTION Teasy_alloc_object. alloc_arrays( variables: ARRAY OF PPOINTER;
      nd: INTEGER;
      dims, first_el: PLONGINT_ARRAY;
      size_of_el: INTEGER): POINTER;
VAR
  idx, i, bytes_per_array: INTEGER;
BEGIN
  bytes_per_array:= sizeof_array( nd, dims, size_of_el);
  POINTER( idx):= alloc( (HIGH( variables)+1) * bytes_per_array);
  FOR i:= 0 TO HIGH( variables) DO
    variables[ i]^:= setup_array_at( POINTER( idx + i*bytes_per_array), nd, dims, first_el, size_of_el);
  RESULT:= POINTER( idx);
  alloc_list^. nominal:= variables[0]^; // so that dealloc works if called on first in list
END;

FUNCTION Teasy_alloc_object. realloc_if_existing(
      ar: POINTER;
      dims, first_el: ARRAY OF INTEGER;
      size_of_el: INTEGER;
      target: POINTER):
  POINTER;
VAR
  i, inc_by: INTEGER;
  p: ARRAY_1P;
BEGIN
  IF ar=NIL THEN
    RESULT:= alloc_array( target, dims, first_el, size_of_el)
  ELSE
  BEGIN
    RESULT:= ar;
    p:= ar;
    FOR i:= LOW( first_el) TO HIGH( first_el)-2 DO
      p:= p[ first_el[ i]];
    IF LONGINT( p[ first_el[ HIGH( first_el)-1]]) + first_el[ HIGH( first_el)]*size_of_el <> LONGINT( target) THEN
    BEGIN
      p:= @p[ first_el[ HIGH( first_el)-1]-1];
      inc_by:= dims[ HIGH( dims)] * size_of_el;
      LONGINT( target):= LONGINT( target) - first_el[ HIGH( first_el)] * size_of_el;
      FOR i:= 1 TO dims[ HIGH( first_el)-1] DO
      BEGIN
        p[ i]:= target;
        INC( LONGINT( target), inc_by);
      END;
    END;
  END;
END;

PROCEDURE Teasy_alloc_object. dealloc( variables: ARRAY OF PPOINTER);
VAR
  i: INTEGER;
BEGIN
  FOR i:= 0 TO HIGH( variables) DO
    IF variables[i]^<>NIL THEN
      dealloc( variables[i]^);
END;

PROCEDURE Teasy_alloc_object. dealloc( p: POINTER);
VAR
  save: palloc_record;
  ar:   ^palloc_record;
BEGIN
  ar:= @alloc_list;

  WHILE (ar^^. nominal <> p) AND (ar^^. next <> NIL) DO
    ar:= @ar^^. next;

  IF ar^^. nominal <> p THEN
RAISE EAccessViolation. CreateFmt( 'Attempt to dealloc failed', []);

  WITH ar^^ DO
  BEGIN
    save:= next;
    IF objptr=NIL THEN
      FreeMem( where, nb)
    ELSE
      objptr. destroy;
  END;
  FreeMem( ar^, alloc_record_size);
  ar^:= save;
END;

DESTRUCTOR Teasy_alloc_object. destroy;
VAR temp: POINTER;
BEGIN
  WHILE alloc_list<>NIL DO
  BEGIN
    temp:= alloc_list. next;
    WITH alloc_list^ DO
    BEGIN
      IF nb>0 THEN
        FreeMem( where, nb)
      ELSE
        objptr. Free;
    END;
    FreeMem( alloc_list, alloc_record_size);
    alloc_list:= temp;
  END;
  INHERITED destroy;
END;

end.
