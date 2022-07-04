#!/usr/bin/env bash
# Use shfmt to find all paths to shell scripts recursively,
# then format each file in-place.

# The formatting flags selected closely resemble
# the Google codestyle guidelines for shell:
# https://google.github.io/styleguide/shellguide.html

DESIRED_PATH="aflplusplus-util"
[[ "${PWD##*/}" == "$DESIRED_PATH" ]] || {
  echo "Run from $DESIRED_PATH"
  exit
}

shfmt -f . | xargs shfmt -l -w -i 2 -ci -bn
