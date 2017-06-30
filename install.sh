#!/usr/bin/env bash

set -eu

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && git rev-parse --show-toplevel)

col_green='\033[32;01m'
col_reset='\033[39;49;00m'

printf ':::%b Installing brew %b:::\n' $col_green $col_reset
bash "$repo_root/install/brew.sh"

printf ':::%b Brewing formulae %b:::\n' $col_green $col_reset
bash "$repo_root/install/brew-formulae.sh"

printf ':::%b Brewing Cask formulae %b:::\n' $col_green $col_reset
bash "$repo_root/install/brew-cask-formulae.sh"

printf ':::%b Installing Python packages %b:::\n' $col_green $col_reset
bash "$repo_root/install/python-packages.sh"

printf ':::%b Installing Ruby Gems %b:::\n' $col_green $col_reset
bash "$repo_root/install/ruby-gems.sh"

printf ':::%b Choosing shell %b:::\n' $col_green $col_reset
bash "$repo_root/install/choose-shell.sh"

printf ':::%b Making symlinks %b:::\n' $col_green $col_reset
bash "$repo_root/install/make-symlinks.sh"
