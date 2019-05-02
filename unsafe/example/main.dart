import 'package:unsafe/unsafe.dart';

void main() {
  var ptr = malloc(24);
  print('Pointer: $ptr');
  free(ptr);
}
