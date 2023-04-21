#include <assert.h>

#define GCMETA(STRUCT) struct STRUCT *forwarded;
#define GCINIT(V) ((V).forwarded = NULL)

#ifdef NGCDEBUG
#define GCVALIDATE(P) (P)
#else
#define GCVALIDATE(P) (assert((P)->forwarded == NULL), (P))
// safer
// #define GCVALIDATE(P) (assert((P) != NULL), assert((P)->forwarded == NULL), (P))
#endif
