$settingFile = "./settings"

. ./readSettings.ps1 $settingFile

If( $nvimrcDir -eq "" )
{
  $nvimrcDir = ./default.ps1 $env:OS
}

If( $installPluginManager -eq 1 -and
    -not $(Get-Item -Path "${pluginManagerPath}/plug.vim" -ErrorAction SilentlyContinue) )
{
  Write-Host "install vim-plug"
  curl.exe -fLo ${pluginManagerPath}/plug.vim --create-dirs `
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

Write-Host "install vimrc"
Copy-Item $vimrcSourceFile $vimrcDir/$vimrcTargetFile
Write-Host "install nvim init file"
Copy-Item $nvimrcSourceFile $nvimrcDir/$nvimrcTargetFile
Write-Host "install nvim ginit file"
Copy-Item $ngvimrcSourceFile $nvimrcDir/$ngvimrcTargetFile
