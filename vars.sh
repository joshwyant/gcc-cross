#!/bin/bash
set -e

export MACHINE="i686"
export OS_NAME="myos"
export BINUTILS_VERSION=2.34
export GCC_VERSION=10.1.0
export AUTOMAKE_VERSION=1.11
export AUTOCONF_VERSION=2.69
export NEWLIB_VERSION=2.5.0

# export variables
export PREFIX="/usr/local/cross"
export AUTOTOOLS_PREFIX="$(pwd)"
export TARGET="$MACHINE-elf"
export OS_TARGET="$MACHINE-$OS_NAME"
export PATH="$PREFIX/bin:$PATH"
