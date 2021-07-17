if exists( 'g:GuiLoaded' )
"
  if !exists( '*FlotisableToggleFullScreen' )
  "
    function FlotisableToggleFullScreen()
    "
      if g:GuiWindowFullScreen == 1
      "
        call GuiWindowFullScreen( 0 )
      "
      else
      "
        call GuiWindowFullScreen( 1 )
      "
      endif
    "
    endfunction
  "
  endif

  colorscheme desert
  highlight Pmenu gui=NONE guibg=Grey

  highlight link LspDiagnosticsDefaultError       Error
  highlight link LspDiagnosticsDefaultWarning     Todo
  highlight link LspDiagnosticsDefaultHint        Todo
  highlight link LspDiagnosticsDefaultInformation Todo

  call GuiWindowMaximized( 1 )

  GuiFont Consolas:h14
  GuiTabline 0

  noremap <F11> :call FlotisableToggleFullScreen()<Enter>
"
endif
