list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
find_package(Dart REQUIRED)

add_dart_native_extension(dart_unsafe lib/src/dart_unsafe.cc)
install(TARGETS dart_unsafe LIBRARY DESTINATION "${CMAKE_CURRENT_LIST_DIR}/lib/src")