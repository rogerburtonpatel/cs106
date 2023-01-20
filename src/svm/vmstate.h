// State of a VM, and functions to allocate, deallocate, add a literal

// This one's the essential part of module 1.
// You'll define the key representation, `struct VMState`,
// and you'll use it in your `vmrun` function.

#ifndef VMSTATE_INCLUDED
#define VMSTATE_INCLUDED

#include <stdint.h>
#include <seq.h>

#include "value.h"

typedef struct VMState *VMState;

// ... define the struct type here ...

struct VMState {
   // instructions-- pointer as a program counter
    Instruction *counter;
   // regs
   Value registers[256];
   // literals- read-only
   Seq_T literals;
   // globals
   Seq_T globals;
   // store is the heap!
};

VMState newstate(struct VMFunction *program);       // allocate and initialize (to empty)
void freestatep(VMState *sp); // deallocate

int literal_slot(VMState state, Value literal);
  // return index of literal in `literals`, adding if needed
  // (at need, can be postponed to module 2)

Value literal_value(VMState state, unsigned index);
  // Return the value at the given index. *Not* intended 
  // for use in `vmrun`, in which you don't want to pay the 
  // overhead of a function call.

int literal_count(VMState state);
  // Returns N, the number of index values for which it
  // is ok to call `literal_value` (range 0 to N-1)

#endif /* VMSTATE_INCLUDED */
