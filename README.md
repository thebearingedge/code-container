# code-container

An all-in-one dev container environment for new web developers.

## Highlights

- Ubuntu 20.04
- Bash
- Git
- HTTPie
- Node.js
- PostgreSQL
- pgweb
- PHP
- MySQL
- Nginx
- Docker CLI & Docker Compose

## On Docker Hub

[https://hub.docker.com/r/thebearingedge/code-container](https://hub.docker.com/r/thebearingedge/code-container)

## VS Code Integration

```jsonc
// .devcontainer/devcontainer.json
{
  "name": "code-container",
  "image": "thebearingedge/code-container",
  "mounts": [
    // get access to the host docker daemon
    "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind",
    // mount SSH config and keys
    "source=${localEnv:HOME}${localEnv:USERPROFILE}/.ssh,target=/home/dev/.ssh,type=bind",
    // mount Git configuration
    "source=${localEnv:HOME}${localEnv:USERPROFILE}/.gitconfig,target=/home/dev/.gitconfig,type=bind"
  ],
  "containerEnv": {
    "WORKSPACE_FOLDER": "${containerWorkspaceFolder}"
  },
  "extensions": [
    "thebearingedge.lfz-code"
    // ... other VS Code extensions
  ],
  "overrideCommand": false,
  "remoteUser": "vscode",
  "settings": {
    "terminal.integrated.profiles.linux": {
      "bash": {
        "path": "bash",
        "icon": "terminal-bash",
        "args": [
          "-l"
        ]
      }
    }
  }
}
```
