#!/bin/sh

export DEBIAN_FRONTEND=noninteractive

set -e

apt-get update

apt-get -y install \
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
  man \
  nano \
  netcat-openbsd \
  psmisc \
  sudo \
  traceroute \
  tzdata \
  unzip \
  wget

apt-get clean -y
rm -rf /var/lib/apt/lists/*
