$settingFile = "./settings"

. ./readSettings.ps1 $settingFile

If( $nvimrcDir -eq "" )
{
  $nvimrcDir = ./default.ps1 $env:OS
}

$targetFiles =  "${vimrcDir}/${vimrcTargetFile}",
                "${nvimrcDir}/${nvimrcTargetFile}",
                "${nvimrcDir}/${ngvimrcTargetFile}"

Write-Host "uninstall rc files"
ForEach( $file in $targetFiles )
{
  Remove-Item $file
}

If( $(Get-Item -Path "${pluginManagerPath}/plug.vim" -ErrorAction SilentlyContinue) )
{
  Remove-Item "${pluginManagerPath}/plug.vim" 
}
