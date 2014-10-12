# Source / Edit bash_profile
alias sbs=". ~/.bash_profile"

alias vi="vim"
alias vbs="vim ~/.bash_profile"
alias vbc="vim ~/.bashrc"
alias vba="vim ~/.bash_aliases"
alias vmx="vim ~/.tmux.conf"

# Edit vimrc
alias vmc="vim ~/.vimrc"

# Edit screenrc
alias vsc="vim ~/.screenrc"
alias vhb="vim ~/.screenhb"

# LS
alias l="ls -lAh"

# CD
alias cd..="cd .."
alias cd-="cd -"
alias code="cd ~/Development/code"
alias dots="cd ~/Development/resources/dotfiles"
alias vims="cd ~/.vim"
alias cellar="cd /usr/local/Cellar"
alias desk="cd ~/Desktop"
alias hb="cd ~/Development/code/handybook"

# Screen
alias sls="screen -ls"
alias sr="screen -r"
alias hb="cd ~/Development/code/handybook && screen -S handybook -c ~/.screenhb"
alias ng="cd ~/Development/code/angular-phonecat && screen -S angular -c ~/.screenng"

# tmux
alias mx="tmux"
alias mxl="tmux ls"
alias mxs="tmux new-session -s"
alias mxa="tmux attach-session -t"

# MV
alias mvv="mv -v"

# RM
alias rmi="rm -i"

# Rails
alias grails="ps aux | grep '[r]ails'"

# Open Downloads in Finder
alias dld="open ~/Downloads"

# Git
alias gst="git status"
