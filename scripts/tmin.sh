#!/usr/bin/env bash
# Wrapper script to call the afl-tmin script in a screen session.
# TODO: find a better way?

DESIRED_PATH="aflplusplus-util"
[[ "${PWD##*/}" == "$DESIRED_PATH" ]] || {
  echo "Run from $DESIRED_PATH"
  exit
}

screen -xr "tmin" -X stuff $'./scripts/_tmin.sh inputs minimized $(nproc)\n'
