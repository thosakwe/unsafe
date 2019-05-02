import 'package:string_scanner/string_scanner.dart';
import 'ast.dart';

final _comment = RegExp(r'//([^\n]*)');
final _id = RegExp(r'[A-Za-z0-9_]+');
final _include = RegExp(r'#include <([^>]+)>');
final _ws = RegExp(r'[ \r\n\t]+');
final _comma = RegExp(r'\s*,\s*');
final _lParen = RegExp(r'\s*\(\s*');
final _rParen = RegExp(r'\s*\)\s*');

class Parser {
  final SpanScanner scanner;

  Parser(String text, {sourceUrl})
      : scanner = SpanScanner(text, sourceUrl: sourceUrl);

  void _eatSpace() => scanner.scan(_ws);

  List<T> _parseList<T>(T Function() f,
      {bool Function() open,
      bool Function() close,
      bool Function() separator}) {
    open ??= () => true;
    close ??= () => true;
    separator ??= () => true;

    var out = <T>[];

    if (open()) {
      _eatSpace();
      var cur = f();

      while (cur != null) {
        out.add(cur);
        if (!separator()) break;
        _eatSpace();
        cur = f();
      }

      if (!close()) {
        throw 'Missing closing:\n${scanner.emptySpan.highlight()}';
      }
    }

    return out;
  }

  UnsafeDefinition parse() {
    var includes = _parseList(parseInclude);
    var funcDefs = _parseList(parseFuncDef);
    return UnsafeDefinition(includes, funcDefs);
  }

  Include parseInclude() {
    _eatSpace();
    if (scanner.scan(_include)) return Include(scanner.lastMatch[1]);
    return null;
  }

  Comment parseComment() {
    if (scanner.scan(_comment)) return Comment(scanner.lastMatch[1].trim());
    return null;
  }

  FuncDef parseFuncDef() {
    var comments = _parseList(parseComment);
    var returnType = parseType();
    if (returnType == null) return null;
    _eatSpace();
    if (!scanner.scan(_id))
      throw 'Missing id after return type:\n${scanner.emptySpan.highlight()}';
    var name = scanner.lastMatch[0];
    _eatSpace();
    var params = _parseList(parseParameter,
        open: () => scanner.scan(_lParen),
        close: () => scanner.scan(_rParen),
        separator: () => scanner.scan(_comma));
    scanner.scan(';');
    _eatSpace();
    return FuncDef(comments, returnType, name, params);
  }

  CParameter parseParameter() {
    _eatSpace();
    var type = parseType();
    if (type == null) return null;
    _eatSpace();
    if (!scanner.scan(_id)) {
      throw 'Missing id after type:\n${scanner.emptySpan.highlight()}';
    } else {
      return CParameter(type, scanner.lastMatch[0]);
    }
  }

  CType parseType() {
    var single = _parseSingleType();
    if (single == null)
      return null;
    else if (scanner.scan('*')) return PointerType(single);
    return single;
  }

  CType _parseSingleType() {
    _eatSpace();
    if (scanner.scan('char*')) {
      return const CStringType();
    } else if (scanner.scan('void')) {
      return const VoidType();
    } else if (scanner.scan(_id)) {
      var id = scanner.lastMatch[0];
      return IntAliasType(id);
    } else {
      return null;
    }
  }
}
