FROM ubuntu:20.04

RUN yes | unminimize 2>&1

COPY ./scripts/base.sh /tmp/scripts/base.sh

RUN sh /tmp/scripts/base.sh \
    && rm -rf /tmp/scripts

COPY ./scripts/setup.sh /tmp/scripts/setup.sh

RUN sh /tmp/scripts/setup.sh \
    && rm -rf /tmp/scripts
