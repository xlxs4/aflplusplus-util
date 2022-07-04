#!/usr/bin/env bash
# Wrapper script to call the afl-cov script in a screen session.
# TODO: find a better way?

DESIRED_PATH="aflplusplus-util"
[[ "${PWD##*/}" == "$DESIRED_PATH" ]] || {
  echo "Run from $DESIRED_PATH"
  exit
}

screen -xr "cov" -X stuff $'./scripts/_cov.sh\n'
