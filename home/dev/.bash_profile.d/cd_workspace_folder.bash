#!/bin/bash

if [ -n "$WORKSPACE_FOLDER" ] && [ -d "$WORKSPACE_FOLDER" ]; then
  cd "$WORKSPACE_FOLDER" || return
fi
