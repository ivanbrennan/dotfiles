#!/usr/bin/env bash

set -eu

brew_prefix=$(brew --prefix 2>/dev/null)
shell=${brew_prefix:+${brew_prefix}/bin/bash}

main() {
  if has_shell; then
    add_shell_to_approved_shells_list
    set_user_shell
  fi
}

has_shell() {
  [[ -x "$shell" ]]
}

add_shell_to_approved_shells_list() {
  if ! shell_already_approved; then
    sudo -v
    sudo echo "$shell" >> /etc/shells
  fi
}

shell_already_approved() {
  grep -qF "$shell" /etc/shells
}

set_user_shell() {
  if [[ $SHELL != "$shell" ]]; then
    local user=$(id -urn)
    chsh -s "$shell" "$user"
  fi
}

main
