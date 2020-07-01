#!/bin/bash
set -e

# install prerequisites
DEBIAN_FRONTEND='noninteractive' apt-get update -y \
    && apt-get upgrade -y
DEBIAN_FRONTEND='noninteractive' apt-get install -y \
  curl build-essential bison flex libgmp3-dev \
  libmpc-dev libmpfr-dev texinfo autoconf automake \
  perl libtool
