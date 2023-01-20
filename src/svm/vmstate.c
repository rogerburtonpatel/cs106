// Memory management and literal addition for VMState

// You'll complete this file as part of module 1


#define _POSIX_C_SOURCE 200809L

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <stdint.h>

#include "vmstate.h"
#include "value.h"


unsigned STARTING_LITS = 1000;
unsigned STARTING_GLOBALS = 1000;

// seperately need to free the program!
void freestatep(VMState *sp) {
    assert(sp && *sp);
    VMState vm = *sp;
    Seq_free(&(vm->literals));
    Seq_free(&(vm->globals));

    free(sp);
}

VMState newstate(struct VMFunction *program) {
    // allocate, initialize, and return a new state
    assert(program);
    struct VMFunction pr = *program;
    /* allocation of instruction space has been done! 
     * now, the instructions pointer becomes our 
     * start of program and program counter*/
    
    VMState vms = malloc(sizeof(*vms));

    vms->counter  = pr.instructions;
    /* registers are static memory */
    vms->literals = Seq_new(STARTING_LITS);
    vms->globals = Seq_new(STARTING_GLOBALS);
    
    return vms;
}

int literal_slot(VMState state, Value literal) {
    (void)state; // suppress compiler warnings
    (void)literal;
    // Return a slot containing the literal, updating literal pool if needed.
    // For module 1, you can get away with putting the literal in slot 0
    // and returning 0.  For module 2, you'll need something slightly
    // more sophisticated.
    assert(0);
    return 1;
}

// these are for module 2 and beyond

Value literal_value(VMState state, unsigned index) {
  (void) state; (void) index; // replace with real code
  assert(0);
    return nilValue;

}

int literal_count(VMState state) {
  (void) state; // replace with real code
  assert(0);
    return 1;

}
