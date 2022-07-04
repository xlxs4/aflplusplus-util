#!/usr/bin/env bash
# Create a spare copy of the project sources,
# and compile the copy with gcov profiling support.
# See https://github.com/mrash/afl-cov#workflow

DESIRED_PATH="aflplusplus-util"
[[ "${PWD##*/}" == "$DESIRED_PATH" ]] || {
  echo "Run from $DESIRED_PATH"
  exit
}

mkdir -p build-cov
cd build-cov || exit
cmake -DCMAKE_C_COMPILER=/usr/bin/gcc \
  -DCMAKE_CXX_COMPILER=/usr/bin/g++ \
  -DCMAKE_CXX_FLAGS="-g -O0 --coverage -fprofile-arcs -ftest-coverage" .. \
  && make -j"$(nproc)"
