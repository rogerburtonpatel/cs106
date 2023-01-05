// Module 1: Help testing `vmrun()`

// Builds a few functions so you can test your `vmrun()`
// before the VM loader is implemented.  Used in module 1 only.

// The implementation is worth looking at, since it has simple
// examples of functions that encode instructions, allocate
// strings, and create VM functions.  That's what you'll be doing
// in module 2.

// These functions are called from `svmtest.c`.



#ifndef TESTFUNS_INCLUDED
#define TESTFUNS_INCLUDED

#include "value.h"

// three test functions:
//      halt
//      print $r0; halt
//      check "$r0" $r0; expect "$r0" $r0; halt

struct VMFunction *haltfun(void);
struct VMFunction *print0fun(void);
struct VMFunction *ce0fun(VMState vm);

#endif
