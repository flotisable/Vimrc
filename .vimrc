" option settings  選項設定{{{
set encoding=utf-8    " 設定編碼  set file encoding
set number            " 顯示行號  display line number
set autoindent        " 自動縮排（與上一行縮排相同）  automatic indent as last line

set foldmethod=manual " 手動折疊程式碼  manual fold the code

set tabstop=2         " 設定 tab 鍵等於幾個空白鍵  set TAB key to be equivalent to how many spaces
set shiftwidth=2
set expandtab         " 將 tab 鍵展開為空白鍵  expand TAB key to be spaces

set showcmd           " 顯示指令在狀態攔（知道自己輸入什麼）  show the command at the status bar
" end option settings
"}}}
" self defined functions  自定義的函式{{{

" relativenumber settings  相對行號設定
if !exists( '*FlotisableToggleRelativeNumber' )
  function FlotisableToggleRelativeNumber()
    if &relativenumber == 0
      set relativenumber
    else
      set norelativenumber
    endif
  endfunction
endif
" end relativenumber settings

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

  call plug#end()
"
endif
" end vim-plug settings
"}}}
" 補全插件設定  completion plugin settings{{{
if isdirectory( expand( printf( '%s/deoplete.nvim', pluginRoot ) ) )
"
  let g:python3_host_prog           = "python3"
  let g:deoplete#enable_at_startup  = 1 " 開啟 vim 時啟用 deoplete  start 'deoplete' when open 'vim'
"
elseif isdirectory( expand( printf( '%s/neocomplcache.vim', pluginRoot ) ) )
"
  let g:neocomplcache_enable_at_startup = 1 " 開啟 vim 時啟用 neocomplcache  start 'neocomplcache' when open 'vim'
"
endif
" end completion plugin settings
"}}}
" LSP 客戶端設定  LSP client settings{{{
if isdirectory( expand( printf( '%s/LanguageClient-neovim', pluginRoot ) ) )
"
  let g:LanguageClient_serverCommands = {}

  call extend( g:LanguageClient_serverCommands, { 'cpp': ['clangd'] } )
"
endif
" end LSP client settings
"}}}
" key mapping  快捷鍵設定{{{
if isdirectory( expand( printf( '%s/nerdtree', pluginRoot ) ) )
"
  noremap   <C-x>     :NERDTreeToggle<Enter>|                         " 設定 Ctrl+x 鍵開闔樹狀檢視器  set Ctrl+s key to toggle tree browser
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
" end key mapping
"}}}
" vim-cpp-enhanced-highlight settings{{{
if isdirectory( expand( printf( '%s/vim-cpp-enhanced-highlight', pluginRoot ) ) )
"
  let g:cpp_class_scope_highlight     = 1
  let g:cpp_member_variable_highlight = 1
  let g:cpp_class_decl_highlight      = 1
"
endif
" end vim-cpp-enhanced-highlight settings
"}}}
" vim: foldmethod=marker foldmarker={{{,}}}
