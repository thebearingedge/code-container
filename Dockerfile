FROM ubuntu:20.04

LABEL author="thebearingedge"

RUN yes | unminimize 2>&1

COPY ./home /home
COPY ./install.sh /tmp/install.sh

RUN sh /tmp/install.sh && \
    rm -rf /tmp/install.sh

#      apache/nginx, node, flask, pgweb, php-fpm, node debugger, livereload
EXPOSE 80            3000  5000   8081   9000     9229           35729

USER dev

CMD [ "sleep", "infinity" ]
