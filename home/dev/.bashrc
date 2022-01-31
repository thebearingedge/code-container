#!/bin/bash

[[ $- != *i* ]] && return

for config in "$HOME"/.bashrc.d/*.bash; do
  # shellcheck source=/dev/null
  source "${config}"
done
