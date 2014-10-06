if ! tmux has-session -t hb-dev 2>/dev/null
then
  tmux new-session -d -s hb-dev   -n vim     -c ~/Development/code/handybook
  tmux new-window     -t hb-dev:8 -n console -c ~/Development/code/handybook
  tmux new-window     -t hb-dev:9 -n shell   -c ~/Development/code/handybook

  tmux select-window  -t hb-dev:0
fi
tmux attach-session -t hb-dev
