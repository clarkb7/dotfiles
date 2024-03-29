function Add-UserPath() {
    param(
        [Parameter(Mandatory=$true)][string] $Path
    )
    $CurrentPathItems = [Environment]::GetEnvironmentVariable("Path", [System.EnvironmentVariableTarget]::User) -split ';'
    if ($CurrentPathItems -notcontains $Path) {
        $CurrentPathItems += $Path
        [Environment]::SetEnvironmentVariable(
            "Path",
            $CurrentPathItems -join ';',
            [System.EnvironmentVariableTarget]::User)
    }
}
