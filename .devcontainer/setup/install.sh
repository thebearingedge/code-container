#!/bin/sh

set -eu

export DEBIAN_FRONTEND=noninteractive
export LANG='en_US.UTF-8'
export LANGUAGE='en_US:en'
export LC_ALL='en_US.UTF-8'

install_packages () {
  apt-get install --no-install-recommends -qq -o=Dpkg::Use-Pty=0 "$@"
}

apt-get -q update


### install base

install_packages \
  apt-transport-https \
  bash-completion \
  build-essential \
  ca-certificates \
  curl \
  dirmngr \
  git \
  gnupg \
  host \
  htop \
  iputils-ping \
  locales \
  lsb-release \
  man \
  nano \
  netcat-openbsd \
  openssh-client \
  psmisc \
  sudo \
  traceroute \
  tzdata \
  unzip


### configure locale

locale-gen en_US.UTF-8


### install docker cli

curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
 gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

arch="$(dpkg --print-architecture)"

echo \
  "deb [arch=$arch signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
       https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) stable" |
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get -q update

install_packages \
  docker-ce-cli


### install postgresql

install_packages \
  postgresql

service postgresql start
su -c 'psql -c "create user dev with superuser password '\''dev'\''"' postgres
service postgresql stop


### install node.js

curl -sL https://deb.nodesource.com/setup_16.x | bash

install_packages \
  nodejs


### install nginx

install_packages \
  nginx


### install php

install_packages \
  php \
  php-fpm \
  php-curl


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


### create vscode user

useradd -m -s /bin/bash -G sudo vscode

echo 'vscode ALL=(dev) NOPASSWD: /bin/bash' > /etc/sudoers.d/vscode
chmod 440 /etc/sudoers.d/vscode

cat << 'EOF' > /home/vscode/.bash_profile
if [ $(stat -c '%U' "$WORKSPACE_FOLDER") = vscode ]; then
  chown -R dev:dev "$WORKSPACE_FOLDER"
fi

sudo -u dev /bin/bash --login; exit
EOF

chown -R vscode:vscode /home/vscode


### create dev user

useradd -m -s /bin/bash -G sudo dev

echo 'dev ALL=(root) NOPASSWD:ALL' > /etc/sudoers.d/dev
chmod 440 /etc/sudoers.d/dev

chown -R dev:dev /home/dev


### clean up

apt-get -y clean
apt-get -y autoremove

rm -rf /var/lib/apt/lists/*
