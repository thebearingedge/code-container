#!/bin/bash

if [ -n "$WORKSPACE_FOLDER" ] && [ -d "$WORKSPACE_FOLDER" ]; then
  # fix permissions so that dev and vscode can write each other's files
  workspaces="$(dirname "$WORKSPACE_FOLDER")"
  workspace_basename="$(basename "$WORKSPACE_FOLDER")"
  workspace_permissions_set="$workspaces"/."$workspace_basename"

  if [ ! -f "$workspace_permissions_set" ]; then
    sudo chmod g+rwx "$WORKSPACE_FOLDER"
    find "$WORKSPACE_FOLDER" -type f -exec sudo chmod g+rw {} \;
    find "$WORKSPACE_FOLDER" -type d -exec sudo chmod g+rwx {} \;
    sudo setfacl -Rm d:g:vscode:rw,g:vscode:rw "$WORKSPACE_FOLDER"
    sudo -u vscode touch "$workspace_permissions_set"
  fi

  cd "$WORKSPACE_FOLDER" || return
fi
