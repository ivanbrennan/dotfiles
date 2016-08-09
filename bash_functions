#!/usr/bin/env bash

# Change profile {{{1
dark() {
  export THEME=dark
  set_profile 'black' 'blue & grey'
  source_bash_profile
}

light() {
  export THEME=light
  set_profile 'white' 'blue & white'
  source_bash_profile
}

remote() {
  export THEME=remote
  set_profile 'remote' 'Smyck'
  source_bash_profile
}

set_profile() {
  if using_iterm; then
    set_iterm_profile "$1"
  else
    set_terminal_profile "$2"
  fi
}

set_iterm_profile() {
  if using_multiplexer; then
    set_multiplex_iterm_profile "$1"
  else
    echo -e "\033]50;SetProfile=$1\007"
  fi
}

set_multiplex_iterm_profile() {
  if using_tmux; then
    set_tmux_iterm_profile "$1"
  else
    set_gnu_screen_iterm_profile "$1"
  fi
}

set_tmux_iterm_profile() {
  echo -e "\033Ptmux;\033\033]50;SetProfile=$1\007\033\\"
}

set_gnu_screen_iterm_profile() {
  echo -e "\033P\033]50;SetProfile=$1\007\033\\"
}

set_terminal_profile() {
  osascript -e "tell application \"Terminal\" to set current settings of front window to settings set \"$1\""
}

using_iterm() {
  [ -n "${ITERM_PROFILE+x}" ]
}

using_multiplexer() {
  [[ "$TERM" =~ "screen" ]]
}

using_tmux() {
  [ -n "${TMUX+x}" ]
}

source_bash_profile() {
  if [ -f ~/.bash_profile ]; then
    . ~/.bash_profile
  fi
}

# Show PATH {{{1
path() {
  echo "PATH:"
  echo "$PATH" | tr ":" "\n"
}

# Toggle hidden files {{{1
hidden() {
  if [[ $( defaults read com.apple.finder AppleShowAllFiles ) == "FALSE" ]]
  then
    defaults write com.apple.finder AppleShowAllFiles TRUE
    echo "Showing hidden"
  else
    defaults write com.apple.finder AppleShowAllFiles FALSE
    echo "Hiding hidden"
  fi
  killall -HUP Finder
}

# Toggle LESS -XR {{{1
xr() {
  if [ -z "${LESS+x}" ]; then
    export LESS="-XR"
  else
    unset LESS
  fi
}

# Run just one MacVim {{{1
ivim() {
  if [ -n "$1" ]; then
    command mvim --remote-silent "$@"
  elif [ -n "$( mvim --serverlist )" ]; then
    command mvim --remote-send ":call foreground()<CR>:enew<CR>:<BS>"
  else
    command mvim
  fi
}

lnspacemacs() {
  ln -shF ~/Development/resources/dotemacs/spacemacs.d ~/.emacs.d
}

lnemacs() {
  ln -shF ~/Development/resources/dotemacs/emacs.d ~/.emacs.d
}

debugemacs() {
  /usr/local/Cellar/emacs-mac/HEAD-c17d400/Emacs.app/Contents/MacOS/Emacs --debug-init &
}

# Easily grep for a matching process {{{1
# USE: psg postgres
psg() {
  local FIRST
  local REST
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ps aux | grep "[$FIRST]$REST"
}

# Easily grep for a matching file {{{1
# USE: lg filename
lg() {
  local FIRST
  local REST
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ls -la | grep "[$FIRST]$REST"
}

