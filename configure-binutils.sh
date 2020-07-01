#!/bin/bash
set -e

# Based on https://wiki.osdev.org/GCC_Cross-Compiler

source vars.sh

# configure binutils
mkdir -p build/binutils && cd build/binutils
../../binutils-$BINUTILS_VERSION/configure --target=$TARGET --prefix="$PREFIX" \
  --with-sysroot --disable-nls --disable-werror

# return to working directory
cd ../..
