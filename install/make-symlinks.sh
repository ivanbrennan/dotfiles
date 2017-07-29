#!/bin/sh

repo=$HOME/Development/resources/dotfiles

term_files=(
  "$repo/terminal/terminfo.d/terminfo"
  "$repo/tmux/tmux-keys.conf"
  "$repo/tmux/tmux.conf"
  "$repo/screenrc"
)

shell_files=(
  "$repo/shell/bash_aliases"
  "$repo/shell/bash_colors.sh"
  "$repo/shell/bash_functions"
  "$repo/shell/bash_history_filter"
  "$repo/shell/bash_profile"
  "$repo/shell/bashrc"
  "$repo/shell/inputrc"
)

ruby_files=(
  "$repo/gemrc"
  "$repo/irbrc"
  "$repo/rspec"
)

tag_files=(
  "$repo/globalrc"
  "$repo/ctags" # move to ctags-config repo?
)

misc_files=(
  "$repo/githelpers"
  "$repo/my.cnf"
  "$repo/less"
)

source_files=(
  "${term_files[@]}"
  "${shell_files[@]}"
  "${tag_files[@]}"
  "${ruby_files[@]}"
  "${misc_files[@]}"
)

main() {
  for src in "${source_files[@]}"; do
    link="$HOME/.$(basename "$src")"

    if already_exists "$link"; then
      backup="${link}-backup-$(date +%s)"
      echo "$link already exists. Backing up to $backup"
      mv -i "$link" "$backup"
    fi

    ln -svhF "$src" "$link" | grep -Fe '->'
  done
}

already_exists() {
  # non-empty && not a symlink
  [ -s "$1" ] && [ ! -L "$1" ]
}

main
