#!/bin/sh

dep_list() {
  echo "git"
  echo "curl"
}
package_install $(package_manager) $(dep_list)

stack_tmp_dir="${repo_root}/stack.tmp"
mkdir -p "${stack_tmp_dir}"

stack_install_script="${stack_tmp_dir}/stack.sh"
curl -sSL "https://get.haskellstack.org/" > "${stack_install_script}"
chmod +x "${stack_install_script}"

mkdir -p "${HOME}/.local/bin"
"${stack_install_script}" -d "${HOME}/.local/bin"
