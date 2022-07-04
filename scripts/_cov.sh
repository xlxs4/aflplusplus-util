#!/usr/bin/env bash

# Run afl-cov in live mode. Integrates lcov/gcov wifh fuzzer findings.

DESIRED_PATH="aflplusplus-util"
[[ "${PWD##*/}" == "$DESIRED_PATH" ]] || {
  echo "Run from $DESIRED_PATH"
  exit
}

# Change accordingly.
LCOV_EXCLUDE_PATTERN="'/usr/include*' '/aflplusplus-util/lib*' '/aflplusplus-util/inc*' '/aflplusplus-util/src*' '/aflplusplus-util/aflplusplus/build-cov*'"
COVERAGE_CMD="cat AFL_FILE | build-cov/aflplusplus"
# Sanity check that executable was compiled with coverage support.
afl-cov --gcov-check --coverage-cmd "$COVERAGE_CMD"

# --ignore-core-pattern because I'd rather have AFL++ to control this.
# Also, if using docker with --security-opt seccomp=unconfined
# there won't be any /proc/sys/kernel/core_pattern inside the container.
afl-cov -d findings --coverage-at-exit --overwrite \
  --ignore-core-pattern \
  --lcov-exclude-pattern "$LCOV_EXCLUDE_PATTERN" \
  --coverage-cmd "$COVERAGE_CMD" \
  --code-dir build-cov/ -v
