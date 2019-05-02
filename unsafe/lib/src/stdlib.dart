import 'dart:io';
import 'dart-ext:unsafe';

int get errno native 'dart_unsafe_errno';

String strerror(int no) native 'dart_unsafe_strerror';

OSError get lastSystemError {
  var no = errno;
  return OSError(strerror(no), no);
}

int calloc(int nitems, int size) native 'dart_unsafe_calloc';

int malloc(int size) native 'dart_unsafe_malloc';

int realloc(int ptr, int size) native 'dart_unsafe_realloc';

void free(int ptr) native 'dart_unsafe_free';

int fork() native 'dart_unsafe_fork';

int brk(int addr) native 'dart_unsafe_brk';

int sbrk(int increment) native 'dart_unsafe_sbrk';
