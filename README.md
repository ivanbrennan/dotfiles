dotfiles
========

.dotfiles and configuration options

### Install

``` Shell
git clone git@github.com:ivanbrennan/dotfiles.git
cd dotfiles && bash install.sh
```

#### Disable Control-Command-D macOS lookup key
```
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 70 '<dict><key>enabled</key><false/></dict>'
```
