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
- Python 3
- MySQL
- Nginx
- Apache
- Docker CLI & Docker Compose

## On Docker Hub

[https://hub.docker.com/r/thebearingedge/code-container](https://hub.docker.com/r/thebearingedge/code-container)

## VS Code Integration

The image comes with a `dev` user and a `vscode` user. This example configuration assumes that you want to have the `vscode` use manage all of the environment processes so you can run a terminal shell as the `dev` user.

```jsonc
// .devcontainer/devcontainer.json
{
  "name": "project-name",
  "image": "thebearingedge/code-container",
  "mounts": [
    // share ssh config. remove this if you don't want to use a vscode user
    "source=${localEnv:HOME}/.ssh,target=/home/dev/.ssh,type=bind",
    // get access to the host docker daemon
    "source=/var/run/docker.sock,target=/var/run/docker.sock,type=bind",
    // mount Git configuration
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
  "postCreateCommand": "./.devcontainer/post-create-command.sh",
  "settings": {
    "css.validate": false,
    "editor.codeActionsOnSave": {
      "source.fixAll.eslint": true,
      "source.fixAll.stylelint": true
    },
    "editor.fontFamily": "Menlo, Monaco, Consolas, 'Courier New', monospace",
    "editor.fontSize": 14,
    "editor.formatOnPaste": true,
    "editor.minimap.enabled": false,
    "editor.occurrencesHighlight": false,
    "editor.overviewRulerBorder": true,
    "editor.renderWhitespace": "all",
    "editor.rulers": [
      80
    ],
    "editor.snippetSuggestions": "none",
    "editor.tabSize": 2,
    "eslint.alwaysShowStatus": true,
    "eslint.format.enable": true,
    "eslint.run": "onType",
    "eslint.validate": [
      "javascript",
      "javascript-react"
    ],
    "explorer.compactFolders": false,
    "explorer.confirmDelete": false,
    "explorer.confirmDragAndDrop": false,
    "explorer.openEditors.visible": 0,
    "extensions.ignoreRecommendations": true,
    "files.associations": {
      ".eslintrc": "json",
      ".markuplintrc": "json",
      ".sql": "plpgsql",
      ".stylelintrc": "json"
    },
    "files.eol": "\n",
    "files.insertFinalNewline": true,
    "files.trimFinalNewlines": true,
    "files.trimTrailingWhitespace": true,
    "javascript.suggest.autoImports": false,
    "javascript.suggestionActions.enabled": false,
    "javascript.updateImportsOnFileMove.enabled": "never",
    "javascript.validate.enable": false,
    "less.validate": false,
    "liveServer.settings.donotShowInfoMsg": true,
    "liveServer.settings.donotVerifyTags": true,
    "scss.validate": false,
    "terminal.integrated.fontSize": 14,
    "terminal.integrated.profiles.linux": {
      "bash": {
        "icon": "terminal-bash",
        "path": "/bin/bash"
      }
    },
    "terminal.integrated.tabs.enabled": false,
    "vsicons.dontShowNewVersionMessage": true,
    "window.restoreWindows": "none",
    "window.zoomLevel": 0,
    "workbench.activityBar.visible": false,
    "workbench.enableExperiments": false,
    "workbench.iconTheme": "vscode-icons",
    "workbench.panel.defaultLocation": "right",
    "workbench.startupEditor": "none"
  }
}
```

## Post-Create Command to Set Permissions

Run this script in `"postCreateCommand"` to isolate the `dev` user's processes from the `vscode` user's processes.

```sh
#!/bin/sh

set -e

echo 'removing node_modules '
sudo rm -rf ./node_modules

echo 'changing file ownership'
sudo chown -R dev:dev .

echo 'changing file permissions'
find . \( -type d -o -type f \) -exec sudo -u dev chmod g+w {} \;

echo 'changing default file acl'
sudo -u dev setfacl -Rm d:g:dev:rw .

echo 'marking safe git repository'
git config --global safe.directory "$(pwd)"

echo 'installing node_modules'
if [ -f package-lock.json ]; then
  sudo -u dev npm ci
elif [ -f package.json ]; then
  sudo -u dev npm install
fi
```
