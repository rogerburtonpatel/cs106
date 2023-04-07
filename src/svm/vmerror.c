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


// TODO DOCUMENT
static ErrorMode mode = NORMAL;

void set_error_mode(ErrorMode new_mode) {
  assert(new_mode == NORMAL || new_mode == TESTING);
  mode = new_mode;
}

/* Only after writing these did I realize norman did it first. */

jmp_buf testjmp;

void enter_check_error(void)
{
    set_error_mode(TESTING);
}
void exit_check_error(void)
{
    if (mode != TESTING) {
        fatal_error("called exit_check_error while not in error mode", __FILE__, __LINE__);
    }
    set_error_mode(NORMAL);
}

ErrorMode error_mode(void)
{
    return mode;
}

/* rewind the stack */

void fatal_error(const char *msg, const char *file, int line)
{
    fprintf(stderr, "Fatal error: %s\t(Internal source at %s, line %d)\n", 
                    msg, file, line);
    abort();
}

void stackunwind(VMState state)
{
    Activation *Stack = state->Stack;
    while (state->stackpointer > 0 
           && Stack[state->stackpointer - 1].dest_reg_idx > 0)  {
        state->stackpointer--;
    }
}

void runerror(VMState state, const char *format, ...)
{
    stackunwind(state);

    if (mode == NORMAL) {
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
    stackunwind(state);
   
    if (mode == NORMAL) {
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
    stackunwind(state);

    if (mode == NORMAL) {
        fprintf(stderr, "Run-time error: expected %s, but got %s.\n"
                        "\t(Internal source at %s, line %d)\n",
                expected, tagnames[got.tag], file, line);
        abort(); /* we can change this to a longjmp to errorbuf 
                    if we don't want errors to crash our vm */
    } else {
        longjmp(testjmp, 1);
    }

}
