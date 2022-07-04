#!/usr/bin/env bash
# Adapted from https://foxglovesecurity.com/2016/03/15/fuzzing-workflows-a-fuzz-job-from-start-to-finish/
# Run afl-tmin on every initial input.
# Minimizes each initial input to a reduced form that
# expresses the same code paths as the original input did.

# This runs afl-tmin on multiple files in parallel,
# since running afl-tmin on a lot of files can be time-consuming.
# GNU parallel could be used instead.
# See https://www.gnu.org/software/parallel/parallel.pdf

DESIRED_PATH="aflplusplus-util"
[[ "${PWD##*/}" == "$DESIRED_PATH" ]] || {
  echo "Run from $DESIRED_PATH"
  exit
}

input_directory=$1
output_directory=$2
number_of_cores=$3
number_of_files=$(find "$input_directory" -maxdepth 1 -type f ! -name "$input_directory" | wc -l)

mkdir -p "$output_directory"

for k in $(seq 1 "$number_of_cores" "$number_of_files"); do
  for i in $(seq 0 $((10#$number_of_cores - 1))); do
    file=$(find "$input_directory" -maxdepth 1 -type f -printf '%P\n' | tac | sed $((i + k))"q;d")
    if [[ $file ]]; then
      afl-tmin -i "$input_directory"/"$file" -o "$output_directory"/"$file" -- build/aflplusplus &
    fi
  done

  wait
done
