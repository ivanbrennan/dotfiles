# Source this after the key-bindings.bash that ships with fzf

[[ $- =~ i ]] || exit 0

# Restore bindings that fzf clobbered
bind '"\C-r": reverse-search-history'
bind '"\C-t": transpose-chars'
bind '"\et": transpose-words'

# Required to refresh the prompt after fzf
bind '"\eR": redraw-current-line'
bind '"\e^": history-expand-line'

# Alt-Space - Paste the selected file path into the command line
if [ $BASH_VERSINFO -gt 3 ]; then
    bind -x '"\e[32;2u": "fzf-file-widget"'
elif __fzf_use_tmux__; then
    bind '"\e[32;2u": " \C-u \C-a\C-k`__fzf_select_tmux__`\e\C-e\C-y\C-a\C-d\C-y\ey\C-h"'
else
    bind '"\e[32;2u": " \C-u \C-a\C-k`__fzf_select__`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\eR \C-h"'
fi

# ALT-R - Paste the selected command from history into the command line
bind '"\er": " \C-e\C-u`__fzf_history__`\e\C-e\e^\eR"'

# ALT-C - cd into the selected directory
bind '"\ec": " \C-e\C-u`__fzf_cd__`\e\C-e\eR\C-m"'
