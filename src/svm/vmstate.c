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

// seperately need to free the program!
void freestatep(VMState *sp) {
    assert(sp && *sp);
    free(*sp);
}

VMState newstate(void) {

    /* allocation of instruction space has been done! 
     * now, the instructions pointer becomes our 
     * start of program and program counter*/
    
    VMState vms = malloc(sizeof(*vms));
    assert(vms != NULL);

    vms->counter  = 0;
    vms->num_literals = vms->num_globals = 0;
    
    /* registers are static memory-- we'll just init them to nils */
    for (int i = 0; i < NUM_REGISTERS; ++i) {
        vms->registers[i] = nilValue;
    }
    for (int i = 0; i < MAX_GLOBALS; ++i) {
        vms->globals[i] = nilValue;
    }
        
    return vms;
}

int literal_slot(VMState state, Value literal) {
    VMNEW(Value, *lit, (sizeof(*lit)));
    *lit = literal;
    state->literals[state->num_literals] = literal;
    return state->num_literals++;
}

  // these are for module 2 and beyond

Value literal_value(VMState state, uint32_t index) {
    return state->literals[index];
}

int literal_count(VMState state) {
    return state->num_literals;
}

const char *global_name(VMState state, unsigned index) {
  (void) state; (void) index; // replace with real code
  assert(0);
  return NULL;
}
