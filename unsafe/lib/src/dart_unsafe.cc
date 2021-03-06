#include <cstring>
#include <dart_api.h>
#include <stdlib.h>
#include <dlfcn.h>
Dart_Handle HandleError(Dart_Handle handle)
{
  if (Dart_IsError(handle))
    Dart_PropagateError(handle);
  return handle;
}
 
void dart_unsafe_malloc(Dart_NativeArguments arguments) {
  size_t size;
  int64_t tempsize;
  Dart_Handle sizeHandle = Dart_GetNativeArgument(arguments, 0);
  HandleError(Dart_IntegerToInt64(sizeHandle, &tempsize));
  size = (size_t) tempsize;
  void* DART_UNSAFE_RESULT = malloc(size);
  Dart_SetReturnValue(arguments, Dart_NewIntegerFromUint64((uint64_t) DART_UNSAFE_RESULT));
}
 
void dart_unsafe_free(Dart_NativeArguments arguments) {
  void* ptr;
  uint64_t tempptr;
  Dart_Handle ptrHandle = Dart_GetNativeArgument(arguments, 0);
  HandleError(Dart_IntegerToUint64(ptrHandle, &tempptr));
  ptr = (void*) tempptr;
  free(ptr);
}
 
void dart_unsafe_dlopen(Dart_NativeArguments arguments) {
  const char* filename;
  int flags;
  Dart_Handle filenameHandle = Dart_GetNativeArgument(arguments, 0);
  HandleError(Dart_StringToCString(filenameHandle, &filename));
  int64_t tempflags;
  Dart_Handle flagsHandle = Dart_GetNativeArgument(arguments, 1);
  HandleError(Dart_IntegerToInt64(flagsHandle, &tempflags));
  flags = (int) tempflags;
  void* DART_UNSAFE_RESULT = dlopen(filename, flags);
  Dart_SetReturnValue(arguments, Dart_NewIntegerFromUint64((uint64_t) DART_UNSAFE_RESULT));
}
 
void dart_unsafe_dlclose(Dart_NativeArguments arguments) {
  void* handle;
  uint64_t temphandle;
  Dart_Handle handleHandle = Dart_GetNativeArgument(arguments, 0);
  HandleError(Dart_IntegerToUint64(handleHandle, &temphandle));
  handle = (void*) temphandle;
  int DART_UNSAFE_RESULT = dlclose(handle);
  Dart_SetReturnValue(arguments, Dart_NewInteger(DART_UNSAFE_RESULT));
}
 
Dart_NativeFunction ResolveName(Dart_Handle name, int argc, bool *auto_setup_scope)
{
  // If we fail, we return NULL, and Dart throws an exception.
  if (!Dart_IsString(name))
    return NULL;
  Dart_NativeFunction result = NULL;
  const char *cname;
  HandleError(Dart_StringToCString(name, &cname));
  if (strcmp("dart_unsafe_malloc", cname) == 0)
  result = dart_unsafe_malloc;
  if (strcmp("dart_unsafe_free", cname) == 0)
  result = dart_unsafe_free;
  if (strcmp("dart_unsafe_dlopen", cname) == 0)
  result = dart_unsafe_dlopen;
  if (strcmp("dart_unsafe_dlclose", cname) == 0)
  result = dart_unsafe_dlclose;
return result;
}
 
DART_EXPORT Dart_Handle dart_unsafe_Init(Dart_Handle parent_library)
{
  if (Dart_IsError(parent_library))
    return parent_library;

  Dart_Handle result_code =
      Dart_SetNativeResolver(parent_library, ResolveName, NULL);
  if (Dart_IsError(result_code))
    return result_code;

  return Dart_Null();
}