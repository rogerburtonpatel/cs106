#include <assert.h>
#include <stdbool.h>
#include "bignums.h"

struct BNUM_T {
    Arraylist_T numarr; /* this has length and so forth */
    bool positive;
};

BNUM_T BNUM_new(size_t length)
{
    Arraylist_T list = Arraylist_new(length);
    if (list == NULL) {
        return NULL;
    }
    
    BNUM_T bn = malloc(sizeof(*bn));
    if (bn == NULL) {
        return NULL;
    }

    bn->positive = true;
    return bn;
}

void BNUM_free(BNUM_T *bn)
{
    assert(bn && *bn);
    if ((*bn)->numarr != NULL) {
        Arraylist_free(&(*bn)->numarr);
    }
    free(*bn);
}

// we'll need comparison, same-sign add, and others. 

BNUM_T BNUM_add(BNUM_T bn1, BNUM_T bn2);
BNUM_T BNUM_sub(BNUM_T minuend, BNUM_T subtrahend);
BNUM_T BNUM_mul(BNUM_T bn1, BNUM_T bn2);
BNUM_T BNUM_div(BNUM_T dividend, BNUM_T divisior);
// BNUM_T BNUM_idiv(BNUM_T dividend, BNUM_T divisior); TODO ASK
BNUM_T BNUM_mod(BNUM_T dividend, BNUM_T divisior);

BNUM_T BNUM_print(BNUM_T bn)
{
    assert(bn && bn->numarr);
    uint32_t *arr = bn->numarr;
    size_t len = arr->length();
    for (size_t i = len - 1; i >= 0; --i) {
        printf("%u", arr[i]);
    }
}
