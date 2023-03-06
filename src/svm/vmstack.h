#ifndef VMSTACK_INCLUDED
#define VMSTACK_INCLUDED

#include "value.h"

typedef struct Activation {
    Instruction *resume_loc;
    uint32_t R_window_start;
    uint32_t dest_reg_idx;
} Activation; /* NOT a pointer type! */



#endif
