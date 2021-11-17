#!/bin/sh

if [ -n "$WORKSPACE_FOLDER" ] && [ -d "$WORKSPACE_FOLDER" ]; then
  chmod g+rwx "$WORKSPACE_FOLDER"
  find "$WORKSPACE_FOLDER" -type f -exec chmod g+rw {} \;
  find "$WORKSPACE_FOLDER" -type d -exec chmod g+rwx {} \;
fi
