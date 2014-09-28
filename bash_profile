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

# ::::::::: Functions :::::::::::::::::::::::: {{{1

  # Change iterm2 profile {{{2
  darken() {
    if [ -n "$ITERM_PROFILE" ]; then
      export THEME=dark
      it2prof black
      reload_profile
    fi
  }

  lighten() {
    if [ -n "$ITERM_PROFILE" ]; then
      unset THEME
      it2prof white
      reload_profile
    fi
  }

  reload_profile() {
    if [ -f ~/.bash_profile ]; then
      . ~/.bash_profile
    fi
  }

  it2prof() {
    if [[ "$TERM" =~ "screen" ]]; then
      scrn_prof "$1"
    else
      # send escape sequence to change iTerm2 profile
      echo -e "\033]50;SetProfile=$1\007"
    fi
  }

  scrn_prof() {
    if [ -n "$TMUX" ]; then
      # tell tmux to send escape sequence to underlying terminal
      echo -e "\033Ptmux;\033\033]50;SetProfile=$1\007\033\\"
    else
      # tell gnu screen to send escape sequence to underlying terminal
      echo -e "\033P\033]50;SetProfile=$1\007\033\\"
    fi
  }

  # Show PATH {{{2
  path() {
    echo "PATH:"
    echo "$PATH" | tr ":" "\n"
  }

  # Toggle hidden files {{{2
  hidden() {
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
  ivim() {
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
  psg() {
    FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
    REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
    ps aux | grep "[$FIRST]$REST"
  }

  # Easily grep for a matching file {{{2
  # USE: lg filename
  lg() {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ls -la | grep "[$FIRST]$REST"
  }

  # Extract archive based on extension {{{2
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

  # Compress PDF with Ghostscript {{{2
  # USE: ghost filename
  ghost() {
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="compressed-$1" "$1"
  }

  # process helpers {{{2
  running() {
    rpid "$1" > /dev/null
  }

  rpid() {
    pgrep -f "$1" 2> /dev/null
  }

  p_start() {
    proc=$1; shift
    name=$1; shift
    if ! running "$proc"; then
      "$@"
    else
      echo "$name already running"
    fi
  }

  p_stop() {
    proc=$1; shift
    name=$1; shift
    if running "$proc"; then
      "$@"
    else
      echo "$name not running"
    fi
  }

  p_status() {
    proc=$1; shift
    name=$1; shift
    if running "$proc"; then
      echo "$name alive"
    else
      echo "$name dead"
    fi
  }

  # Start / Stop PostgreSQL server {{{2
  pgsta() {
    pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start
  }

  pgsto() {
    pg_ctl -D /usr/local/var/postgres stop -s -m fast
  }

  # MySQL server {{{2
  msta() {
    p_start mysql MySQL mysql.server start
  }

  msto() {
    p_stop mysql MySQL mysql.server stop
  }

  mstat() {
    p_status mysql MySQL
  }

  # Redis server {{{2
  resta() {
    p_start redis "Redis daemon" redis_start
  }

  resto() {
    p_stop redis "Redis daemon" redis_stop
  }

  restat() {
    p_status redis "Redis daemon"
  }

  redis_start() {
    redis-server ~/.redis/redis.conf
    until running redis; do
      sleep 1
    done
    echo "Redis daemon spawned"
  }

  redis_stop() {
    kill "$(rpid redis)"
    while running redis; do
      sleep 1
    done
    echo "Redis daemon slain"
  }

  # Sidekiq {{{2
  sista() {
    p_start sidekiq "Sidekiq daemon" sidekiq_start
  }

  sksto() {
    p_stop sidekiq "Sidekiq daemon" sidekiq_stop
  }

  sistat() {
    p_status sidekiq "Sidekiq daemon"
  }

  sidekiq_start() {
    sidekiq -d
    until running sidekiq; do
      sleep 1
    done
    echo "Sidekiq daemaon spawned"
  }

  sidekiq_stop() {
    kill "$(rpid sidekiq)"
    while running sidekiq; do
      sleep 1
    done
    echo "Sidekiq daemon slain"
  }

  # Rails {{{2
  krs() {
    p_stop "rails s" "Rails server" rails_stop "server" "$1"
  }

  krs9() {
    krs '-9'
  }

  krc() {
    p_stop "rails c" "Rails console" rails_stop "console"
  }

  rastat() {
    p_status "rails s" "Rails server"
  }

  rastac() {
    p_status "rails c" "Rails console"
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

  # All servers {{{2
  asta() {
    msta && resta && sista
  }

  asto() {
    sksto && resto && msto
  }

  astat() {
    mstat && restat && sistat
  }

  astatt() {
    mstat && restat && sistat && rastat && rastac
  }

  astop() {
    krc && krs && sksto && resto && msto
  }

  # ssh tabs {{{2
  ssh() {
    echo -en "\033]0;$*\007"
    /usr/bin/ssh $@
  }

# ::::::::: Final Config and Plugins ::::::::: {{{1

  # History {{{2
    # Erase duplicates in history
      export HISTCONTROL=erasedups

    # Store 10k history entries
      export HISTSIZE=10000

    # Append to the history file when exiting instead of overwriting it
      shopt -s histappend

  # Case insensitive tab autocomplete {{{2
  bind "set completion-ignore-case on"

  # Git Bash Completion {{{2
  # Activate bash git completion if installed via homebrew
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi

  # Colors {{{2
    # grep
    export GREP_OPTIONS="--color"

    # Enable coloring in the terminal
    export CLICOLOR=1
    case "$THEME" in
      "dark")
        export LSCOLORS="GxBxBxDxBxEgEdxbxgxcxd";;
      *)
        export LSCOLORS="DxCxcxDxbxegedabagaced";;
    esac

    # Order of attributes:
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
    # Default is "exfxcxdxbxegedabagacad"

    # Color designators:
    # a black         A bold black (grey)
    # b red           B bold red
    # c green         C bold green
    # d brown         D bold brown (yellow)
    # e blue          E bold blue
    # f magenta       F bold magenta
    # g cyan          G bold cyan
    # h light grey    H bold light grey (white)
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
      # Default is "exfxcxdxbxegedabagacad"

    # Load .bash_colors if it exists
    if [ -f ~/.bash_colors.sh ]; then
      . ~/.bash_colors.sh
    fi

    # Color designators: {{{3
      # a black       A bold black (grey)
      # b red         B bold red
      # c green       C bold green
      # d brown       D bold brown (yellow)
      # e blue        E bold blue
      # f magenta     F bold magenta
      # g cyan        G bold cyan
      # h light grey  H bold light grey (white)
      # x default foreground or background

# ::::::::: Prompt ::::::::::::::::::::::::::: {{{1

    # Git prompt components
    minutes_since_last_commit() {
      now=`date +%s`
      last_commit=`git log --pretty=format:'%at' -1`
      seconds_since_last_commit=$((now-last_commit))
      minutes_since_last_commit=$((seconds_since_last_commit/60))
      echo $minutes_since_last_commit
    }
    grb_git_prompt() {
      local g="$(__gitdir)"
      if [ -n "$g" ]; then
        local MINUTES_SINCE_LAST_COMMIT=`minutes_since_last_commit`
        if [ "$MINUTES_SINCE_LAST_COMMIT" -gt 30 ]; then
          local COLOR=${RED}
        elif [ "$MINUTES_SINCE_LAST_COMMIT" -gt 10 ]; then
          local COLOR=${YELLOW}
        else
          local COLOR=${GREEN}
        fi
        local SINCE_LAST_COMMIT="${COLOR}$(minutes_since_last_commit)m${NORMAL}"
        # The __git_ps1 function inserts the current git branch where %s is
        local GIT_PROMPT=`__git_ps1 "($WHITE%s$NORMAL|${SINCE_LAST_COMMIT})"`
        echo ${GIT_PROMPT}
      fi
    }
    prompt_dark() {
      PS1="\[╭╺(${GREEN}\h${NORMAL}:${BLUE}\u${NORMAL}) ${BLUE}\W${NORMAL} \$(grb_git_prompt) ${NORMAL}\n╰╺⧉  "
    }
    # Build the prompt
    prompt_light() {
      # some chars for reference: <U+F8FF> ⧉ ℔ λ ⦔ Ω №  ✓

      export PS1="\[╭╺(${BLUE}\h${NORMAL}:${BLUE}\u${NORMAL}) ${BLUE}\w${RED}\$(__git_ps1)\[\e[m\n╰╺⧉  "
      export PS2="   > "
      export PS4="   + "
      }

    # Call the prompt function
    case "$THEME" in
      "dark")
        prompt_dark;;
      *)
        prompt_light;;
    esac


# ::::::::: RVM :::::::::::::::::::::::::::::: {{{1

  # Mandatory loading of RVM into the shell
  # This must be the last line of your bash_profile always

  [[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
