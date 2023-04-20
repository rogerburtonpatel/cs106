#ifndef VMSTACK_INCLUDED
#define VMSTACK_INCLUDED

#include "value.h"

/* Invariants: 
   dest_reg_idx is relative to R_window_start
   fun is the caller of the currently running function. */
typedef struct Activation {
    struct VMFunction *fun;
    int64_t counter;
    uint32_t R_window_start;
    int32_t dest_reg_idx; /* relative to R_window_start */
} Activation; /* NOT a pointer type! */




#endif
