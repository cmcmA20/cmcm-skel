umask 0022

if [ -f "$HOME/.rc" ] ; then
  . "$HOME/.rc"
fi

if [ -d "$HOME/bin" ] ; then
  PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ] ; then
  PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/.cargo/bin" ] ; then
  PATH="$HOME/.cargo/bin:$PATH"
fi
if [ -d "$HOME/HOL/bin" ] ; then
  PATH="$HOME/HOL/bin:$PATH"
fi
if [ -d "$HOME/cakeml" ] ; then
  PATH="$HOME/cakeml:$PATH"
fi
if [ -e $HOME/.nix-profile/etc/profile.d/nix.sh ]; then
    . $HOME/.nix-profile/etc/profile.d/nix.sh;
fi
export PATH

if command -v more >/dev/null 2>&1 ; then
  PAGER='more'
fi
if command -v less >/dev/null 2>&1 ; then
  PAGER='less'
fi
export PAGER

if command -v vim >/dev/null 2>&1 ; then
  EDITOR='vim'
fi
if command -v nvim >/dev/null 2>&1 ; then
  EDITOR='nvim'
  nvim -R -U NONE -u NONE -c ":UpdateRemotePlugins" -c ":q"
fi
export EDITOR
if [ -n $EDITOR ] ; then
  export VISUAL=$EDITOR
fi

set -o vi
