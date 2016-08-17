# bashrc for interactive shells

# bashrc is meant for non-login shells. It should not
# print any output, as that causes tools like scp fail.

# ::::::::: Environment Variables ::::::::::::

  # Theme {{{1

  if [ -z "$THEME" ]; then
    case "$ITERM_PROFILE" in
      'black'  ) export THEME=dark   ;;
      'remote' ) export THEME=remote ;;
      *        ) export THEME=light  ;;
    esac
  fi

  # Year {{{1

  current_year=$(date +'%Y')
  export YEAR=$current_year

  # Library Paths {{{1

    # These variables tell your shell where they can find certain
    # required libraries so other programs can reliably call the
    # variable name instead of a hardcoded path.

    # NODE_PATH from Homebrew I believe
    export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"

  # Configurations {{{1

    # GIT_MERGE_AUTO_EDIT
    # This variable configures git to not require a message when you merge.
    export GIT_MERGE_AUTOEDIT="no"

    # Editors
    NVIM_TRUE_COLOR="NVIM_TUI_ENABLE_TRUE_COLOR=1 nvim"
    export VISUAL=$NVIM_TRUE_COLOR
    export GIT_EDITOR=$NVIM_TRUE_COLOR
    export SVN_EDITOR=$NVIM_TRUE_COLOR

  # Paths {{{1

    # USR_PATHS {{{2

      # The USR_PATHS variable will store all relevant /usr paths for easier usage
      # Each path is seperate via a ":" and we always use absolute paths.

      # A bit about the /usr directory
      # The /usr directory is a convention from linux that creates a common place to put
      # files and executables that the entire system needs access too. It tries to be user
      # independent, so whichever user is logged in should have permissions to the /usr directory.
      # We call that /usr/local. Within /usr/local, there is a bin directory for actually
      # storing the binaries (programs) that our system would want.
      # Homebrew adopts this convetion so things installed via Homebrew
      # get symlinked into /usr/local

      export USR_PATHS="/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin"

      # We build our final PATH by combining the variables defined above
      # along with any previous values in the PATH variable.

    # CDPATH {{{2

      # DON'T EXPORT THIS, as it can screw up scripts.
      CDPATH=".:~/Development:~/Development/resources:~"

    # PATH {{{2

      export PATH="$USR_PATHS:$PATH"

      ### Added by the Heroku Toolbelt
      export PATH="/usr/local/heroku/bin:$PATH"

# ::::::::: Bash Completion ::::::::::::::::::

  # Case insensitive tab autocomplete {{{1
  bind "set completion-ignore-case on"

  # Git Bash Completion {{{1
  # Activate bash git completion if installed via homebrew
  if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
  fi

  # Colors {{{1
    # grep
    export GREP_OPTIONS="--color"

    # Enable coloring in the terminal
    export CLICOLOR=1
    export LSCOLORS="exgxcxdxbxegedabagacad"

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


    # Order of attributes: {{{2
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

    # Source .bash_colors if it exists
    if [ -f ~/.bash_colors.sh ]; then
      . ~/.bash_colors.sh
    fi

    # Color designators: {{{2
      # a black       A bold black (grey)
      # b red         B bold red
      # c green       C bold green
      # d brown       D bold brown (yellow)
      # e blue        E bold blue
      # f magenta     F bold magenta
      # g cyan        G bold cyan
      # h light grey  H bold light grey (white)
      # x default foreground or background

# ::::::::: Prompt :::::::::::::::::::::::::::

  # Git prompt components: {{{1
  minutes_since_last_commit() {
    local now
    local last_commit
    now=`date +%s`
    last_commit=`git log --pretty=format:'%at' -1 2>/dev/null`

    if [ "$?" -eq 0 ]; then
      local seconds_since_last_commit
      local minutes_since_last_commit
      seconds_since_last_commit=$((now-last_commit))
      minutes_since_last_commit=$((seconds_since_last_commit/60))
      echo $minutes_since_last_commit
    fi
  }

  minutes_color() {
    if [ -z "$1" ]; then
      return
    elif [[ "$1" -gt 30 ]]; then
      echo "${RED}"
    elif [[  "$1" -gt 10  ]]; then
      echo "${YELLOW}"
    else
      echo "${GREEN}"
    fi
  }

  grb_git_prompt() {
    local g
    g="$(__gitdir)"

    if [ -n "$g" ]; then
      local COLOR
      local MINUTES_SINCE_LAST_COMMIT

      COLOR=`hi_color`
      MINUTES_SINCE_LAST_COMMIT=`minutes_since_last_commit`

      if [ -n "$MINUTES_SINCE_LAST_COMMIT" ]; then
        local SINCE_LAST_COMMIT
        COLOR=`minutes_color MINUTES_SINCE_LAST_COMMIT`
        SINCE_LAST_COMMIT=" ${COLOR}$(minutes_since_last_commit)m${NORMAL}"
      fi
      # The __git_ps1 function inserts the current git branch where %s is
      local GIT_PROMPT
      GIT_PROMPT=`__git_ps1 "(${COLOR}%s$NORMAL)"`
      echo ${GIT_PROMPT}
    fi
  }

  # ℣ ℒ ∮ ֆ လ  ჶ Ꭶ ဝ ⬭ ⱇ ⬲
  # Build the prompt: {{{1
  build_prompt() {
    export PS1="╭-${BRIGHT_BLUE}\u${NORMAL}·${BRIGHT_BLUE}\W${NORMAL} \$(grb_git_prompt) ${NORMAL}\n╰ဝ "
    export PS2="quote ❯ "
    export PS4="   + "
    }

    hi_color() {
      if [[ "$THEME" =~ dark ]]; then
        echo $WHITE
      else
        echo $BLACK
      fi
    }

  # Call the prompt function
  build_prompt
