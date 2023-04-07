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


typedef enum ErrorMode { NORMAL, TESTING } ErrorMode;


extern void typeerror(VMState state, const char *expected, Value got,
                                const char *file, int line);
extern void runerror(VMState state, const char *format, ...);
  // takes arguments as for `printf`, not `print`
extern void runerror_p(VMState state, const char *format, ...);
  // takes arguments as for `print`, not `printf`

/* call only for compiler bugs or uncatchable errors */
extern _Noreturn void fatal_error(const char *msg, const char *file, int line);

void enter_check_error(void); // start running within the dynamic extent 
                              // of an active check-error test
void exit_check_error(void); // leave the dynamic extent 
                             // of an active check-error test
ErrorMode error_mode(void);                             
   // It is a checked run-time error to call exit without a matching enter.

#endif
