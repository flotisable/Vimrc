Param( $os )

Switch ( ${os} )
{
  Linux       { "$env:USERPROFILE/.config/nvim" }
  Windows_NT  { "$env:LOCALAPPDATA\nvim"       }
  Darwin      { "$env:USERPROFILE/.config/nvim" }
}
