// Heart of the VM: runs instructions until told to halt

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
#include "vmsizes.h"

#include "print.h"

#include "svmdebug.h"
#include "disasm.h"

#include "vmerror.h"
#include "vmheap.h"
#include "vmstring.h"

#ifndef CANDUMP
#define CANDUMP 0
#else 
#define CANDUMP 1
#endif

#define UX uX(curr_instr)
#define UY uY(curr_instr)
#define UZ uZ(curr_instr)

#define VMSAVE() \
    (vm->fun     = fun, \
     vm->counter = pc - vm->fun->instructions, \
     vm->R_window_start = registers - vm->registers)

#define VMLOAD() \
    (fun = vm->fun, \
     pc  = vm->fun->instructions + vm->counter, \
     cons_symbol = vm->literals[vm->cons_sym_slot], \
     registers = vm->registers + vm->R_window_start)

#define GC() (VMSAVE(), gc(vm), VMLOAD())

extern int setjmp_proxy(jmp_buf t); /* see what a difference this makes! */
void vmrun(VMState vm, struct VMFunction *fun, CallStatus status) {
    const char *dump_decode = svmdebug_value("decode");
    const char *dump_call =  svmdebug_value("call");
    const char *dump_case = svmdebug_value("case");
    (void)dump_call; /* not used for now */
    Instruction *pc;
    /* Invariant: registers always = vm->registers + vm->R_window_start */
    Value *registers;
    Value v;

    Value constructor;
    uint8_t arity; /* for goto-vcon */
    /* Invariant: vm->fun and fun are always the currently running function
       before gargage collection, vm->fun */
    vm->fun = fun;

    if (fun->size < 1) {
        return;
    }

    Value cons_symbol = vm->literals[vm->cons_sym_slot]; 
    // ^ restore me after GC 
    // (this is for pattern matching so we know what 'cons' is)

    switch (status) {
        case INITIAL_CALL:;
            /* Thank you to Norman for this debugging infrastructure */
            VMLOAD();
            Activation base_record = 
                {.fun = fun,
                 .counter        = 0,
                 .R_window_start = 0,
                 .dest_reg_idx   = 0,};
            vm->Stack[vm->stackpointer++] = base_record;
            break;
        case ERROR_CALL:;
            if (error_mode() == TESTING) {
                pass_test();
                exit_check_error();
                Activation a = vm->Stack[--vm->stackpointer];
                vm->R_window_start = a.R_window_start;
                registers = vm->registers + a.R_window_start;
                pc = &(a.fun->instructions[0]) + a.counter + 1;
                break;
            } else {
                fprintf(stderr, "Stack trace: some day!\n");
                /* we're done */
                return;
            }
        default:
            assert(0);
    }
    // size_t total_instructions = 0;
    while (1) {
        Instruction curr_instr = *pc;
        // total_instructions++;

          if (CANDUMP && dump_decode) {
              idump(stderr, 
              vm, 
              ((int64_t)pc - (int64_t)&(vm->Stack[0].fun->instructions[0])) / 4, // TODO change this nonsense
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
                // fprintf(stderr, "Total instructions run: %zu", total_instructions);
                VMLOAD();
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
                if (error_mode() == TESTING) {
                    fprintf(stderr, "Fatal error: "
                                     "nested check-error not allowed\n");
                    abort();
                }

                uint8_t r0 = UX;
                if (registers[r0].tag != VMFunction) {
                    const char *funname = 
                                        lastglobalset(vm, r0, fun, pc);
                    not_a_function_error(vm, funname, "check-error", r0);
                }
                add_test();
                enter_check_error();
                /* push special frame and vmcall func.  */
                    if (vm->stackpointer == MAX_STACK_FRAMES) {
                        exit_check_error(); //otherwise we don't unwind properly
                        runerror(vm, 
                            "attempting to push an error frame in check-error"
                            " caused a Stack Overflow");
                    }

                    struct VMFunction *func = AS_VMFUNCTION(vm, registers[r0]);
                    (void)GCVALIDATE(func);
                    assert(func->arity == 0); /* this can NEVER have args */
                    /* push special frame */
                    Activation error_frame = 
                            {.fun = fun, 
                            .counter        = pc - fun->instructions, 
                            .R_window_start = vm->R_window_start, 
                    // PRESENT ME talk about this funky line
                            .dest_reg_idx   = -(int)uYZ(curr_instr)};

                    vm->Stack[vm->stackpointer++] = error_frame;
                    vm->fun = fun = func;
                    pc = &func->instructions[0] - 1;
                break;
            }
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
                int64_t d = (int64_t)AS_NUMBER(vm, registers[rZ]);
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
            // TODO THESE DON'T WORK WITH GLOBALS
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
            // TODO FIX: THIS DOESN'T WORK
                registers[UX] = 
                    mkNumberValue(-(int64_t)AS_NUMBER(vm, registers[UY]));
                break;    
            case Not:
                registers[UX] = 
                    mkBooleanValue(!AS_BOOL(vm, registers[UY]));
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

            /* LISTS */

            case Cons: {
                v        = registers[UY];
                Value v2 = registers[UZ];
                // never forget the pain this caused v
                // VMNEW(struct VMBlock *, cell, sizeof(int) + 2 * sizeof(Value));
                VMNEW(struct VMBlock *, cell, vmsize_cons());
                cell->nslots   = 2;
                cell->slots[0] = v;
                cell->slots[1] = v2;
                registers[UX]  = mkConsValue(cell);
                break;
            }
            case Car:
                registers[UX] = AS_CONS_CELL(vm, registers[UY])->slots[0];
                break;
            case Cdr:
                registers[UX] = AS_CONS_CELL(vm, registers[UY])->slots[1];
                break;
            
            /* EXTENDED LITERALS: Unusual R2U8/R2 case */
            case PlusImm:
                registers[UX] = mkNumberValue(AS_NUMBER(vm, registers[UY]) 
                                                                    + (UZ - 128));
                break;
            
            case Gt0:
                registers[UX] = 
                               mkBooleanValue(AS_NUMBER(vm, registers[UY]) > 0);
                break;

            /* (UN)CONDITIONAL MOVEMENT */
            case If: {
                bool truth = AS_BOOL(vm, registers[UX]);
                if (!truth) {
                    pc++; // If false, skip next instruction.
                }
                break;
            }
            case Goto: {
                int32_t offset = iXYZ(curr_instr);
                if (offset < 0 && gc_needed) {
                    GC();
                }
                pc += 1 + offset; 
                continue; // follows the semantics by adding 1 + for the normal
                          // counter increment, then adding the goto value, 
                          // then skipping the increment with continue

            }
            /* FUNCTIONS */
            case Return: {
                if (vm->stackpointer == 0) {
                    runerror(vm, "attempting to return register %hhu, "
                                 "from non-function.", UX);
                }

                Activation callee = vm->Stack[--vm->stackpointer];

                Value return_value = registers[UX];

                // restore register window state and current instruction
                vm->R_window_start = callee.R_window_start;
                registers = vm->registers + callee.R_window_start;
                vm->fun = fun = callee.fun;
                pc = &(callee.fun->instructions[0]) + callee.counter;

                if (callee.dest_reg_idx < 0) {
                /* we've failed a check-error test if this happens. */
                    int slot = -callee.dest_reg_idx;
                    v = literal_value(vm, (uint16_t)slot);
                    fail_check_error(vm, AS_CSTRING(vm, v));
                } else {
                    registers[callee.dest_reg_idx] = return_value;
                }
                break;
            }
            // TODO pull out more error messaging into vmstate helper funs
            case Call: {
                if (gc_needed)
                    GC();
                uint8_t r0 = UY;
                uint8_t rn = UZ;
                uint8_t n  = rn - r0;

                uint8_t dest_reg_idx = UX;

                struct VMFunction *func;

                switch (registers[r0].tag) {
                    case VMFunction:
                        func = registers[r0].f;
                        break;
                    case VMClosure:
                        func = registers[r0].hof->f;
                        break;
                    default:;
                        func = NULL; /* stops the compiler from complaining */
                        const char *funname = lastglobalset(vm, r0, fun, pc);
                        not_a_function_error(vm, funname, "call", r0);
                        break;
                }
                (void)GCVALIDATE(func);
                /* We'd like to do this up top, but we need to make sure the 
                function exists first so we can print a helpful 
                debug message with a name we know to be valid! */
                if (vm->stackpointer == MAX_STACK_FRAMES) {
                    if (error_mode() == NORMAL) {
                        fprintf(stderr, "Offending function:");
                        fprintfunname(stderr, vm, mkVMFunctionValue(func));
                        fprintf(stderr, "\n");
                    }
                    runerror(vm, 
                        "attempting to call function in register %hhu"
                        " caused a Stack Overflow", r0);
                }


                if (vm->R_window_start + r0 + func->nregs > NUM_REGISTERS) {
                    if (error_mode() == NORMAL) {
                        fprintf(stderr, "Offending function:");
                        fprintfunname(stderr, vm, mkVMFunctionValue(func));
                        fprintf(stderr, "\n");
                    }
                    runerror(vm, 
                        "attempting to call function in register %hhu"
                        " caused a Register Window Overflow", r0);
                }



                Activation new_record = 
                            {.fun = fun, 
                            .counter        = pc - fun->instructions, 
                            .R_window_start = vm->R_window_start, 
                            .dest_reg_idx   = dest_reg_idx};
            
                vm->Stack[vm->stackpointer++] = new_record;

                if (func->arity != n) {
                    if (error_mode() == NORMAL) {
                        fprintf(stderr, "Offending function:");
                        fprintfunname(stderr, vm, mkVMFunctionValue(func));
                        fprintf(stderr, "\n");
                    }
                    runerror(vm, 
                        "attempted to call function in register %hhu"
                        " with %d arguments; the function's arity is %d", 
                        r0, n, func->arity);
                }

                /* move the register window */
                vm->R_window_start += r0;
                registers = vm->registers + vm->R_window_start;

               /*  transfer control= move instruction pointer to start of 
                function instruction stream, 
                and set current running function to this one */
                vm->fun = fun = func;
                pc = &func->instructions[0] - 1; /* account for increment */

                /* return will undo this based on the activation!  */
                break;
            }
            case Tailcall: {
                if (gc_needed)
                    GC();
                uint8_t r0 = UX;
                uint8_t rn = UY;
                uint8_t n  = rn - r0;

                struct VMFunction *func;

                switch (registers[r0].tag) {
                    case VMFunction:
                        func = registers[r0].f;
                        break;
                    case VMClosure:
                        func = registers[r0].hof->f;
                        break;
                    default:;
                        func = NULL; /* stops the compiler from complaining */
                        const char *funname = lastglobalset(vm, r0, fun, pc);
                        not_a_function_error(vm, funname, "call", r0);
                        break;
                }
                (void)GCVALIDATE(func);
                                       
                if (rn + vm->R_window_start >= NUM_REGISTERS) {
                    if (error_mode() == NORMAL) {
                        fprintf(stderr, "Offending function:");
                        fprintfunname(stderr, vm, mkVMFunctionValue(func));
                        fprintf(stderr, "\n");
                    }
                    runerror(vm, 
                      "attempting to tailcall function in register %hhu"
                      "caused a Register Window Overflow", r0);
                }
                
                /* copy over function and argument registers  */
                for (int i = 0; i <= n; ++i) {
                    registers[i] = registers[r0 + i];
                }

                if (func->arity != n) {
                    if (error_mode() == NORMAL) {
                        fprintf(stderr, "Offending function:");
                        fprintfunname(stderr, vm, mkVMFunctionValue(func));
                        fprintf(stderr, "\n");
                    }
                    runerror(vm, 
                        "attempted to call function in register %hhu"
                        " with %d arguments; the function's arity is %d", 
                        r0, n, func->arity);
                }

               /*  transfer control= move instruction pointer to start of 
                function instruction stream, 
                and set current running function to this one */
                vm->fun = fun = func;
                pc = &func->instructions[0] - 1; /* account for increment */

                break;
            }

            case MkClosure: {
                struct VMFunction *f = AS_VMFUNCTION(vm, registers[UY]);
                (void)GCVALIDATE(f);
                size_t nslots = UZ;
                VMNEW(struct VMClosure *, cl, 
                      vmsize_closure(nslots));
                cl->f = f;
                cl->nslots = nslots;
                registers[UX] = mkClosureValue(cl);
                break;
            }
            case SetClSlot: {
                struct VMClosure *cl = AS_CLOSURE(vm, registers[UX]);
                (void)GCVALIDATE(cl);
                assert(UZ < cl->nslots);
                cl->captured[UZ] = registers[UY];
                break;
            }
            case GetClSlot: {
                struct VMClosure *cl = AS_CLOSURE(vm, registers[UY]);
                (void)GCVALIDATE(cl);
                assert(UZ < cl->nslots);
                registers[UX] = cl-> captured[UZ];
                break;
            }

            case MkBlock: {
                size_t nslots = UZ;
                VMNEW(struct VMBlock *, b, 
                      vmsize_block(nslots));
                b->nslots = nslots;
                b->slots[0] = registers[UY];
                registers[UX] = mkBlockValue(b);
                break;
            }
            case SetBlockSlot: {
                struct VMBlock *b = AS_BLOCK(vm, registers[UX]);
                (void)GCVALIDATE(b);
                assert(UZ < b->nslots);
                b->slots[UZ] = registers[UY];
                break;
            }
            case GetBlockSlot: {
                struct VMBlock *block = registers[UY].block;
                if (registers[UY].tag == ConsCell) {
                    switch (UZ) {
                    case 0: registers[UX] = cons_symbol; break;
                    case 1: case 2: registers[UX] = block->slots[UZ - 1]; break;
                    default: 
                         runerror(vm, "A cons cell doesn't have a slot %d", UZ);
                    }
                } else {
                    block = AS_BLOCK(vm, registers[UY]);
                    if (UZ >= block->nslots) {
                        runerror(vm, "Attempted to access slot %d on a block "
                                     "with %d slots", UZ, block->nslots);
                    }
                    registers[UX] = block->slots[UZ];
                }
                break;
            }

            case GotoVcon: {
                constructor = registers[UX];
                uint8_t numslots = UY;
                switch (constructor.tag) {
                    case Block: 
                        arity = constructor.block->nslots - 1;
                        constructor = constructor.block->slots[0]; 
                        break;
                    case ConsCell:
                        arity = 2;
                        constructor = cons_symbol;
                        break;
                    default:
                        arity = 0;
                        break;
                }

                if (CANDUMP && dump_case) {
                    fprint(stderr, "in GotoVcon- from scrutinee %v, we have "
                                   "computed constructor %v with arity %d\n"
                                   , registers[UX], constructor, arity);
                }

                /* find corresponding ifVconMatch */
                pc++; /* enter jump table */
                for (int i = 0; i < numslots; i++) {
                    /* we do this because UX and friends are based off of 
                       variable curr_instr-- I might change this to just be
                       *pc to have a single point of truth. */
                    curr_instr = *pc;
                    assert(opcode(curr_instr) == IfVconMatch); /* extra care */
                    Value maybematch = vm->literals[uYZ(curr_instr)];
                    if (CANDUMP && dump_case) {
                    fprint(stderr, "in GotoVcon- matching scrutinee %v against "
                                   "ifVconMatch value %v with arity %d\n",
                                    constructor, maybematch, UX);
                }
                    if (UX == arity && eqvalue(maybematch, constructor)) 
                    {
                        /* +2: 1 to actually arrive at the goto from the 'if', 
                            1 for the usual pre-offset increment. */
                        pc += 2 + iXYZ(*(pc + 1)); 
                        break;
                    }
                    pc += 2; /* on to the next ifVconMatch/Goto pair */
                }
                continue; /* just leave off here; don't re-increment pc. */
            }

            /* R0- MANUAL GARBAGE COLLECTION */
            case Gc: 
                GC();
                break;

            default:
                printf("Opcode Not implemented!\n");
                break;
        }
        pc += 1;
    }
    return;
}

