# ::::::::: Colors ::::::::::::::::::::::::::: {{{1
  export LSCOLORS="BxGxBxDxBxEgEdxbxgxcxd"

# ::::::::: Prompt ::::::::::::::::::::::::::: {{{1
  # Git prompt components
  function minutes_since_last_commit {
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
  prompt() {
    PS1="($BLUE\h$NORMAL:$BLUE\u$NORMAL) $BLUE\W$NORMAL\$(grb_git_prompt) ${WHITE}⧉$NORMAL "
  }
  prompt

# ::::::::: Vim :::::::::::::::::::::::::::::: {{{1
ln -sf ~/Development/resources/vim/vimrc_dark.vim ~/.vimrc
