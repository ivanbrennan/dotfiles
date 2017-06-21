#!/usr/bin/env bash

set -eu

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)

col_green='\033[32;01m'
col_reset='\033[39;49;00m'

printf ':::%b Symlinking shell config files %b:::\n' $col_green $col_reset
bash "$repo_root/install/shell-symlinks.sh"
