" option settings  選項設定{{{
set encoding=utf-8    " 設定編碼  set file encoding
set number            " 顯示行號  display line number
set autoindent        " 自動縮排（與上一行縮排相同）  automatic indent as last line

set foldmethod=manual " 手動折疊程式碼  manual fold the code

set tabstop=2         " 設定 tab 鍵等於幾個空白鍵  set TAB key to be equivalent to how many spaces
set shiftwidth=2
set expandtab         " 將 tab 鍵展開為空白鍵  expand TAB key to be spaces

set showcmd           " 顯示指令在狀態攔（知道自己輸入什麼）  show the command at the status bar

set errorformat^=%D%*[^:]:\ Entering\ directory\ '%f',%X%*[^:]:\ Leaving\ directory\ '%f'

set laststatus=2
set hlsearch

if has( "cscope" )
"
  if filereadable( "cscope.out" )
  "
    cscope add cscope.out
  "
  endif
  set cscopeverbose
"
endif
" end option settings
"}}}
" self defined functions  自定義的函式{{{

" relativenumber settings  相對行號設定
if !exists( '*FlotisableToggleRelativeNumber' )
"
  function FlotisableToggleRelativeNumber()
  "
    if &relativenumber == 0
    "
      set relativenumber
    "
    else
    "
      set norelativenumber
    "
    endif
  "
  endfunction
"
endif
" end relativenumber settings

if !exists( '*FlotisablePluginExists' )
"
  function FlotisablePluginExists( name )
  "
    return isdirectory( expand( printf( '%s/%s', g:pluginRoot, a:name ) ) )
  "
  endfunction
"
endif

" end self defined functions
"}}}
" setup colorscheme for terminal and gui  根據終端與圖形設置不同的顏色主題{{{
if has( 'gui_running' )
  colorscheme desert  " colorscheme in gui  圖形介面顏色主題
else
  colorscheme elflord " colorscheme in terminal  終端機顏色主題
endif
" end setup colorscheme for terminal and gui
"}}}
" save and load view  自動讀取與儲存手動的折疊{{{
au BufWinLeave * silent! mkview
au BufWinEnter * silent! loadview
" end save and load view
"}}}
" vim-plug settings  vim-plug 插件設定（用來管理其他插件的插件）  plugin for manage other plugins  https://github.com/junegunn/vim-plug{{{
if filereadable( globpath( &runtimepath, 'autoload/plug.vim' ) )
"
  let g:pluginRoot = '~/.vim/plugged'

  call plug#begin( pluginRoot )

  Plug 'scrooloose/nerdtree'                                    " 樹狀顯示資料夾的插件  plugin for display directory as tree view
  Plug 'majutsushi/tagbar'                                      " 顯示 tag 的插件（需搭配 ctags ）  plugin for display tags( depend on 'ctags' )

  if has( 'nvim' )                                              " neovim 專用插件  neovim specific plugins
  "
    Plug 'kassio/neoterm'                                       " 終端機插件  terminal plugin
  "
  endif

  Plug 'octol/vim-cpp-enhanced-highlight'                       " C++語法高亮插件  plugin for C++ highlight
  Plug 'vim-perl/vim-perl', { 'do': 'make clean moose' }
  Plug 'pprovost/vim-ps1'
  Plug 'flotisable/FlotisableStatusLine', {'branch':'develop'}  " 個人使用的狀態列設定插件  self use statusline plugin

  " 自動補全的插件  plugin for autocomplete
  if ( has( 'nvim' ) || v:version >= 800 ) && has( 'python3' )
  "
    if has( 'nvim' )
    "
      Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    "
    else
    "
      Plug 'Shougo/deoplete.nvim'
      Plug 'roxma/nvim-yarp'
      Plug 'roxma/vim-hug-neovim-rpc'
    "
    endif
  "
  else " 當 vim 版本較低時  when 'vim' version is older
  "
    Plug 'shougo/neocomplcache.vim'
  "
  endif
  " end plugin for autocomplete

  " LSP 客戶端  language server protocal client
  if has( 'nvim' ) || v:version >= 800
  "
    if has( 'win32' )
    "
      Plug 'autozimu/LanguageClient-neovim',
        \ { 'branch': 'next',
          \ 'do': 'powershell -executionpolicy bypass -File install.ps1' }
    "
    else
    "
      Plug 'autozimu/LanguageClient-neovim',
        \ { 'branch': 'next',
          \ 'do': 'bash install.sh' }
    "
    endif
  "
  endif
  " end language server protocal client

  " 版本控制差異插件  VCS diff plugin
  if has( 'nvim' ) || has( 'patch-8.0.902' )
    Plug 'mhinz/vim-signify'
  else
    Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
  endif
  " end VCS diff plugin

  " 程式碼片段插件  code snippet plugin
  Plug 'MarcWeber/vim-addon-mw-utils'
  Plug 'tomtom/tlib_vim'
  Plug 'garbas/vim-snipmate'
  " end code snippet plugin

  Plug 'flotisable/FlotisableVimSnippets' " 個人使用的程式碼片段  self use code snippet

  call plug#end()
