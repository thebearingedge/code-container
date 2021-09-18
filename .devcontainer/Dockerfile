FROM ubuntu:20.04

COPY ./setup /tmp/setup

RUN yes | unminimize 2>&1 && \
    mkdir -p /home/dev && \
    cp -rp /tmp/setup/home/. /home/dev && \
    sh /tmp/setup/install.sh && \
    rm -rf /tmp/setup
