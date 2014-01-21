#!bin/bash

# ::::::::: Prompt ::::::::::::::::::::::::::: {{{1

  # Output the active git branch
  function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
  }

  # Build the prompt
  function prompt {
    # some chars for reference:  ⧉ ℔ λ ⦔ Ω №  ✓
    # define some local colors
    local          RED="\[\033[0;31m\]"
    local    LIGHT_RED="\[\033[1;31m\]"
    local        BLACK="\[\033[0;30m\]"
    local        WHITE="\[\033[0;37m\]"
    local          OFF="\[\033[0m\]"

    export PS1="\[╭╺[\[\033[0;34m\]\u\[\033[0m\]][\[\033[0;34m\]\h\[\033[0m\]]\[\033[0;31m\]\$(parse_git_branch) \[\033[0;34m\]\w\[\e[0m\]\[\e[m\n╰╺⧉\[\033[0m\]  "
    export PS2="   > "
    export PS4='   + '
    }

  # Call the prompt function
  prompt

  # For more prompt coolness, check out Halloween Bash:
  # http://xta.github.io/HalloweenBash/

# ::::::::: Environment Variables :::::::::::: {{{1

  # Library Paths {{{2

    # These variables tell your shell where they can find certain
    # required libraries so other programs can reliably call the
    # variable name instead of a hardcoded path.

    # NODE_PATH
    # Node Path from Homebrew I believe
    export NODE_PATH="/usr/local/lib/node_modules:$NODE_PATH"

    # This is deprecated!
    # PYTHON_SHARE
    # Python Shared Path from Homebrew I believe
    #export PYTHON_SHARE='/usr/local/share/python'

    # Those NODE & Python Paths won't break anything even if you
    # don't have NODE or Python installed. Eventually you will and
    # then you don't have to update your bash_profile

  # Configurations {{{2

    # GIT_MERGE_AUTO_EDIT
    # This variable configures git to not require a message when you merge.
    export GIT_MERGE_AUTOEDIT='no'

    # Editors - MacVim 7.4 option
    # Tells your shell that when a program requires various editors, use MacVim.
    # The -w flag tells your shell to wait until sublime exits
    export VISUAL="mvim -f"
    export SVN_EDITOR="mvim -f"
    export GIT_EDITOR="mvim -f"
    export EDITOR="mvim -f"

    # Editors - Sublime option
    # Tells your shell that when a program requires various editors, use sublime.
    # The -w flag tells your shell to wait until sublime exits
    # export VISUAL="subl -w"
    # export SVN_EDITOR="subl -w"
    # export GIT_EDITOR="subl -w"
    # export EDITOR="subl -w"

  # Paths {{{2

    # USR_PATHS {{{3
    # The USR_PATHS variable will just store all relevant /usr paths for easier usage
    # Each path is seperate via a ":" and we always use absolute paths.

    # A bit about the /usr directory
    # The /usr directory is a convention from linux that creates a common place to put
    # files and executables that the entire system needs access too. It tries to be user
    # independent, so whichever user is logged in should have permissions to the /usr directory.
    # We call that /usr/local. Within /usr/local, there is a bin directory for actually
    # storing the binaries (programs) that our system would want.
    # Also, Homebrew adopts this convetion so things installed via Homebrew
    # get symlinked into /usr/local

    export USR_PATHS="/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin"

    # We build our final PATH by combining the variables defined above
    # along with any previous values in the PATH variable.

    # Our PATH variable is special and very important. Whenever we type a command into our shell,
    # it will try to find that command within a directory that is defined in our PATH.

    # This is deprecated!
    # Read http://blog.seldomatt.com/blog/2012/10/08/bash-and-the-one-true-path/ for more on that.
    #export PATH="$USR_PATHS:$PYTHON_SHARE:$PATH"

    # CDPATH {{{3
    # DON'T EXPORT THIS, as it can screw up scripts.
    # Quickly navigate to certain directories in the interactive shell.
    CDPATH=".:~/Development:~"

# ::::::::: Functions :::::::::::::::::::::::: {{{1

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

  # cd into the desktop from anywhere {{{2
  # USE: desktop subfolder
  function desktop {
    cd /Users/$USER/Desktop/$@
  }

  # Easily grep for a matching process {{{2
  # Is this any different from pgrep?
  # USE: psg postgres
  function psg {
    FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
    REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
    ps aux | grep "[$FIRST]$REST"
  }

  # Extract archive based on extension {{{2
  # USE: extract imazip.zip
  #      extract imatar.tar
  function extract () {
      if [ -f $1 ]; then
          case $1 in
              *.tar.bz2)  tar xjf $1      ;;
              *.tar.gz)   tar xzf $1      ;;
              *.bz2)      bunzip2 $1      ;;
              *.rar)      rar x $1        ;;
              *.gz)       gunzip $1       ;;
              *.tar)      tar xf $1       ;;
              *.tbz2)     tar xjf $1      ;;
              *.tgz)      tar xzf $1      ;;
              *.zip)      unzip $1        ;;
              *.Z)        uncompress $1   ;;
              *)          echo "'$1' cannot be extracted via extract()" ;;
          esac
      else
          echo "'$1' is not a valid file"
      fi
  }

  # Easily grep for a matching file {{{2
  # USE: lg filename
  function lg {
  FIRST=`echo $1 | sed -e 's/^\(.\).*/\1/'`
  REST=`echo $1 | sed -e 's/^.\(.*\)/\1/'`
  ls -la | grep "[$FIRST]$REST"
  }

  # Compress PDF with Ghostscript
  # USE: ghost filename
  function ghost () {
    gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile="compressed-$1" "$1"
  }

# ::::::::: Aliases :::::::::::::::::::::::::: {{{1

  # Source bash_aliases
  if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
  fi

# ::::::::: Final Config and Plugins ::::::::: {{{1

  # Git Bash Completion {{{2
  # Activate bash git completion if installed via homebrew
  if [ -f `brew --prefix`/etc/bash_completion ]; then
    . `brew --prefix`/etc/bash_completion
  fi

  # PATH {{{2
    # This is working
    export PATH=/usr/local/bin:/Users/ivan/.rvm/bin:$PATH

    # Would this be better? (Note: USR_PATHS="/usr/local:/usr/local/bin:/usr/local/sbin:/usr/bin")
    #export PATH="$USR_PATHS:$PATH"

  # Case insensitive tab autocomplete
  bind "set completion-ignore-case on"

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
