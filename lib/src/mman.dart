import 'dart-ext:unsafe';

/*
void *mmap(void *addr, size_t length, int prot, int flags,
                  int fd, off_t offset);
       int munmap(void *addr, size_t length);
*/

int mmap(int addr, int length, int prot, int flags, int fd, int offset)
    native 'dart_unsafe_mmap';

int munmap(int addr, int length) native 'dart_unsafe_munmap';
