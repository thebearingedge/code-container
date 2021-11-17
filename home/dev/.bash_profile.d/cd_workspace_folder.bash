#!/bin/bash

if [ -n "$WORKSPACE_FOLDER" ] && [ -d "$WORKSPACE_FOLDER" ]; then
  umask 0002
  cd "$WORKSPACE_FOLDER" || return
fi
