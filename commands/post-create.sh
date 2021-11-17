#!/bin/sh

# fix permissions so that dev and vscode can write each other's files

if [ -n "$WORKSPACE_FOLDER" ] && [ -d "$WORKSPACE_FOLDER" ]; then
  workspaces="$(dirname "$WORKSPACE_FOLDER")"
  workspace_basename="$(basename "$WORKSPACE_FOLDER")"
  if [ ! -f "$workspaces"/."$workspace_basename" ]; then
    chmod g+rwx "$WORKSPACE_FOLDER"
    find "$WORKSPACE_FOLDER" -type f -exec chmod g+rw {} \;
    find "$WORKSPACE_FOLDER" -type d -exec chmod g+rwx {} \;
    touch "$workspaces"/."$workspace_basename"
  fi
fi
