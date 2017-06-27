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

dotfiles=(
  "${term_files[@]}"
  "${shell_files[@]}"
  "${tag_files[@]}"
  "${ruby_files[@]}"
  "${misc_files[@]}"
)

for file in "${dotfiles[@]}"; do
  name=$(basename "$file")
  ln -svhF "$file" "$HOME/.$name"
done
