#!/bin/bash
set -e

# Based on https://wiki.osdev.org/GCC_Cross-Compiler

source vars.sh

# build binutils
cd build/binutils
make -j$((`nproc`+1))
make install

# return to working directory
cd ../..
