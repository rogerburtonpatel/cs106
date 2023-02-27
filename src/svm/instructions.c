// List of all opcodes, parsers, and unparsers

// You'll develop this list from module 2 onward.  Every time
// you add a new instruction, you'll add an entry here.
// You'll also define the opcode in file opcodes.h,
// and you'll add a case to your `vmrun` function.

#include "iformat.h"
#include "name.h"
#include "itable.h"

#pragma GCC diagnostic ignored "-Wmissing-field-initializers"

instruction_info instructions[] = {
  { "halt", Halt, parseR0, "halt" },
  { "print", Print, parseR1, "print rX" },
  { "println", Println, parseR1, "println rX" },
  { "printu", Printu, parseR1, "printu rX" },
  { "error", Error, parseR1, "error rX" },
  { "loadliteral", LoadLiteral, parseR1LIT, "rX := LIT" },
  { "loadglobal", LoadGlobal, parseR1GLO, "rX := _G[glo]" },
  { "setglobal", SetGlobal, parseR1GLO, "_G[glo] := rX" },
  { "check", Check, parseR1LIT, "check LIT, rX" },
  { "expect", Expect, parseR1LIT, "expect LIT, rX" },

  { "+",  Add,  parseR3, "+ rX rY rZ" },
  { "-",  Sub,  parseR3, "- rX rY rZ" },
  { "*", Mult, parseR3, "* rX rY rZ" },
  { "/",  Div,  parseR3, "/ rX rY rZ" },
  { "//", IDiv, parseR3, "// rX rY rZ" },
  { "mod",  Mod,  parseR3, "mod rX rY rZ" },
  { ">",  Gt,  parseR3, "> rX rY rZ" },
  { "<",  Lt,  parseR3, "< rX rY rZ" },
  { ">=",  Ge,  parseR3, "<= rX rY rZ" },
  { "<=",  Le,  parseR3, ">= rX rY rZ" },
  { "cons",  Le,  parseR3, "cons rX rY rZ" },
  { "=",  Le,  parseR3, "= rX rY rZ" },

  { "inc", Inc, parseR1, "inc rX" },
  { "dec", Dec, parseR1, "dec rX" },
  { "neg", Neg, parseR1, "neg rX" },
  { "not", Not, parseR1, "not rX" },

  {"boolOf", BoolOf, parseR2, "boolof rX rY" },
  {"copy", RegCopy, parseR2, "rX := rY"},
  {"car", Car, parseR2, "rX := car rY"},
  {"cdr", Cdr, parseR2, "rX := cdr rY"},
  {"function?", IsFunction, parseR2, "rX := function? rY"},
  {"number?", IsNumber, parseR2, "rX := number? rY"},
  {"symbol?", IsSymbol, parseR2, "rX := symbol? rY"},
  {"pair?", IsPair, parseR2, "rX := pair? rY"},
  {"boolean?", IsBoolean, parseR2, "rX := booelan? rY"},
  {"null?", IsNull, parseR2, "rX := null? rY"},
  {"nil?", IsNil, parseR2, "rX := nil? rY"},
  {"swap", Swap, parseR2, "rX, rY := rY, rX"},
  {"+imm", PlusImm, parseR2U8, "rX := rY + IMM"},

  {"if",   If,   parseR1,    "if rX" },
  {"goto", Goto, parseR0I24, "goto offset" },
};

int number_of_instructions = sizeof(instructions) / sizeof(instructions[0]);

int isgetglobal(Opcode code) {
  (void) code;
  return 0; // change this for your SVM
}

