#!/usr/bin/env bash
# Use cwtriage to use gdb and gdb's "exploitable" plugin, to
# triage afl-found crashes and probe which
# lead to exploitable conditions and which don't.

# cwdump is used to summarize the crashes in the crashwalk database
# by bucketing by major/minor stack hash.
# Although AFL already de-dupes crashes,
# bucketing summarizes these by an order of magnitude or more.
# Crashes that bucket the same have exactly the same stack contents,
# so they're likely (but NOT guaranteed) to be the same bug.

DESIRED_PATH="aflplusplus-util"
[[ "${PWD##*/}" == "$DESIRED_PATH" ]] || {
  echo "Run from $DESIRED_PATH"
  exit
}

screen -xr "crashwalk" -X stuff $'cwtriage -root findings/ -afl && cwdump ./crashwalk.db > triage\n'
