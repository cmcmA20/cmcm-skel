#!/bin/sh

#repo_root=
#x11=yes

whoami=$(readlink -f $0)
whereami=$(dirname ${whoami})
if [ -z "${repo_root}" ] ; then
  repo_root=${whereami}
fi
include_dir=${repo_root}/include
backup_root=${repo_root}/backup

. ${include_dir}/functions.sh

dep_list() {
  echo "git"
}
package_install $(package_manager) $(dep_list)

git_clone "https://github.com/callmecabman/cmcm-skel.git" "${repo_root}"

OPTIND=1
while getopts "hdatnp:" opt; do
  case "$opt" in
  h)
    echo "${whoami}\n"\
         "-h\t\thelp\n"\
         "-d\t\tdotfiles\n"\
         "-a\t\talacritty\n"\
         "-t\t\ttmux\n"\
         "-n\t\tneovim\n"\
         "-p\t\tvim plugins\n"
    exit 0
    ;;
  d)
    safe_copy "${repo_root}/.aliases" "${HOME}/.aliases"
    safe_copy "${repo_root}/.profile" "${HOME}/.profile"
    safe_copy "${repo_root}/.rc" "${HOME}/.rc"
    safe_symlink "${HOME}/.rc" "${HOME}/.bashrc"
    safe_symlink "${HOME}/.rc" "${HOME}/.zshrc"
    safe_copy "${repo_root}/.tmux.conf" "${HOME}/.tmux.conf"
    if [ x"$x11" == "xyes" ] ; then
      safe_copy "${repo_root}/.xsessionrc" "${HOME}/.xsessionrc"
    fi
    ;;
  a)
    . ${include_dir}/alacritty.sh
    ;;
  t)
    . ${include_dir}/tmux.sh
    ;;
  n)
    . ${include_dir}/neovim.sh
    ;;
  p)
    . ${include_dir}/vim-plugins.sh
    ;;
  esac
done

