dotfiles
========

.dotfiles and configuration options

## Install

### Prerequisites

#### Run install script

```sh
bash -c \
     "$(curl -fsSL -H 'Accept: application/vnd.github-blob.raw' \
       'https://api.github.com/repos/ivanbrennan/dotfiles/contents/install/base-install.sh')" \
     'base-install.sh' \
     --branch master \
     --github-host github.com

```

#### Disable Control-Command-D macOS lookup key
```
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 70 '<dict><key>enabled</key><false/></dict>'
```
