#!/usr/bin/env bash
# Start named screen sessions in detached mode.
# This creates a session but doesn't attach to it.

DESIRED_PATH="aflplusplus-util"
[[ "${PWD##*/}" == "$DESIRED_PATH" ]] || {
  echo "Run from $DESIRED_PATH"
  exit
}

# Create the session only if a session with that name doesn't already exist.
function bgsc {
  if ! (screen -ls | awk '{print $1}' | grep -q "$1$"); then screen -d -m -S "$1"; fi
}

bgsc "fuzzer1" \
  && bgsc "fuzzer2" \
  && bgsc "tmin" \
  && bgsc "cmin" \
  && bgsc "crashwalk" \
  && bgsc "cov"
