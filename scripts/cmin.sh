#!/usr/bin/env bash
# Wrapper script to call the afl-cmin script in a screen session.
# TODO: find a better way?

DESIRED_PATH="aflplusplus-util"
[[ "${PWD##*/}" == "$DESIRED_PATH" ]] || {
  echo "Run from $DESIRED_PATH"
  exit
}

screen -xr "cmin" -X stuff $'./scripts/_cmin.sh\n'
