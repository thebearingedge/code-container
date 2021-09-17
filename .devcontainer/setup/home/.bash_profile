#!/bin/bash

for f in "$HOME"/.bash_profile.d/*.bash; do
  # shellcheck source=/dev/null
  source "$f"
done
