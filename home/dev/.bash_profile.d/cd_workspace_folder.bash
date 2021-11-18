#!/bin/bash

ssh_dir="$HOME"/.ssh

if [ -d "$ssh_dir" ]; then
  # fix permissions in case the host .ssh permissions are loose
  ssh_permissions_set="$HOME"/.ssh_permissions_set

  if [ ! -f "$ssh_permissions_set" ]; then
    chmod 700 "$ssh_dir"
    chmod 600 "$ssh_dir"/*
    chmod 644 "$ssh_dir"/*.pub
    touch "$ssh_permissions_set"
  fi

fi
