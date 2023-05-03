/* a pure ChatGPT arraylist implementation. */

#include <stdlib.h>
#include <assert.h>
#include "arraylist.h"


struct Arraylist_T {
    uint32_t *arr;
    size_t length;
    size_t capacity;
};

Arraylist_T Arraylist_new(size_t hint) {
    Arraylist_T list = malloc(sizeof(*list));
    if (list == NULL) {
        return NULL;
    }
    list->arr = calloc(hint, sizeof(list->arr));
    if (list->arr == NULL) {
        free(list);
        return NULL;
    }
    list->length = 0;
    list->capacity = hint;
    return list;
}

void Arraylist_free(Arraylist_T *list)
{
    assert(list && *list);
    if ((*list)->arr != NULL) {
        free((*list)->arr);
    }
    free(*list);
}

size_t length(Arraylist_T list) {
    return list->length;
}

void push_front(Arraylist_T list, uint32_t val)
{
    if (list->length == list->capacity) {
        expand(list);
    }
    for (size_t i = list->length; i > 0; i--) {
        list->arr[i] = list->arr[i-1];
    }
    list->arr[0] = val;
    list->length++;
}

void push_back(Arraylist_T list, uint32_t val)
{
    if (list->length == list->capacity) {
        expand(list);
    }
    list->arr[list->length] = val;
    list->length++;
}

uint32_t Arraylist_at(Arraylist_T list, uint64_t idx) 
{
    assert(idx < list->length);
    return list->arr[idx];
}


void expand(Arraylist_T list)
{
    size_t new_capacity = (list->capacity + 2) * 2;
    uint32_t *new_arr = malloc(new_capacity * sizeof(uint32_t));
    assert(new_arr != NULL);
    uint32_t *arr = list->arr;
    for (size_t i = 0; i < list->length; ++i) {
        new_arr[i] = arr[i];
    }
    list->arr = new_arr;
    list->capacity = new_capacity;
}

Arraylist_T arraylist_deep_copy(const Arraylist_T list)
{
    Arraylist_T new_list = malloc(sizeof(*new_list));
    assert(new_list != NULL);

    new_list->arr = malloc(list->capacity * sizeof(uint32_t));
    assert(new_list->arr != NULL);

    new_list->length = list->length;
    new_list->capacity = list->capacity;

    for (size_t i = 0; i < list->length; i++) {
        new_list->arr[i] = list->arr[i];
    }

    return new_list;
}
