formulae=(
  aspell
  bash
  bash-completion@2
  cask
  cmake
  coreutils
  git
  gnutls
  graphviz
  imagemagick
  jq
  less
  multimarkdown
  mysql
  nginx
  node
  openssl
  par
  pcre
  postgresql
  python
  python3
  rbenv
  readline
  reattach-to-user-namespace
  redis
  ruby-build
  screen
  sqlite
  ssh-copy-id
  the_silver_searcher
  tmux
  tree
  v8
)
for f in formulae; do
  brew install $f
done

## Custom formulae

# vim
brew install vim               \
     --with-override-system-vi \
     --with-custom-perl        \
     --with-custom-ruby

# emacs-mac
brew tap railwaycat/emacsmacport
brew install emacs-mac --with-spacemacs-icon

# neovim
brew tap neovim/neovim
brew install neovim

# ctags
brew tap universal-ctags/universal-ctags
brew install --HEAD universal-ctags

# global https://github.com/Homebrew/homebrew-core/pull/8309
cd $(brew --repo homebrew/core)
git remote add ivanbrennan git@github.com:ivanbrennan/homebrew-core.git
git checkout global-with-universal-ctags
brew install global --with-universal-ctags
git checkout master
cd -

# valgrind https://stackoverflow.com/a/43431715/1631106
