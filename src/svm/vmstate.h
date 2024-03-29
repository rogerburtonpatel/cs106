// State of a VM, and functions to allocate, deallocate, add a literal/global.
// Some nice error helpers as well. 

#ifndef VMSTATE_INCLUDED
#define VMSTATE_INCLUDED

#include <stdint.h>
#include <setjmp.h>

#include "print.h"
#include "value.h"
#include "vmstack.h"
#include "name.h"
#include "vtable.h"

#define MAX_LITERALS 4096
#define MAX_GLOBALS  4096

#define MAX_STACK_FRAMES 5000
#define NUM_REGISTERS (10 * MAX_STACK_FRAMES)


typedef struct VMState *VMState;

/* Invariants:
   While the mutator is running:
   Before the garbace collector runs:
   .fun is the currently running function
   .counter is how far the program counter is relative to the start
    of .fun's instruction stream
   .R_window_start is the distance from the local variable 'registers'
    in vmrun and this .register field. 
*/
struct VMState {

  struct VMFunction *fun;
  int64_t counter;
  Value registers[NUM_REGISTERS];
  Value literals[MAX_LITERALS];
  
  Activation Stack[MAX_STACK_FRAMES];
  uint16_t stackpointer; /* points to 1st empty slot, right above 'top' */
  uint32_t R_window_start;

  uint16_t num_literals;
  Name global_names[MAX_GLOBALS];
  Value globals    [MAX_GLOBALS];
  uint16_t num_globals;

   // store is the vmheap

   Value awaiting_expect;  // value passed to the pending `check`, if any
   uint16_t cons_sym_slot; // for access to legacy lists- pattern matching

};

VMState newstate();       // allocate and initialize (to empty)
void freestatep(VMState *sp); // deallocate


// The remaining functions won't be needed until module 2, but 
// they are worth thinking about now---and possibly writing.

int literal_slot(VMState state, Value literal);
  // return any index of literal in `literals`, adding if needed

uint32_t global_slot(VMState state, Value name);
  // return the unique index of `name` in `globals`, adding if needed.
  // The `name` parameter must be a VM string or the result is
  // a checked run-time error.

void initialize_global(VMState state, Value name, Value initial_value);
  // Equivalent to a `val` declaration; used for setting `argv`


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


/* some nice error functions */
extern void not_a_function_error(VMState vm, const char *funname, 
                 const char *offending_op, uint8_t r0);

#endif /* VMSTATE_INCLUDED */
