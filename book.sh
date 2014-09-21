if ! tmux has-session -t book 2>/dev/null
then
  tmux new-session -d -s book   -n git     -c ~/Development/code/handybook

  tmux new-window     -t book:5 -n shell   -c ~/Development/code/handybook
  tmux new-window     -t book:6 -n server  -c ~/Development/code/handybook
  tmux new-window     -t book:7 -n console -c ~/Development/code/handybook
  tmux new-window     -t book:8 -n tests   -c ~/Development/code/handybook
  tmux new-window     -t book:9 -n vim     -c ~/Development/code/handybook

  tmux select-window  -t book:0
fi
tmux attach-session -t book
