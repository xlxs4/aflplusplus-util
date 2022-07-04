#!/usr/bin/env bash
# Kill the running screen sessions.

DESIRED_PATH="aflplusplus-util"
[[ "${PWD##*/}" == "$DESIRED_PATH" ]] || {
  echo "Run from $DESIRED_PATH"
  exit
}

screen -X -S fuzzer1 quit
screen -X -S fuzzer2 quit
screen -X -S tmin quit
screen -X -S cmin quit
screen -X -S crashwalk quit
screen -X -S cov quit
