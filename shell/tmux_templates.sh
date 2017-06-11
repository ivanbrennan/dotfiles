#!/bin/sh

hdv() {
  if ! tmux has-session -t hb-dev 2>/dev/null
  then
    tmux new-session -d -s hb-dev   -n shell   -c ~/Development/code/handy/handybook
    tmux new-window     -t hb-dev:9 -n vim     -c ~/Development/code/handy/handybook

    tmux select-window  -t hb-dev:9
  fi
  tmux attach-session -t hb-dev
}

hsv() {
  if ! tmux has-session -t hb-server 2>/dev/null
  then
    tmux new-session -d -s hb-server   -n shell   -c ~/Development/code/handy/handybook
    tmux new-window     -t hb-server:7 -n tests   -c ~/Development/code/handy/handybook
    tmux new-window     -t hb-server:8 -n console -c ~/Development/code/handy/handybook
    tmux new-window     -t hb-server:9 -n server  -c ~/Development/code/handy/handybook

    tmux select-window  -t hb-server:0
  fi
  tmux attach-session -t hb-server
}
