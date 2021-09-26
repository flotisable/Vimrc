if exists( 'g:GuiLoaded' )
"
  function! FlotisableToggleFullScreen()
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

  colorscheme kalahari
  highlight Pmenu gui=NONE guibg=Grey

  call GuiWindowMaximized( 1 )

  GuiFont Consolas:h14
  GuiTabline 0

  noremap <F11> <Cmd>call FlotisableToggleFullScreen()<Enter>
"
endif
