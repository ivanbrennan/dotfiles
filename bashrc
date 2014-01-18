# Load .bash_profile if it exists
if [ -f ~/.bash_profile ]; then
  . ~/.bash_profile
fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
