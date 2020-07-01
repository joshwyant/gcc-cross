#!/bin/bash
set -e

# Based on https://wiki.osdev.org/GCC_Cross-Compiler

source vars.sh

# build gcc
cd build/gcc
make -j$((`nproc`+1)) all-gcc
make -j$((`nproc`+1)) all-target-libgcc
make install-gcc
make install-target-libgcc

# Test the new installation
$TARGET-gcc --version

# return to working directory
cd ../..
