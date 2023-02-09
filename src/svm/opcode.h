// Defines all the opcodes used in the VM

// When you're thinking about new instructions, define them here first.
// It's OK for an opcode to be defined here even if it is not implemented 
// anywhere.  But if you want to *run* an instruction (module 1) or *load*
// an instruction (module 2), the opcode has to be defined here first.

#ifndef OPCODE_INCLUDED
#define OPCODE_INCLUDED

#include <stdbool.h>

typedef enum opcode { 
                      Halt, // R0
                      Print, // R1
                      Println, // R1
                      Check, Expect, // R1LIT
                      GotoVcon, // R1U8
                      IfVconMatch, // U8LIT, not meant to be evaluated
                      Add, Sub, Div, Mult, Mod, // R3
                      Inc, Dec, Neg, Not,
                      LoadLiteral, // R1LIT
                      LoadGlobal, // R1GLO
                      SetGlobal, // R1GLO
                      Add, Sub, Div, IDiv, Mult, Mod, // R3
                      Inc, Dec, Neg, Not,
                      BoolOf, // R2
                      RegAssign, // R2
                      Swap, // R2
                      PlusImm, // R2
                      If, Goto, // R1
                      Unimp, // stand-in for opcodes not yet implemented
                      Unimp2, // stand-in for opcodes not yet implemented
} Opcode;

bool isgetglobal(Opcode code); // update this for your SVM, in instructions.c

#endif
