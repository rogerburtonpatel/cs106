// Specification of the vmrun function.

// This file isn't interesting; it's the implementation that's interesting.

#ifndef VMRUN_INCLUDED
#define VMRUN_INCLUDED

#include "value.h"

void vmrun(struct VMState *vm, struct VMFunction *fun);

#endif /* VMRUN_INCLUDED */
