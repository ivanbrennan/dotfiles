#!/usr/bin/env bash

set -eu
set -o pipefail

{ # Prevent execution if this script was only partially downloaded

while [[ $# -gt 0 ]]; do
  case $1 in
    -b|--branch)
      ARG_DOTFILES_BRANCH=$2
      shift
      ;;
    -g|--github-host)
      ARG_GITHUB_HOST=$2
      shift
      ;;
    *)
      echo "Usage: $0 [-b|--branch NAME] [-g|--github-host HOST]"
      exit 1
      ;;
  esac
  shift
done

DOTFILES_BRANCH=${ARG_DOTFILES_BRANCH:-master}
GITHUB_HOST=${ARG_GITHUB_HOST:-github.com}

TEMP_DIR="$(mktemp -d -t dotfiles-install.XXXXXXXXXX)"
trap 'rm -rf "$TEMP_DIR"' EXIT

echo_green() {
  local green="\x1b[32;01m"
  local reset="\x1b[39;49;00m"
  echo -e "${green}${1}${reset}"
}

echo_green '### Cloning dotfiles for installation files ###'
git clone \
    --branch ${DOTFILES_BRANCH} \
    "git@${GITHUB_HOST}:ivanbrennan/dotfiles.git" \
    "${TEMP_DIR}/dotfiles"


bash ${TEMP_DIR}/dotfiles/install/install.sh ${TEMP_DIR}

} # End of wrapping
