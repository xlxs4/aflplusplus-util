#!/usr/bin/env bash
# This, unlike tmin.sh, does some extra work because now
# we want afl-tmin to run on the findings directory, containing
# the queue from the two fuzzer instances.

DESIRED_PATH="aflplusplus-util"
[[ "${PWD##*/}" == "$DESIRED_PATH" ]] || {
  echo "Run from $DESIRED_PATH"
  exit
}

mkdir -p queue
./scripts/_tmin.sh queue_cmin queue "$(nproc)" || exit
cd findings || exit
rm -rf fuzzer1/queue \
  && rm -rf fuzzer2/queue \
  && cp -r ../queue fuzzer1/queue \
  && cp -r ../queue fuzzer2/queue \
  && rm -rf ../queue \
  && rm -rf ../queue_cmin
