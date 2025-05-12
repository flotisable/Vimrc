let s:syntaxCompleteCache = {}

" wrapper of build in lsp omnifunc  內建 lsp omnifunc 的 wrapper{{{
" this function is to make neovim build in lsp omnifunc work with neocomplcache
function! ft#buildInLspOmniFunc( findstart, base )
  return v:lua.vim.lsp.omnifunc( a:findstart, a:base )
endfunction
" end wrapper of build in lsp omnifunc
"}}}
" setup buffer local keybinding  設定 buffer local 的按鍵{{{
function! ft#bufferLocalMaps( keyMapName, ... )
"
  let l:keyMap = get( g:my.keybindings, a:keyMapName, {} )

  for l:keyMapName in a:000
    let l:keyMap = get( l:keyMap, l:keyMapName, {} )
  endfor

  for l:key in keys( l:keyMap )
    execute printf( 'map <buffer> <silent> %s %s', l:key, l:keyMap[key] )
  endfor
"
endfunction
" end setup buffer local keybinding
"}}}
" setup buffer local keybinding for lsp  設定 lsp buffer local 的按鍵{{{
function! ft#lspMaps( isNvimBuiltinOrVimLsp )
"
  if  !a:isNvimBuiltinOrVimLsp &&
      \ ( !exists( 'g:LanguageClient_serverCommands' ) || !has_key( g:LanguageClient_serverCommands, &filetype ) ) &&
      \ ( !exists( 'g:lsc_server_commands' ) || !has_key( g:lsc_server_commands, &filetype ) )
    return
  endif

  for scope in [ "global", &filetype ]
    call ft#bufferLocalMaps( 'lsp', scope )
  endfor
"
endfunction
" end setup buffer local keybinding for lsp
"}}}
" async syntax complete  非同步語法補全{{{
" this function is to make syntaxcomplete#Complete become asynchronous. modified
" from syntaxcomplete#Complete in neovim 0.6.1
function! ft#asyncSyntaxComplete( findstart, base )
"
  if a:findstart || !has( 'nvim' ) && v:version < 800
    return syntaxcomplete#Complete( a:findstart, a:base )
  elseif exists( 's:buildSyntaxCompleteList' )
    return []
  endif

  let s:filetype = substitute( &filetype, '\.', '_', 'g' )

  if exists( 's:syntaxCompleteCache["' . s:filetype . '"]' )
  "
    let l:filterExpr = "v:val =~ '^" . escape( a:base, '\\/.*$^~[]' ) . "'"

    return filter( deepcopy( s:syntaxCompleteCache[s:filetype] ), l:filterExpr )
  "
  endif

  let s:completeList            = []
  let s:buildSyntaxCompleteList = 1

  if has( 'nvim' )
  "
    call jobstart(
      \ [
      \   v:progpath, '--headless', expand( '%:p' ),
      \   '-c', 'call chansend( stdioopen( {} ), syntaxcomplete#OmniSyntaxList() )',
      \   '-c', 'quit'
      \ ],
      \ {
      \   'on_stdout':  function( 's:AsyncSyntaxCompleteOnStdout' ),
      \   'on_exit':    function( 's:AsyncSyntaxCompleteOnExit'   )
      \ } )
  "
  else
  "
    call job_start(
      \ [
      \   v:progpath, '-Esu', $MYVIMRC, expand( '%:p' ),
      \   '-c', 'syntax on',
      \   '-c', 'let g:buf = bufadd( "tmp" ) | call bufload( g:buf )',
      \   '-c', 'call appendbufline( g:buf, 0, syntaxcomplete#OmniSyntaxList() )',
      \   '-c', 'buffer tmp | %print | quit!'
      \ ],
      \ {
      \   'out_cb':   function( 's:AsyncSyntaxCompleteOnStdout' ),
      \   'exit_cb':  function( 's:AsyncSyntaxCompleteOnExit'   )
      \ } )
  "
  endif
"
endfunction
" end async syntax complete
"}}}
" helper functions of async syntax complete{{{
function! s:AsyncSyntaxCompleteOnExitCore()
"
  let s:syntaxCompleteCache[s:filetype] = uniq( s:completeList )
  unlet s:buildSyntaxCompleteList
"
endfunction

if has( 'nvim' )
"
  function! s:AsyncSyntaxCompleteOnStdout( id, data, name )
    let s:completeList += a:data
  endfunction

  function! s:AsyncSyntaxCompleteOnExit( id, exitCode, eventType )
    call s:AsyncSyntaxCompleteOnExitCore()
  endfunction
"
elseif v:version >= 800
"
  function! s:AsyncSyntaxCompleteOnStdout( channel, message )
    let s:completeList += split( a:message )[-1:]
  endfunction

  function! s:AsyncSyntaxCompleteOnExit( job, exitCode )
    call s:AsyncSyntaxCompleteOnExitCore()
  endfunction
"
endif
" end helper functions of async syntax complete
"}}}
" toggle terminal  切換終端機{{{
function! ft#toggleTerminal()
"
  if !has( 'nvim' ) && !has( 'terminal' )
    return
  endif

  if exists( 's:terminal' ) && bufnr() == s:terminal
    execute 'set laststatus='  . s:settings['laststatus']
    execute 'set showtabline=' . s:settings['showtabline']
    tabclose!
    return
  endif

  let s:settings =
  \ {
  \   'laststatus':   &laststatus,
  \   'showtabline':  &showtabline
  \ }

  if !exists( 's:terminal' )
    if has( 'nvim' )
      execute 'tabedit term://' . &shell
      startinsert
    else
      execute 'tab term ++kill=kill'
    endif
    let s:terminal = bufnr()
  else
    execute 'silent tab sbuffer ' . s:terminal
    normal i
  endif

  setlocal nonumber
  setlocal norelativenumber
  set laststatus=0
  set showtabline=0
"
endfunction
" end toggle terminal
"}}}
" vim-lsp callback for switchSourceHeader  切換 header, source 的 callback{{{
function! ft#vimLspSwitchSourceHeader( data )
"
  if lsp#client#is_error( a:data['response']) || !has_key( a:data['response'], 'result' )
    call lsp#utils#error( 'Can not found corresponding header or source file' )
    return
  endif

  execute 'silent edit ' . lsp#utils#uri_to_path( a:data['response']['result'] )
"
endfunction
" end vim-lsp callback for switchSourceHeader
"}}}
" toggle sharing setup  切換分享設定{{{
function! ft#toggleSharingSetup()
"
  if !exists( 'w:isSharing' )
  "
    let w:isSharing           = 0
    let w:sharingOrigSettings = {}
  "
  endif

  let w:isSharing = !w:isSharing

  if w:isSharing
  "
    let w:sharingOrigSettings.relativenumber  = &relativenumber
    let w:sharingOrigSettings.number          = &number
    let w:sharingOrigSettings.cursorline      = &cursorline
    let w:sharingOrigSettings.cursorcolumn    = &cursorcolumn
    let w:sharingOrigSettings.colorcolumn     = &colorcolumn

    set norelativenumber
    set number
    set cursorline
    set cursorcolumn
    set colorcolumn=+0
  "
  else
  "
    let &relativenumber = w:sharingOrigSettings.relativenumber
    let &number         = w:sharingOrigSettings.number
    let &cursorline     = w:sharingOrigSettings.cursorline
    let &cursorcolumn   = w:sharingOrigSettings.cursorcolumn
    let &colorcolumn    = w:sharingOrigSettings.colorcolumn
  "
  endif
"
endfunction
" end toggle sharing setup
"}}}
" vim: foldmethod=marker foldmarker={{{,}}}
