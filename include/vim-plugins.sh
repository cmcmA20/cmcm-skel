#!/bin/sh

nvim_dir=$(config_home_path)/nvim
mkdir -p "${nvim_dir}"
safe_copy "${repo_root}/init.vim" "${nvim_dir}/init.vim"
safe_symlink "${nvim_dir}" "${HOME}/.vim"
safe_symlink "${nvim_dir}/init.vim" "${HOME}/.vimrc"

vim_dir=${HOME}/.vim
pathogen_dir=${vim_dir}/autoload
plug_dir=${vim_dir}/bundle
mkdir -p "${pathogen_dir}"
mkdir -p "${plug_dir}"
curl -Lsso "${pathogen_dir}/pathogen.vim"\
     "https://github.com/tpope/vim-pathogen/raw/master/autoload/pathogen.vim"

# generally useful
git_clone "https://github.com/Shougo/deoplete.nvim.git" "${plug_dir}/deoplete"
git_clone "https://github.com/ervandew/supertab.git" "${plug_dir}/supertab"
#git_clone "https://github.com/vim-airline/vim-airline.git" "${plug_dir}/airline"
git_clone "https://github.com/moll/vim-bbye.git" "${plug_dir}/bbye"
git_clone "https://github.com/tpope/vim-commentary.git" "${plug_dir}/commentary"
git_clone "https://github.com/tpope/vim-fugitive.git" "${plug_dir}/fugitive"
git_clone "https://github.com/tpope/vim-sensible.git" "${plug_dir}/sensible"
git_clone "https://github.com/christoomey/vim-tmux-navigator.git" "${plug_dir}/tmux-navigator"
#git_clone "https://github.com/vim-scripts/Align.git" "${plug_dir}/align"

# language specific
#git_clone "https://github.com/rust-lang/rust.vim.git" "${plug_dir}/rust"
#git_clone "https://github.com/neovimhaskell/haskell-vim.git" "${plug_dir}/haskell"
#git_clone "https://github.com/idris-hackers/idris-vim.git" "${plug_dir}/idris"
