#!/bin/sh

export DEBIAN_FRONTEND=noninteractive
export LANG='en_US.UTF-8'
export LANGUAGE='en_US:en'
export LC_ALL='en_US.UTF-8'

set -e

apt-get update

apt-get -y install \
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

apt-get autoremove

apt-get clean -y

rm -rf /var/lib/apt/lists/*
