#!/bin/bash

for config in "$HOME"/.bash_profile.d/*.bash; do
  # shellcheck source=/dev/null
  source "${config}"
done
