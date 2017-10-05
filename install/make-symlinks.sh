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
  "$repo/shell/bash_history_filter.awk"
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
  "$repo/haskeline"
)

source_files=(
  "${term_files[@]}"
  "${shell_files[@]}"
  "${tag_files[@]}"
  "${ruby_files[@]}"
  "${misc_files[@]}"
)

docker_cmds=(
  docker
  docker-machine
  docker-compose
)

main() {
  symlink_dotfiles
  symlink_docker_completions
}

symlink_dotfiles() {
  for src in "${source_files[@]}"; do
    link="$HOME/.$(basename "$src")"

    if already_exists "$link"; then
      backup="${link}-backup-$(date +%s)"
      echo "$link already exists. Backing up to $backup"
      mv -i "$link" "$backup"
    fi

    make_symlink "$src" "$link"
  done
}

symlink_docker_completions() {
  brew_prefix="$(brew --prefix 2>/dev/null)"
  completion_dir="${brew_prefix:+${brew_prefix}/etc/bash_completion.d}"

  if [[ -w "$completion_dir" ]]; then
    docker_etc=/Applications/Docker.app/Contents/Resources/etc

    for cmd in "${docker_cmds[@]}"; do
      cmd_completion="${docker_etc}/${cmd}.bash-completion"

      if [[ -r "$cmd_completion" ]]; then
        make_symlink "$cmd_completion" "${completion_dir}/${cmd}"
      fi
    done
  fi
}

already_exists() {
  # non-empty && not a symlink
  [ -s "$1" ] && [ ! -L "$1" ]
}

make_symlink() {
  local src=$1 link=$2
  ln -svnF "$src" "$link" | grep -Fe '->'
}

symlink_dotfiles
symlink_docker_completions
