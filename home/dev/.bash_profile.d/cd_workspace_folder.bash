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

  ssh_dir="$HOME"/.ssh

  if [ -d "$ssh_dir" ]; then
    # fix permissions in case the host .ssh permissions are loose
    ssh_permissions_set="$workspaces"/."$workspace_basename"_ssh

    if [ ! -f "$ssh_permissions_set" ]; then
      sudo chown -R dev "$ssh_dir"
      chmod 700 "$ssh_dir"
      chmod 600 "$ssh_dir"/*
      chmod 644 "$ssh_dir"/*.pub
      sudo -u vscode touch "$ssh_permissions_set"
    fi

  fi

  cd "$WORKSPACE_FOLDER" || return
fi
