// Functions for unit testing

// Module 1: The Check and Expect instructions will call these functions.
// The C `main` function calls `report_unit_tests`.

#ifndef CHECK_EXPECT
#define CHECK_EXPECT

#include "value.h"

// These functions can't be called in just any order.
// Sequences of calls have to respect a protocol, written
// here in EBNF:
//
//    { { (check expect | check_assert) } report_unit_tests }
//
// The protocol amounts to "check before expect."

struct VMState;

void check       (struct VMState *vm, const char *source, Value v);
void expect      (struct VMState *vm, const char *source, Value v);
void check_assert(const char *source, Value v);
void begin_error_check(struct VMState *vm);
void check_error(struct VMState *vm, const char *source);


void report_unit_tests(void);

// N.B. All strings are C strings.  These functions make private copies at need,
// so callers may move or recover memory.


#endif
