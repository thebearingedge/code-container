#!/bin/bash

[[ $- != *i* ]] && return

exec sudo -u dev "$0" "${@}"
