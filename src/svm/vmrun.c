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


void vmrun(VMState vm, struct VMFunction *fun) {
    // Cache vars from VMState
    // TODO: CACHE MORE THINGS
    register uint32_t counter = vm->counter = 0; // TODO ask abt this-- do we reset each time?
    register Instruction current_instruction;
    register Opcode op;
    register uint8_t rX;
    register uint8_t rY;
    register uint8_t rZ;
    Value *v; // For literals
    vm->registers[0] = mkNumberValue(3); // TODO REMOVE
    // TODO: ASK ABOUT VALGRIND


    /* command loop */
    // Run code from `fun` until it executes a Halt instruction.
    // Then return.

    while(1) {
        /* get next instruction */
        current_instruction = fun->instructions[counter];
        op                  = opcode(current_instruction);
        
        // TODO: bring up in code review. what the heck with idx?
        switch (op) {
            /* BASIC */
            case Halt:
                vm->counter = counter;
                vm->curr_instruction = current_instruction;
                return; /* END THE PROGRAM */
            case Print:
                rX = uX(current_instruction);
                print("%v\n", rX);
                break;
            case Check:
                rX = uX(current_instruction);
                uint16_t idx = uYZ(current_instruction);
                v = Seq_get(vm->literals, idx);
                check(vm, AS_CSTRING(vm, *v), vm->registers[rX]);
                break;
            case Expect:
                rX = uX(current_instruction);
                idx = uYZ(current_instruction);
                v = Seq_get(vm->literals, idx);
                expect(vm, AS_CSTRING(vm, *v), vm->registers[rX]);
                break;
            /* ARITH */
            case Add:
                rX = uX(current_instruction);
                rY = uY(current_instruction);
                rZ = uZ(current_instruction);
                vm->registers[rZ] = mkNumberValue(AS_NUMBER(vm, vm->registers[rX]) 
                                                  + AS_NUMBER(vm, vm->registers[rY]));
                break;
            case Sub:
                rX = uX(current_instruction);
                rY = uY(current_instruction);
                rZ = uZ(current_instruction);
                vm->registers[rZ] = mkNumberValue(AS_NUMBER(vm, vm->registers[rX]) 
                                                  - AS_NUMBER(vm, vm->registers[rY]));
                break;
            case Mult:
                rX = uX(current_instruction);
                rY = uY(current_instruction);
                rZ = uZ(current_instruction);
                vm->registers[rZ] = mkNumberValue(AS_NUMBER(vm, vm->registers[rX]) 
                                                  * AS_NUMBER(vm, vm->registers[rY]));
                break;
            case Div:
                rX = uX(current_instruction);
                rY = uY(current_instruction);
                rZ = uZ(current_instruction);
                vm->registers[rZ] = mkNumberValue(AS_NUMBER(vm, vm->registers[rX]) 
                                                  / AS_NUMBER(vm, vm->registers[rY]));
                break;
            // Special case: need to cast to int64_t for mod since it's not defined 
            // on Number_T (double), then cast back to Number_T for mkNumberValue. 
            case Mod:
                rX = uX(current_instruction);
                rY = uY(current_instruction);
                rZ = uZ(current_instruction);
                vm->registers[rZ] = mkNumberValue((Number_T)
                                                  ((int64_t)AS_NUMBER(vm, vm->registers[rX]) 
                                                  % (int64_t)AS_NUMBER(vm, vm->registers[rY])));
                break;
            // case InitConsCell: { // TODO ask norman about initialization
            //     struct VMBlock *vmb = vmalloc_raw(sizeof(*vmb));
            //     vmb->nslots = 0;

            // }
            
                break;
            default:
                printf("Not implemented!\n");
                break;
        }
        counter++;
    }
    return;
}
