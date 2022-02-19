$settingFile = "./settings.toml"

$scriptDir = "$(Split-Path $PSCommandPath )"

. ${scriptDir}/readSettings.ps1 $settingFile

ForEach( $target in $settings['target'].keys )
{
  $targetFile = Invoke-Expression "Write-Output $($settings['target'][$target])"
  $sourceFile = Invoke-Expression "Write-Output $($settings['source'][$target])"

  Switch( $target )
  {
    'pluginManager'
    {
      $dirType = 'vimShare'
      If( !$settings['pluginManager']['install'] )
      {
        Continue
      }
    }
    'vimrcLocal'  { $dirType = 'vimShare' }
    'vimrc'       { $dirType = 'vim'      }
    default       { $dirType = 'nvim'     }
  }

  $dir = Invoke-Expression "Write-Output $($settings['dir'][$dirType])"

  Write-Host "install $sourceFile"
  Copy-Item $sourceFile $dir/$targetFile 
}
