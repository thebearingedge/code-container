FROM ubuntu:20.04

LABEL author="thebearingedge"

RUN yes | unminimize 2>&1

COPY ./home /home
COPY ./install.sh /tmp/install.sh

RUN sh /tmp/install.sh && \
    rm -rf /tmp/install.sh

#      apache/nginx, node, flask, pgweb, php-fpm, livereload
EXPOSE 80            3000  5000   8081   9000     35729

USER dev

WORKDIR /home/dev

CMD [ "sleep", "infinity" ]
