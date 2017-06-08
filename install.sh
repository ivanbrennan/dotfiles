#!/usr/bin/env bash

set -eu

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)

col_green="\x1b[32;01m"
col_reset="\x1b[39;49;00m"

echo -e "${col_green}::: Symlinking shell config files :::${col_reset}"
bash "$repo_root/install/shell-symlinks.sh"
