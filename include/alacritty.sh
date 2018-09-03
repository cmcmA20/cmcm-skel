#!/bin/sh

dep_list() {
  echo "git"
  echo "cmake"
  echo "pkg-config"
  echo "libfreetype6-dev"
  echo "libfontconfig1-dev"
  echo "rustc"
  echo "cargo"
}
package_install $(package_manager) $(dep_list)

alacritty_repo_dir="${repo_root}/alacritty.tmp"
git_clone "https://github.com/jwilm/alacritty.git" "${alacritty_repo_dir}"

(cd "${alacritty_repo_dir}" &&\
 cargo build --release &&\
 cargo install --force)
