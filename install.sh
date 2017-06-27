#!/usr/bin/env bash

PROGNAME=$(basename $0)
DEFAULT_REPO="https://github.com/callmecabman/cmcm-skel.git"

if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi

if [ -t 1 ] && [ -n "${ncolors}" ] && [ "${ncolors}" -ge 8 ]; then
  RED="$(tput setaf 1)"
  GREEN="$(tput setaf 2)"
  YELLOW="$(tput setaf 3)"
  BOLD="$(tput bold)"
  NORMAL="$(tput sgr0)"
else
  RED=""
  GREEN=""
  YELLOW=""
  BOLD=""
  NORMAL=""
fi

msg() { echo -e "${GREEN}--- $@${NORMAL}" 1>&2; }
warn() { echo -e "${YELLOW}${BOLD}--> $@${NORMAL}" 1>&2; }
err() { echo -e "${RED}${BOLD}*** $@${NORMAL}" 1>&2; }

config_home() {
  local cfg_home
  if [ -z ${XDG_CONFIG_HOME+x} ]; then
    cfg_home="${HOME}/.config"
  else
    cfg_home=${XDG_CONFIG_HOME}
  fi
  echo ${cfg_home}
  return 0
}

update_pull() {
  local repo_path=$1
  cd ${repo_path}
  if [ "$(git status -s)" ]; then
    ## Local repo has changes, prompt before overwriting them:
    read -p "Would you like to force a sync? THIS WILL REMOVE ANY LOCAL CHANGES!  [y/N]: " response
    case $response in
      [yY][eE][sS]|[yY])
        git reset --hard
      ;;
    esac
  fi
  git pull --rebase
  return $?
}

check_repo_change() {
  local REPO_PATH=$1
  local CS_DEST=$2
  local orig_repo

  orig_repo=$(cd $CS_DEST && git config --get remote.origin.url) || exit 1
  if test -z "$orig_repo" -o "$orig_repo" != $REPO_PATH
  then
    err "The source repository path [$REPO_PATH] does not match the"
    err "origin repository of the existing installation [$orig_repo]."
    err "Please remove the existing installation [$CS_DEST] and try again."
    exit 1
  fi
}

install() {
  local REPO_PATH=$1
  local CS_DEST=$2

  if [ -e ${CS_DEST} ]; then
    warn "Existing cmcm-skel installation detected at ${CS_DEST}."
  elif [ -e ${HOME}/.cmcm-skel ]; then
    warn "Old cmcm-skel installation detected."
    msg "Migrating existing installation to ${CS_DEST}..."
    mv -f ${HOME}/.cmcm-skel ${CS_DEST}
    mv -f ${HOME}/.vimrc.local ${CS_DEST}/vimrc.local
    mv -f ${HOME}/.vimrc.local.pre ${CS_DEST}/vimrc.local.pre
    sed -i.bak "s/Plugin '/Plug '/g" ${HOME}/.vim.local/bundles.vim
    mv -f ${HOME}/.vim.local/bundles.vim ${CS_DEST}/plugins.vim
    rm -f ${HOME}/.vim.local/bundles.vim.bak
    rmdir ${HOME}/.vim.local >/dev/null
  else
    warn "No previous installations detected."
    msg "Installing cmcm-skel from ${REPO_PATH} ..."
    mkdir -p $(config_home)
    git clone ${REPO_PATH} ${CS_DEST} || exit 1

    return 0
  fi

  check_repo_change ${REPO_PATH} ${CS_DEST}
  # Quick update to make sure we execute correct update procedure
  msg "Syncing cmcm-skel with upstream..."
  if ! update_pull ${CS_DEST} ; then
    err "Sync (git pull) failed. Aborting..."
    exit 1;
  fi
}

do_setup() {
  local CS_DEST=$1
  local setup_path=${CS_DEST}/scripts/setup.sh

  . $setup_path || { \
    err "Failed to source ${setup_path}."
    err "Have you cloned from the correct repository?"
    exit 1
  }

  setup_tools
  setup_vim $CS_DEST
  setup_done $CS_DEST
}

main() {
  local REPO_PATH=$1
  local CS_DEST="$(config_home)/cmcm-skel"
  local CS_DEPENDENCIES_DEST="$(config_home)/cmcm-skel"

  install $REPO_PATH $CS_DEST
  do_setup $CS_DEST
}

main $DEFAULT_REPO
