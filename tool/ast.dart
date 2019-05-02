class UnsafeDefinition {
  final List<Include> includes;
  final List<FuncDef> funcDefs;

  const UnsafeDefinition(this.includes, this.funcDefs);
}

class Include {
  final String systemPath;

  const Include(this.systemPath);
}

class FuncDef {
  final List<Comment> comments;
  final CType returnType;
  final String name;
  final List<CParameter> parameters;

  const FuncDef(this.comments, this.returnType, this.name, this.parameters);
}

class CParameter {
  final CType type;
  final String name;

  const CParameter(this.type, this.name);
}

class Comment {
  final String text;

  const Comment(this.text);
}

abstract class CType {
  const CType();

  String get source;
}

class VoidType extends CType {
  const VoidType();

  String get source => 'void';
}

class CStringType extends CType {
  const CStringType();

  String get source => 'char*';
}

class PointerType extends CType {
  final CType to;

  const PointerType(this.to);

  String get source => '${to.source}*';
}

class IntAliasType extends CType {
  final String name;
  final bool isUnsigned;

  const IntAliasType(this.name, {this.isUnsigned = false});

  String get source => name;
}
