import 'dart-ext:unsafe';

int dlopen(String filename, int flag) native 'dart_unsafe_dlopen';

String dlerror() native 'dart_unsafe_dlerror';

int dlsym(int handle, String symbol) native 'dart_unsafe_dylsym';

int dlclose(int handle) native 'dart_unsafe_dlclose';
