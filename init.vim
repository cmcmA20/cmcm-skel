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

map <leader>nh :nohlsearch<cr>

map <leader>fo :foldopen<cr>
map <leader>fc :foldclose<cr>

map <leader>tc :tabnew<cr>
map <leader>td :tabclose<cr>
map <leader>tn :tabnext<cr>
map <leader>tp :tabprevious<cr>

map <leader>bd :bdelete<cr>
map <leader>bn :bnext<cr>
map <leader>bp :bprevious<cr>

"nnoremap <silent> <leader>lh :call LanguageClient_textDocument_hover()<CR>
"nnoremap <silent> <leader>ld :call LanguageClient_textDocument_definition()<CR>
"nnoremap <silent> <leader>lr :call LanguageClient_textDocument_rename()<CR>
"nnoremap <silent> <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
"nnoremap <silent> <leader>lf :call LanguageClient_textDocument_formatting()<CR>
"nnoremap <silent> <leader>lr :call LanguageClient_textDocument_references()<CR>
"nnoremap <silent> <leader>la :call LanguageClient_textDocument_codeAction()<CR>

" PLUGINS
" vim-tmux-navigator
let g:tmux_navigator_disable_when_zoomed = 1

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

" deoplete
let g:deoplete#enable_at_startup = 1

" LanguageClient-neovim
"set hidden
"let g:LanguageClient_serverCommands = {
"			\ 'haskell': ['hie', '--lsp'],
"			\ }

" haskell-vim
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
let g:haskell_indent_let_no_in = 1

" vim-pathogen
execute pathogen#infect()
