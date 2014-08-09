# Source / Edit bash_profile
alias sbs="source ~/.bash_profile"
alias vbs="vim ~/.bash_profile"
alias vbc="vim ~/.bashrc"
alias vba="vim ~/.bash_aliases"

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

# MV
alias mvv="mv -v"

# RM
alias rmi="rm -i"

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

# Servers
alias msta="mysql.server start"
alias msto="mysql.server stop"
alias redd="redis-server ~/.redis/redis.conf"
alias sidd="sidekiq -d"

# Commands
alias psg="ps aux | grep "
alias psr="ps aux | grep rails"
alias lsr="lsof -i :3000"
alias krs="kill $(lsof -i :3000 -t)"
alias krsk="kill -9 $(lsof -i :3000 -t)"