"
endif
" end vim-plug settings
"}}}
" 補全插件設定  completion plugin settings{{{
if FlotisablePluginExists( 'deoplete.nvim' )
"
  let g:python3_host_prog           = "python3"
  let g:deoplete#enable_at_startup  = 1 " 開啟 vim 時啟用 deoplete  start 'deoplete' when open 'vim'
"
elseif FlotisablePluginExists( 'neocomplcache.vim' )
"
  let g:neocomplcache_enable_at_startup = 1 " 開啟 vim 時啟用 neocomplcache  start 'neocomplcache' when open 'vim'
"
endif
" end completion plugin settings
"}}}
" LSP 客戶端設定  LSP client settings{{{
if FlotisablePluginExists( 'LanguageClient-neovim' )
"
  let g:LanguageClient_diagnosticsEnable  = 0
  let g:LanguageClient_serverCommands     = {}

  call extend( g:LanguageClient_serverCommands, { 'cpp': ['clangd'] } )
"
endif
" end LSP client settings
"}}}
" 版本控制差異插件設定  VCS diff plugin settings{{{
if FlotisablePluginExists( 'LanguageClient-neovim' )
"
  set updatetime=100

  let g:signify_disable_by_default = 1
"
endif
" end VCS diff plugin settings
"}}}
" key mapping  快捷鍵設定{{{
if FlotisablePluginExists( 'nerdtree' )
"
  noremap <C-x> :NERDTreeToggle<Enter>| " 設定 Ctrl+x 鍵開闔樹狀檢視器  set Ctrl+s key to toggle tree browser
"
endif

if FlotisablePluginExists( 'tagbar' )
"
  noremap <Leader>t :Tagbar<Enter>
"
endif

if FlotisablePluginExists( 'vim-signify' )
"
  noremap <Leader>s :SignifyToggle<Enter>
  noremap <Leader>d :SignifyHunkDiff<Enter>
  noremap <Leader>D :SignifyDiff<Enter>
"
endif

noremap   <Leader>r :call FlotisableToggleRelativeNumber()<Enter>|  " 設定 Leader r 鍵開關相對行號設定
noremap   <Space>   <C-F>
noremap   <BS>      <C-B>
noremap!  <C-a>     <Home>
noremap!  <C-e>     <End>
noremap!  <C-f>     <Right>
noremap!  <C-b>     <Left>
noremap!  <C-p>     <Up>
noremap!  <C-n>     <Down>
noremap!  <C-k>     <C-e><C-u>
noremap!  <C-d>     <Del>

if has( "cscope" )
"
  nnoremap <C-_>s :cscope find s <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-_>g :cscope find g <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-_>c :cscope find c <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-_>t :cscope find t <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-_>e :cscope find e <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-_>f :cscope find f <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-_>i :cscope find i <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-_>d :cscope find d <C-R>=expand("<cword>")<CR><CR>
"
endif
" end key mapping
"}}}
" vim-cpp-enhanced-highlight settings{{{
if FlotisablePluginExists( 'vim-cpp-enhanced-highlight' )
"
  let g:cpp_class_scope_highlight     = 1
  let g:cpp_member_variable_highlight = 1
  let g:cpp_class_decl_highlight      = 1
"
endif
" end vim-cpp-enhanced-highlight settings
"}}}
" vim: foldmethod=marker foldmarker={{{,}}}
