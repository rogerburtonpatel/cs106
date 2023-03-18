#ifndef BIGNUMS_H
#define BIGNUMS_H

#include "arraylist.h"
#include <stdlib.h>

struct BNUM_T {
    Arraylist_T numarr; /* this has length and so forth */
    bool positive;
};

typedef struct BNUM_T *BNUM_T;

BNUM_T BNUM_new(size_t length);

BNUM_T BNUM_add(BNUM_T bn1, BNUM_T bn2);
BNUM_T BNUM_sub(BNUM_T minuend, BNUM_T subtrahend);
BNUM_T BNUM_mul(BNUM_T bn1, BNUM_T bn2);
BNUM_T BNUM_div(BNUM_T dividend, BNUM_T divisior);
BNUM_T BNUM_mod(BNUM_T dividend, BNUM_T divisior);
BNUM_T BNUM_print(BNUM_T bn);

void BNUM_free(BNUM_T *bn);


#endif /* BIGNUMS_H */