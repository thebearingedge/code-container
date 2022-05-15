# code-container

An all-in-one dev container environment for web developers.

## Highlights

- Ubuntu 22.04
- Bash
- Git
- HTTPie
- Node.js 18
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
    // mount host docker socket
    "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind",
    // mount ssh config
    "source=${localEnv:HOME}${localEnv:USERPROFILE}/.ssh,target=/home/dev/.ssh,type=bind",
    // mount git config
    "source=${localEnv:HOME}${localEnv:USERPROFILE}/.gitconfig,target=/home/dev/.gitconfig,type=bind",
    // persist postgres data
    "target=/var/lib/postgresql",
    // persist vscode extensions
    "target=/home/vscode/.vscode-server/extensions"
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
  "postCreateCommand": "curl -fsSL https://raw.githubusercontent.com/thebearingedge/code-container/main/post-create-command.sh | sh"
}
```

## Post-Create Command to Set Permissions

Run this script in `"postCreateCommand"` to isolate the `dev` user's processes from the `vscode` user's processes.

### Example `post-create-command.sh`

[The source code is here.](https://raw.githubusercontent.com/thebearingedge/code-container/main/post-create-command.sh)
