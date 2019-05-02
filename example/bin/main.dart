import 'package:unsafe/unsafe.dart';

main() {
  var p = malloc(34);
  print('P from malloc: $p');
  free(p);

  var crt = dlopen('libc.dylib', 0);
  print('CRT for libc.dylib: $crt');
  dlclose(crt);
}
