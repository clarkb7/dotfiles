# http://onethingwell.org/post/586977440/mkcd-improved
function mkcd
{
  dir="$*";
  mkdir -p "$dir" && cd "$dir";
}

# Colored man pages
# https://wiki.archlinux.org/index.php/Man_page#Colored_man_pages
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
    LESS_TERMCAP_md=$'\E[01;38;5;74m' \
    LESS_TERMCAP_me=$'\E[0m' \
    LESS_TERMCAP_se=$'\E[0m' \
    LESS_TERMCAP_so=$'\E[38;5;246m' \
    LESS_TERMCAP_ue=$'\E[0m' \
    LESS_TERMCAP_us=$'\E[04;38;5;146m' \
    man "$@"
}

# grep
grep_exclude_dirs=".git .tox .vs"
# NOTE: command expansion on array for zsh/bash compat
grep_exclude_dir_opts=$(for d in $(echo "$grep_exclude_dirs"); do echo -n "--exclude-dir $d "; done)

alias pygrep="grep -R --include '*.py'"
alias gogrep="grep -R --include '*.go'"
alias grep="grep $grep_exclude_dir_opts"
alias rgrep="rgrep $grep_exclude_dir_opts"

# cat with highlighting
alias hl='highlight --style molokai --out-format=xterm256'

function wsl1 {
    wsl.exe -d debian-wsl1 --cd ~
}
function wsl2 {
    wsl.exe -d debian-docker --cd ~
}
