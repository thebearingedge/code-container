#!/bin/sh

set -e

echo 'removing node_modules'
find . -type d -name 'node_modules' -exec rm -rf {} +

if [ -d /home/dev/.ssh ]; then
  echo 'setting ssh file permissions'
  sudo chown -R dev:dev /home/dev/.ssh
  sudo chmod 600 /home/dev/.ssh/*
  sudo chmod 644 /home/dev/.ssh/*.pub
fi

echo 'changing project file permissions'
sudo chown -R dev:dev .
find . \( -type d -o -type f \) -exec sudo -u dev chmod g+w {} \;

echo 'changing default file acl'
sudo -u dev setfacl -Rm d:g:dev:rw .

echo 'marking safe git repository for vscode user'
git config --global safe.directory "$(pwd)"

echo 'installing node_modules'
if [ -f package-lock.json ]; then
  sudo -u dev npm ci
elif [ -f package.json ]; then
  sudo -u dev npm install
fi
