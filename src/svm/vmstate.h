// State of a VM, and functions to allocate, deallocate, add a literal

// This one's the essential part of module 1.
// You'll define the key representation, `struct VMState`,
// and you'll use it in your `vmrun` function.

#ifndef VMSTATE_INCLUDED
#define VMSTATE_INCLUDED

#include <stdint.h>
<<<<<<< HEAD
// #include <seq.h>

=======
#include "stable.h"
#include "name.h"
>>>>>>> da1190e7047633d4137734220ee270e23150acb6
#include "value.h"
#include "vtable.h"


#define MAX_LITERALS 4096
#define MAX_GLOBALS  4096

typedef struct VMState *VMState;
#define NUM_REGISTERS 256


struct VMState {

  Instruction *instructions;
  uint64_t counter;
  Value registers[NUM_REGISTERS];
  Value literals[MAX_LITERALS];
  uint32_t num_literals;

  char *global_names[MAX_GLOBALS];
  Value globals    [MAX_GLOBALS];
  uint32_t num_globals;

   // store is the vmheap
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
