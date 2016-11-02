#!/bin/sh

# ::::::::: Preamble ::::::::::::::::::::::::: {{{1

# bash_profile is meant for login invocations. OSX conventionally
# uses a login shell for all interactive sessions.

# ::::::::: Environtment Variables ::::::::::: {{{1

  # Source .bashrc if it exists
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi

# ::::::::: Aliases :::::::::::::::::::::::::: {{{1

  # Source bash_aliases if it exists
  if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
  fi

# ::::::::: Functions :::::::::::::::::::::::: {{{1

  # Source bash_functions if it exists
  if [ -f ~/.bash_functions ]; then
    . ~/.bash_functions
  fi

# ::::::::: Final Config and Plugins ::::::::: {{{1

  # History {{{2
    # Erase duplicates in history
      export HISTCONTROL=erasedups

    # Store 10k history entries
      export HISTSIZE=10000

    # Append to the history file when exiting instead of overwriting it
      shopt -s histappend

  # Output Control {{{2
    # If the shell is interactive, disable START/STOP output control.
    # This allows Ctrl-S to be used for i-search.
    case "$-" in
      *i*) stty -ixon;;
    esac

# ::::::::: rbenv :::::::::::::::::::::::::::: {{{1

    if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

