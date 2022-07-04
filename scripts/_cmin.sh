#!/usr/bin/env bash
# Grab the findings of both fuzzers,
# use afl-cmin to minimize the corpus,
# then feed it back to the fuzzers.
# rsync is used instead of cp
# because cp doesn't like overwriting files.

DESIRED_PATH="aflplusplus-util"
[[ "${PWD##*/}" == "$DESIRED_PATH" ]] || {
  echo "Run from $DESIRED_PATH"
  exit
}

mkdir -p queue_all
rsync --progress -a --delete findings/fuzzer*/queue/* queue_all/ || exit
afl-cmin -i queue_all -o queue_cmin -- build/aflplusplus \
  && rm -rf queue_all
