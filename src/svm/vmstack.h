#ifndef VMSTACK_INCLUDED
#define VMSTACK_INCLUDED

#include "value.h"


typedef struct Activation {
    Instruction *resume_loc;
    uint32_t R_window_start;
    int32_t dest_reg_idx; /* relative to R_window_start */
} Activation; /* NOT a pointer type! */




#endif
