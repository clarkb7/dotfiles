execute pathogen#infect()

" Spaces
set number colorcolumn=90 tabstop=4 shiftwidth=4 expandtab
" Color
syntax on
set bg=dark
colorscheme gruvbox
set encoding=utf-8
set t_Co=256
set tgc
" Use capslock for insert/normal
set <F13>=^[[25~
nnoremap <F13> i
inoremap <F13> <Esc>l

" neovim stuff
if has('nvim')
   set icm=nosplit
endif
