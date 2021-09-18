#!/bin/bash

cd "${WORKSPACE_FOLDER}" ||
   >&2 echo '$''WORKSPACE_FOLDER not set' && sleep infinity
