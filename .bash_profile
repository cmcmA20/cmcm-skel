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

PAGER=`which less`
if [ $? == 0 ] ; then
  export PAGER
fi
EDITOR=`which vim`
if [ $? == 0 ] ; then
  export EDITOR
fi
if [ -n $EDITOR ] ; then
  export VISUAL=$EDITOR
fi

SETXKBMAP_CMD=`which setxkbmap`
if [ $? != 0 ] ; then
  setxkbmap -layout "us,ru" -option "grp:rctrl_toggle"
fi
