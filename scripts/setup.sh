#!/usr/bin/env bash
# Make sure all dependencies are installed and ready to go.

DESIRED_PATH="aflplusplus-util"
[[ "${PWD##*/}" == "$DESIRED_PATH" ]] || {
  echo "Run from $DESIRED_PATH"
  exit
}
CURRENT_DIRECTORY="$PWD"

# Make sure that afl-fuzz runs on an optimally configured system.
# See https://github.com/AFLplusplus/AFLplusplus/blob/stable/docs/fuzzing_in_depth.md#a-running-afl-fuzz
# You can find these files in
# https://raw.githubusercontent.com/AFLplusplus/AFLplusplus/stable/afl-system-config
# and in
# https://raw.githubusercontent.com/AFLplusplus/AFLplusplus/stable/afl-persistent-config

# If you want to run afl-fuzz without these changes just comment this out.
export AFL_SKIP_CPUFREQ=0

# Enable the StatsD metrics collection on the fuzzer instances.
# See https://github.com/AFLplusplus/AFLplusplus/blob/stable/docs/rpc_statsd.md#setting-environment-variables-in-afl
export AFL_STATSD=1

# Enable tags for each StatsD metric. Needed to see aggregate metrics for each individual fuzzing instance.
# See https://github.com/AFLplusplus/AFLplusplus/blob/stable/docs/rpc_statsd.md#setting-environment-variables-in-afl
export AFL_STATSD_TAGS_FLAVOR=dogstatsd

# Have everything in the Docker container use vim instead of Joe.
export VISUAL=vim
export EDITOR="$VISUAL"

# Check if package is installed, install it otherwise.
function maybe-install {
  if ! dpkg-query -W -f='${Status}' "$1" | grep "ok installed"; then
    apt install --yes --no-install-recommends "$1"
  fi
}

# Check if directory exists and is not empty.
function dir-ok {
  if [[ -d "$1" && -n "$(ls -A "$1")" ]]; then
    true
  else
    false
  fi
}

apt update \
  && apt upgrade -y \
  && maybe-install screen \
  && maybe-install rsync \
  && maybe-install gdb \
  && maybe-install curl \
  && maybe-install python2 # For afl-cov

# Manually install go, to get a more recent version.
# If we don't, we can't use go install, and we can't
# use shfmt.

if ! dir-ok /usr/local/go; then
  mkdir -p ~/.go
  rm -rf ~/go
  GOPATH="$HOME"/.go
  echo "GOPATH=$HOME/.go" >>"$HOME"/.bashrc \
    && echo "export GOPATH" >>"$HOME"/.bashrc \
    && echo "PATH=$PATH:/usr/local/go/bin:$GOPATH/bin" >>"$HOME"/.bashrc

  curl -OL https://go.dev/dl/go1.17.6.linux-amd64.tar.gz \
    && tar -C /usr/local -xvf go1.17.6.linux-amd64.tar.gz \
    && rm -rf go1.17.6.linux-amd64.tar.gz

  # A hack to be able to source .bashrc from inside the shell script.
  # See https://askubuntu.com/a/77053/1165092

  # Note that if you run the script as source all env changes
  # made by the script will be immediately reflected in your working environment
  # and, therefore, in all subsequent script executions.
  # Otherwise the terminal will not reflect the env changes caused.
  # In other words, you still have to
  # either re-source ~/.bashrc manually, or restart the terminal.
  # See https://stackoverflow.com/a/18548047/10772985
  PS1='$ ' && source "$HOME"/.bashrc
  go version || exit
fi

cd || exit
if ! dir-ok src; then
  mkdir -p src
  cd src || exit
  git clone https://github.com/jfoote/exploitable.git
fi

cd || exit
if ! dir-ok go; then
  mkdir -p go
  go get -u github.com/bnagy/crashwalk/cmd/...
  go install mvdan.cc/sh/v3/cmd/shfmt@latest
fi

wget -N -q -O "/usr/local/bin/afl-cov" "https://raw.githubusercontent.com/mrash/afl-cov/master/afl-cov"

TLDR_MESSAGE="setup.sh (execute with source)
instrument.sh
build-cov.sh
launch-screen.sh
tmin.sh
fuzz.sh
cov.sh       -
stop-fuzz.sh |
cmin.sh      | repeat
retmin.sh    |
refuzz.sh    -
triage.sh
quit-screen.sh"

alias tldr='echo "$TLDR_MESSAGE"'

# Meant to preserve being cd'ed in the aflplusplus folder
# in case you ran setup.sh with source (which you should)
cd "$CURRENT_DIRECTORY" || exit
