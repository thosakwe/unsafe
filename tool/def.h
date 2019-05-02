#include <stdlib.h>

// Allocates size bytes of uninitialized storage.
//
// If allocation succeeds, returns a pointer to the lowest (first) byte in the allocated memory block that is suitably aligned for any object type with fundamental alignment.
// 
// If size is zero, the behavior is implementation defined (null pointer may be returned, or some non-null pointer may be returned that may not be used to access storage, but has to be passed to free).
void* malloc(size_t size);

// Deallocates the space previously allocated by malloc(), calloc(), aligned_alloc, (since C11) or realloc().
//
// If ptr is a null pointer, the function does nothing.
void free(void* ptr);