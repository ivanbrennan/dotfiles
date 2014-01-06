# Load .bash_profile if it exists
if [ -f ~/.bash_profile ]; then
  source ~/.bash_profile
fi

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
