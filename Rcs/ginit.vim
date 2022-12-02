let s:defaultGuiFont = &guifont

" self defined functions  自定義的函式{{{
" zoom GUI font  調整字型大小{{{
function MyZoom( isZoomIn, isReset )
"
  if a:isReset
    let &guifont = s:defaultGuiFont
    return
  endif

  let l:prefix  = ':h'
  let l:pattern = l:prefix . '\(\d\+\)'
  let l:size    = get( matchlist( &guifont, l:pattern ), 1, -1 )

  if 0 >= l:size
    return
  endif

  let l:size    += ( a:isZoomIn ) ? 1: -1
  let &guifont  = substitute( &guifont, l:pattern, l:prefix . l:size, '' )
"
endfunction
" end zoom GUI font
"}}}
" end self defined functions
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
" key mapping  快捷鍵設定{{{
noremap <silent> <C-0>  :call MyZoom( 0, 1 )<Enter>| " reset guifont
noremap <silent> -      :call MyZoom( 0, 0 )<Enter>| " zoom out
noremap <silent> +      :call MyZoom( 1, 0 )<Enter>| " zoom in
" end key mapping
"}}}
" vim: foldmethod=marker foldmarker={{{,}}}
