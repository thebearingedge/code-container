#!/bin/sh

# fix permissions so that dev and vscode can write each other's files

if [ -n "$WORKSPACE_FOLDER" ] && [ -d "$WORKSPACE_FOLDER" ]; then

  workspaces="$(dirname "$WORKSPACE_FOLDER")"
  workspace_basename="$(basename "$WORKSPACE_FOLDER")"
  workspace_permissions_set="$workspaces"/."$workspace_basename"

  if [ ! -f "$workspace_permissions_set" ]; then
    chmod g+rwx "$WORKSPACE_FOLDER"
    find "$WORKSPACE_FOLDER" -type f -exec chmod g+rw {} \;
    find "$WORKSPACE_FOLDER" -type d -exec chmod g+rwx {} \;
    setfacl -Rm d:g:vscode:rw,g:vscode:rw "$WORKSPACE_FOLDER"
    touch "$workspace_permissions_set"
  fi

fi

exec "$@"
