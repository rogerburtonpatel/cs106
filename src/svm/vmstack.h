#ifndef VMSTACK_INCLUDED
#define VMSTACK_INCLUDED

#include "value.h"

/* 
 * Invariants: 
 *  1. dest_reg_idx is relative to R_window_start
 *  2. fun is the caller of the currently running function: the callee.
 *  3. counter is how far into the callee we were when we called the 
 *     currently running function. It's the point we'll return to when we 
 *     reach a `return`.
 *  3. if dest_reg_idx is negative, this is a special error frame generated
 *     by a call to `check-error`. The dest_reg_idx, when made positive, 
 *     represents an index into the literal pool at which lives the correct
 *     message to print should the test fail. 
 */
typedef struct Activation {
    struct VMFunction *fun;
    int64_t counter;
    uint32_t R_window_start;
    int32_t dest_reg_idx; /* relative to R_window_start */
} Activation; /* NOT a pointer type! */

#endif
