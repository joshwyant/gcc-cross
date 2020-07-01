#!/bin/bash
set -e

# Based on https://wiki.osdev.org/Porting_Newlib

source vars.sh

# Build autotools
mkdir build/autotools
cd build/autotools

../../automake-$AUTOMAKE_VERSION/configure --prefix="$AUTOTOOLS_PREFIX"
make -j$((`nproc`+1)) && make install

../../autoconf-$AUTOCONF_VERSION/configure --prefix="$AUTOTOOLS_PREFIX"
make -j$((`nproc`+1)) && make install

# return to working directory
cd ../..
