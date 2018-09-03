#!/bin/sh

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
    git clone -q "${remote}" "${local_dir}"
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
