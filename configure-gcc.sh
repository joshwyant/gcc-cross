#!/bin/bash
set -e

# Based on https://wiki.osdev.org/GCC_Cross-Compiler

source vars.sh

# configure gcc
mkdir build/gcc && cd build/gcc
../../gcc-$GCC_VERSION/configure --target=$TARGET --prefix="$PREFIX" --disable-nls \
  --enable-languages=c,c++ --without-headers

# return to working directory
cd ../..
