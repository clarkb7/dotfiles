. ~/.local/share/chezmoi/helpers.ps1

# Set path 
Add-UserPath -Path "$env:LocalAppData\ColorTool"
# Set theme
& "$env:LocalAppData\ColorTool\ColorTool.exe" -b "$env:LocalAppData\ColorTool\schemes\OneHalfDark.itermcolors"
