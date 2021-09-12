#!/bin/sh

set -e

useradd --create-home --shell /bin/bash --groups sudo dev && \
  echo 'dev ALL=(root) NOPASSWD:ALL' > /etc/sudoers.d/dev && \
  chmod 440 /etc/sudoers.d/dev && \
  mkdir -p /home/dev/.ssh && \
  touch /home/dev/.hushlogin /home/dev/.sudo_as_admin_successful && \
  echo 'export LS_COLORS="$LS_COLORS:fi=97:di=34:tw=34:ow=34"' >> /home/dev/.bashrc

chown -R dev:dev /home/dev
