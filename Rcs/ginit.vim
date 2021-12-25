if exists( 'g:GuiLoaded' )
"
  function! MyToggleFullScreen()
  "
    if g:GuiWindowFullScreen == 1
      call GuiWindowFullScreen( 0 )
    else
      call GuiWindowFullScreen( 1 )
    endif
  "
  endfunction

  call GuiWindowMaximized( 1 )

  GuiTabline 0

  noremap <F11> <Cmd>call MyToggleFullScreen()<Enter>
"
endif

if MyPluginExistsAndInRtp( 'nord-vim' )
  colorscheme nord
else
  colorscheme desert
endif
