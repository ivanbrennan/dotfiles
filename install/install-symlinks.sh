#!/bin/sh

dotfiles=(
  "$HOME/Development/resources/dotfiles/shell/bash_aliases"
  "$HOME/Development/resources/dotfiles/shell/bash_colors.sh"
  "$HOME/Development/resources/dotfiles/shell/bash_functions"
  "$HOME/Development/resources/dotfiles/shell/bash_profile"
  "$HOME/Development/resources/dotfiles/shell/bashrc"
  "$HOME/Development/resources/dotfiles/shell/inputrc"
)

echo '### Generating symlinks...'

for file in ${dotfiles[@]}; do
  name=$(basename $file)
  ln -svhF "$file" "$HOME/.$name"
done
