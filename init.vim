" GENERAL STUFF

" even more sensible
let g:skip_defaults_vim = 1
set nocompatible

" No tabs please
set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
set smarttab

" Programming please
set ruler
set number
set list

" KEYBINDINGS
let mapleader=","
let maplocalleader="<"

map <leader>nh :nohlsearch<cr>

map <leader>fo :foldopen<cr>
map <leader>fc :foldclose<cr>

map <leader>tc :tabnew<cr>
map <leader>tx :tabclose<cr>
map <leader>tn :tabnext<cr>
map <leader>tp :tabprevious<cr>
map <leader>tl :tabs<cr>

map <leader>bc :enew<cr>
map <leader>bx :bdelete<cr>
map <leader>bn :bnext<cr>
map <leader>bp :bprevious<cr>
map <leader>bl :ls<cr>

" PLUGINS
" vim-tmux-navigator
let g:tmux_navigator_disable_when_zoomed = 1

" deoplete
let g:deoplete#enable_at_startup = 1

" vim-pathogen
execute pathogen#infect()
