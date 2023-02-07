# Fix dircolor - it is blue highlight by default
$PSStyle.FileInfo.Directory = "`e[34m"
# Fix parameter color - it is same as background by default
Set-PsReadLineOption -Colors @{Parameter = "`e[38;5;250m"}
Set-PsReadLineOption -Colors @{Operator = "`e[38;5;250m"}

