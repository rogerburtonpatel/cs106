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

#define shift(x, n) x + n

void vmrun(VMState vm, struct VMFunction *fun) {
    // Cache vars from VMState
    // Would use the register keyword if it did anything 
    uint32_t counter = vm->counter = 0;
    Instruction current_instruction;
    Opcode op;
    uint8_t rX;
    uint8_t rY;
    uint8_t rZ;
    Value *registers = vm->registers;
    Value *v; // For literals

    /* command loop */
    // Run code from `fun` until it executes a Halt instruction.
    // Then return.

    while(1) {
        /* get next instruction */
        current_instruction = fun->instructions[counter];
        op                  = opcode(current_instruction);
        
        switch (op) {
            /* BASIC */
            case Halt:
                vm->counter = counter;
                vm->curr_instruction = current_instruction;
                return; /* END THE PROGRAM */
            case Print:
                rX = uX(current_instruction);
                print("%v\n", registers[rX]);
                break;
            case Check:
                rX = uX(current_instruction);
                uint16_t idx = uYZ(current_instruction);
                v = Seq_get(vm->literals, idx);
                check(vm, AS_CSTRING(vm, *v), registers[rX]);
                break;
            case Expect:
                rX = uX(current_instruction);
                idx = uYZ(current_instruction); // REV: idx declaration and usage
                v = Seq_get(vm->literals, idx);
                expect(vm, AS_CSTRING(vm, *v), registers[rX]);
                break;
            /* ARITH */
            case Add:
                rX = uX(current_instruction);
                rY = uY(current_instruction);
                rZ = uZ(current_instruction);
                vm->registers[rZ] = mkNumberValue(AS_NUMBER(vm, registers[rX]) 
                                                  + AS_NUMBER(vm, registers[rY]));
                break;
            case Sub:
                rX = uX(current_instruction);
                rY = uY(current_instruction);
                rZ = uZ(current_instruction);
                vm->registers[rZ] = mkNumberValue(AS_NUMBER(vm, registers[rX]) 
                                                  - AS_NUMBER(vm, registers[rY]));
                break;
            case Mult:
                rX = uX(current_instruction);
                rY = uY(current_instruction);
                rZ = uZ(current_instruction);
                vm->registers[rZ] = mkNumberValue(AS_NUMBER(vm, registers[rX]) 
                                                  * AS_NUMBER(vm, registers[rY]));
                break;
            case Div:
                rX = uX(current_instruction);
                rY = uY(current_instruction);
                rZ = uZ(current_instruction);
                vm->registers[rZ] = mkNumberValue(AS_NUMBER(vm, registers[rX]) 
                                                  / AS_NUMBER(vm, registers[rY]));
                break;

            // Special case: need to cast to int64_t for mod since it's not defined 
            // on Number_T (double), then cast back to Number_T for mkNumberValue. 
            case Mod:
                rX = uX(current_instruction);
                rY = uY(current_instruction);
                rZ = uZ(current_instruction);
                vm->registers[rZ] = mkNumberValue((Number_T)
                                                  ((int64_t)AS_NUMBER(vm, registers[rX]) 
                                                  % (int64_t)AS_NUMBER(vm, registers[rY])));
                break;

            /* UNARY ARITH- R1 */
            case Inc:
                rX = uX(current_instruction);
                vm->registers[rX] = mkNumberValue(AS_NUMBER(vm, registers[rX]) + 1);
                break;
            case Dec:
                rX = uX(current_instruction);
                vm->registers[rX] = mkNumberValue(AS_NUMBER(vm, registers[rX]) - 1);
                break;
            case Neg:
                rX = uX(current_instruction);
                vm->registers[rX] = mkNumberValue(-AS_NUMBER(vm, registers[rX]));
                break;    
            // REV: Is this needed in vScheme?   
            case Not:
                rX = uX(current_instruction);
                vm->registers[rX] = mkNumberValue(~(int64_t)AS_NUMBER(vm, registers[rX]));
                break;       
                                          
            /* LITS <-> GLOBS <-> REGS */
            case LoadLiteral: {
                rX = uX(current_instruction);
                uint16_t idx = uYZ(current_instruction);
                v = Seq_get(vm->literals, idx);
                vm->registers[rX] = *v;
                break;
            }


            /* SPECIAL CASES */
            case BoolOf:
                rX = uX(current_instruction);
                rY = uY(current_instruction);
                *v = registers[rX];
                registers[rY] = falsey(*v);
                break;

            /* (UN)CONDITIONAL MOVEMENT */
            case If: 
                rX = uX(current_instruction);
                // Check for falseness
                *v = falsey(registers[rX]);
                if (!v->b) {
                    counter++; // If false, skip next instruction. Otherwise, proceed
                }
                break;
            case Goto:
                rX = uX(current_instruction);
                counter += 1 + AS_NUMBER(vm, registers[rX]); 
                continue; // this follows the semantics by adding 1 + for the normal
                          // counter increment, then adding the goto value, then skipping
                          // the increment with continue
            default:
                printf("Not implemented!\n");
                break;
        }
        counter++;
    }
    return;
}

