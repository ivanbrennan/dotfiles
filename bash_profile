#!bin/bash

# ::::::::: Preamble ::::::::::::::::::::::::: {{{1

# bash_profile is meant for login invocations. The convention
# in OSX seems to be to use a login shell for all interactive
# sessions. That being the case, and at the recommendation of
# RVM's Wayne E. Seguin, I'm keeping environment variables and
# such in bashrc and using bash_profile for interactive stuff
# like prompts and functions. I don't know if RVM's way is the
# best way (plus I've been meaning to switch to rbenv), but it
# sounds like a reasonable approach for now.

# ::::::::: Environtment Variables ::::::::::: {{{1

  # Load .bashrc if it exists
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi

# ::::::::: Aliases :::::::::::::::::::::::::: {{{1

  # Source bash_aliases if it exists
  if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
  fi

# ::::::::: Prompt ::::::::::::::::::::::::::: {{{1

  # Output the active git branch
  function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  }

  # Build the prompt
  function prompt {
    # some chars for reference:  ⧉ ℔ λ ⦔ Ω №  ✓
    # define some local colors
    local BLUE="\[\033[0;34m\]"
    local  RED="\[\033[0;31m\]"
    local  OFF="\[\033[0m\]"

    export PS1="\[╭╺[$BLUE\u$OFF][$BLUE\h$OFF][$BLUE\A$OFF]$RED\$(parse_git_branch) $BLUE\w$OFF\[\e[m\n╰╺⧉  "
    export PS2="   > "
    export PS4="   + "
    }

  # Call the prompt function
  prompt

