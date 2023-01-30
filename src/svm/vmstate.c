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


// TODO For next time: test and see if allocation is necessary. I suspect not

// also, linear search is fine here, since we're dealing with a max n of ~65k:
// This isn't enough to benefit from constant vs. linear time in a way 
// perceptable to humans. 
int literal_slot(VMState state, Value literal) {
    VMNEW(Value, *lit, (sizeof(*lit)));
    *lit = literal;
    Value *literals = state->literals;
    for (int i = 0; i < state->num_literals, ++i) {
        if (identical(literals[i], literal)) {
            return i;
        }
    }
    state->literals[state->num_literals] = literal;
    return state->num_literals++;
}

uint32_t global_slot(VMState state, Value name) {
    (void)state;
    (void)name;
    assert(0);
}

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
void initialize_global(VMState vm, Value name, Value v) {
  (void) vm; (void) name; (void) v; // replace with real code
  assert(0);
}
