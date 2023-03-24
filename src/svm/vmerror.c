// Implementations of the error functions

// Modules < 7: Interesting only if you want to know how to write 
// a function that acts like printf.

// Module 7 onward: useful to extend with a stack trace.

#include <assert.h>
#include <stdlib.h>
#include <stdio.h>

#include "print.h"
#include "value.h"
#include "vmerror.h"

uint64_t NHANDLERS = 0;


/* Only after writing these did I realize norman did it first. */

jmp_buf errorjmp; /* right now, we don't use this, but we will if we change how
                   we handle errors */
jmp_buf testjmp;

Printbuf errorbuf;

/* rewind the stack */

void stackunwind(VMState state, const char *format, ...)
{
    (void) format;
    Activation *Stack = state->Stack;
    while (state->stackpointer > 0 
           && Stack[state->stackpointer - 1].dest_reg_idx != ERROR_FRAME)  {
        state->stackpointer--;
    }
    ;
}

void runerror(VMState state, const char *format, ...)
{
    stackunwind(state, "");

   if (!errorbuf) {
        errorbuf = printbuf();
   }
    if (NHANDLERS == 0) {
        fprintf(stderr, "Run-time error:\n    ");
        va_list args;
        va_start(args, format);
        vfprintf(stderr, format, args);
        va_end(args);
        fprintf(stderr, "\n");
        abort(); /* we can change this to a longjmp to errorbuf 
                    if we don't want errors to crash our vm */
    } else {
        longjmp(testjmp, 1);
    }
}

void runerror_p(VMState state, const char *format, ...)
{
    stackunwind(state, "");
   
   if (!errorbuf) {
        errorbuf = printbuf();
   }

    if (NHANDLERS == 0) {
        fprintf(stderr, "Run-time error:\n    ");
        assert(format);
        va_list_box box;
        va_start(box.ap, format);
        vfprint(stderr, format, &box);
        va_end(box.ap);
        fprintf(stderr, "\n");
        abort(); /* we can change this to a longjmp to errorbuf 
                    if we don't want errors to crash our vm */
    } else {
        longjmp(testjmp, 1);
    }
}

void typeerror(VMState state, const char *expected, Value got, 
                              const char *file, int line)
{
    stackunwind(state, "");

    if (NHANDLERS == 0) {
        fprintf(stderr, "Run-time error: expected %s, but got %s.\n"
                        "\t(Internal source at %s, line %d)\n",
                expected, tagnames[got.tag], file, line);
        abort(); /* we can change this to a longjmp to errorbuf 
                    if we don't want errors to crash our vm */
    } else {
        longjmp(testjmp, 1);
    }

}
