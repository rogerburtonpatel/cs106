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
#include "vmheap.h"
#include "vmheap.h"


unsigned STARTING_LITS = 64;
unsigned STARTING_GLOBALS = 64;

// seperately need to free the program!
void freestatep(VMState *sp) {
    assert(sp && *sp);
    VMState vm = *sp;

    // Because Seq_T holds malloc'ed pointers, all have to be freed
    Seq_T literals = vm->literals;
    // // int literals_len = Seq_length(literals);
    // // for (int i = 0; i < literals_len; ++i) {
    // //     free((Value *)Seq_get(literals, i));
    // // }
    Seq_free(&(literals));

    Seq_T globals = vm->globals;
    int globals_len = Seq_length(globals);
    for (int i = 0; i < globals_len; ++i) {
        free((Value *)Seq_get(globals, i));
    }
    Seq_free(&(globals));

    free(*sp);
}

VMState newstate(void) {

    /* allocation of instruction space has been done! 
     * now, the instructions pointer becomes our 
     * start of program and program counter*/
    
    VMState vms = malloc(sizeof(*vms));
    assert(vms != NULL);

    vms->counter  = 0;
    
    /* registers are static memory-- we'll just init them to nils */
    for (int i = 0; i < NUM_REGISTERS; ++i) {
        vms->registers[i] = nilValue;
    }
    vms->literals = Seq_new(STARTING_LITS);
    vms->globals  = Seq_new(STARTING_GLOBALS);
    
    return vms;
}

int literal_slot(VMState state, Value literal) {
    VMNEW(Value, *lit, (sizeof(*lit)));
    *lit = literal;
    Seq_addlo(state->literals, lit);
    return 0;
}
  // TODO FOR MODULE 2: CHECK BELOW
  // these are for module 2 and beyond

Value literal_value(VMState state, unsigned index) {
    return *(Value *)Seq_get(state->literals, index);
}

int literal_count(VMState state) {
    return Seq_length(state->literals);
}

const char *global_name(VMState state, unsigned index) {
  (void) state; (void) index; // replace with real code
  assert(0);
  return NULL;
}
