$settingFile = "./settings.toml"

$scriptDir = "$(Split-Path $PSCommandPath )"

. ${scriptDir}/readSettings.ps1 $settingFile

$root           = Invoke-Expression "Write-Output $($settings['dir']['root'])"
$rcRoot         = ( Get-Item ${scriptDir}/../Rcs/$os ).FullName
$rcRootPattern  = "$( $rcRoot -replace '\\', '\\' )\\"

ForEach( $file in ( Get-ChildItem -Recurse -File $rcRoot ).FullName )
{
  $file       = $file -replace $rcRootPattern, ""
  $sourceFile = "$rcRoot/$file"
  $targetFile = "$root/$file"
  $dir        = $(Split-Path -Parent $targetFile)

  If( $file -match 'plug' -and !$settings['pluginManager']['install'] )
  {
    Continue
  }
  If( New-Item -Type Directory -ErrorAction SilentlyContinue $dir)
  {
    Write-Host "create directory" $dir
  }
  Write-Host "install $file"
  Copy-Item $sourceFile $targetFile 
}
