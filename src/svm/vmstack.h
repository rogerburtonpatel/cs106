#ifndef VMSTACK_INCLUDED
#define VMSTACK_INCLUDED

#include "value.h"

#define ERROR_FRAME -1 /* dest_reg_idx = ERROR_FRAME when in check-error */

typedef struct Activation {
    Instruction *resume_loc;
    uint32_t R_window_start;
    int32_t dest_reg_idx; /* relative to R_window_start */
} Activation; /* NOT a pointer type! */



#endif
