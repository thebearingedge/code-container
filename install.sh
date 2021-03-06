#!/bin/sh

set -eu

export DEBIAN_FRONTEND=noninteractive
export LANG='en_US.UTF-8'
export LANGUAGE='en_US:en'
export LC_ALL='en_US.UTF-8'

arch="$(dpkg --print-architecture)"

install_packages () {
  apt-get install --no-install-recommends -qq -o=Dpkg::Use-Pty=0 "$@"
}

apt-get -q update


### install base

install_packages \
  acl \
  apt-transport-https \
  bash-completion \
  build-essential \
  ca-certificates \
  curl \
  dirmngr \
  execline \
  git \
  gnupg \
  host \
  htop \
  httpie \
  iputils-ping \
  less \
  locales \
  lsb-release \
  man \
  nano \
  netcat-openbsd \
  openssh-client \
  psmisc \
  shellcheck \
  software-properties-common \
  sudo \
  traceroute \
  tree \
  tzdata \
  unzip \
  zip


### git completion

curl -fL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash > \
  /home/dev/.bashrc.d/git-completion.bash

### configure locale

locale-gen en_US.UTF-8


### create dev user

useradd -s /bin/bash -G sudo dev
chown -R dev:dev /home/dev

echo 'dev ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/dev
chmod 440 /etc/sudoers.d/dev


### create vscode user

useradd -s /bin/bash -G sudo vscode
chown -R vscode:vscode /home/vscode

echo 'vscode ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/vscode
chmod 440 /etc/sudoers.d/vscode


### set vscode primary group to dev

usermod -a -G dev vscode
usermod -g dev vscode


### install docker cli

curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
  gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$arch signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
       https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) stable" |
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get -q update

install_packages \
  docker-ce-cli \
  docker-compose


### install postgresql

install_packages \
  postgresql

service postgresql start
su -c 'psql -c "create user dev with superuser password '\''dev'\''"' postgres
su -c 'createdb -O dev dev' postgres
service postgresql stop

pgweb_cli="pgweb_linux_${arch}"

if [ "$arch" = 'arm64' ]; then
  pgweb_cli="pgweb_linux_${arch}_v7"
fi

pgweb_release='https://github.com/sosedoff/pgweb/releases/latest'
pgweb_latest="$(curl -fsSL -o /dev/null -w "%{url_effective}" $pgweb_release)"
pgweb_version="$(basename "$pgweb_latest")"
pgweb_download='https://github.com/sosedoff/pgweb/releases/download'
pgweb_download_url="$pgweb_download/$pgweb_version/$pgweb_cli.zip"

curl -fsSL -o "/tmp/$pgweb_cli.zip" "$pgweb_download_url"
unzip "/tmp/$pgweb_cli.zip" -d /tmp
mv "/tmp/$pgweb_cli" /usr/local/bin/pgweb
rm "/tmp/$pgweb_cli.zip"

### install node.js

curl -fsSL https://deb.nodesource.com/setup_18.x | bash

install_packages \
  nodejs


### install apache

install_packages \
  apache2

echo 'ServerName 127.0.0.1' >> /etc/apache2/conf-available/server-name.conf
a2enconf server-name


### install nginx

install_packages \
  nginx


### install mysql

echo "mysql-server mysql-server/root_password password root" |
     debconf-set-selections
echo "mysql-server mysql-server/root_password_again password root" |
     debconf-set-selections

install_packages \
  mysql-server

usermod -d /var/run/mysqld/ mysql

service mysql start
mysql -uroot -proot << EOF
create user 'dev'@'localhost' identified by 'dev';
grant all privileges on *.* to 'dev'@'localhost';
flush privileges;
EOF
service mysql stop


### install php

install_packages \
  php \
  php-fpm \
  php-curl \
  php-mysql \
  libapache2-mod-php


### install python

add-apt-repository -y ppa:deadsnakes/ppa

install_packages \
  python3.10 \
  python3.10-distutils

sudo -u dev /bin/bash -l -c '\
  curl -fsSL https://bootstrap.pypa.io/get-pip.py | python3.10
'


### clean up

apt-get -y clean
apt-get -y autoremove

rm -rf /var/lib/apt/lists/*
