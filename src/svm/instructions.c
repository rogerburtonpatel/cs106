// List of all opcodes, parsers, and unparsers

// You'll develop this list from module 2 onward.  Every time
// you add a new instruction, you'll add an entry here.
// You'll also define the opcode in file opcodes.h,
// and you'll add a case to your `vmrun` function.

#include "iformat.h"
#include "name.h"
#include "itable.h"

#include <stdio.h>

#pragma GCC diagnostic ignored "-Wmissing-field-initializers"

instruction_info instructions[] = {
  { "halt", Halt, parseR0, "halt" },
  { "print", Print, parseR1, "print rX" },
  { "println", Println, parseR1, "println rX" },
  { "loadliteral", LoadLiteral, parseR1LIT, "rX := LIT" },
  { "check", Check, parseR1LIT, "check LIT, rX" },
  { "expect", Expect, parseR1LIT, "expect LIT, rX" },

  { "+",  Add,  parseR3, "add rX rY rZ" },
  { "-",  Sub,  parseR3, "sub rX rY rZ" },
  { "*", Mult, parseR3, "mult rX rY rZ" },
  { "/",  Div,  parseR3, "div rX rY rZ" },
  { "//", IDiv, parseR3, "idiv rX rY rZ" },
  { "mod",  Mod,  parseR3, "mod rX rY rZ" },

  { "inc", Inc, parseR1, "inc rX" },
  { "dec", Dec, parseR1, "dec rX" },
  { "neg", Neg, parseR1, "neg rX" },
  { "not", Not, parseR1, "not rX" },

  {"boolof", BoolOf, parseR2, "boolof rX rY" },
  {"=", RegAssign, parseR2, "rX := rY"},
  {"swap", Swap, parseR2, "rX, rY := rY, rX"},
  {"+imm", PlusImm, parseR2U8, "rX := rY + IMM"},

  {"if",   If,   parseR1,    "if rX" },
  {"goto", Goto, parseR0I24, "goto offset" },
};

int number_of_instructions = sizeof(instructions) / sizeof(instructions[0]);

bool isgetglobal(Opcode code) {
  fprintf(stderr,
          "%s, line %d: function `isgetglobal` is not implemented", __FILE__, __LINE__);
  (void) code;
  return false; // change this for your SVM
}

