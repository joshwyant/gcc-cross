FROM joshwyant/gcc-cross as workspace
WORKDIR /tmp
COPY . .
RUN ./installs.sh
RUN ./download.sh
RUN ./prep.sh

#FROM workspace as configure-binutils
#RUN ./configure-binutils.sh

#FROM configure-binutils as build-binutils
#RUN ./build-binutils.sh

#FROM build-binutils as configure-gcc
#RUN ./configure-gcc.sh

#FROM configure-gcc as build-gcc
#RUN ./build-gcc.sh

#FROM build-gcc as build-autotools
FROM workspace as build-autotools
RUN ./build-autotools.sh

FROM build-autotools as build-newlib
RUN ./build-newlib.sh

FROM build-newlib as final-pass
RUN ./final-pass.sh

FROM ubuntu
COPY --from=final-pass /usr/local/cross/ /usr/local/cross
RUN DEBIAN_FRONTEND='noninteractive' apt-get update
RUN DEBIAN_FRONTEND='noninteractive' apt-get install -y \
  nasm libmpc3
ENV PATH="/usr/local/cross/bin:${PATH}"
