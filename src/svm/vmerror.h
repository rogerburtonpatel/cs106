// Error reporting

// Module 1: Useful for reporting errors, like (for example) 
// an unrecognized opcode.
// Module 7 onward: Can be extended to report a stack trace on error
// (depth goal).

#ifndef ERROR_DEFINED
#define ERROR_DEFINED

#include <stdarg.h>
#include <stdnoreturn.h>

#include "vmstate.h"
#include "value.h"

/*
 * Only after writing these did I realize norman did it first. 
 */
extern uint64_t NHANDLERS;

// Checked run-time errors: print a message and halt the computation.

extern void typeerror(VMState state, const char *expected, Value got,
                                const char *file, int line);
extern void runerror(VMState state, const char *format, ...);
  // takes arguments as for `printf`, not `print`
extern void runerror_p(VMState state, const char *format, ...);
  // takes arguments as for `print`, not `printf`

#endif
