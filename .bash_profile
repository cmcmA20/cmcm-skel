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

if command -v less >/dev/null 2>&1 ; then
  export PAGER='less'
fi
if command -v vim >/dev/null 2>&1 ; then
  export EDITOR
fi
if [ -n $EDITOR ] ; then
  export VISUAL=$EDITOR
fi

if command -v setxkbmap >/dev/null 2>&1 ; then
  setxkbmap -layout "us,ru" -option "grp:rctrl_toggle"
fi
