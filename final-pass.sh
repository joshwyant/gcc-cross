#!/bin/bash

# Based on: https://wiki.osdev.org/OS_Specific_Toolchain

source vars.sh

# Remove aliased binaries
pushd /usr/local/cross/bin
rm $OS_TARGET-ar
rm $OS_TARGET-as
rm $OS_TARGET-gcc
rm $OS_TARGET-cc
rm $OS_TARGET-ranlib
rm $OS_TARGET-readelf
popd

# Apply OS-specific patches
echo Applying patches...
patch -s -p0 < binutils-$BINUTILS_VERSION.patch
patch -s -p0 < gcc-$GCC_VERSION.patch

# Configure OS-related changes in Binutils
echo Automake binutils...
pushd binutils-$BINUTILS_VERSION/ld
autoreconf # likely version mismatch, so reconf
automake
popd

# Configure OS-related changes in GCC
echo Autoconf gcc...
pushd gcc-$GCC_VERSION/libstdc++-v3
autoconf
popd

# Re-build binutils
echo Re-build binutils...
mkdir -p build/binutils-$OS_NAME && cd build/binutils-$OS_NAME
../../binutils-$BINUTILS_VERSION/configure --target=$OS_TARGET --prefix="$PREFIX" \
  --with-sysroot=$PREFIX/$MACHINE-$OS_NAME --disable-nls --disable-werror --enable-shared \
  --disable-dependency-tracking
make -j$((`nproc`+1))
make install
cd ../..

# Re-build gcc and libstdc++
echo Re-build gcc...
mkdir build/gcc-$OS_NAME && cd build/gcc-$OS_NAME
../../gcc-$GCC_VERSION/configure --target=$OS_TARGET --prefix="$PREFIX" --disable-nls \
  --enable-languages=c,c++ --with-newlib --enable-shared \
  --with-sysroot=$PREFIX/$MACHINE-$OS_NAME
make -j$((`nproc`+1)) all-gcc all-target-libgcc
make install-gcc install-target-libgcc
make -j$((`nproc`+1)) all-target-libstdc++-v3
make install-target-libstdc++-v3
cd ../..

# Re-build newlib
echo Re-build newlib...
mkdir build/newlib-final && cd build/newlib-final
../../newlib-2.5.0/configure --prefix=$PREFIX --target=$OS_TARGET --enable-newlib-io-long-long
make -j$((`nproc`+1)) all
make install

# return to working directory
cd ../..
