// Functions for unit testing

// These implementations are adapted from my book *Programming
// Languages: Build, Prove, and Compare.*  The fact of having
// Check and Expect as VM instructions is extremely interesting,
// but the implementations themselves are not interesting.
// You needn't bother with them.

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <setjmp.h>

#include "check-expect.h"
#include "print.h"

#include "vmstate.h"
#include "vmerror.h"

static char *checks;

static int ntests = 0;
static int npassed = 0;

extern jmp_buf testjmp;

void add_test()
{
    ntests++;
}

void pass_test()
{
    npassed++;
}

static char *copy(const char *s) {
  int n = strlen(s);
  char *t = malloc(n+1);
  strcpy(t, s);
  return t;
}


void check(struct VMState *vm, const char *source, Value v) {
  assert(checks == NULL);
  checks = copy(source);
  vm->awaiting_expect = v;
}

void expect(struct VMState *vm, const char *source, Value expectv) {
  (void)source;
  ntests++;
  assert(checks != NULL);
  if (eqtests (vm->awaiting_expect, expectv)) {
    npassed++;
  } else {
    fprint(stderr, "Check-expect failed: expected %s to evaluate to %v, "
           "but it's %v.\n", checks, expectv, vm->awaiting_expect);
  }
  vm->awaiting_expect = nilValue;
  free(checks);
  checks = NULL;
}

void check_assert(const char *source, Value v) {
  ntests++;
  assert(checks == NULL);
  if (v.tag == Nil || (v.tag == Boolean && !v.b)) {
    fprint(stderr, "Check-assert failed: %s evaluates to %v.\n", source, v);
  } else {
    npassed++;
  }
}

/* note: runerror will have unwound the stack at this point, so we
    have an error frame on top */
void begin_error_check(struct VMState *vm, Instruction **pc, Value **registers, 
                                                             uint32_t jmp_amt)
{
    ntests++;
    NHANDLERS++;
    /* if not familiar with the arcane setjmp/longjmp form: 
       this will return 0 when we make the 'jump-to point,' and 
       nonzero if we jump to it with longjmp. */
    fprintf(stderr, "outer p:%p\n", (void *)vm);
    int havejumped = setjmp(testjmp);
    fprintf(stderr, "inner p 1:%p\n", (void *)vm);

    /* Ensure that the function that calls sigsetjmp() does not return before 
    you call the corresponding siglongjmp() function. Calling siglongjmp() 
    after the function calling sigsetjmp() returns causes unpredictable 
    program behavior. */

    if (havejumped) {
        npassed++;
        NHANDLERS--;
        fprintf(stderr, "inner p 2:%p\n", (void *)vm);
        /* restore frame */
        fprintf(stderr, "stackpointer: %hu\n", vm->stackpointer);
        fprintf(stderr, "Stack[0].dest_reg_idx: %d\n", vm->Stack[0].dest_reg_idx);
        Activation a = vm->Stack[--vm->stackpointer];
        vm->R_window_start = a.R_window_start;
        *registers = vm->registers + a.R_window_start;
        *pc = a.resume_loc + jmp_amt; /* goto end of check-error */
    } else {
        /* push special frame */
        if (vm->stackpointer == MAX_STACK_FRAMES) {
            runerror(vm, 
                "attempting to push an error frame in check-error"
                " caused a Stack Overflow");
        }
        Activation a = {*pc, vm->R_window_start, ERROR_FRAME};
        vm->Stack[vm->stackpointer++] = a;

        /* continue with execution, now in error mode */
    }
    
}

/* if we get here, the test has failed. 
    gives a nice error msg and uninstalls handler so
   subsequent errors will crash if they should. */
void check_error(struct VMState *vm, const char *source)
{
    (void) vm;
    fprintf(stderr, "Check-error failed: evaluating \"%s\" was expected to "
                    "produce an error, but evaluation terminated "
                    "normally.\n", source);
    NHANDLERS--;
}

void report_unit_tests(void) {
    switch (ntests) {
    case 0: break; /* no report */
    case 1:
        if (npassed == 1)
            printf("The only test passed.\n");
        else
            printf("The only test failed.\n");
        break;
    case 2:
        switch (npassed) {
        case 0: printf("Both tests failed.\n"); break;
        case 1: printf("One of two tests passed.\n"); break;
        case 2: printf("Both tests passed.\n"); break;
        default: assert(0); break;
        }
        break;
    default:
        if (npassed == ntests)
            printf("All %d tests passed.\n", ntests);
        else if (npassed == 0) 
            printf("All %d tests failed.\n", ntests);
        else
            printf("%d of %d tests passed.\n", npassed, ntests);
        break;
    }
    ntests = npassed = 0; // reset the counters
}
