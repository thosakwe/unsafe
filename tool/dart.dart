import 'package:dart_style/dart_style.dart';
import 'ast.dart';

String genDart(UnsafeDefinition def) {
  var buf = StringBuffer();
  buf..writeln("import 'dart-ext:unsafe';")..writeln();

  for (var f in def.funcDefs) {
    for (var c in f.comments) {
      buf.writeln('/// ${c.text}');
    }

    var t = f.returnType;
    if (t is VoidType) {
      buf.write('void');
    } else if (t is CStringType) {
      buf.write('String');
    } else {
      buf.write('int');
    }

    buf.write(' ${f.name}(');

    for (int i = 0; i < f.parameters.length; i++) {
      var p = f.parameters[i];
      var t = p.type;
      if (i > 0) buf.write(', ');

      if (t is VoidType) {
        buf.write('void');
      } else if (t is CStringType) {
        buf.write('String');
      } else {
        buf.write('int');
      }

      buf.write(' ${p.name}');
    }

    buf..write(') native ')..write("'dart_unsafe_${f.name}';");
  }

  return DartFormatter().format(buf.toString());
}
