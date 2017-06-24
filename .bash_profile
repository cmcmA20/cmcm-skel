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

export PAGER=`which less`
export EDITOR=`which vim`
export VISUAL=$EDITOR
