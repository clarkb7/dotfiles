let g:go_version_warning = 0

" Disable ugly scrolling
let g:loaded_comfortable_motion = 0
let g:comfortable_motion_no_default_key_mappings = 1

" line numbers
set number

" disable folding
set nofoldenable

" Disable Background COlor Erase (BCE) to fix incorrect
" bg color
set t_ut=

" Enable pretty colors
set termguicolors
" fix pretty colors
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"

" ctrl-p
"" default to search by filename
let g:ctrlp_by_filename = 1

let g:ctrlp_user_command = {
    \ 'types': {
    \     1: ['.git', 'cd %s && git ls-files . -co --exclude-standard'],
    \     },
    \ 'fallback': 'find %s -type f',
    \ }

" wix installer files
autocmd BufNewFile,BufRead *.wxs.erb,*.wxl.erb,*.wxi set syntax=xml expandtab ts=2 sw=2 sts=2

" Set replace confirmation current item to have different highlight color from other matches
highlight IncSearch guibg=blue ctermbg=blue term=underline
