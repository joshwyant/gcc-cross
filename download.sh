#!/bin/bash
set -e

source vars.sh

# download and extract sources
echo Downloading binutils...
curl -s https://ftp.gnu.org/gnu/binutils/binutils-$BINUTILS_VERSION.tar.gz \
  --output binutils-$BINUTILS_VERSION.tar.gz > /dev/null

echo Downloading gcc...
curl -s https://ftp.gnu.org/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz \
  --output gcc-$GCC_VERSION.tar.gz > /dev/null

echo Downloading automake...
curl -s https://ftp.gnu.org/gnu/automake/automake-$AUTOMAKE_VERSION.tar.gz \
  --output automake-$AUTOMAKE_VERSION.tar.gz > /dev/null

echo Downloading autoconf...
curl -s https://ftp.gnu.org/gnu/autoconf/autoconf-$AUTOCONF_VERSION.tar.gz \
  --output autoconf-$AUTOCONF_VERSION.tar.gz > /dev/null

echo Downloading newlib...
curl -s  https://sourceware.org/pub/newlib/newlib-$NEWLIB_VERSION.tar.gz \
  --output newlib-$NEWLIB_VERSION.tar.gz > /dev/null

echo Extracting binutils...
tar xf binutils-$BINUTILS_VERSION.tar.gz

echo Extracting gcc...
tar xf gcc-$GCC_VERSION.tar.gz

echo Extracting automake...
tar xf automake-$AUTOMAKE_VERSION.tar.gz

echo Extracting autoconf...
tar xf autoconf-$AUTOCONF_VERSION.tar.gz

echo Extracting newlib...
tar xf newlib-$NEWLIB_VERSION.tar.gz
