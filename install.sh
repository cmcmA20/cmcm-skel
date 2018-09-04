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

# FUNCTIONS START
config_home_path() {
  local cfg_home
  if [ -z ${XDG_CONFIG_HOME+x} ] ; then
    cfg_home="${HOME}/.config"
  else
    cfg_home=${XDG_CONFIG_HOME}
  fi
  echo ${cfg_home}
}

repo_root_path() {
  local r_root
  if [ -z ${repo_root+x} ] ; then
    r_root="${HOME}/cmcm-skel"
  else
    r_root="${repo_root}"
  fi
  echo ${r_root}
}

backup_root_path() {
  local bkp_root="$(repo_root_path)/backup"
  echo ${bkp_root}
}

package_manager() {
  local pkg_mgr
  if command -v apt-get >/dev/null 2>&1 ; then
    pkg_mgr="APT"
  elif command -v dnf >/dev/null 2>&1 ; then
    pkg_mgr="DNF"
  elif command -v yum >/dev/null 2>&1 ; then
    pkg_mgr="YUM"
  else
    pkg_mgr="OTHER"
  fi
  echo ${pkg_mgr}
}

package_install() {
  local pkg_mgr=$1; shift
  if [ $# -eq 0 ] ; then
    echo "No packages to install."
    return
  fi
  echo "Installing packages [$*] using [$pkg_mgr]..."
  case ${pkg_mgr} in
    APT )
      sudo apt-get install --no-upgrade -y $*
      ;;
    DNF )
      sudo dnf install -yq $*
      ;;
    YUM )
      sudo yum install -yq $*
      ;;
    OTHER )
      echo "Unknown package manager. Install the packages manually."
      exit 1
  esac
}

git_clone() {
  local remote=$1
  local local_dir=$2
  if [ -d "${local_dir}/.git" ] ; then
    (cd "${local_dir}" &&\
     git reset --hard -q &&\
     git clean --force -d -q &&\
     git pull --rebase -q)
  else
    rm -rf "${local_dir}"
    mkdir -p "${local_dir}"
    git clone --depth 1 -q "${remote}" "${local_dir}"
  fi
}

home_backup() {
  local backup_root=$(backup_root_path)
  local target=$1
  local backup=${backup_root}/$(echo ${target} | sed "s;${HOME}/;;")
  mkdir -p "$(dirname ${backup})"
  if [ -e "${backup}" ] ; then
    return
  fi
  mv -f "${target}" "${backup}"
}

safe_symlink() {
  local backup_root=$(backup_root_path)
  local source=$1
  local target=$2
  if [ -e "${target}" ] ; then
    home_backup "${target}"
  fi
  ln -fs "${source}" "${target}"
}

safe_copy() {
  local backup_root=$(backup_root_path)
  local source=$1
  local target=$2
  if [ -e "${target}" ] ; then
    home_backup "${target}"
  fi
  cp -Rf "${source}" "${target}"
}
# FUNCTIONS END

dep_list() {
  echo "git"
}
package_install $(package_manager) $(dep_list)

git_clone "https://github.com/callmecabman/cmcm-skel.git" "${repo_root}"

OPTIND=1
while getopts ":hdatnp" opt; do
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

