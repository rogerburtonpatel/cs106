// Hash table from Hanson's *C Interfaces and Implementations*, adapted

// Use this for global variables and table values.
// The table itself and all entries are meant to be
// garbage-collected, so there is never a need to explicitly
// free any memory associated with VTable_T.

// Key difference from Hanson: a missing entry is equivalent to `nil`,
// so VTable_get always succeeds.

#ifndef VTABLE_INCLUDED
#define VTABLE_INCLUDED

#include "value.h"

#define T VTable_T

typedef struct T *T;
extern T     VTable_new   (int hint);
  // allocate a new table from garbage-collected memory, so the heap
  // must be initialized

extern int   VTable_length(T vtable);
extern void  VTable_put   (T vtable, Value key, Value value);
extern Value VTable_get   (T vtable, Value key);
extern void  VTable_remove(T vtable, Value key); // equivalent to putting nilValue

#undef T
#endif
