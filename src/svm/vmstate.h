// State of a VM, and functions to allocate, deallocate, add a literal

// This one's the essential part of module 1.
// You'll define the key representation, `struct VMState`,
// and you'll use it in your `vmrun` function.

#ifndef VMSTATE_INCLUDED
#define VMSTATE_INCLUDED

#include <stdint.h>
<<<<<<< HEAD
#include <seq.h>
=======
// #include <seq.h>
>>>>>>> newstate

#include "value.h"

#define MAX_LITERALS 4096
#define MAX_GLOBALS  4096

typedef struct VMState *VMState;
#define NUM_REGISTERS 256


struct VMState {
<<<<<<< HEAD
   // curr instruction: stored. 
   Instruction curr_instruction; 
   // counter-- indexer into instructions array. 
    uint64_t counter;
   // regs
   Value registers[NUM_REGISTERS];
   // literals- read-only
   Seq_T literals;   // globals
   Seq_T globals;
   // store is the heap!
=======

  Instruction *instructions;
  uint64_t counter;
  Value registers[NUM_REGISTERS];
  Value literals[MAX_LITERALS];
  uint32_t num_literals;

  char *global_names[MAX_GLOBALS];
  Value globals    [MAX_GLOBALS];
  uint32_t num_globals;

   // store is the vmheap
>>>>>>> newstate
};

VMState newstate(void);       // allocate and initialize (to empty)
void freestatep(VMState *sp); // deallocate


// The remaining functions won't be needed until module 2, but 
// they are worth thinking about now---and possibly writing.

int literal_slot(VMState state, Value literal);
  // return any index of literal in `literals`, adding if needed

int global_slot(VMState state, Value name);
  // return the unique index of `name` in `globals`, adding if needed.
  // The `name` parameter must be a VM string or the result is
  // a checked run-time error.


// The last three functions are used only for disassembly.

Value literal_value(VMState state, unsigned index);
  // Return the value at the given index. *Not* intended 
  // for use in `vmrun`, in which you don't want to pay the 
  // overhead of a function call.

int literal_count(VMState state);
  // Returns N, the number of index values for which it
  // is ok to call `literal_value` (range 0 to N-1)

const char *global_name(VMState state, unsigned index);
  // Return the name of the global at the given index.

#endif /* VMSTATE_INCLUDED */
