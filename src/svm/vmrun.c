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
    
    if (fun->size < 1) {
        return;
    }

    uint32_t counter = vm->counter = 0;
    Instruction *instructions = vm->instructions = fun->instructions;
    Instruction curr_instr;
    
    Value *registers = vm->registers;
    Value v;

    while(1) {
        curr_instr = instructions[counter];
        switch (opcode(curr_instr)) {
            /* BASIC */
            case Halt:
                /* I'm ok with having a counter variable external to the vmstate
                   and storing it when we Halt, because it saves a dereference
                   every time, and we only Halt once. */
                vm->counter = counter;
                return;
            case Print:
                print("%v", registers[uX(curr_instr)]);
                break;
            case Println:
                print("%v\n", registers[uX(curr_instr)]);
                break;
            case Check: {
                v = literal_value(vm, uYZ(curr_instr));
                check(vm, AS_CSTRING(vm, v), registers[uX(curr_instr)]);
                break;
            }
            case Expect: {
                v = literal_value(vm, uYZ(curr_instr));
                expect(vm, AS_CSTRING(vm, v), registers[uX(curr_instr)]);
                break;
            }
            /* ARITH- R3 */
            case Add:
                vm->registers[uX(curr_instr)] = 
                    mkNumberValue(AS_NUMBER(vm, registers[uY(curr_instr)]) 
                                  + AS_NUMBER(vm, registers[uZ(curr_instr)]));
                                                            
                break;
            case Sub:
                vm->registers[uX(curr_instr)] = 
                    mkNumberValue(AS_NUMBER(vm, registers[uY(curr_instr)]) 
                                  - AS_NUMBER(vm, registers[uZ(curr_instr)]));
                break;
            case Mult:
                vm->registers[uX(curr_instr)] = 
                    mkNumberValue(AS_NUMBER(vm, registers[uY(curr_instr)]) 
                                  * AS_NUMBER(vm, registers[uZ(curr_instr)]));
                break;

            case Div: {
                uint8_t rZ = uZ(curr_instr);
                Number_T d = AS_NUMBER(vm, registers[rZ]);
                if (d == 0) {
                    runerror(vm, "division by zero");
                }
                vm->registers[uX(curr_instr)] = 
                    mkNumberValue(AS_NUMBER(vm, registers[uY(curr_instr)]) / d);
                break;
            }
            // Special case: need to cast to int64_t for idiv && mod since they
            // have different behavior/are not defined on Number_T (double), 
            // then cast back to Number_T for mkNumberValue. 

            case IDiv: {
                uint8_t rZ = uZ(curr_instr);
                Number_T d = (int64_t)AS_NUMBER(vm, registers[rZ]);
                if (d == 0) {
                    runerror(vm, "division by zero");
                }
                vm->registers[uX(curr_instr)] = 
                    mkNumberValue((int64_t)AS_NUMBER(vm, 
                                                    registers[uY(curr_instr)]) 
                                            / d);
                break;
            }
            case Mod: {
                uint8_t rZ = uZ(curr_instr);
                // coersion
                int64_t d = AS_NUMBER(vm, registers[rZ]);
                if (d == 0) {
                    runerror(vm, "division by zero");
                }
                vm->registers[uX(curr_instr)] = 
                    mkNumberValue((int64_t)AS_NUMBER(vm, 
                                                    registers[uY(curr_instr)]) 
                                            % d);
                break;
            }
            /* UNARY ARITH- R1 */
            case Inc:
                vm->registers[uX(curr_instr)] = 
                    mkNumberValue(AS_NUMBER(vm, registers[uX(curr_instr)]) + 1);
                break;
            case Dec:
                vm->registers[uX(curr_instr)] = 
                    mkNumberValue(AS_NUMBER(vm, registers[uX(curr_instr)]) - 1);
                break;
            case Neg:
                vm->registers[uX(curr_instr)] = 
                    mkNumberValue(-AS_NUMBER(vm, registers[uX(curr_instr)]));
                break;    
            // REV: Is this needed in vScheme?   
            case Not:
                vm->registers[uX(curr_instr)] = 
                    mkNumberValue(~(int64_t)AS_NUMBER(
                                                vm, registers[uX(curr_instr)]));
                break;       
                                          
            /* LITS <-> GLOBS <-> REGS */
            case LoadLiteral: 
                vm->registers[uX(curr_instr)] = vm->literals[uYZ(curr_instr)];
                break;


            /* SPECIAL CASES */
            case BoolOf:
                v.tag = Boolean;
                v.b = falsey(registers[uX(curr_instr)]);
                registers[uY(curr_instr)] = v;
                break;

            /* (UN)CONDITIONAL MOVEMENT */
            case If: 
                bool v_false = falsey(registers[uX(curr_instr)]);
                if (!v_false) {
                    counter++; // If false, skip next instruction.
                }
                break;
            case Goto:
                counter += 1 + AS_NUMBER(vm, registers[iXYZ(curr_instr)]); 
                continue; // follows the semantics by adding 1 + for the normal
                          // counter increment, then adding the goto value, 
                          // then skipping the increment with continue
            default:
                printf("Not implemented!\n");
                break;
        }
        counter++;
    }
    return;
}

