// Memory management and literal/global addition for VMState

#define _POSIX_C_SOURCE 200809L

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <stdint.h>
#include <stdint.h>

#include "vmstate.h"
#include "value.h"
#include "vmheap.h"
#include "vmheap.h"
#include "vmerror.h"


unsigned STARTING_LITS = 1000;
unsigned STARTING_GLOBALS = 1000;

// seperately need to free the program 'fun'!
void freestatep(VMState *sp) {
    assert(sp && *sp);
    free(*sp);
}

VMState newstate(void) {
    /* allocation of instruction space has been done with 'fun'! */
    VMState vms = calloc(1, sizeof(*vms));
    assert(vms != NULL);
    
    /* because of the magic of calloc, 
       stackpointer, R_window_start, 
       num_literals, num_globals,
       counter,
       all the registers,
       all the literals,
       all the globals, 
       and awaiting_expect,
       are all set to 0 (or nilValue),
       as they should be. */

    vms->cons_sym_slot = 
                        literal_slot(vms, mkStringValue(Vmstring_newc("cons")));
    // for switch statements
    vms->globals[global_slot(vms, mkStringValue(Vmstring_newc("&gamma")))] =
            mkNumberValue(10.0); // for GC
        
    return vms;
}



// also, linear search is fine here, since we're dealing with a max name of ~65k:
// This isn't enough to benefit from constant vs. linear time in a way 
// perceptable to humans. 
int literal_slot(VMState state, Value literal) {
    // TODO DEPTH POINT: This for garbage collection. 
    // Value needs a forwarding pointer. 
    // VMNEW(Value *, lit, (sizeof(*lit)));
    // *lit = literal;
    Value *literals = state->literals;
    for (int i = 0; i < state->num_literals; ++i) {
        if (identical(literals[i], literal)) {
            return i;
        }
    }
    state->literals[state->num_literals] = literal;
    return state->num_literals++;
}
// From Norman. I wrote using strcmp with VMString extraction, but this is 
// just much better. 
uint32_t global_slot(VMState state, Value namev) {
    Name name = strtoname(AS_CSTRING(state, namev));
    int slot;
    for (slot = 0; slot < state->num_globals; slot++) {
      if (state->global_names[slot] == name)
        return slot;
    }
    slot = state->num_globals++;
    assert(slot < MAX_GLOBALS);
    state->global_names[slot] = name;
    return slot;
}

Value literal_value(VMState state, uint32_t index) {
    return state->literals[index];
}

int literal_count(VMState state) {
    return state->num_literals;
}

const char *global_name(VMState state, unsigned index) {
    assert(index < MAX_GLOBALS); // probably unecessary but catches loader bugs
    return nametostr(state->global_names[index]);
}
void initialize_global(VMState vm, Value name, Value v) {
  (void) vm; (void) name; (void) v; // todo replace with real code
  return;
}


void not_a_function_error(VMState vm, const char *funname, 
                          const char *offending_op, uint8_t r0)
{
    if (funname == NULL) {
        runerror(vm, 
        "tried %sing a function in register %hhu, "
        "which is nil and was never set to a function.", offending_op, r0);
    } else {
        runerror(vm, 
    "tried %sing a function in register %hhu, which is "
    "nil and was last set to function \"%s\".", offending_op, r0, funname);
    }
}
