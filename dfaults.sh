#!/bin/sh

# disable rubber-band scrolling
defaults write -g               NSScrollViewRubberbanding -int  0
defaults write com.apple.iTunes disable-elastic-scroll    -bool TRUE

# black-menus in full-screen
defaults write -g NSFullScreenDarkMenu -bool TRUE
