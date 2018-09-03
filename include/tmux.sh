#!/bin/sh

dep_list() {
  echo "git"
  echo "gcc"
  echo "autoconf"
  echo "pkg-config"
  echo "libevent-dev"
  echo "libncurses5-dev"
}
package_install $(package_manager) $(dep_list)

tmux_repo_dir="${repo_root}/tmux.tmp"
git_clone "https://github.com/tmux/tmux.git" "${tmux_repo_dir}"

mkdir -p ${HOME}/.local
(cd "${tmux_repo_dir}" &&\
 sh autogen.sh &&\
 ./configure --prefix=${HOME}/.local &&\
 make &&\
 make install)
