set nocompatible               " rise above vi compatibility

set backspace=indent,eol,start " allow backspacing over everything in insert mode
set backup                     " keep a backup file
set history=50                 " keep history 50-deep

" set autoindent " Mimic indentation of previous line
syntax on " syntax highlighting
filetype plugin indent on " filetype detection and options

set expandtab " convert tabs to spaces
set shiftwidth=2 " auto-indent tab width
set softtabstop=2 " manual tab width
set number " display line numbers

colorscheme mustang


"*-------------------------------------------------------*"
" KEY MAPS

  set timeoutlen=200 " timeout on mappings and key codes

" Quickly edit/reload vimrc
  let mapleader=";"
  nmap <leader>ev :e $MYVIMRC<CR>
  nmap <leader>sv :so $MYVIMRC<CR>
  
"*-------------------------------------------------------*"

"                         k
" Navigation:         j <-+-> l
"                        Spc
"
  nnoremap j h
  nnoremap <Space> j
  
" Go to beginning of line
  nnoremap lj 0
" Go to end of line
  nnoremap jl $

" Go to next word
  nnoremap <C-l> w
" Go to previous word
  nnoremap <C-j> b

" Go to first line
  nnoremap u gg
" Go to last line
  nnoremap U G

" Page up
  nnoremap <Space>k <C-b>
" Page down
  nnoremap k<Space> <C-f>

" Half-page up
  nnoremap <Space>jk <C-u>
" Half-page down
  nnoremap kj<Space> <C-d>

" Go to top of screen: H
" Go to mid of screen: M
" Go to bot of screen: L

" Scroll up 1 line
  nnoremap <C-u> <C-y>
" Scroll down 1 line
  nnoremap <C-n> <C-e>

"*-------------------------------------------------------*"
" Editing:          i | jk   U | Y
"

" Exit insert mode BROKEN (breaks tab behavior)
  inoremap <C> <Esc> 

" Delete to end of line
  nnoremap djl d$
" Delete to beginning of line
  nnoremap dlj d0

" Clear and replace to end of line
  nnoremap cjl c$
" Clear and replace to beginning of line
  nnoremap clj c0

" Yank to end of line
  nnoremap yjl y$
" Yank to beggining of line
  nnoremap ylj y0

" Insert newline above current line
  nnoremap <Space>; O<Esc>j
" Insert newline below current line
  nnoremap ;<Space> o<Esc>k

" Delete line above current line
  nnoremap d<Space>; kdd
" Delete line below current line
  nnoremap d;<Space> jdd

" Open new line above current line
  nnoremap <Space>o O

" Undo
  nnoremap U u
" Redo
  nnoremap Y <C-r>

"Note: I've switch the Control and Caps-Lock keys in OS X.
