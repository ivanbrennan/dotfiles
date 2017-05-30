#!/usr/bin/env bash

set -eu
set -o pipefail

{ # Prevent execution if this script was only partially downloaded

main() {
  config_file=$HOME/.ctags
  touch $config_file

  options=(--languages=-javascript,sql,json,svg
           --exclude=.git
           --exclude=*.min.css)

  for opt in ${options[@]}; do
    if ! line_exists "$opt" $config_file; then
      echo "$opt" >> $config_file
    fi
  done
}

line_exists() {
  local line=$1
  local file=$2

  grep --files-with-matches \
       --fixed-strings      \
       -e "$line" $file     \
       >/dev/null 2>&1
}

main

} # End of wrapping
