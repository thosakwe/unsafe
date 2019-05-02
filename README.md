# unsafe
Unsafe native methods (malloc, mmap, dlopen, etc.) for Dart :radioactive:

Use at your own risk (of memory leak, buffer overflow attack, etc.).

Experimental/not done.

## Why?
Just for education/experimentation.

## Generating the Bindings
I've written a parser for a *very small*, very strict subset of C, which can be
used to read `unsafe/tool/def.h`.

Running `unsafe/tool/gen.dart` will produce `unsafe/lib/src/dart_unsafe.cc` and `unsafe/lib/src/unsafe.dart`.

## Building the Extension
Build using CMake. Make sure to run the `install` target:

```bash
mkdir -p dart-unsafe-build
cdp dart-unsafe-build
cmake ..
cmake --build . --target install -- -j8
```

## Running
The examples will work perfectly if run from the `example`
directory, but within the `unsafe` package itself, it won't
work.

I don't feel like explaining why, so
click here for more info:
https://github.com/dart-lang/sdk/issues/35292