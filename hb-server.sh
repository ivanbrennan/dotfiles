if ! tmux has-session -t hb-server 2>/dev/null
then
  tmux new-session -d -s hb-server   -n shell   -c ~/Development/code/handybook
  tmux new-window     -t hb-server:1 -n view    -c ~/Development/code/handybook
  tmux new-window     -t hb-server:8 -n server  -c ~/Development/code/handybook
  tmux new-window     -t hb-server:9 -n ssh     -c ~/Development/code/handybook

  tmux select-window  -t hb-server:0
fi
tmux attach-session -t hb-server
