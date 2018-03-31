dotfiles
========

.dotfiles and configuration options

### Install

``` Shell
git clone git@github.com:ivanbrennan/dotfiles.git
cd dotfiles && bash install.sh
```

#### lesskey
compile lesskey to a user location:
``` sh
lesskey --output=$HOME/.less -- ./lesskey
```

compile lesskey to a system-wide location:
``` sh
sudo lesskey --output=/etc/sysless -- ./lesskey

[![Bash History Filter](/shell/bash_history_filter_awk.png?raw=true)](/shell/bash_history_filter.awk)
