# Dart

The dart programming language https://dart.dev/

Can compile to a native executable, JS, and WASM.

## Opinion

Basically a statically typed Javascript, but the types are optional, and
invalid coersions just throw exceptions at runtime. Go turns OOP Javascript.

The `dart create`
[most basic example](https://dart.dev/learn/tutorial/first-app#task-2-create-a-new-dart-project)
has 50 dependencies it installs.
To print "Hello world: 42!".

## Installation

From the website https://dart.dev/get-dart/archive - download the SDK zip.

```sh
unzip dartsdk-linux-x64-release.zip  # should go into dart-sdk/ directory
export PATH="$HOME/opt/dart-sdk/bin:$PATH" # or similar
dart --version
```

## Running

```sh
# Run directly
dart cat.dart < README.md

# Or compile separately
dart compile exe cat.dart  # ~1 second for hello world
./cat.exe < README.md      # Called .exe even on Linux
```