# Extract archive based on extension {{{1
# USE: extract imazip.zip
#      extract imatar.tar
extract() {
  if [ -f $1 ]; then
    case $1 in
      *.tar.bz2)  tar xjf "$1"      ;;
      *.tar.gz)   tar xzf "$1"      ;;
      *.bz2)      bunzip2 "$1"      ;;
      *.rar)      rar x "$1"        ;;
      *.gz)       gunzip "$1"       ;;
      *.tar)      tar xf "$1"       ;;
      *.tbz2)     tar xjf "$1"      ;;
      *.tgz)      tar xzf "$1"      ;;
      *.zip)      unzip "$1"        ;;
      *.Z)        uncompress "$1"   ;;
      *)          echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Compress PDF with Ghostscript {{{1
# USE: ghost filename
ghost() {
  gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="compressed-$1" "$1"
}

# process helpers {{{1
running() {
  rpid "$1" > /dev/null
}

rpid() {
  pgrep -f "$1" 2> /dev/null
}

p_start() {
  local proc
  local name
  proc=$1; shift
  name=$1; shift
  if ! running "$proc"; then
    "$@"
  else
    echo "$name already running"
  fi
}

p_stop() {
  local proc
  local name
  proc=$1; shift
  name=$1; shift
  if running "$proc"; then
    "$@"
  else
    echo "$name not running"
  fi
}

p_status() {
  local proc
  local name
  proc=$1; shift
  name=$1; shift
  if running "$proc"; then
    echo "$name alive"
  else
    echo "$name dead"
  fi
}

# Start / Stop PostgreSQL server {{{1
pgsta() {
  pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
}

pgsto() {
  pg_ctl -D /usr/local/var/postgres stop -s -m fast
}

# server helpers {{{1
mstat() {
  p_status mysql MySQL
}

restat() {
  p_status redis "Redis daemon"
}

sistat() {
  p_status sidekiq "Sidekiq daemon"
}

astat() {
  mstat && restat && sistat
}

astop() {
  sksto && resto && msto
}

serverhelp() {
  echo -e "MySQL: \tmysql.server start"
  echo -e "\tmysql.server stop\n"
  echo -e "Redis: \tredis-server ~/.redis/redis.conf"
  echo -e "\tpkill redis\n"
  echo -e "kiqs: \tsidekiq -d"
  echo -e "\tpkill sidekiq"
}
# Rails {{{1
krs() {
  p_stop "rails s" "Rails server" rails_stop "server" "$1"
}

krs9() {
  krs '-9'
}

rails_stop() {
  kill "$2" "$(rpid "rails ${1:0:1}")" 2> /dev/null
  for i in 1 2; do
    if ! running "rails ${1:0:1}"; then
      break
    else
      sleep 1
    fi
  done
  reportkill "$1"
}

reportkill() {
  if ! running "rails ${1:0:1}"; then
    echo "Rails $1 slain"
  else
    echo "Rails $1 survived (pid $(rpid "rails ${1:0:1}"))"
  fi
}

# ssh tabs {{{1
ssh() {
  echo -en "\033]0;$*\007"
  /usr/bin/ssh $@
}

# tmux {{{1
hdv() {
  if ! tmux has-session -t hb-dev 2>/dev/null
  then
    tmux new-session -d -s hb-dev   -n shell   -c ~/Development/code/handy/handybook
    tmux new-window     -t hb-dev:9 -n vim     -c ~/Development/code/handy/handybook

    tmux select-window  -t hb-dev:9
  fi
  tmux attach-session -t hb-dev
}
hsv() {
  if ! tmux has-session -t hb-server 2>/dev/null
  then
    tmux new-session -d -s hb-server   -n shell   -c ~/Development/code/handy/handybook
    tmux new-window     -t hb-server:7 -n tests   -c ~/Development/code/handy/handybook
    tmux new-window     -t hb-server:8 -n console -c ~/Development/code/handy/handybook
    tmux new-window     -t hb-server:9 -n server  -c ~/Development/code/handy/handybook

    tmux select-window  -t hb-server:0
  fi
  tmux attach-session -t hb-server
}

if_git_tmux() {
  if git rev-parse --git-dir >/dev/null 2>&1 && [ -n "${TMUX+x}" ]; then
    "$@"
  fi
}

smartpane() {
  local WIDTH=$( tmux display-message -p '#{pane_width}' )
  local HEIGHT=$( tmux display-message -p '#{pane_height}' )
  local RATIO=3

  if [ ${WIDTH} -gt $(( ${HEIGHT} * ${RATIO} )) ]; then
    local CHARS=85
    $( tmux split-window -h -l ${CHARS} "$1" )
  else
    local PERCENT=30
    $( tmux split-window -v -p ${PERCENT} "$1" )
  fi
}

glit() {
  if_git_tmux smartpane "gitsh"
}

gmit() {
  if_git_tmux smartpane "git commit"
}

# search and replace {{{1
rupl() {
  if [ "$#" != 2 ]; then
    echo "Usage: rupl search_pattern replacement"
    return 1
  else
    local search_pattern
    local replacement
    search_pattern=$1
    replacement=$2

    greplace '**.rb' "$search_pattern" "$replacement"
  fi
}

greplace() {
  if [ "$#" != 3 ]; then
    echo "Usage: greplace file_pattern search_pattern replacement"
    return 1
  else
    local file_pattern
    local search_pattern
    local replacement
    file_pattern=$1
    search_pattern=$2
    replacement=$3

    # This is built for BSD grep and the sed bundled with OS X.
    # GNU grep takes -Z instead of --null, and other versions of sed may not support the -i '' syntax.

    find . -name "$file_pattern" -exec grep -lw --null "$search_pattern" {} + |
    xargs -0 sed -i '' "s/[[:<:]]$search_pattern[[:>:]]/$replacement/g"
  fi
}

