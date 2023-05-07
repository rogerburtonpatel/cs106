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
 * INVARIANT: ONLY safe to change mode with set_error_mode() in the backend, 
 * and clients may ONLY affect these values with enter_check_error() and 
 * exit_check_error. Never change this flag manually in client code. 
 * You may always read the global mode. 
 */  
typedef enum ErrorMode { NORMAL, TESTING } ErrorMode;

/* 
 * This buffer is initialized by svm.c before calling vmrun(). 
 *  INVARIANT: It is always safe to jump to it within vmrun(), though this 
 *  should only be done if a run-time error occurs while the current error mode 
 *  is in 'TESTING', and only functions in the vmerror module should jump to it. 
 *  INVARIANT: The buffer is refreshed after each jump. 
 */

extern jmp_buf check_error_jmp;

extern void typeerror(VMState state, const char *expected, Value got,
                                const char *file, int line);
extern void runerror(VMState state, const char *format, ...);
  // takes arguments as for `printf`, not `print`
extern void runerror_p(VMState state, const char *format, ...);
  // takes arguments as for `print`, not `printf`

extern _Noreturn void fatal_error(const char *msg, const char *file, int line);
// call only for compiler bugs or uncatchable errors

// Thank you to nr for these ideas!
void enter_check_error(void); // start running within the dynamic extent 
                              // of an active check-error test
void exit_check_error(void); // leave the dynamic extent 
                             // of an active check-error test
   // It is a checked run-time error to call exit without a matching enter.
ErrorMode error_mode(void);                

#endif
