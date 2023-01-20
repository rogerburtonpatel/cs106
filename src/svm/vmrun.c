// Heart of the VM: runs instructions until told to halt

// You'll write a small `vmrun` function in module 1.  You'll pay
// some attention to performance, but you'll implement only a few 
// instructions.  You'll add other instructions as needed in future modules.

#define _POSIX_C_SOURCE 200809L

#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <stdbool.h>

#include "check-expect.h"
#include "iformat.h"
#include "value.h"
#include "vmstate.h"
#include "vmrun.h"

#include "print.h"

#include "vmerror.h"
#include "vmheap.h"
#include "vmstring.h"

// uint32_t PC_STEP = sizeof(Instruction);

/* TODO decoder functions-- maybe move to another file? but static inline-- ask */
static inline Opcode get_opcode(Instruction word) {
    return word >> 24;
}

void vmrun(VMState vm, struct VMFunction *fun) {
    // Cache vars from VMState
    // TODO: CACHE MORE THINGS
    register uint32_t counter = vm->counter;
    register Instruction current_instruction;
    register Opcode op;

    /* command loop */
    // Run code from `fun` until it executes a Halt instruction.
    // Then return.
    while(1) {
        /* get next instruction */
        current_instruction = fun->instructions[counter];
        op                  = get_opcode(current_instruction);
        printf("Opcode: %d\n", op);
        
        switch (op) {
            case Halt:
                vm->counter = counter;
                vm->curr_instruction = current_instruction;
                return; /* END THE PROGRAM */
            case Print:

            default:
                printf("Not implemented!\n");
                break;
        }
        counter++;
    }
    return;
}
