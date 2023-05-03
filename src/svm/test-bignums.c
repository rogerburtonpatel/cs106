#include <stdio.h>
#include <stdlib.h>
#include "arraylist.h"
#include "bignums.h"

int main() {
    // Initialize the list
    Arraylist_T list = Arraylist_new(4);

    // Test adding items to the list
    printf("Adding items to list...\n");
    for (uint32_t i = 1; i <= 10; i++) {
        push_back(list, i);
    }

    // Test getting items from the list
    printf("Getting items from list...\n");
    printf("List length here: %zu\n", length(list));

    for (uint32_t i = 0; i < length(list); i++) {
        printf("%u ", Arraylist_at(list, i));
    }
    printf("\n");

    // Test expanding the list
    printf("Expanding list...\n");
    expand(list);
    printf("List length after expansion: %zu\n", length(list));

    // Test adding an item to the front of the list
    printf("Adding item to the front of the list...\n");
    push_front(list, 0);
    printf("List after adding item to front: ");
    for (uint32_t i = 0; i < length(list); i++) {
        printf("%u ", Arraylist_at(list, i));
    }
    printf("\n");

    // Test freeing the list
    printf("Freeing list...\n");
    Arraylist_free(&list);
    printf("List freed.\n");

    return 0;
}
