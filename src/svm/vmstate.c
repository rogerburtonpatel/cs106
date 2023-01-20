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
    // TODO FREE ALL LITERALS MANUALLY-- ASK IF NEED TAG
    Seq_free(&(vm->literals));
    Seq_free(&(vm->globals));

    // TODO: Why free invalid ptr?
    free(sp);
}

VMState newstate(void) {

    /* allocation of instruction space has been done! 
     * now, the instructions pointer becomes our 
     * start of program and program counter*/
    
    VMState vms   = malloc(sizeof(*vms));

    vms->counter  = 0;
    /* registers are static memory */
    vms->literals = Seq_new(STARTING_LITS);
    vms->globals  = Seq_new(STARTING_GLOBALS);
    
    return vms;
}

int literal_slot(VMState state, Value literal) {
    Value *lit = malloc(sizeof(*lit));
    lit = &literal;
    Seq_addlo(state->literals, lit);

    // // Return a slot containing the literal, updating literal pool if needed.
    // // For module 1, you can get away with putting the literal in slot 0
    // // and returning 0.  For module 2, you'll need something slightly
    // // more sophisticated.
    return 0;
}

// these are for module 2 and beyond

Value literal_value(VMState state, unsigned index) {
  // TODO CHECK
  // return Seq_get
  (void) state; (void) index; // replace with real code
  assert(0);
    return nilValue;

}

int literal_count(VMState state) {
  (void) state; // replace with real code
  assert(0);
    return 1;

}

const char *global_name(VMState state, unsigned index) {
  (void) state; (void) index; // replace with real code
  assert(0);
  return NULL;
}
