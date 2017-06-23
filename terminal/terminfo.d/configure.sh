dir=$HOME/Development/resources/dotfiles/terminal/terminfo.d
files=( tmux.terminfo
        tmux-256color.terminfo
        xterm-256color.terminfo )

for file in "$files"; do
  tic -o $dir/terminfo $dir/$file
done

ln -svhF $dir/terminfo $HOME/.terminfo
