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

  call GuiWindowMaximized( 1 )

  GuiFont Consolas:h14
  GuiTabline 0

  noremap <F11> <Cmd>call FlotisableToggleFullScreen()<Enter>
"
endif

if FlotisablePluginExistsAndInRtp( 'kalahari.vim' )
  colorscheme kalahari
else
  colorscheme desert
endif
autocmd ColorScheme * highlight Pmenu gui=NONE guibg=Grey
