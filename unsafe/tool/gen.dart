import 'dart:io';
import 'c.dart';
import 'dart.dart';
import 'parser.dart';

main() async {
  var defFile = File('tool/def.h');
  var defContent = await defFile.readAsString();
  var parser = Parser(defContent, sourceUrl: defFile.uri);
  var def = parser.parse();

  var cFile = File('lib/src/dart_unsafe.cc');
  var dartFile = File('lib/src/unsafe.dart');
  await cFile.writeAsString(genC(def));
  await dartFile.writeAsString(genDart(def));
}
