#!/usr/bin/env bash

set -e
{ # Prevent execution if this script was only partially downloaded

commands=$(mktemp -t install-ctags-git-hooks.XXXXXX)
trap 'rm -f "$commands"' EXIT # delete temp file upon EXIT

main() {
  envvar_template_dir=$(echo $GIT_TEMPLATE_DIR)
  config_template_dir=$(git config --global --get --path init.templateDir)
  template_dir=${envvar_template_dir:-${config_template_dir}}

  if [ -z "$template_dir" ]; then
    echo "ERROR: No git template directory configured."
    exit 1
  fi

  hooks_dir=$template_dir/hooks
  mkdir -p $hooks_dir

  if [ -e $hooks_dir/ctags ]; then
    timestamp=$(date +%s)
    echo "### Moving existing $hooks_dir/ctags to ctags.backup.$timestamp"
    mv $hooks_dir/ctags $hooks_dir/ctags.backup.$timestamp
  fi

  echo "### Creating $hooks_dir/ctags"
  curl -fsSL --output $hooks_dir/ctags \
       -H 'Accept: application/vnd.github-blob.raw' \
       'https://api.github.com/repos/ivanbrennan/dotfiles/contents/git/templates/hooks/ctags'

  chmod +x $hooks_dir/ctags

  echo '.git/hooks/ctags >/dev/null 2>&1 &' > $commands
  for file in post-checkout post-commit post-merge; do
    add_or_create_hook $hooks_dir/$file
  done

  cat << 'EOF' > $commands
case "$1" in
  rebase) exec .git/hooks/post-merge ;;
esac
EOF
  add_or_create_hook $hooks_dir/post-rewrite
}

add_or_create_hook() {
  local file=$1
  local name=$(basename $file)

  if [ -e $file ]; then
    if ! contains_match $commands $file; then
      echo "### Appending to existing $name hook"
      echo          >> $file
      cat $commands >> $file
    fi
  else
    echo "### Creating $name hook"
    touch $file
    chmod +x $file
    echo '#!/bin/sh' >> $file
    echo             >> $file
    cat $commands    >> $file
  fi
}

contains_match() {
  local text=$1
  local file=$2

  [[ $(<$file) = *$(<$text)* ]]
}

main

} # End of wrapping
