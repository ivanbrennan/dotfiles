# Source / Edit bash_profile
alias sbs="source ~/.bash_profile"
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
alias dots="cd ~/Development/resources/dotfiles"
alias vims="cd ~/.vim"
alias cellar="cd /usr/local/Cellar"
alias desk="cd ~/Desktop"
alias hand="cd ~/Development/code/handybook"

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
alias gl="git pull"
alias gp="git push"
alias gd="git diff | mate"
alias gc="git commit -v"
alias gca="git commit -v -a"
alias gb="git branch"
alias gba="git branch -a"
alias ga="git log --graph"
