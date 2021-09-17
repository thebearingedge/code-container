#!/bin/sh

set -eu

export DEBIAN_FRONTEND=noninteractive
export LANG='en_US.UTF-8'
export LANGUAGE='en_US:en'
export LC_ALL='en_US.UTF-8'

install_packages () {
  apt-get install -qq -o=Dpkg::Use-Pty=0 "$@"
}

apt-get update

# install base

install_packages \
  apt-transport-https \
  bash-completion \
  build-essential \
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
  psmisc \
  sudo \
  traceroute \
  tzdata \
  unzip

# configure locale

locale-gen en_US.UTF-8

# install docker

curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
 gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

arch="$(dpkg --print-architecture)"

echo \
  "deb [arch=$arch signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
       https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) stable" |
  tee /etc/apt/sources.list.d/docker.list > /dev/null

apt-get -q update

install_packages docker-ce docker-ce-cli containerd.io

# install postgresql

install_packages postgresql
service postgresql start
su -c 'psql -c "create user dev with superuser password '\''dev'\''"' postgres
su -c 'createdb -O dev dev' postgres
service postgresql stop

# install node.js

curl -sL https://deb.nodesource.com/setup_16.x | bash
install_packages nodejs

# create dev user

useradd -m -s /bin/bash -G sudo,docker dev

echo 'dev ALL=(root) NOPASSWD:ALL' > /etc/sudoers.d/dev
chmod 440 /etc/sudoers.d/dev

chown -R dev:dev /home/dev

echo 'su - dev' >> /root/.bash_profile
echo 'exit' >> /root/.bash_logout

# clean up

apt-get -yq autoremove

rm -rf /var/lib/apt/lists/*
