#!/bin/sh

# Source / Edit bash_profile
alias sbs=". ~/.bash_profile"

# Git
alias gst="git status"
alias gasp="git add -p db/schema.rb"
alias gpr="git log origin/master.. --reverse"
alias gpc="git log origin/master.. -- | wc -l"

# iOS Simulator
alias simulator='open /Applications/Xcode.app/Contents/Developer/Applications/iOS\ Simulator.app'

# LS
alias l="CLICOLOR_FORCE=1 ls -lAh"
alias lsa="CLICOLOR_FORCE=1 ls -A"
alias lsf="CLICOLOR_FORCE=1 ls -F"

# LESS
alias lessr="less -R"

# MV
alias mvv="mv -v"

# RM
alias rmi="rm -i"

# Vim
alias nvim="NVIM_TUI_ENABLE_TRUE_COLOR=1 nvim"
alias vi="nvim"
alias view="nvim -MR"

# GDB
alias gdb="gdb -quiet"

