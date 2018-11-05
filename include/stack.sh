#!/bin/sh

dep_list() {
  echo "git"
  echo "curl"
}
package_install $(package_manager) $(dep_list)

stack_tmp_dir="${repo_root}/stack.tmp"
mkdir -p "${stack_tmp_dir}"
curl -sSL "https://get.haskellstack.org/" > "${stack_tmp_dir}/stack.sh"
chmod +x "${stack_tmp_dir}/stack.sh"

mkdir -p ${HOME}/.local
${stack_tmp_dir}/stack.sh -d "${HOME}/.local/bin"
