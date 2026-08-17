set scrolloff=8
set number
set relativenumber
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'rose-pine/vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }

call plug#end()

set termguicolors     " enable true colors support
colorscheme rosepine

hi Normal       guifg=#e1e0ea guibg=#080808
hi Comment      guifg=#93919f
hi Constant     guifg=#dec6a4
hi String       guifg=#dec6a4
hi Function     guifg=#d9c3c2
hi Identifier   guifg=#d9c3c2
hi Special      guifg=#d9c3c2
hi Keyword      guifg=#858b8b
hi Statement    guifg=#858b8b
hi Type         guifg=#d1d8d8
hi PreProc      guifg=#cbc2ce
hi Operator     guifg=#93919f
hi LineNr       guifg=#72707d
hi CursorLineNr guifg=#e1e0ea

let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_operators = 1

let mapleader = " "
nnoremap <leader>pv :Ex<CR>
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader><CR> :so ~/.vimrc<CR>
inoremap jk <Esc>

nnoremap <leader>pf :Files<CR>
