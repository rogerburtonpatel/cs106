// Implementation of the VM heap

// Modules 1 to 10: Nothing to see here.
// Module 11: You'll reclaim and recycle heap pages.

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "vmheap.h"


union align {
#ifdef MAXALIGN
        char pad[MAXALIGN];
#else
        int i;
        long l;
        long *lp;
        void *p;
        void (*fp)(void);
        float f;
        double d;
        long double ld;
#endif
};

#define PAGESIZE (32*1024)   // bytes in one page
#define NPAYLOAD (PAGESIZE - sizeof (struct page *) - sizeof(union align))
#define SMALL_OBJECT_LIMIT  (NPAYLOAD / 4)

// alignment code copied from Hanson, C Interfaces and Implementations, MIT license

static inline size_t roundup(size_t n, size_t block) {
  return ((n + block - 1) / block) * block;
}

typedef struct page {
  struct page *link;
  union align a;
  // empty space here not declared, just like Hanson
} *Page;

static Page current;
  // current page, linked to older pages that have already been used
  // to satisfy allocation requests ("allocated")

static char *next, *limit;
  // if not NULL, pointers into current page


static Page fresh;
  // completely empty pages that can be used to satisfy future allocation requests

static void refill(void) {
  // add pages
#define MEGAPAGE 1
  char *memory = malloc(MEGAPAGE * PAGESIZE);
  assert(memory);
  for (int i = 0; i < MEGAPAGE; i++) {
    Page p = (Page) memory;
    p->link = fresh;
    fresh = p;
    memory += PAGESIZE;
  }
#undef MEGAPAGE
}

static Page newpage(void) {
  if (fresh == NULL)
    refill();

  assert(fresh);
  Page new = fresh;
  fresh = fresh->link;

  return new;
}

static void link_new_page(void) {
  Page new = newpage();
  new->link = current;
  current = new;
  next  = (char *)&current->a;
  limit = (char *)current + PAGESIZE;
}

static inline void *alloc_small(size_t n) {
  assert(n > 0);
  long nbytes = (long) roundup(n, sizeof (union align));
  assert(nbytes < limit - (char *)&current->a); // not too big
  if (nbytes > limit - next)
    link_new_page();
  assert(nbytes <= limit - next);
  void *object = next;
  next += nbytes;
  return object;
}
    
void *vmalloc_raw(size_t n) {
  if (n <= SMALL_OBJECT_LIMIT) {
    return alloc_small(n);
  } else {
    fprintf(stderr, "Large-object allocator not implemented for object of size %lu\n",
            (unsigned long) n);
    assert(0);
    return NULL;
  }
}

void *vmcalloc_raw(size_t num, size_t size) {
  void *block = vmalloc_raw(num * size);
  memset(block, 0, num * size);
  return block;
}


void heap_init(void) {
  link_new_page();
}

void heap_shutdown(void) {
  while(current) {
    Page next = current->link;
    free(current);
    current = next;
  }
  while(fresh) {
    Page next = fresh->link;
    free(fresh);
    fresh = next;
  }
}
