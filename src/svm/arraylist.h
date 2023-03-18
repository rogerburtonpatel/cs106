#ifndef ARRAYLIST_H
#define ARRAYLIST_H

#include <stdint.h>
#include <stddef.h>

typedef struct Arraylist_T *Arraylist_T;

Arraylist_T Arraylist_new(size_t hint);
void Arraylist_free(Arraylist_T *list);
size_t length(Arraylist_T list);
void push_front(Arraylist_T list, uint32_t val);
void push_back(Arraylist_T list, uint32_t val);
uint32_t Arraylist_at(Arraylist_T list, uint64_t idx);
void expand(Arraylist_T list);

#endif /* ARRAYLIST_H */
