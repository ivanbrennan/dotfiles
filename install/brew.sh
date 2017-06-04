#!/usr/bin/env bash

brew_existst() {
  hash brew 2>/dev/null
}

if brew_exists; then
  echo '### Updating Homebrew...'
  brew update
then
  echo "Installing Homebrew..."
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
