//// Parsers for loading virtual object code.

// In module 2, you add parsers `parseR1LIT` and `parseR1GLOBAL` to
// this file.  The other parsers may serve as examples you can build on.

#include <assert.h>

#include "iformat.h"
#include "iparsers.h"
#include "vmstate.h"


#define SEE(R) do { if ((R) > *maxreg) *maxreg = (R); } while(0)

/* Helper functions */
static Value get_literal(Tokens *litp, const char *input);

Instruction parseR3(VMState vm, Opcode opcode, Tokens operands, unsigned *maxreg) {
  (void)vm;
  uint8_t regX = tokens_get_byte(&operands, NULL);
  uint8_t regY = tokens_get_byte(&operands, NULL);
  uint8_t regZ = tokens_get_byte(&operands, NULL);
  assert(operands == NULL);
  SEE(regX); SEE(regY); SEE(regZ);
  return eR3(opcode, regX, regY, regZ);
}

Instruction parseR2(VMState vm, Opcode opcode, Tokens operands, unsigned *maxreg) {
  (void)vm;
  uint8_t regX = tokens_get_byte(&operands, NULL);
  uint8_t regY = tokens_get_byte(&operands, NULL);
  assert(operands == NULL);
  SEE(regX); SEE(regY);
  return eR2(opcode, regX, regY);
}

Instruction parseR1(VMState vm, Opcode opcode, Tokens operands, unsigned *maxreg) {
  (void)vm;
  uint8_t regX = tokens_get_byte(&operands, NULL);
  assert(operands == NULL);
  SEE(regX);
  return eR1(opcode, regX);
}

Instruction parseR0(VMState vm, Opcode opcode, Tokens operands, unsigned *maxreg) {
  (void)vm;
  (void)maxreg;
  assert(operands == NULL);
  return eR0(opcode);
}

Instruction parseR1U16(VMState vm, Opcode opcode, Tokens operands, unsigned *maxreg) {
  (void)vm;
  uint8_t regX = tokens_get_byte(&operands, NULL);
  uint32_t immediate = tokens_get_int(&operands, NULL);
  assert(operands == NULL); // hit the newline
  assert(immediate == (uint16_t) immediate);
  SEE(regX);
  return eR1U16(opcode, regX, immediate);
}

Instruction parseR1U8(VMState vm, Opcode opcode, Tokens operands, unsigned *maxreg) {
  (void)vm;
  uint8_t regX = tokens_get_byte(&operands, NULL);
  uint8_t k    = tokens_get_byte(&operands, NULL);
  assert(operands == NULL);
  SEE(regX);
  return eR1U8(opcode, regX, k);
}


Instruction parseR2U8(VMState vm, Opcode opcode, Tokens operands, unsigned *maxreg) {
  (void)vm;
  uint8_t regX = tokens_get_byte(&operands, NULL);
  uint8_t regY = tokens_get_byte(&operands, NULL);
  uint8_t k    = tokens_get_byte(&operands, NULL);
  assert(operands == NULL);
  SEE(regX); SEE(regY);
  return eR3(opcode, regX, regY, k);
}

Instruction parseR0I24(VMState vm, Opcode opcode, Tokens operands, unsigned *maxreg) {
  (void)vm;
  (void)maxreg;
  int32_t immediate = tokens_get_int(&operands, NULL);
  assert(immediate == ((immediate << 8) >> 8));
  assert(operands == NULL);
  return eR0I24(opcode, immediate);
}


static Name truename, falsename, nilname, emptyname, stringname;

static void initnames(void) {
  if (truename == NULL) {
    truename     = strtoname("true");
    falsename    = strtoname("false");
    nilname      = strtoname("nil");
    emptyname    = strtoname("emptylist");
    stringname   = strtoname("string");
  }
}

/* Encode load literal instruction */
Instruction parseR1LIT(VMState vm, Opcode opcode, Tokens operands, unsigned *maxreg) {
    initnames(); // before comparing names, you must call this function
    uint8_t reg = tokens_get_byte(&operands, NULL);
    Value litv = get_literal(&operands, NULL);
    uint32_t litslot = literal_slot(vm, litv);
    assert(litslot == (uint16_t) litslot);
    assert(operands == NULL);
    SEE(reg);
    return eR1U16(opcode, reg, litslot);
}

Instruction parseU8LIT(VMState vm, Opcode opcode, Tokens operands, unsigned *maxreg) {
    (void)maxreg;
    initnames(); // before comparing names, you must call this function
    uint8_t u8 = tokens_get_byte(&operands, NULL);
    Value litv = get_literal(&operands, NULL);
    uint32_t litslot = literal_slot(vm, litv);
    assert(litslot == (uint16_t) litslot);
    assert(operands == NULL);
    return eR1U16(opcode, u8, litslot);
}

/* Encode load literal instruction but with no register involved */
Instruction parseLIT(VMState vm, Opcode opcode, Tokens operands, unsigned *maxreg)
{
    (void)maxreg;
    initnames(); // before comparing names, you must call this function
    Value litv = get_literal(&operands, NULL);
    uint32_t litslot = literal_slot(vm, litv);
    assert(litslot == (uint16_t) litslot);
    assert(operands == NULL);
    return eR1U16(opcode, 0, litslot);
}

/* Encode global variable declaration instruction */
Instruction parseR1GLO(VMState vm, Opcode opcode, Tokens operands, unsigned *maxreg) {
    initnames();
    uint8_t reg = tokens_get_byte(&operands, NULL);
    Value globalname = get_literal(&operands, NULL);
    uint32_t globalslot = global_slot(vm, globalname);
    assert(globalslot == (uint16_t) globalslot);
    assert(operands == NULL);
    Instruction instruction = eR1U16(opcode, reg, globalslot);
    SEE(reg);
    return instruction;
}

/* Get Literal Value from the token stream and return corresponding Value */
static Value get_literal(Tokens *litp, const char *input)
{
    int tokenType = first_token_type(*litp);
    switch (tokenType) {
        case TNAME: {
            Name name = tokens_get_name(litp, input);
            if (name == truename) {
                return mkBooleanValue(true);
            } else if (name == falsename) {
                return mkBooleanValue(false);
            } else if (name == nilname) {
                return nilValue;
            } else if (name == emptyname) {
                return emptylistValue;
            } else if (name == stringname) {
                uint32_t len = tokens_get_int(litp, input);
                StringBuffer sb = Vmstring_buffer(len);
                for (uint32_t i = 0; i < len; ++i) {
                    Vmstring_putc(sb, tokens_get_byte(litp, input));
                }
                VMString vstr = Vmstring_of_buffer(&sb);
                return mkStringValue(vstr);
            } else {
                assert(0);
            }
            break;
        }
        case TU32:
        /* TODO: ask about this! */
            return mkNumberValue((Number_T) 
                                 (int32_t)tokens_get_int(litp, input));
        case TDOUBLE:
          return mkNumberValue((Number_T)tokens_get_signed_number(litp, input));
        default:
            assert(0);    
    }
}
