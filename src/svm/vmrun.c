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

Opcode get_opcode(Instruction word) {
    return word >> 24;
}

void vmrun(VMState vm, struct VMFunction *fun) {
    (void)fun;
    // Cache vars from VMState
    uint32_t counter = vm->counter;
    Instruction current_instruction = fun->instructions[counter];
    Opcode op  = get_opcode(current_instruction);

    /* command loop */
    while(op != Halt) {
        printf("Opcode: %d\n", op);
        counter++;
        /* get next instruction */
        Instruction current_instruction = fun->instructions[counter];
        Opcode op           = get_opcode(current_instruction);
        (void)op;
    }


    // Run code from `fun` until it executes a Halt instruction.
    // Then return.
    return;
}
