# bashrc for interactive shells

# bashrc is meant for non-login shells. It should not
# print any output, as that causes tools like scp fail.

# ::::::::: Environment Variables ::::::::::::

  # Theme {{{1

    if [ -z "$THEME" ]; then
      export THEME=light
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

