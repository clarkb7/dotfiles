" Spaces
set number colorcolumn=90 tabstop=4 shiftwidth=4 expandtab
" Color
syntax on
set bg=dark
colorscheme jellybeans
set encoding=utf-8
set t_Co=256
" Custom colors
" Must be after colorscheme
highlight ColorColumn ctermbg=DarkGray
" Transparent background
"hi Normal ctermbg=NONE
" Use capslock for insert/normal
set <F13>=^[[25~
nnoremap <F13> i
inoremap <F13> <Esc>l
