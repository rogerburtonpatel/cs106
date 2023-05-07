// Defines all the opcodes used in the VM

// When you're thinking about new instructions, define them here first.
// It's OK for an opcode to be defined here even if it is not implemented 
// anywhere.  But if you want to *run* an instruction or *load*
// an instruction, the opcode has to be defined here first.

#ifndef OPCODE_INCLUDED
#define OPCODE_INCLUDED

#include <stdbool.h>

typedef enum opcode { 
                      Halt, // R0
                      Print, Println, Printu, // R1
                      Printl, Printlnl, // LIT
                      Error, // R1
                      Check, Expect, CheckAssert, // R1LIT
                      CheckError, // R1LIT
                      LoadLiteral, // R1LIT
                      GetGlobal, SetGlobal, // R1GLO
                      Add, Sub, Div, IDiv, Mult, Mod, Lt, Gt, Le, Ge, Eq, // R3
                      Gt0, PlusImm, // Depth: EXTENDED LITERALS- R2
                      MkBlock, GetBlockSlot, SetBlockSlot, // R2U8
                      GotoVcon, // R1U8
                      IfVconMatch, // U8LIT, not meant to be evaluated
                      Cons, // R3
                      Car, Cdr,  // R2
                      Inc, Dec, // R1
                      Neg, Not, // R2
                      BoolOf, // R2
                      Hash, // R2
                      IsFunction, IsNumber, IsSymbol, IsPair, // R2 
                      IsBoolean, IsNull, IsNil, // R2
                      RegCopy, Swap, // R2
                      Return, // R1
                      Call, // R3
                      Tailcall, // R2
                      MkClosure, SetClSlot, GetClSlot, // R3
                      If, // R1
                      Goto, // iXYZ
                      Gc, // R0- manual garbage collection for debugging
                      Unimp, // stand-in for opcodes not yet implemented
                      Unimp2, // stand-in for opcodes not yet implemented
} Opcode;

bool isgetglobal(Opcode code); // update this for your SVM, in instructions.c

#endif
