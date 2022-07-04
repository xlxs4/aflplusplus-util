#!/usr/bin/env bash
# Remove the folder containing the instrumented executable,
# the project sources copy executable with gcov support,
# all `afl-fuzz`-generated files, including what the fuzzing
# instances found, and the minimized initial input testcases.

DESIRED_PATH="aflplusplus-util"
[[ "${PWD##*/}" == "$DESIRED_PATH" ]] || {
  echo "Run from $DESIRED_PATH"
  exit
}

rm -rf build build-cov findings minimized crashwalk.db triage
