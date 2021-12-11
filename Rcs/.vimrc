" option settings  選項設定{{{
set encoding    =utf-8  " set file encoding  設定編碼
set number              " display line number  顯示行號
set showcmd             " show the command at the status bar  顯示指令在狀態列（知道自己輸入什麼）
set laststatus  =2      " show the status line  顯示狀態列
set autoindent          " automatic indent as last line  自動縮排（與上一行縮排相同
set smartindent         " smart indent based on {}  根據大括號縮排
set foldmethod  =manual " manual fold the code  手動折疊程式碼
set textwidth   =80
set tabstop     =2      " set TAB key to be equivalent to how many spaces  設定 tab 鍵等於幾個空白鍵
set shiftwidth  =2      " use same number of spaces for indent as tabstop  設定縮排時用 tabstop 的空白鍵數量
set expandtab           " expand TAB key to be spaces  將 tab 鍵展開為空白鍵
set hlsearch            " highlight the searched pattern  高亮搜尋的 pattern
set incsearch           " enable incremental search  開啟遞增搜尋

set listchars   =tab:>\ ,trail:-,nbsp:+
set errorformat ^=%D%*[^:]:\ Entering\ directory\ '%f',%X%*[^:]:\ Leaving\ directory\ '%f'
set viewoptions =folds,cursor

if has( 'win32' )
  set guifont=Consolas:h14
else
  set guifont=DejaVu\ Sans\ Mono:h14
endif

if has( 'nvim' )
  set jumpoptions=stack
endif

if has( 'patch-7.4.775' )
  set completeopt=menuone,noinsert
endif

if has( 'win32' )
"
  set shell         =powershell
  let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  let &shellredir   = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  let &shellpipe    = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  set shellquote    =
  set shellxquote   =
"
endif

if has( "cscope" )
"
  if executable( "gtags-cscope" ) && filereadable( "GTAGS" )
  "
    set cscopeprg=gtags-cscope

    cscope add GTAGS
  "
  elseif filereadable( "cscope.out" )
    cscope add cscope.out
  endif
  set cscopeverbose
"
endif
" end option settings
"}}}
" self defined settings  自定義設定{{{
let g:flotisable = {
  \   'keybindings': {
  \     'lsp': {}
  \   },
  \   'pluginRoot':           $HOME . '/.vim/plugged',
  \   'powershellBundlePath': $HOME . '/Applications/PowerShellEditorServices',
  \   'snippetAuthor':        'Flotisable'
  \ }
" end self defined settings
"}}}
" self defined functions  自定義的函式{{{
" test pluggin existence  檢測插件是否存在{{{
" this function is add since old vim not support optional argument
function! FlotisablePluginExistsAndInRtp( name )
  return FlotisablePluginExists( a:name, 1 )
endfunction

function! FlotisablePluginExists( name, isCheckRtp )
"
  let l:fullName = g:flotisable.pluginRoot . '/' . a:name

  return isdirectory( l:fullName ) && ( !a:isCheckRtp || stridx( &runtimepath, a:name ) != -1 )
"
endfunction
" end test pluggin existence
"}}}
" wrapper of build in lsp omnifunc  內建 lsp omnifunc 的 wrapper{{{
" this wrapper function it to make neovim build in lsp omni function work
" with neocomplcache
function! FlotisableBuildInLspOmniFunc( findstart, base )
  return v:lua.vim.lsp.omnifunc( a:findstart, a:base )
endfunction
" end wrapper of build in lsp omnifunc
"}}}
" setup buffer local keybinding for lsp  設定 lsp buffer local 的按鍵{{{
function! FlotisableLspMaps( isNvimBuiltin )
"
  if !a:isNvimBuiltin && !has_key( g:LanguageClient_serverCommands, &filetype )
    return
  endif

  let l:mapFormat = 'map <buffer> <silent> %s %s'

  for scope in [ "global", &filetype ]
  "
    if !exists( 'g:flotisable.keybindings.lsp["' . scope . '"]' )
      continue
    endif

    for key in keys( g:flotisable.keybindings.lsp[scope] )
      execute printf( l:mapFormat, key, g:flotisable.keybindings.lsp[scope][key] )
    endfor
  "
  endfor
