FROM ubuntu:20.04

RUN yes | unminimize 2>&1

COPY ./setup/install.sh /tmp/setup/install.sh
COPY ./setup/home /home/dev

RUN sh /tmp/setup/install.sh rm -rf /tmp/setup
