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

#define CANDUMP 1

#define UX uX(curr_instr)
#define UY uY(curr_instr)
#define UZ uZ(curr_instr)

extern int ntests, npassed;
extern jmp_buf testjmp;


// TODO remove if not needed
// /* used for runerror stack rewinding */
// int ERRORNO = -1;

void vmrun(VMState vm, struct VMFunction *fun) {
    
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
            idump(stderr, 
            vm, 
            ((int64_t)pc - (int64_t)vm->instructions) / 4, 
            curr_instr, 
            0, 
            registers + UX, 
            registers + UY, 
            registers + UZ);
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
                print("%v", registers[UX]);
                break;
            case Println:
                print("%v\n", registers[UX]);
                break;
            case Printu:
                print("%U", (unsigned)AS_NUMBER(vm, registers[UX]));
                break;
            case Printl:
                print("%v", literal_value(vm, uYZ(curr_instr)));
                break;
            case Printlnl:
                print("%v\n", literal_value(vm, uYZ(curr_instr)));
                break;     
            case Error:
                runerror_p(vm, "%v", registers[UX]);
                break;                              
            case Check: {
                v = literal_value(vm, uYZ(curr_instr));
                check(vm, AS_CSTRING(vm, v), registers[UX]);
                break;
            }
            case Expect: {
                v = literal_value(vm, uYZ(curr_instr));
                expect(vm, AS_CSTRING(vm, v), registers[UX]);
                break;
            }
            case CheckAssert: {
                v = literal_value(vm, uYZ(curr_instr));
                check(vm, AS_CSTRING(vm, v), registers[UX]);
                expect(vm, AS_CSTRING(vm, v), mkBooleanValue(true));
                break;
            }
            case CheckError: {
                uint8_t r0 = UX;
                if (registers[r0].tag == Nil) {
                    const char *funname = lastglobalset(vm, r0, fun, pc);
                    nilfunerror(vm, funname, "check-error", r0);
                }
                // TODO: UYZ is TEST FAIL MSG
                ntests++;
                NHANDLERS++;
                // set up jump. if we're 1st time, 
                // push special frame and call func. 
                // otherwise unwind stack, restore program like return. 
                // TODO update return to fail a test. 

                /* this 'goto' convention re-initializes the buffer
                   if we have multiple jumps (e.g. from multiple 
                   check-error instructions) */
                if(setjmp(testjmp)) {
                    npassed++;
                    NHANDLERS--;
                    /* restore frame */
                    Activation a = vm->Stack[--vm->stackpointer];
                    vm->R_window_start = a.R_window_start;
                    registers = vm->registers + a.R_window_start;
                    pc = a.resume_loc;
                    /* then move on with our lives */
                } else /* we're not here from a jump */ {
                    if (vm->stackpointer == MAX_STACK_FRAMES) {
                        if (vm->Stack[vm->stackpointer - 1].dest_reg_idx == -1)
                           {
                            fprintf(stderr, "You've hit the outstandingly rare"
                                            " \nand almost definitely contrived"
                                            " case \nwhere pushing an error"
                                            " frame via check-error \ncaused a"
                                            " stack overflow \nbut where that" 
                                            " very overflow \nwas caught by"
                                            " another check-error."
                                            " \nWell done.\n");
                           }

                        NHANDLERS--; /* otherwise we don't unwind properly */
                        runerror(vm, 
                            "attempting to push an error frame in check-error"
                            " caused a Stack Overflow");
                    }

                    struct VMFunction *func = AS_VMFUNCTION(vm, registers[r0]);
                    assert(func->arity == 0); /* this can NEVER have args */
                    /* push special frame */
                    Activation a = {pc, vm->R_window_start, ERROR_FRAME};
                    vm->Stack[vm->stackpointer++] = a;
                    
                    pc = &func->instructions[0] - 1;
                    /* continue with execution, now in error mode */
                }
                break;
            }
                
            // case BeginCheckError: {
            //     ntests++;
            //     NHANDLERS++;
            //     /* if not familiar with the arcane setjmp/longjmp form: 
            //     this will return 0 when we make the 'jump-to point,' and 
            //     nonzero if we jump to it with longjmp. */
            //     if (setjmp(testjmp)) {
            //         npassed++;
            //         NHANDLERS--;
                    /* restore frame */
                    // Activation a = vm->Stack[--vm->stackpointer];
                    // vm->R_window_start = a.R_window_start;
                    // registers = vm->registers + a.R_window_start;
                    // pc = a.resume_loc;
            //     } else {
                //     /* push special frame */
                //     if (vm->stackpointer == MAX_STACK_FRAMES) {
                //         if (vm->Stack[vm->stackpointer - 1].dest_reg_idx == -1)
                //            {
                //             fprintf(stderr, "You've hit the outstandingly rare"
                //                             " \nand almost definitely contrived"
                //                             " case \nwhere pushing an error"
                //                             " frame via check-error \ncaused a"
                //                             " stack overflow \nbut where that" 
                //                             " very overflow \nwas caught by"
                //                             " another check-error."
                //                             " \nWell done.\n");
                //            }

                //         NHANDLERS--; /* otherwise we don't unwind properly */
                //         runerror(vm, 
                //             "attempting to push an error frame in check-error"
                //             " caused a Stack Overflow");
                //     }
                //     Activation a = {pc + iXYZ(curr_instr), 
                //                      /* goto end of check-error */
                //                         vm->R_window_start, ERROR_FRAME};
                //     vm->Stack[vm->stackpointer++] = a;

                //     /* continue with execution, now in error mode */
                // }
                // break;
            // }            
            // case EndCheckError: {
            //     v = literal_value(vm, uYZ(curr_instr));
            //         fprintf(stderr, "Check-error failed: evaluating \"%s\" was "
            //         "expected to produce an error, but evaluation terminated "
            //         "normally.\n", AS_CSTRING(vm, v));
            //         /* error if nhandlers is 0 */
            //     NHANDLERS--;
            //     vm->stackpointer--; /* to remove the error frame */
            //     break;
            // }
            /* ARITH- R3 */
            case Add:
                registers[UX] = 
                    mkNumberValue(AS_NUMBER(vm, registers[UY]) 
                                  + AS_NUMBER(vm, registers[UZ]));
                                                            
                break;
            case Sub:
                registers[UX] = 
                    mkNumberValue(AS_NUMBER(vm, registers[UY]) 
                                  - AS_NUMBER(vm, registers[UZ]));
                break;
            case Mult:
                registers[UX] = 
                    mkNumberValue(AS_NUMBER(vm, registers[UY]) 
                                  * AS_NUMBER(vm, registers[UZ]));
                break;

            case Div: {
                uint8_t rZ = UZ;
                Number_T d = AS_NUMBER(vm, registers[rZ]);
                if (d == 0) {
                    runerror(vm, "division by zero");
                }
                registers[UX] = 
                    mkNumberValue(AS_NUMBER(vm, registers[UY]) / d);
                break;
            }
            // Special case: need to cast to int64_t for idiv && mod since they
            // have different behavior/are not defined on Number_T (double), 
            // then cast back to Number_T for mkNumberValue. 

            case IDiv: {
                uint8_t rZ = UZ;
                Number_T d = (int64_t)AS_NUMBER(vm, registers[rZ]);
                if (d == 0) {
                    runerror(vm, "division by zero");
                }
                registers[UX] = 
                    mkNumberValue((int64_t)AS_NUMBER(vm, 
                                                    registers[UY]) 
                                            / d);
                break;
            }
            case Mod: {
                uint8_t rZ = UZ;
                // coersion
                int64_t d = AS_NUMBER(vm, registers[rZ]);
                if (d == 0) {
                    runerror(vm, "division by zero");
                }
                registers[UX] = 
                    mkNumberValue((int64_t)AS_NUMBER(vm, 
                                                    registers[UY]) 
                                            % d);
                break;
            }

            /* BOOLEAN LOGIC- R3 */
            case Eq:
                registers[UX] = 
                mkBooleanValue(
                    eqvalue(registers[UY], 
                            registers[UZ]));
                break;

            case Gt:
                registers[UX] = 
                mkBooleanValue(AS_NUMBER(vm, registers[UY]) > 
                            AS_NUMBER(vm, registers[UZ]));
                break;

            case Lt:
                registers[UX] = 
                mkBooleanValue(AS_NUMBER(vm, registers[UY]) <
                            AS_NUMBER(vm, registers[UZ]));
                break;

            case Ge:
                registers[UX] = 
                mkBooleanValue(AS_NUMBER(vm, registers[UY]) >= 
                            AS_NUMBER(vm, registers[UZ]));
                break;
            
            case Le:
                registers[UX] = 
                mkBooleanValue(AS_NUMBER(vm, registers[UY]) <=
                            AS_NUMBER(vm, registers[UZ]));
                break;

            /* UNARY ARITH- R1 */
            case Inc:
                registers[UX] = 
                    mkNumberValue(AS_NUMBER(vm, registers[UX]) + 1);
                break;
            case Dec:
                registers[UX] = 
                    mkNumberValue(AS_NUMBER(vm, registers[UX]) - 1);
                break;
            case Neg:
                registers[UX] = 
                    mkNumberValue(-AS_NUMBER(vm, registers[UX]));
                break;    
            // REV: Is this needed in vScheme?   
            case Not:
                registers[UX] = 
                    mkNumberValue(~(int64_t)AS_NUMBER(
                                                vm, registers[UX]));
                break;  
            /* LITS <-> GLOBS <-> REGS */
            case LoadLiteral: 
                registers[UX] = vm->literals[uYZ(curr_instr)];
                break;
            
            case GetGlobal:
                registers[UX] = vm->globals[uYZ(curr_instr)];
                break;

            case SetGlobal:
                vm->globals[uYZ(curr_instr)] = registers[UX];
                break;

            /* R2 */
            case BoolOf:
                v.tag = Boolean;
                v.b = AS_BOOL(vm, registers[UY]);
                registers[UX] = v;
                break;
            

            case RegCopy:
                registers[UX] = registers[UY];
                break;

            case Swap:
                v = registers[UX];
                registers[UX] = registers[UY];
                registers[UY] = v;
                break;
            
            case Hash:
                registers[UX] = mkNumberValue(hashvalue(registers[UY]));
                break;

            case IsNil:
                registers[UX] = mkBooleanValue(registers[UY].tag == Nil);
                break;
            case IsBoolean:
                registers[UX] = mkBooleanValue(registers[UY].tag == Boolean);
                break;
            case IsNumber:
                registers[UX] = mkBooleanValue(registers[UY].tag == Number);
                break;
            case IsSymbol:
                registers[UX] = mkBooleanValue(registers[UY].tag == String);
                break;
            case IsNull:
                registers[UX] = mkBooleanValue(registers[UY].tag == Emptylist);
                break;
            case IsPair:
                registers[UX] = mkBooleanValue(registers[UY].tag == ConsCell);
                break;
            case IsFunction:
                registers[UX] = 
                    mkBooleanValue(   registers[UY].tag == VMFunction
                                   || registers[UY].tag == VMClosure);
                break;
            
            /* Unusual R2U8 case */
            case PlusImm:
                registers[UX] = mkNumberValue(AS_NUMBER(vm, registers[UY]) 
                                                                    + UZ);
                break;

            /* (UN)CONDITIONAL MOVEMENT */
            case If: 
                bool truth = AS_BOOL(vm, registers[UX]);
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
            case Return: {
                if (vm->stackpointer == 0) {
                    runerror(vm, "attempting to return register %hhu, "
                                 "from non-function.", UX);
                }

                Activation a = vm->Stack[--vm->stackpointer];


                Value return_value = registers[UX];

                // restore register window state and current instruction
                vm->R_window_start = a.R_window_start;
                registers = vm->registers + a.R_window_start;
                pc = a.resume_loc;

                if (a.dest_reg_idx < 0) {
                /* we've failed a check-error test if this happens. */                
                    NHANDLERS--;
                } else {
                    // set final return
                    registers[a.dest_reg_idx] = return_value;
                }
                break;
            }
            // TODO pull out more error messaging into vmstate helper funs
            case Call: {
                uint8_t r0 = UY;
                uint8_t rn = UZ;
                uint8_t n  = rn - r0;

                uint8_t dest_reg_idx = UX;


                // check for invalid function 
                if (registers[r0].tag == Nil) {
                    const char *funname = lastglobalset(vm, r0, fun, pc);
                    nilfunerror(vm, funname, "call", r0);
                }
                // We'd like to do this up top, but we need to make sure the 
                // function exists first so we can print a helpful 
                // debug message with a name we know to be valid!
                struct VMFunction *func = AS_VMFUNCTION(vm, registers[r0]);
                if (vm->stackpointer == MAX_STACK_FRAMES) {
                    if (NHANDLERS == 0) {
                        fprintf(stderr, "Offending function:");
                        fprintfunname(stderr, vm, mkVMFunctionValue(func));
                        fprintf(stderr, "\n");
                    }
                    runerror(vm, 
                        "attempting to call function in register %hhu"
                        " caused a Stack Overflow", r0);
                }


                if (vm->R_window_start + r0 + func->nregs > NUM_REGISTERS) {
                    if (NHANDLERS == 0) {
                        fprintf(stderr, "Offending function:");
                        fprintfunname(stderr, vm, mkVMFunctionValue(func));
                        fprintf(stderr, "\n");
                    }
                    runerror(vm, 
                        "attempting to call function in register %hhu"
                        " caused a Register Window Overflow", r0);
                }

                // call stack save
                Activation a = {pc, vm->R_window_start, 
                                 dest_reg_idx};
                vm->Stack[vm->stackpointer++] = a;


                // fprintf(stderr, "reg of func: %hhu, arity: %d, n: %hhu\n", r0, func->arity, n);

                assert(func->arity == n);

                // move the register window
                vm->R_window_start += r0;
                registers = vm->registers + vm->R_window_start;

                // transfer control= move instruction pointer to start of 
                // function instruction stream
                pc = &func->instructions[0] - 1; /* account for increment */

                // return will undo this based on the activation! 
                break;
            }
            case Tailcall: {
                uint8_t r0 = UX;
                uint8_t rn = UY;
                uint8_t n  = rn - r0;

                if (registers[r0].tag == Nil) {
                    const char *funname = lastglobalset(vm, r0, fun, pc);
                    nilfunerror(vm, funname, "tailcall", r0);
                }

                struct VMFunction *func = AS_VMFUNCTION(vm, registers[0]);

                if (rn + vm->R_window_start >= NUM_REGISTERS) {
                    if (NHANDLERS == 0) {
                        fprintf(stderr, "Offending function:");
                        fprintfunname(stderr, vm, mkVMFunctionValue(func));
                        fprintf(stderr, "\n");
                    }
                    runerror(vm, 
                      "attempting to tailcall function in register %hhu"
                      "caused a Register Window Overflow", r0);
                }

                // copy over function and argument registers 
                for (int i = 0; i <= n; ++i) {
                    registers[i] = registers[r0 + i];
                }

                // fprintf(stderr, "reg of func: %hhu, arity: %d, n: %hhu\n", r0, func->arity, n);
                assert(func->arity == n);

                pc = &func->instructions[0] - 1; /* account for increment */


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

