FROM ubuntu

COPY build.sh /tmp

RUN chmod 777 /tmp/build.sh && /tmp/build.sh

ENV PATH="/usr/local/cross/bin:${PATH}"
