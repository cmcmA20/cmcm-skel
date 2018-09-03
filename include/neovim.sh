#!/bin/sh

dep_list() {
  echo "git"
  echo "gcc"
  echo "pkg-config"
  echo "cmake"
  echo "automake"
  echo "autotools-dev"
  echo "gettext"
  echo "unzip"
  echo "libtool-bin"
}
package_install $(package_manager) $(dep_list)

neovim_repo_dir="${repo_root}/neovim.tmp"
git_clone "https://github.com/neovim/neovim.git" "${neovim_repo_dir}"

mkdir -p ${HOME}/.local
(cd "${neovim_repo_dir}" &&\
 make CMAKE_BUILD_TYPE=RelWithDebInfo\
      CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=${HOME}/.local/" &&\
 make install)

nvim_dir=$(config_home)/nvim
mkdir -p "${nvim_dir}"
safe_symlink "${nvim_dir}" "${HOME}/.vim"
safe_symlink "${nvim_dir}/init.vim" "${HOME}/.vimrc"
