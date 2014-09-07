tmux new-session -d         -s book   -c ~/Development/code/handybook

tmux new-window  -n server  -t book:5 -c ~/Development/code/handybook
tmux new-window  -n git     -t book:6 -c ~/Development/code/handybook
tmux new-window  -n console -t book:7 -c ~/Development/code/handybook
tmux new-window  -n tests   -t book:8 -c ~/Development/code/handybook
tmux new-window  -n vim     -t book:9 -c ~/Development/code/handybook

tmux attach-session         -t book
