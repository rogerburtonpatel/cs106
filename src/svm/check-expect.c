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

#include "check-expect.h"
#include "print.h"

#include "vmstate.h"
#include "vmerror.h"

static char *checks;

static int ntests = 0;
static int npassed = 0;

extern jmp_buf testjmp;

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

void begin_error_check(struct VMState *vm)
{
    ntests++;
    NHANDLERS++;
    /* if not familiar with the arcane setjmp/longjmp form: 
       this will return 0 when we make the 'jump-to point,' and 
       nonzero if we jump to it with longjmp. */
    int havejumped = setjmp(testjmp);
    if (havejumped) {
        npassed++;
    } else {
        // push special frame
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
