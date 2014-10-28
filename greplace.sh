#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o xtrace

filename_pattern=$1
pattern=$2
replacement=$3

find . -name "${filename_pattern}" | xargs grep -rl "${pattern}" | xargs sed -i '' "s/${pattern}/${replacement}/g"
