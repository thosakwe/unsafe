cmake_minimum_required(VERSION 3.0)
project(dart_unsafe)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
find_package(Dart REQUIRED)

set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_LIST_DIR})
add_dart_native_extension(dart_unsafe lib/src/dart_unsafe.cc)