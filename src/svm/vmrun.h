// Specification of the vmrun function.

// This file isn't interesting; it's the implementation that's interesting.

#ifndef VMRUN_INCLUDED
#define VMRUN_INCLUDED

#include "value.h"

typedef enum CallStatus { INITIAL_CALL, ERROR_CALL } CallStatus;

// void vmrun(struct VMState *vm, struct VMFunction *fun);
  // #pragma GCC diagnostic ignored "-Wmaybe-uninitialized"
void vmrun(struct VMState *vm, struct VMFunction *fun,  CallStatus status);

#endif /* VMRUN_INCLUDED */
