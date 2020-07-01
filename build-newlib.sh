#!/bin/bash

# Based on: https://wiki.osdev.org/Porting_Newlib

source vars.sh

# Hack: bootstrap by first aliasing i686-elf to i686-myos
# Removed before installing real os-specific toolchain.
pushd /usr/local/cross/bin
ln $TARGET-ar $OS_TARGET-ar
ln $TARGET-as $OS_TARGET-as
ln $TARGET-gcc $OS_TARGET-gcc
ln $TARGET-gcc $OS_TARGET-cc
ln $TARGET-ranlib $OS_TARGET-ranlib
ln $TARGET-readelf $OS_TARGET-readelf
popd

# Apply patch
patch -s -p0 < newlib.patch

# Copy files
cp -ar newlib-files/ newlib-$NEWLIB_VERSION/newlib/libc/sys/$OS_NAME

# Make sure custom autotools is in the path
export PATH="$AUTOTOOLS_PREFIX/bin:$PATH"

# Configure MyOS-related changes in Newlib
pushd newlib-$NEWLIB_VERSION/newlib/libc/sys
autoconf

cd $OS_NAME
autoreconf
popd

# Configure and install newlib
mkdir build/newlib
cd build/newlib
../../newlib-2.5.0/configure --prefix=$PREFIX --target=$OS_TARGET --enable-newlib-io-long-long
make -j$((`nproc`+1)) all
make install

# return to working directory
cd ../..
