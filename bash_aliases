#!/bin/sh

# Source / Edit bash_profile
alias sbs=". ~/.bash_profile"

# Git
alias gst="git status"
alias gpr="git log origin/master.. --reverse"
alias gpt="git log origin/master.. --reverse --pretty='[\`%h\`](https://github.com/Handybook/handybook/commit/%H) %s'"
alias gpp="git log origin/master.. --reverse -p"
alias gpc="git log origin/master.. -- | wc -l"

# iOS Simulator
alias simulator='open /Applications/Xcode.app/Contents/Developer/Applications/iOS\ Simulator.app'

# LS
alias l="CLICOLOR_FORCE=1 ls -lAh"
alias lsa="CLICOLOR_FORCE=1 ls -A"
alias lsf="CLICOLOR_FORCE=1 ls -F"

# LESS
alias lessr="less -R"

# -iv
alias cp="cp -iv"
alias rm="rm -iv"
alias mv="mv -iv"

# Vim
alias nvim="NVIM_TUI_ENABLE_TRUE_COLOR=1 nvim"
alias vi="nvim"
alias view="nvim -MR"

# GDB
alias gdb="gdb -quiet"

