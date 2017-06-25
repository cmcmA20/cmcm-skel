umask 0022

if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

fc-cache -vf $HOME/.config/fontconfig/conf.d

export PAGER=`which less`
export EDITOR=`which vim`
export VISUAL=$EDITOR

SETXKBMAP_CMD=`which setxkbmap`
if [ x != x$SETXKBMAP_CMD ] ; then
    setxkbmap -layout "us,ru" -option "grp:rctrl_toggle"
fi