# ::::::::: Functions :::::::::::::::::::::::: {{{1

  # Show PATH {{{2
  function path {
    echo "PATH:"
    echo "$PATH" | tr ":" "\n"
  }

  # Toggle hidden files {{{2
  function hidden {
    if [[ $( defaults read com.apple.finder AppleShowAllFiles ) == "NO" ]]
    then
      defaults write com.apple.finder AppleShowAllFiles TRUE
      echo "Showing hidden"
    else
      defaults write com.apple.finder AppleShowAllFiles FALSE
      echo "Hiding hidden"
    fi
    killall -HUP Finder
  }

  # Run just one MacVim {{{2
  function ivim {
    if [ -n "$1" ]; then
      command mvim --remote-silent "$@"
    elif [ -n "$( mvim --serverlist )" ]; then
      command mvim --remote-send ":call foreground()<CR>:enew<CR>:<BS>"
    else
      command mvim
    fi
  }

  # Easily grep for a matching process {{{2
  # USE: psg postgres
  function psg {
    FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
    REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
    ps aux | grep "[$FIRST]$REST"
  }

  # Easily grep for a matching file {{{2
  # USE: lg filename
  function lg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ls -la | grep "[$FIRST]$REST"
  }

  # Extract archive based on extension {{{2
  # USE: extract imazip.zip
  #      extract imatar.tar
  function extract {
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

  # Compress PDF with Ghostscript {{{2
  # USE: ghost filename
  function ghost {
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="compressed-$1" "$1"
  }

  # process helpers {{{2
  function running {
    pgrep -f "$1" &> /dev/null
  }

  function rpid {
    pgrep -f "$1" 2> /dev/null
  }

  # Start / Stop PostgreSQL server {{{2
  function psta {
    pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
  }

  function psto {
    pg_ctl -D /usr/local/var/postgres stop -s -m fast
  }

  # MySQL server {{{2
  function msta {
    if ! running mysql; then
      mysql.server start
    else
      echo "MySQL already running"
    fi
  }

  function msto {
    if running mysql; then
      mysql.server stop
    else
      echo "MySQL not running"
    fi
  }

  function mstat {
    if running mysql; then
      echo "MySQL alive"
    else
      echo "MySQL dead"
    fi
  }

  # Redis server {{{2
  function resta {
    if ! running redis; then
      redis-server ~/.redis/redis.conf
      until running redis; do
        sleep 1
      done
      echo "Redis daemon spawned"
    else
      echo "Redis daemon already running"
    fi
  }

  function resto {
    if running redis; then
      kill $(rpid redis)
      while running redis; do
        sleep 1
      done
      echo "Redis daemon slain"
    else
      echo "Redis daemon not running"
    fi
  }

  function restat {
    if running redis; then
      echo "Redis daemon alive"
    else
      echo "Redis daemon dead"
    fi
  }

  # Sidekiq {{{2
  function sksta {
    if ! running sidekiq; then
      sidekiq -d
      until running sidekiq; do
        sleep 1
      done
      echo "Sidekiq daemon spawned"
    else
      echo "Sidekiq daemon already running"
    fi
  }

  function sksto {
    if running sidekiq; then
      kill $(rpid sidekiq)
      while running sidekiq; do
        sleep 1
      done
      echo "Sidekiq daemon slain"
    else
      echo "Sidekiq daemon not running"
    fi
  }

  function skstat {
    if running sidekiq; then
      echo "Sidekiq daemon alive"
    else
      echo "Sidekiq daemon dead"
    fi
  }

  # Rails {{{2
  function krs {
    if running 'rails s'; then
      kill $1 $(rpid 'rails s')
      for i in 1 2; do
        if ! running 'rails s'; then
          break
        else
          sleep 1
        fi
      done
      reportkill
    else
      echo "Rails server not running"
    fi
  }

  function reportkill {
    if ! running 'rails s'; then
      echo "Rails server slain"
    else
      echo "Rails server survived (pid $(rpid 'rails s'))"
    fi
  }

  function krs9 {
    krs '-9'
  }

  function krc {
    if running 'rails c'; then
      kill $(rpid 'rails c')
      while running 'rails c'; do
        sleep 1
      done
      echo "Rails console slain"
    else
      echo "Rails console not running"
    fi
  }

  function rastat {
    if running 'rails s'; then
      echo "Rails server alive"
    else
      echo "Rails server dead"
    fi
  }

  function rastac {
    if running 'rails c'; then
      echo "Rails console alive"
    else
      echo "Rails console dead"
    fi
  }

  # All servers {{{2
  function asta {
    msta && resta && sksta
  }

  function asto {
    sksto && resto && msto
  }

  function astat {
    mstat && restat && skstat
  }

  function astatt {
    mstat && restat && skstat && rastat && rastac
  }

  function astop {
    krc && krs && sksto && resto && msto
  }

  # ssh tabs {{{2
  function ssh() {
    echo -en "\033]0;$*\007"
    /usr/bin/ssh $@
  }

# ::::::::: Final Config and Plugins ::::::::: {{{1

  # Case insensitive tab autocomplete {{{2
  bind "set completion-ignore-case on"

  # Git Bash Completion {{{2
  # Activate bash git completion if installed via homebrew
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi

  # Coloring {{{2

    # Enable coloring in the terminal
    export CLICOLOR=1

    # Specify how to color specific items
    export LSCOLORS=hxCxcxDxbxegedabagaced

    # Color designators: {{{3
      # a black
      # b red
      # c green
      # d brown
      # e blue
      # f magenta
      # g cyan
      # h light grey
      # A bold black, usually shows up as dark grey
      # B bold red
      # C bold green
      # D bold brown, usually shows up as yellow
      # E bold blue
      # F bold magenta
      # G bold cyan
      # H bold light grey; looks like bright white
      # x default foreground or background

    # Order of attributes: {{{3
      #  1. directory
      #  2. symbolic link
      #  3. socket
      #  4. pipe
      #  5. executable
      #  6. block special
      #  7. character special
      #  8. executable with setuid bit set
      #  9. executable with setgid bit set
      # 10. directory writable to others, with sticky bit
      # 11. directory writable to others, without sticky bit
      # Default is "exfxcxdxbxegedabagacad", i.e. blue foreground
      # and default background for regular directories, black
      # foreground and red background for setuid executables, etc.

# ::::::::: RVM :::::::::::::::::::::::::::::: {{{1

  # Mandatory loading of RVM into the shell
  # This must be the last line of your bash_profile always

  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
