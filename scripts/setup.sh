#!/usr/bin/env bash

SCRIPT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
. ${SCRIPT_DIR}/func.sh

# Print package name to install if command is not found
# $1: command name
# $2: package name
cmdpkg() {
  test -n "$(which $1)" || echo "$2"
}

# $1: package manager
package_list() {
  cmdpkg git git
  cmdpkg vim vim
  cmdpkg tmux tmux

  case $1 in
    BREW)
      cmdpkg make homebrew/dupes/make
      cmdpkg ctags ctags
      cmdpkg par par ;;
    PORT)
      cmdpkg make gmake
      cmdpkg ctags ctags
      cmdpkg par par ;;
    APT)
      cmdpkg make make
      cmdpkg ctags exuberant-ctags
      cmdpkg par par
      cmdpkg curl curl
      echo libcurl4-openssl-dev ;;
    YUM|DNF)
      cmdpkg make make
      cmdpkg ctags ctags
      cmdpkg par par
      echo "libcurl-devel zlib-devel powerline" ;;
  esac
}

setup_tools() {
  # Installs _only if_ the command is not available
  local PACKAGE_MGR=$(package_manager)
  package_install ${PACKAGE_MGR} $(package_list ${PACKAGE_MGR})

  local NOT_INSTALLED=$(check_exist ctags curl curl-config git make vim par tmux)
  [ ! -z "${NOT_INSTALLED}" ] && exit_err "Installer requires '${NOT_INSTALLED}'. Please install and try again."

  msg "Checking ctags' exuberance..."
  local RETCODE
  ctags --version | grep -q Exuberant ; RETCODE=$?
  [ ${RETCODE} -ne 0 ] && exit_err "Requires exuberant-ctags, not just ctags. Please install and put it in your PATH."

  msg "Setting git to use fully-pathed vim for messages..."
  git config --global core.editor $(which vim)
}

vim_check_version() {
  local VIM_VER=$(vim --version | sed -n 's/^.*IMproved \([^ ]*\).*$/\1/p')
  if ! verlte '7.4' ${VIM_VER} ; then
    exit_err "Detected vim version \"${VIM_VER}\", however version 7.4 or later is required."
  fi

  if vim --version | grep -q +ruby 2>&1 ; then
    msg "Testing for broken Ruby interface in vim..."
    vim -T dumb --cmd "ruby puts RUBY_VERSION" --cmd qa! 1>/dev/null 2>/dev/null
    if [ $? -eq 0 ] ; then
      msg "Test passed. Ruby interface is OK."
    else
      err "The Ruby interface is broken on your installation of vim."
      err "Reinstall or recompile vim."
      msg "If you're on OS X, try the following:"
      detail "rvm use system"
      detail "brew reinstall vim"
      warn "If nothing helped, please report at https://github.com/begriffs/haskell-vim-now/issues"
      exit 1
    fi
  fi
}

vim_backup () {
  local CS_DEST=$1

  if [ -e ~/.vim/colors ]; then
    msg "Preserving color scheme files..."
    cp -R ~/.vim/colors ${CS_DEST}/colors
  fi

  today=`date +%Y%m%d_%H%M%S`
  msg "Backing up current vim config using timestamp ${today}..."
  [ ! -e ${CS_DEST}/backup ] && mkdir ${CS_DEST}/backup

  for i in .vim .vimrc .gvimrc; do [ -e ${HOME}/${i} ] && mv ${HOME}/${i} ${CS_DEST}/backup/${i}.${today} && detail "${CS_DEST}/backup/${i}.${today}"; done
}

vim_setup_links() {
  local CS_DEST=$1

  msg "Creating vim config symlinks"
  detail "~/.vimrc -> ${CS_DEST}/.vimrc"
  ln -sf ${CS_DEST}/.vimrc ${HOME}/.vimrc

  detail "~/.vim   -> ${CS_DEST}/.vim"
  ln -sf ${CS_DEST}/.vim ${HOME}/.vim
}

vim_install_plug() {
  local CS_DEST=$1

  if [ ! -e ${CS_DEST}/.vim/autoload/plug.vim ]; then
    msg "Installing vim-plug"
    curl -fLo ${CS_DEST}/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim \
      || exit_err_report "Failed to install vim-plug."
  fi
}

vim_install_plugins() {
  msg "Installing plugins using vim-plug..."
  vim -E -u ${CS_DEST}/.vimrc +PlugUpgrade +PlugUpdate +PlugClean! +qall
}

setup_vim() {
  local CS_DEST=$1

  vim_check_version
  vim_install_plug $CS_DEST

  # Point of no return; we cannot fail after this.
  # Backup old config and switch to new config
  vim_backup          $CS_DEST
  vim_setup_links     $CS_DEST
  vim_install_plugins $CS_DEST
}

setup_skel() {
  local CS_DEST=$1

  msg "Copying profile files"
  cp -f $CS_DEST/.bashrc       $HOME/.bashrc
  cp -f $CS_DEST/.bash_profile $HOME/.bash_profile
  cp -f $CS_DEST/.bash_aliases $HOME/.bash_aliases
  cp -f $CS_DEST/.tmux.conf    $HOME/.tmux.conf
}

setup_fonts() {
  local CS_DEST=$1

  msg "Installing Powerline fonts"
  curl -ssL https://github.com/powerline/powerline/raw/develop/font/PowerlineSymbols.otf > $CS_DEST/PowerlineSymbols.otf
  FONTS_EC=$?
  curl -ssL https://github.com/powerline/powerline/raw/develop/font/10-powerline-symbols.conf > $CS_DEST/10-powerline-symbols.conf
  FCONF_EC=$?
  if [ $FONTS_EC != 0 ] || [ $FCONF_EC != 0 ]; then
    err "Powerline fonts download failed"
    return 1
  fi

  mkdir -p $HOME/.fonts
  mv -f $CS_DEST/PowerlineSymbols.otf $HOME/.fonts/PowerlineSymbols.otf
  fc-cache -vf $HOME/.fonts/

  mkdir -p $HOME/.config/fontconfig/conf.d
  mv -f $CS_DEST/10-powerline-symbols.conf $HOME/.config/fontconfig/conf.d/10-powerline-symbols.conf
}

setup_done() {
  local CS_DEST=$1

  echo -e "\n"
  msg "<---- cmcm-skel installation successfully finished ---->"
  echo -e "\n"
}
