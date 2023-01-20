// Implementation of hash table, modified from Hanson CII

// Will have to be looked at in module 12, but not until then.

#include <assert.h>
#include <limits.h>
#include <stddef.h>
#include <string.h>

#include "vtable.h"
#include "vmheap.h"

#include "print.h"

#define T VTable_T
struct T {
        int size;  // number of buckets
	int length; // population
	unsigned timestamp;
	struct binding {
		struct binding *link;
		Value key;
		Value value;
	} **buckets;
};


size_t VTable_size(int nbuckets) {
  T table;
  return sizeof (*table) + nbuckets * sizeof (table->buckets[0]);
}

T VTable_new(int hint) {
	int i;
	static int primes[] = { 5, 5, 11, 23, 47, 97, 197, 397, 509, 1021, 2053, 4093,
		8191, 16381, 32771, 65521, INT_MAX };
           // smaller sizes borrowed from Lua 3.0
	assert(hint >= 0);
	for (i = 1; primes[i] < hint; i++)
		;
        VMNEW(T, table, VTable_size(primes[i-1]));
	table->size = primes[i-1];
	table->buckets = (struct binding **)(table + 1);
	for (i = 0; i < table->size; i++)
		table->buckets[i] = NULL;
	table->length = 0;
	table->timestamp = 0;
	return table;
}

Value VTable_get(T table, Value key) {
	int i;
	struct binding *p;
	assert(table);
        uint32_t h = hashvalue(key);
	i = h % table->size;
	for (p = table->buckets[i]; p; p = p->link)
		if (identical(key, p->key))
			break;
	return p ? p->value : nilValue;
}

void VTable_put(T table, Value key, Value value) {
	int i;
	struct binding *p;
	assert(table);
        if (value.tag == Nil) {
                VTable_remove(table, key);
        } else {
                i = hashvalue(key)%table->size;
                for (p = table->buckets[i]; p; p = p->link)
                        if (identical(key, p->key))
                                break;
                if (p == NULL) {
                        p = vmalloc_raw(sizeof(*p));
                        p->key = key;
                        p->link = table->buckets[i];
                        table->buckets[i] = p;
                        table->length++;
                }
                p->value = value;
                table->timestamp++;
        }
}
int VTable_length(T table) {
	assert(table);
	return table->length;
}

void VTable_remove(T table, Value key) {
	int i;
	struct binding **pp;
	assert(table);
	table->timestamp++;
	i = hashvalue(key)%table->size;
	for (pp = &table->buckets[i]; *pp; pp = &(*pp)->link)
		if (identical(key, (*pp)->key)) {
			struct binding *p = *pp;
			// Value value = p->value;
			*pp = p->link;
			// FREE(p);
			table->length--;
		}
}

//  void VTable_free(T *table) {
//  	assert(table && *table);
//  	if ((*table)->length > 0) {
//  		int i;
//  		struct binding *p, *q;
//  		for (i = 0; i < (*table)->size; i++)
//  			for (p = (*table)->buckets[i]; p; p = q) {
//  				q = p->link;
//  				FREE(p);
//  			}
//  	}
//  	FREE(*table);
//  }

