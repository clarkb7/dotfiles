" Spaces
set number colorcolumn=90 tabstop=2 shiftwidth=2 cindent expandtab
" Color
syntax on
colorscheme darkblue
" Custom colors
" Must be after colorscheme
highlight ColorColumn ctermbg=DarkGray
" Transparent background
hi Normal ctermbg=NONE
" Syntax extensions
au BufRead,BufNewFile *.pl set filetype=prolog

