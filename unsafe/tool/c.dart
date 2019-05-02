import 'package:code_buffer/code_buffer.dart';
import 'ast.dart';

String genC(UnsafeDefinition def) {
  var buf = CodeBuffer();
  buf.writeln('#include <cstring>');
  buf.writeln('#include <dart_api.h>');

  for (var include in def.includes) {
    buf.writeln('#include <${include.systemPath}>');
  }

  buf.writeln('''
Dart_Handle HandleError(Dart_Handle handle)
{
  if (Dart_IsError(handle))
    Dart_PropagateError(handle);
  return handle;
}
  '''
      .trim());

  for (var f in def.funcDefs) {
    buf
      ..writeln(' ')
      ..writeln('void dart_unsafe_${f.name}(Dart_NativeArguments arguments) {')
      ..indent();

    // Declare params
    for (var p in f.parameters) {
      if (p.type is CStringType) buf.write('const ');
      buf.writeln('${p.type.source} ${p.name};');
    }

    // Read them
    for (int i = 0; i < f.parameters.length; i++) {
      var p = f.parameters[i];
      var t = p.type;

      if (t is IntAliasType) {
        var v = t.isUnsigned ? 'Uint' : 'Int';
        var tt = t.isUnsigned ? 'uint64_t' : 'int64_t';
        buf.writeln('$tt temp${p.name};');
        buf.writeln(
            'Dart_Handle ${p.name}Handle = Dart_GetNativeArgument(arguments, $i);');
        buf.writeln(
            'HandleError(Dart_IntegerTo${v}64(${p.name}Handle, &temp${p.name}));');
        buf.writeln('${p.name} = (${t.source}) temp${p.name};');
      } else if (t is CStringType) {
        buf.writeln(
            'Dart_Handle ${p.name}Handle = Dart_GetNativeArgument(arguments, $i);');
        buf.writeln(
            'HandleError(Dart_StringToCString(${p.name}Handle, &${p.name}));');
      } else if (t is PointerType) {
        buf.writeln('uint64_t temp${p.name};');
        buf.writeln(
            'Dart_Handle ${p.name}Handle = Dart_GetNativeArgument(arguments, $i);');
        buf.writeln(
            'HandleError(Dart_IntegerToUint64(${p.name}Handle, &temp${p.name}));');
        buf.writeln('${p.name} = (${t.source}) temp${p.name};');
      }
    }

    // Next, perform the call.
    var a = f.parameters.map((p) => p.name).join(', ');
    var call = '${f.name}($a)';
    var r = f.returnType;

    if (r is VoidType) {
      buf.writeln('$call;');
    } else {
      String dv;
      buf.writeln('${r.source} DART_UNSAFE_RESULT = $call;');

      if (r is PointerType) {
        dv = 'Dart_NewIntegerFromUint64((uint64_t) DART_UNSAFE_RESULT)';
      } else if (r is IntAliasType) {
        var v = 'Dart_NewInteger';
        if (r.isUnsigned) v += 'FromUint64';
        dv = '$v(DART_UNSAFE_RESULT)';
      } else if (r is CStringType) {
        dv = 'Dart_NewStringFromCString(DART_UNSAFE_RESULT)';
      }

      if (dv != null) {
        buf.writeln('Dart_SetReturnValue(arguments, $dv);');
      }
    }

    buf
      ..outdent()
      ..writeln('}');
  }

  buf.writeln(' ');

  buf.writeln('''
Dart_NativeFunction ResolveName(Dart_Handle name, int argc, bool *auto_setup_scope)
{
  // If we fail, we return NULL, and Dart throws an exception.
  if (!Dart_IsString(name))
    return NULL;
  Dart_NativeFunction result = NULL;
  const char *cname;
  HandleError(Dart_StringToCString(name, &cname));
  '''
      .trim());

  buf.indent();
  for (var f in def.funcDefs) {
    // if (strcmp("Dart_WingsSocket_closeDescriptor", cname) == 0)
    // result = Dart_WingsSocket_closeDescriptor;
    buf.writeln('if (strcmp("dart_unsafe_${f.name}", cname) == 0)');
    buf.writeln('result = dart_unsafe_${f.name};');
  }

  buf.outdent();
  buf.writeln('''
  return result;
}
  '''
      .trim());

  buf.writeln(' ');

  buf.writeln('''
DART_EXPORT Dart_Handle dart_unsafe_Init(Dart_Handle parent_library)
{
  if (Dart_IsError(parent_library))
    return parent_library;

  Dart_Handle result_code =
      Dart_SetNativeResolver(parent_library, ResolveName, NULL);
  if (Dart_IsError(result_code))
    return result_code;

  return Dart_Null();
}'''
      .trim());

  return buf.toString();
}
