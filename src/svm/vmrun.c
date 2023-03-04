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
#include <string.h>

#include "check-expect.h"
#include "iformat.h"
#include "value.h"
#include "vmstate.h"
#include "vmrun.h"

#include "print.h"

#include "svmdebug.h"
#include "disasm.h"

#include "vmerror.h"
#include "vmheap.h"
#include "vmstring.h"
#include "vmsizes.h"

#define CANDUMP 1

#define CANDUMP 1

void vmrun(VMState vm, struct VMFunction *fun) {
    print("%x\n", 0xf09d9aaf);
    print("%x\n", 0xf09d9aaf & 0x1fffff);
    print("%U\n", (unsigned)0x1d9aaf);
    
    if (fun->size < 1) {
        return;
    }

    /* Thank you to Norman for this debugging infrastructure */
    const char *dump_decode = svmdebug_value("decode");
    const char *dump_call   = svmdebug_value("call");
    (void) dump_call;  // make it OK not to use `dump_call`

    Instruction *pc = vm->instructions = fun->instructions;

    Instruction curr_instr;
    Value *registers = vm->registers; 
    /* registers always = vm->registers + vm->R_window_start */
    Value v;

    while(1) {
        curr_instr = *pc;

        if (CANDUMP && dump_decode) {
            idump(stderr, vm, (int64_t)pc, curr_instr, 0, 
            registers + uX(curr_instr), 
            registers + uY(curr_instr), 
            registers + uZ(curr_instr));
        }
        switch (opcode(curr_instr)) {
            /* BASIC */
            case Halt:
                /* I'm ok with having a counter variable external to the vmstate
                   and storing it when we Halt, because it saves a dereference
                   every time, and we only Halt once. */
                vm->pc = pc;
                return;
            case Print:
                print("%v", registers[uX(curr_instr)]);
                break;
            case Println:
                print("%v\n", registers[uX(curr_instr)]);
                break;
            case Printu:
                print("%U", (unsigned)AS_NUMBER(vm, registers[uX(curr_instr)]));
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
            case CheckAssert: {
                v = literal_value(vm, uYZ(curr_instr));
                check(vm, AS_CSTRING(vm, v), registers[uX(curr_instr)]);
                expect(vm, AS_CSTRING(vm, v), mkBooleanValue(false));
                break;
            }

            /* ARITH- R3 */
            case Add:
                registers[uX(curr_instr)] = 
                    mkNumberValue(AS_NUMBER(vm, registers[uY(curr_instr)]) 
                                  + AS_NUMBER(vm, registers[uZ(curr_instr)]));
                                                            
                break;
            case Sub:
                registers[uX(curr_instr)] = 
                    mkNumberValue(AS_NUMBER(vm, registers[uY(curr_instr)]) 
                                  - AS_NUMBER(vm, registers[uZ(curr_instr)]));
                break;
            case Mult:
                registers[uX(curr_instr)] = 
                    mkNumberValue(AS_NUMBER(vm, registers[uY(curr_instr)]) 
                                  * AS_NUMBER(vm, registers[uZ(curr_instr)]));
                break;

            case Div: {
                uint8_t rZ = uZ(curr_instr);
                Number_T d = AS_NUMBER(vm, registers[rZ]);
                if (d == 0) {
                    runerror(vm, "division by zero");
                }
                registers[uX(curr_instr)] = 
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
                registers[uX(curr_instr)] = 
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
                registers[uX(curr_instr)] = 
                    mkNumberValue((int64_t)AS_NUMBER(vm, 
                                                    registers[uY(curr_instr)]) 
                                            % d);
                break;
            }

            /* BOOLEAN LOGIC- R3 */
            case Eq:
            // TODO: THIS WILL BE MORE COMPLEX. HEHE
                registers[uX(curr_instr)] = 
                mkBooleanValue(
                    AS_NUMBER(vm, registers[uY(curr_instr)]) 
                    == AS_NUMBER(vm, registers[uZ(curr_instr)]));
                break;
            /* UNARY ARITH- R1 */
            case Inc:
                registers[uX(curr_instr)] = 
                    mkNumberValue(AS_NUMBER(vm, registers[uX(curr_instr)]) + 1);
                break;
            case Dec:
                registers[uX(curr_instr)] = 
                    mkNumberValue(AS_NUMBER(vm, registers[uX(curr_instr)]) - 1);
                break;
            case Neg:
                registers[uX(curr_instr)] = 
                    mkNumberValue(-AS_NUMBER(vm, registers[uX(curr_instr)]));
                break;    
            // REV: Is this needed in vScheme?   
            case Not:
                registers[uX(curr_instr)] = 
                    mkNumberValue(~(int64_t)AS_NUMBER(
                                                vm, registers[uX(curr_instr)]));
                break;       
                                          
            /* LITS <-> GLOBS <-> REGS */
            case LoadLiteral: 
                registers[uX(curr_instr)] = vm->literals[uYZ(curr_instr)];
                break;
            
            case GetGlobal:
                registers[uX(curr_instr)] = vm->globals[uYZ(curr_instr)];
                break;

            case SetGlobal:
                vm->globals[uYZ(curr_instr)] = registers[uX(curr_instr)];
                break;

            /* R2 */
            case BoolOf:
                v.tag = Boolean;
                v.b = asBool(registers[uY(curr_instr)]);
                registers[uX(curr_instr)] = v;
                break;
            

            case RegCopy:
                registers[uX(curr_instr)] = registers[uY(curr_instr)];
                break;

            case Swap:
                v = registers[uX(curr_instr)];
                registers[uX(curr_instr)] = registers[uY(curr_instr)];
                registers[uY(curr_instr)] = v;
                break;
            
            case Hash:
                registers[uX(curr_instr)] = 
                            mkNumberValue(hashvalue(registers[uY(curr_instr)]));
                break;

            case PlusImm:
                registers[uX(curr_instr)] = mkNumberValue(
                            AS_NUMBER(vm, registers[uY(curr_instr)]) 
                            + uZ(curr_instr));
                break;
            

            /* (UN)CONDITIONAL MOVEMENT */
            case If: 
                bool truth = asBool(registers[uX(curr_instr)]);
                if (!truth) {
                    pc++; // If false, skip next instruction.
                }
                break;
            case Goto:
                pc += 1 + iXYZ(curr_instr); 
                continue; // follows the semantics by adding 1 + for the normal
                          // counter increment, then adding the goto value, 
                          // then skipping the increment with continue


            /* FUNCTIONS */
            case Return: 
                assert(0);
                break;
            }
            case Call: {
                uint8_t r0 = uY(curr_instr);
                uint8_t rn = uZ(curr_instr);
                uint8_t n  = rn - r0;

                uint32_t dest_reg_idx = uX(curr_instr);

                // save caller activation record on the stack
                Activation a = {pc + 1, vm->R_window_start, dest_reg_idx};
                vm->Stack[vm->stackpointer++] = a;

                // check for invalid function 
                if (registers[r0].tag == Nil) {
                    const char *funname = lastglobalset(vm, r0, fun, pc);
                    if (funname == NULL) {
                        runerror(vm, 
                        "tried calling a function in register %hhu, \
                        which is nil and was never set to a function.\n", r0);
                    } else {
                        runerror(vm, 
                        "tried calling a function in register %hhu, which is \
                          nil and was last set to function %s.\n", r0, funname);
                    }
                }

                // grab the called function
                struct VMFunction *fun = AS_VMFUNCTION(vm, registers[r0]);
                assert(fun->arity == n);

                // move the register window
                vm->R_window_start += r0;
                registers = vm->registers + vm->R_window_start;

                // transfer control= move instruction pointer to start of 
                // function instruction stream
                pc = &func->instructions[0] - 1; /* account for increment */

                // return will undo this based on the activation! 
                break;
            /* LITS <-> GLOBS <-> REGS */
            case LoadLiteral:
                rX = uX(current_instruction);
                uint16_t idx = uYZ(current_instruction);
                v = Seq_get(vm->literals, idx);
                vm->registers[rX] = v;
                break;
            }
            case Tailcall: 
                assert(0);
                break;
            }

            default:
                printf("Opcode Not implemented!\n");
                break;
        }
        pc += 1;
    }
    return;
}

