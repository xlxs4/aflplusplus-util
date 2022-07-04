#!/usr/bin/env bash
# Send a CTRL+C to the running sessions.

DESIRED_PATH="aflplusplus-util"
[[ "${PWD##*/}" == "$DESIRED_PATH" ]] || {
  echo "Run from $DESIRED_PATH"
  exit
}

screen -xr "fuzzer1" -X stuff $'\003\n' \
  && screen -xr "fuzzer2" -X stuff $'\003\n'
