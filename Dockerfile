FROM ubuntu:20.04

RUN yes | unminimize 2>&1

COPY ./setup /tmp/setup

RUN mkdir -p /home/dev && \
    cp -rp /tmp/setup/home/. /home/dev && \
    sh /tmp/setup/install.sh && \
    rm -rf /tmp/setup

USER dev

WORKDIR /home/dev

EXPOSE 80            3000  5000   8081   9000     35729
#      apache/nginx, node, flask, pgweb, php-fpm, livereload

CMD [ "sleep", "infinity" ]
