#ifndef GCDEBUG_INCLUDED
#define GCDEBUG_INCLUDED

#define NOVALGRIND 1

#include <stdlib.h>

void gc_debug_init(void); // required before using other things in this interface

// unless SVMDEBUG includes a `gc` element, these functions have no effect

void gcprint (const char *fmt, ...);  /* print GC debugging info */
void gcprintf(const char *fmt, ...);


#endif
