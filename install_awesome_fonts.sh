#!/bin/sh

set -e

cd ~/Library/Fonts
for font in all-the-icons \
            file-icons    \
            fontawesome   \
            octicons      \
            weathericons
do
  if [ ! -e "${font}.ttf" ]; then
    curl -O "https://raw.githubusercontent.com/domtronn/all-the-icons.el/master/fonts/${font}.ttf"
  fi
done
