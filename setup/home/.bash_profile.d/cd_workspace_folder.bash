#!/bin/bash

if [ -n "$WORKSPACE_FOLDER" ] && [ -d "$WORKSPACE_FOLDER" ]; then
  if [ "$(stat -c '%U' "$WORKSPACE_FOLDER")" != dev ]; then
    sudo chown -R dev:dev "$WORKSPACE_FOLDER"
  fi
  cd "$WORKSPACE_FOLDER" || return
fi
