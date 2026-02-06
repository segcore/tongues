#!/bin/bash

build() {
    (
        cd "$1"
        echo "=== $1   $2"
        time $2
    )
}

build c "cc cat.c -o cat"
build c++ "g++ cat.cpp -o cat"
build csharp "mcs cat.cs -out:cat"
build haskell "ghc cat.hs"
build jai "jai cat.jai -quiet"
build julia "julia cat.jl" </dev/null
build lua "luac -o cat cat.lua" # Lua is not usually compiled, but it can be to bytecode
build odin "odin build cat.odin -file"
build rust "rustc cat.rs"
build zig "zig build-exe cat.zig"
