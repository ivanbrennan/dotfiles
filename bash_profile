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
    local         BLUE="\[\033[0;34m\]"
    local          RED="\[\033[0;31m\]"
    local          OFF="\[\033[0m\]"

    export PS1="\[╭╺[$BLUE\u$OFF][$BLUE\h$OFF]$RED\$(parse_git_branch) $BLUE\w$OFF\[\e[m\n╰╺⧉  "
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
      # For Mavericks, condition will have to change
    then
      defaults write com.apple.finder AppleShowAllFiles YES
      # For Mavericks, change this to:
      #defaults write com.apple.finder AppleShowAllFiles -boolean true
      echo "Showing hidden"
    else
      defaults write com.apple.finder AppleShowAllFiles NO
      # For Mavericks, change this to:
      #defaults delete com.apple.finder AppleShowAllFiles
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
  # Is this any different from pgrep?
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

  # Start / Stop PostgreSQL server {{{2
  # USE: ghost filename
  function pgstart {
    pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
  }

  # USE: ghost filename
  function pgstop {
    pg_ctl -D /usr/local/var/postgres stop -s -m fast
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
