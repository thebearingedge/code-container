# code-container

An all-in-one dev container environment for web developers.

## Highlights

- Ubuntu 22.04
- Bash
- Git
- HTTPie
- Node.js
- PostgreSQL
- pgweb
- PHP
- Python 3
- MySQL
- Nginx
- Apache
- Docker CLI & Docker Compose

## On Docker Hub

[https://hub.docker.com/r/thebearingedge/code-container](https://hub.docker.com/r/thebearingedge/code-container)

## VS Code Integration

The image comes with a `dev` user and a `vscode` user. This example configuration assumes that you want to have the `vscode` use manage all of the environment processes while you run a terminal shell as the `dev` user.

### Example `.devcontainer/devcontainer.json`

```jsonc
{
  "name": "${containerWorkspaceFolderBasename}",
  "image": "thebearingedge/code-container",
  "mounts": [
    // persist postgres data
    "target=/var/lib/postgresql",
    // mount host docker socket
    "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind",
    // mount ssh config
    "source=${localEnv:HOME}${localEnv:USERPROFILE}/.ssh,target=/home/dev/.ssh,type=bind",
    // mount git config
    "source=${localEnv:HOME}${localEnv:USERPROFILE}/.gitconfig,target=/home/dev/.gitconfig,type=bind"
  ],
  "appPort": [
    80,    // apache/nginx
    3000,  // node
    5000,  // flask
    8081,  // pgweb
    9000,  // php-fpm
    9229,  // node debugger
    35729  // livereload
  ],
  "extensions": [
    "thebearingedge.lfz-code"
  ],
  "remoteUser": "vscode",
  "containerUser": "vscode",
  "postCreateCommand": "sh .devcontainer/post-create-command.sh"
}
```

## Post-Create Command to Set Permissions

Run this script in `"postCreateCommand"` to isolate the `dev` user's processes from the `vscode` user's processes.

### Example `.devcontainer/post-create-command.sh`

```sh
#!/bin/sh

set -e

echo 'removing node_modules '
sudo rm -rf ./node_modules

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
```