"
endfunction
" end setup buffer local keybinding for LanguageClient-neovim
"}}}
" customize highlight  設定介面的顏色{{{
function! FlotisableCustomHighlight()
"
  highlight CursorColumn  cterm=NONE ctermbg=Grey
  highlight CursorLine    cterm=NONE ctermbg=Grey

  highlight DiffAdd     cterm=bold ctermfg=Yellow ctermbg=DarkGreen gui=bold guifg='Yellow' guibg='DarkGreen'
  highlight DiffChange  cterm=bold ctermfg=Blue   ctermbg=Yellow    gui=bold guifg='Blue'   guibg='Yellow'
  highlight DiffText    cterm=bold ctermfg=Yellow ctermbg=Red       gui=bold guifg='Yellow' guibg='Red'
  highlight DiffDelete                            ctermbg=Red                               guibg='Red'

  highlight link LspDiagnosticsDefaultError       Error
  highlight link LspDiagnosticsDefaultWarning     Todo
  highlight link LspDiagnosticsDefaultHint        Todo
  highlight link LspDiagnosticsDefaultInformation Todo

  highlight Pmenu gui=NONE guibg=Grey
"
endfunction
" end customize highlight
"}}}
" end self defined functions
"}}}
" save and load view  自動讀取與儲存手動的折疊{{{
autocmd BufWinLeave * silent! mkview
autocmd BufWinEnter * silent! loadview
" end save and load view
"}}}
" minimal completion base on syntax  基於語法的補全{{{
autocmd FileType * if &omnifunc == "" | setlocal omnifunc=syntaxcomplete#Complete | endif
" end minimal completion base on syntax
"}}}
" plugin settings  插件設定{{{
" vim-plug settings  vim-plug 插件設定（用來管理其他插件的插件）  plugin for manage other plugins  https://github.com/junegunn/vim-plug{{{
if filereadable( $HOME . '/.vim/autoload/plug.vim' )
"
  call plug#begin( flotisable.pluginRoot )

  " basic plugins  基本的插件{{{
  Plug 'arcticicestudio/nord-vim'
  Plug 'AndrewRadev/bufferize.vim'  " make command output a buffer  將指令輸出變成 buffer
  Plug 't9md/vim-quickhl'           " mark plugin  標記插件

  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle'                  } " plugin for display directory as tree view  樹狀顯示資料夾的插件
  Plug 'majutsushi/tagbar',   { 'on': [ 'Tagbar', 'TagbarCurrentTag' ]  } " plugin for display tags( depend on 'ctags' )  顯示 tag 的插件（需搭配 ctags ）

  if v:version >= 800
    Plug 'JMcKiern/vim-venter' " center the text in a window  將視窗文字置中
  endif
  " end basic plugins
  "}}}
  " plugin for interactive finder and dispatcher  互動式查詢{{{
  if has( 'nvim-0.4.2' ) || has( 'patch-8.1.2114' )
    Plug 'liuchengxu/vim-clap', { 'do': { -> clap#installer#force_download() } }
  endif
  " end plugin for interactive finder and dispatcher  互動式查詢
  "}}}
  " terminal plugin  終端機插件{{{
  if has( 'nvim' ) || has( 'terminal' )
    Plug 'kassio/neoterm'
  endif
  " end terminal plugin  終端機插件
  "}}}
  " language specific plugins  特定語言的插件{{{
  if has( 'nvim-0.5' ) && ( executable( 'gcc' ) || executable( 'clang' ) )
    Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  else
  "
    Plug 'octol/vim-cpp-enhanced-highlight'
    Plug 'cespare/vim-toml'
  "
  endif

  Plug 'vim-perl/vim-perl', { 'do': 'make clean moose' }
  Plug 'pprovost/vim-ps1'
  " end language specific plugins
  "}}}
  " plugin for autocomplete  自動補全的插件{{{
  if  v:version >= 702 && has( 'insert_expand' ) && has( 'menu' )
    Plug 'lifepillar/vim-mucomplete'
  else " when 'vim' version is older  當 vim 版本較低時
    Plug 'shougo/neocomplcache.vim'
  endif
  " end plugin for autocomplete
  "}}}
  " language server protocal client  LSP 客戶端{{{
  if has( 'nvim' ) || v:version >= 800
  "
    if has( 'nvim-0.5' )
      Plug 'neovim/nvim-lspconfig'
    else
    "
      Plug 'autozimu/LanguageClient-neovim',
        \ {
        \   'branch': 'next',
        \   'do':     has( 'win32' )  ? 'powershell -executionpolicy bypass -File install.ps1'
        \                             : 'bash install.sh'
        \ }
    "
    endif
  "
  endif
  " end language server protocal client
  "}}}
  " VCS diff plugin  版本控制差異插件{{{
  if has( 'nvim' ) || has( 'patch-8.0.902' )
    Plug 'mhinz/vim-signify'
  else
    Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
  endif
  " end VCS diff plugin
  "}}}
  " code snippet plugin  程式碼片段插件{{{
  Plug 'MarcWeber/vim-addon-mw-utils'
  Plug 'tomtom/tlib_vim'
  Plug 'garbas/vim-snipmate'
  " end code snippet plugin
  "}}}
  " self use plugin  個人使用的插件{{{
  Plug 'flotisable/FlotisableStatusLine', {'branch':'develop'}  " self use statusline plugin  個人使用的狀態列設定插件
  Plug 'flotisable/FlotisableVimSnippets'                       " self use code snippet  個人使用的程式碼片段
  " end self use plugin}}}
  call plug#end()
"
endif
" end vim-plug settings
"}}}
" bufferize settings  bufferize 插件設定{{{
if FlotisablePluginExistsAndInRtp( 'bufferize.vim' )
"
  noremap <Leader>bb :Bufferize |       " set \bb to bufferize command  設定 \bb bufferize vim 命令
  noremap <Leader>bs :BufferizeSystem | " set \bs to bufferize system commad  設定 \bs bufferize 系統命令
  noremap <Leader>bn :Bufferize norm |  " set \bn to bufferize normal mode command  設定 \bn bufferize vim 一般模式命令
"
endif
" end bufferize settings
"}}}
" mark plugin settings  標記插件設定{{{
if FlotisablePluginExistsAndInRtp( 'vim-quickhl' )
"
  nmap <Leader>m <Plug>(quickhl-manual-this)|   " set \m key to set mark  設定 \m 鍵設置標籤
  xmap <Leader>m <Plug>(quickhl-manual-this)|   " set \m key to set mark  設定 \m 鍵設置標籤
  nmap <Leader>M <Plug>(quickhl-manual-reset)|  " set \M key to clear mark  設定 \M 鍵清理標籤
  xmap <Leader>M <Plug>(quickhl-manual-reset)|  " set \M key to clear mark  設定 \M 鍵清理標籤
"
endif
" end mark plugin settings
"}}}
" venter settings  venter 插件設定{{{
if FlotisablePluginExistsAndInRtp( 'vim-venter' )
"
  let g:venter_use_textwidth = v:true

  nmap <Leader>C <Cmd>VenterToggle<Enter>| " set \C key to center window text  設定 \C 鍵置中視窗文字
"
endif
" end venter settings
"}}}
" nerdtree settings  nerdtree 插件設定{{{
if FlotisablePluginExists( 'nerdtree', 0 )
  noremap <C-x> <Cmd>NERDTreeToggle<Enter>| " set Ctrl+x key to toggle tree browser  設定 Ctrl+x 鍵開闔樹狀檢視器
endif
" end nerdtree settings
"}}}
" tagbar settings  tagbar 插件設定{{{
if FlotisablePluginExists( 'tagbar', 0 )
  noremap <Leader>t <Cmd>Tagbar<Enter>|           " set \t key to toggle tagbar  設定 \t 鍵開闔 tagbar
  noremap <Leader>T <Cmd>TagbarCurrentTag<Enter>| " set \T to show current tag  設定 \T 顯示現在的 tag
endif
" end tagbar settings
"}}}
" interactive finder plugin settings  互動式查詢插件設定{{{
if FlotisablePluginExistsAndInRtp( 'vim-clap' )
"
  let g:clap_theme  = 'material_design_dark'
  let g:clap_layout = {
                    \   'relative': 'editor',
                    \   'col':      '5%',
                    \   'row':      '10%',
                    \   'width':    '45%',
                    \   'height':   '80%'
                    \ }

  noremap <Leader>F <Cmd>Clap providers<Enter>| " set \fp key to open provider dispather  設定 \fp 鍵開啟模糊搜尋選單
  noremap g/        <Cmd>Clap blines<Enter>|    " set g/ key to search in file  設定 g/ 鍵在檔案中搜尋
  noremap gb        <Cmd>Clap buffers<Enter>|   " set gb key to search buffer  設定 gb 鍵搜尋 buffer
  noremap <Leader>f :Clap files |               " set \ff key to search file  設定 \ff 鍵搜尋檔案
  noremap <Leader>g :Clap grep2 |               " set \fg key to search file content  設定 \fg 鍵搜尋檔案內容

  if has( 'nvim' )
  "
    autocmd FileType clap_input inoremap <silent> <buffer> <C-n> <C-R>=clap#navigation#linewise( 'down' )<Enter>
    autocmd FileType clap_input inoremap <silent> <buffer> <C-p> <C-R>=clap#navigation#linewise( 'up'   )<Enter>
  "
  else
  "
    let g:clap_popup_move_manager = {
                                  \ "\<C-N>": "\<Down>",
                                  \ "\<C-P>": "\<Up>",
                                  \ }
  "
  endif
"
endif
" end interactive finder plugin settings
"}}}
" neoterm settings  neoterm 插件設定{{{
if FlotisablePluginExistsAndInRtp( 'neoterm' )
"
  let g:neoterm_autoinsert  = 1       " 開啟終端機後進入終端機模式  enter terminal mode after open the terminal
  let g:neoterm_default_mod = ":tab"  " 設定以 tab 開啟終端機  open terminal in a tab

  if has( 'win32' )
    let g:neoterm_shell = &shell . ' #'
  endif

  noremap   <C-s> <Cmd>Ttoggle<Enter>| " set Ctrl+s key to toggle terminal  設定 Ctrl+s 鍵開闔終端機
  tnoremap  <C-s> <Cmd>Ttoggle<Enter>| " set Ctrl+s key to toggle terminal  設定 Ctrl+s 鍵開闔終端機
"
endif
" end neoterm settings
"}}}
" vim-cpp-enhanced-highlight settings  C++ 語法高亮插件設定{{{
if FlotisablePluginExistsAndInRtp( 'vim-cpp-enhanced-highlight' )
"
  let g:cpp_class_scope_highlight     = 1
  let g:cpp_member_variable_highlight = 1
  let g:cpp_class_decl_highlight      = 1
"
endif
" end vim-cpp-enhanced-highlight settings
"}}}
" nvim-treesitter settings  nvim-treesitter 設定{{{
if FlotisablePluginExistsAndInRtp( 'nvim-treesitter' )
"
  lua << EOF
    require'nvim-treesitter.configs'.setup
    {
      ensure_installed  = { 'cpp', 'rust', 'toml', 'vim', 'lua' },
      highlight         = { enable = true }
    }
EOF
"
endif
" end nvim-treesitter settings
"}}}
" completion plugin settings  補全插件設定{{{
if FlotisablePluginExistsAndInRtp( 'vim-mucomplete' )
"
  let g:mucomplete#no_mappings = 1

  " to work with vim-clap
  autocmd FileType    clap_input  MUcompleteAutoOff
  autocmd InsertEnter *           if &filetype != 'clap_input' | MUcompleteAutoOn | endif
"
elseif FlotisablePluginExistsAndInRtp( 'neocomplcache.vim' )
"
  " the plugin has the issue that it can auto insert the completion when set
  " noselect in completeopt
  let g:neocomplcache_omni_patterns = { '_': '\w\+' }

  autocmd InsertEnter * NeoComplCacheEnable
"
endif
" end completion plugin settings
"}}}
" LSP client settings  LSP 客戶端設定{{{
if FlotisablePluginExistsAndInRtp( 'nvim-lspconfig' )
"
  " sign setup  符號設定{{{
  call sign_define( 'LspDiagnosticsSignError',
    \ { 'text': "✖", 'texthl': 'LspDiagnosticsSignError' } )
  call sign_define( 'LspDiagnosticsSignWarning',
    \ { 'text': "⚠", 'texthl': 'LspDiagnosticsSignWarning' } )
  call sign_define( 'LspDiagnosticsSignHint',
    \ { 'text': "➤", 'texthl': 'LspDiagnosticsSignHint' } )
  call sign_define( 'LspDiagnosticsSignInformation',
    \ { 'text': "ℹ", 'texthl': 'LspDiagnosticsSignInformation' } )
  " end sign setup
  "}}}
  lua << EOF
    local lsp = require'lspconfig'

    -- use lsp omni function when a language server is attached{{{
    local function flotisableOnAttach( client, buffer )
      vim.api.nvim_buf_set_option( buffer, 'omnifunc', 'FlotisableBuildInLspOmniFunc' )
      vim.fn.FlotisableLspMaps( true )
    end

    lsp.util.default_config = vim.tbl_extend(
      "force",
      lsp.util.default_config,
      { on_attach = flotisableOnAttach }
    )
    -- end use lsp omni function when a language server is attached
    --}}}
    -- show diagnostics in quick fix list{{{
    local defaultHandler  = vim.lsp.diagnostic.on_publish_diagnostics
    local nvimVersion     = vim.version()

    local function flotisableOnPublishDiagnosticCore( result, clientId )
      if not result or #result.diagnostics == 0 then
        do return end
      end
      for _, v in ipairs( result.diagnostics ) do
        v.bufnr = clientId
        v.lnum  = v.range.start.line + 1
        v.col   = v.range.start.character + 1
        v.text  = v.message
      end
      vim.lsp.util.set_qflist( result.diagnostics )
    end

    if nvimVersion.minor > 5 or nvimVersion == 5 and nvimVersion.patch == 1 then
      vim.lsp.diagnostic.on_publish_diagnostics = function( error, result, context, config )
        defaultHandler( error, result, context, config )
        flotisableOnPublishDiagnosticCore( result, context.clientId )
      end
    else
      vim.lsp.diagnostic.on_publish_diagnostics = function( error, method, result, clientId, bufnr, config )
        defaultHandler( error, method, result, clientId, buffnr, config )
        flotisableOnPublishDiagnosticCore( result, clientId )
      end
    end
    -- end show diagnostics in quick fix list
    --}}}
    -- language setup{{{
    lsp.clangd.setup{}
    lsp.bashls.setup{}
    lsp.vimls.setup{}
    lsp.perlls.setup{}
    lsp.rust_analyzer.setup{}
    lsp.efm.setup
    {
      filetypes = { 'raku' }
    }
    lsp.powershell_es.setup
    {
      bundle_path = vim.g.flotisable.powershellBundlePath
    }
    lsp.pylsp.setup{}
    -- language setup
    --}}}
EOF
  " key mappings{{{
  noremap <Leader>lo <Cmd>LspStart<Enter>|  " set \lo key to start language client  設定 \lo 鍵啟動 LSP 客戶端
  noremap <Leader>lc <Cmd>LspStop<Enter>|   " set \lc key to stop language client  設定 \lc 鍵關閉 LSP 客戶端

  " set gd key to go to definition  設定 gd 鍵跳至定義
  " set gr key to show reference  設定 gr 鍵顯示參照
  " set K key to showhover  設定 K 鍵顯示文檔
  let g:flotisable.keybindings.lsp = {
    \   'global': {
    \     'gd': '<Cmd>lua vim.lsp.buf.definition()<Enter>',
    \     'gr': '<Cmd>lua vim.lsp.buf.references()<Enter>',
    \     'K':  '<Cmd>lua vim.lsp.buf.hover()<Enter>'
    \   },
    \   'cpp': {
    \     '<Leader>a': '<Cmd>ClangdSwitchSourceHeader<Enter>'
    \   }
    \ }
  " end key mappings
  "}}}
"
elseif FlotisablePluginExistsAndInRtp( 'LanguageClient-neovim' )
"
  let g:LanguageClient_serverCommands = {
    \ 'cpp':    ['clangd'],
    \ 'sh':     ['bash-language-server','start'],
    \ 'vim':    ['vim-language-server','--stdio'],
    \ 'rust':   ['rust-analyzer'],
    \ 'raku':   ['efm-langserver'],
    \ 'python': ['pylsp']
    \ }

  noremap <Leader>lo <Cmd>LanguageClientStart<Enter>| " set \lo key to statr language client  設定 \lo 鍵啟動 LSP 客戶端
  noremap <Leader>lc <Cmd>LanguageClientStop<Enter>|  " set \lc key to stop language client  設定 \lc 鍵關閉 LSP 客戶端

  " set gd key to go to definition  設定 gd 鍵跳至定義
  " set gr key to show reference  設定 gr 鍵顯示參照
  " set K key to showhover  設定 K 鍵顯示文檔
  let g:flotisable.keybindings.lsp = {
    \   'global': {
    \     'gd': '<Plug>(lcn-definition)',
    \     'gr': '<Plug>(lcn-references)',
    \     'K':  '<Plug>(lcn-hover)'
    \   },
    \   'cpp': {
    \     '<Leader>a': '<Cmd>call LanguageClient#Call( "textDocument/switchSourceHeader", { "uri": expand("%") }, v:null )<Enter>'
    \   }
    \ }

  autocmd Filetype * call FlotisableLspMaps( v:false )
"
endif
" end LSP client settings
"}}}
" VCS diff plugin settings  版本控制差異插件設定{{{
if FlotisablePluginExistsAndInRtp( 'vim-signify' )
"
  set updatetime=100

  let g:signify_disable_by_default = 1

  noremap <Leader>s <Cmd>SignifyToggle<Enter>|    " set \s key to toggle VCS diff  設定 \s 鍵開闔版本控制差異
  noremap <Leader>d <Cmd>SignifyHunkDiff<Enter>|  " set \d key to show hunk diff  設定 \d 鍵顯示片段差異
  noremap <Leader>u <Cmd>SignifyHunkUndo<Enter>|  " set \u key to undo hunk  設定 \u 鍵回復片段
  noremap <Leader>D <Cmd>SignifyDiff<Enter>|      " set \D key to show full diff  設定 \D 鍵顯示檔案差異
"
endif
" end VCS diff plugin settings
"}}}
" code snippet settings  code snippet 設定{{{
if FlotisablePluginExistsAndInRtp( 'vim-snipmate' )
"
  let g:snips_author              = g:flotisable.snippetAuthor
  let g:snipMate                  = {}
  let g:snipMate.snippet_version  = 1

  imap <C-s> <Plug>snipMateShow| " set C-s to show snip candidates  設定 C-s 顯示可用程式碼片段

  " use Ctrl+n, Ctrl+p to select multiple snippet  用 Ctrl+n, Ctrl+p 選擇程式片段
  let g:tlib_extend_keyagents_InputList_s = {
    \ 16: 'tlib#agent#Up',
    \ 14: 'tlib#agent#Down'
    \ }
"
endif
" end code snippet settings
"}}}
" end plugin settings
"}}}
" highlight setup  高亮設定{{{
if FlotisablePluginExistsAndInRtp( 'nord-vim' )
  colorscheme nord
elseif has( 'gui_running' ) " colorscheme in gui  圖形介面顏色主題
  colorscheme desert
else                        " colorscheme in terminal  終端機顏色主題
  colorscheme elflord
endif

call FlotisableCustomHighlight()

autocmd ColorScheme * call FlotisableCustomHighlight()
" end highlight setup
"}}}
" key mapping  快捷鍵設定{{{
if has( 'nvim' ) || has( 'terminal' )
  tnoremap  <C-q> <C-\><C-n>| " set Ctrl+q key to exit terminal mode  設定 Ctrl+q 鍵離開 terminal 模式
endif

noremap <Leader>r <Cmd>set relativenumber!<Enter>|            " 設定 \r 鍵開關相對行號設定
noremap <Leader>c <Cmd>set cursorline! cursorcolumn!<Enter>|  " 設定 \c 鍵開關游標高亮
noremap <Leader>L <Cmd>set list!<Enter>|                      " 設定 \L 開關特殊字元顯示

nnoremap  <Space> <C-F>
nnoremap  <BS>    <C-B>
xnoremap  <Space> <C-F>
xnoremap  <BS>    <C-B>
noremap!  <C-a>   <Home>
noremap!  <C-e>   <End>
noremap!  <C-f>   <Right>
noremap!  <C-b>   <Left>
noremap!  <C-p>   <Up>
noremap!  <C-n>   <Down>
noremap!  <C-k>   <C-e><C-u>
noremap!  <C-d>   <Del>

if has( "cscope" )
"
  nnoremap <C-_>s <Cmd>execute 'cscope find s' expand("<cword>")<CR>
  nnoremap <C-_>g <Cmd>execute 'cscope find g' expand("<cword>")<CR>
  nnoremap <C-_>c <Cmd>execute 'cscope find c' expand("<cword>")<CR>
  nnoremap <C-_>t <Cmd>execute 'cscope find t' expand("<cword>")<CR>
  nnoremap <C-_>e <Cmd>execute 'cscope find e' expand("<cword>")<CR>
  nnoremap <C-_>f <Cmd>execute 'cscope find f' expand("<cword>")<CR>
  nnoremap <C-_>i <Cmd>execute 'cscope find i' expand("<cword>")<CR>
  nnoremap <C-_>d <Cmd>execute 'cscope find d' expand("<cword>")<CR>
"
endif
" end key mapping
"}}}
" vim: foldmethod=marker foldmarker={{{,}}}