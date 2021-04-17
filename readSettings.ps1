Param( $settingFile )

ForEach( $line in Get-Content $settingFile )
{
  If( $line -eq "" )
  {
    Continue
  }
  $variableName, $value = $line -split '='

  While( $value -match '\$\{(\w+)\}' )
  {
    $substVarName   = $Matches[1]
    $substVarValue  = Get-Variable -Name $substVarName -ValueOnly -ErrorAction SilentlyContinue
    $value          = $value -replace "\$\{$substVarName\}", "$substVarValue"
  }

  Set-Variable -Name $variableName -Value $value
}
