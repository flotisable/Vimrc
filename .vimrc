" option settings  選項設定{{{
set encoding    =utf-8  " set file encoding  設定編碼
set number              " display line number  顯示行號
set showcmd             " show the command at the status bar  顯示指令在狀態列（知道自己輸入什麼）
set laststatus  =2      " show the status line  顯示狀態列
set autoindent          " automatic indent as last line  自動縮排（與上一行縮排相同
set smartindent         " smart indent based on {}  根據大括號縮排
set foldmethod  =manual " manual fold the code  手動折疊程式碼
set tabstop     =2      " set TAB key to be equivalent to how many spaces  設定 tab 鍵等於幾個空白鍵
set shiftwidth  =0      " use same number of spaces for indent as tabstop  設定縮排時用 tabstop 的空白鍵數量
set expandtab           " expand TAB key to be spaces  將 tab 鍵展開為空白鍵
set hlsearch            " highlight the searched pattern  高亮搜尋的 pattern
set incsearch           " enable incremental search  開啟遞增搜尋

set errorformat ^=%D%*[^:]:\ Entering\ directory\ '%f',%X%*[^:]:\ Leaving\ directory\ '%f'
set viewoptions =folds,cursor,curdir

if has( 'nvim' )
"
  set jumpoptions=stack
"
endif

if has( 'patch-7.4.775' )
"
  set completeopt=menuone,noinsert
"
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
" test pluggin existence  檢測插件是否存在{{{
" this function is add since old vim not support optional argument
function! FlotisablePluginExistsAndInRtp( name )
"
  return FlotisablePluginExists( a:name, 1 )
"
endfunction

function! FlotisablePluginExists( name, isCheckRtp )
"
  if !exists( 'g:plug_home' )
  "
    echo 'g:plug_home not defined'
    return 0
  "
  endif

  let l:fullPath = expand( printf( '%s/%s', g:plug_home, a:name ) )

  return isdirectory( l:fullPath ) && ( !a:isCheckRtp || stridx( &runtimepath, a:name ) != -1 )
"
endfunction
" end test pluggin existence
"}}}
" interactive fuzzy finder settings  互動式查詢設定{{{
function! FlotisableToggleClapPreviewDirection()
"
  if !FlotisablePluginExistsAndInRtp( 'vim-clap' )
  "
    echo "Plugin vim-clap not installed"
    return
  "
  endif

  if !exists( 'g:clap_preview_direction' )
  "
    let g:clap_preview_direction = 'LR'
  "
  endif

  if g:clap_preview_direction == 'LR'
  "
    let g:clap_preview_direction  = 'UD'
    let g:clap_layout.width       = '90%'
    let g:clap_layout.height      = '40%'
  "
  else
  "
    let g:clap_preview_direction  = 'LR'
    let g:clap_layout.width       = '45%'
    let g:clap_layout.height      = '80%'
  "
  endif

  echo "Clap preview direction changes to '" .. g:clap_preview_direction .. "'"
"
endfunction
" end interactive fuzzy finder settings
"}}}
" wrapper of build in lsp omnifunc  內建 lsp omnifunc 的 wrapper{{{
" this wrapper function it to make neovim build in lsp omni function work
" with deoplete and neocomplcache
function! FlotisableBuildInLspOmniFunc( findstart, base )
"
  return v:lua.vim.lsp.omnifunc( a:findstart, a:base )
"
endfunction
" end wrapper of build in lsp omnifunc
"}}}
" setup buffer local keybinding for lsp  設定 lsp buffer local 的按鍵{{{
function! FlotisableLspMaps( isNvimBuiltin )
"
  if  !exists( 'g:flotisable.keybindings.lsp' ) ||
      ( !a:isNvimBuiltin && !has_key( g:LanguageClient_serverCommands, &filetype ) )
  "
    return
  "
  endif

  let l:mapFormat = 'map <buffer> <silent> %s %s'

  if exists( 'g:flotisable.keybindings.lsp.global' )
  "
    for key in keys( g:flotisable.keybindings.lsp.global )
    "
      execute printf( l:mapFormat, key, g:flotisable.keybindings.lsp.global[key] )
    "
    endfor
  "
  endif

  if exists( 'g:flotisable.keybindings.lsp["' .. &filetype .. '"]' )
  "
    for key in keys( g:flotisable.keybindings.lsp[&filetype] )
    "
      execute printf( l:mapFormat, key, g:flotisable.keybindings.lsp[&filetype][key] )
    "
    endfor
  "
  endif
"
endfunction
" end setup buffer local keybinding for LanguageClient-neovim
"}}}
" customize highlight  設定圖形介面的顏色{{{
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
autocmd FileType *
  \ if &omnifunc == ""                          |
  \   setlocal omnifunc=syntaxcomplete#Complete |
  \ endif
" end minimal completion base on syntax
"}}}
" plugin settings  插件設定{{{
" vim-plug settings  vim-plug 插件設定（用來管理其他插件的插件）  plugin for manage other plugins  https://github.com/junegunn/vim-plug{{{
if filereadable( globpath( &runtimepath, 'autoload/plug.vim' ) )
"
  let g:pluginRoot = '~/.vim/plugged'

  call plug#begin( pluginRoot )

  Plug 'fabi1cazenave/kalahari.vim'

  Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle'  } " plugin for display directory as tree view  樹狀顯示資料夾的插件
  Plug 'majutsushi/tagbar',   { 'on': 'Tagbar'          } " plugin for display tags( depend on 'ctags' )  顯示 tag 的插件（需搭配 ctags ）
  Plug 'AndrewRadev/bufferize.vim'                        " make command output a buffer  將指令輸出變成 buffer

  " plugin for interactive finder and dispatcher  互動式查詢{{{
  if has( 'nvim-0.4.2' ) || has( 'patch-8.1.2114' )
  "
    Plug 'liuchengxu/vim-clap', { 'do': { -> clap#installer#force_download() } }
  "
  endif
  " end plugin for interactive finder and dispatcher  互動式查詢
  "}}}
  " terminal plugin  終端機插件{{{
  if has( 'nvim' ) || has( 'terminal' )
  "
    Plug 'kassio/neoterm'
  "
  endif
  " end terminal plugin  終端機插件
  "}}}
  " language specific plugins  特定語言的插件{{{
  if has( 'nvim-0.5' ) && ( executable( 'gcc' ) || executable( 'clang' ) )
  "
    Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  "
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
  "
    Plug 'lifepillar/vim-mucomplete'
  "
  elseif has( 'nvim-0.5' )
  "
    Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'ray-x/cmp-treesitter'
    Plug 'hrsh7th/cmp-omni'
  "
  elseif ( has( 'nvim' ) || v:version >= 800 ) && has( 'python3' )
  "
    Plug 'Shougo/neco-syntax'
    Plug 'Shougo/deoplete.nvim', has( 'nvim' ) ? { 'do': ':UpdateRemotePlugins' }: {}

    if !has( 'nvim' )
    "
      Plug 'roxma/nvim-yarp'
      Plug 'roxma/vim-hug-neovim-rpc'
    "
    endif
  "
  else " when 'vim' version is older  當 vim 版本較低時
  "
    Plug 'shougo/neocomplcache.vim'
  "
  endif
  " end plugin for autocomplete
  "}}}
  " language server protocal client  LSP 客戶端{{{
  if has( 'nvim' ) || v:version >= 800
  "
    if has( 'nvim-0.5' )
    "
      Plug 'neovim/nvim-lspconfig'
    "
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
  " mark plugin  標記插件{{{
  Plug 'inkarkat/vim-ingo-library'
  Plug 'inkarkat/vim-mark'
  " end mark plugin
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
"
endif
" end interactive finder plugin settings
"}}}
" completion plugin settings  補全插件設定{{{
if FlotisablePluginExistsAndInRtp( 'vim-mucomplete' )
"
  let g:mucomplete#no_mappings = 1

  autocmd InsertEnter * MUcompleteAutoOn
"
elseif FlotisablePluginExistsAndInRtp( 'nvim-cmp' )
"
  lua <<EOF
    require'cmp'.setup
    {
      sources =
      {
        { name = 'nvim_lsp'   },
        { name = 'buffer'     },
        { name = 'path'       },
        { name = 'treesitter' },
        { name = 'omni'       },
      }
    }
EOF
"
elseif FlotisablePluginExistsAndInRtp( 'deoplete.nvim' )
"
  let g:python3_host_prog = "python3"

  autocmd InsertEnter * call deoplete#custom#var( 'omni', 'input_patterns', { '_': '\w+' } )
  autocmd InsertEnter * call deoplete#enable()
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
  call sign_define( 'LspDiagnosticsSignError',
    \ { 'text': "✖", 'texthl': 'LspDiagnosticsSignError' } )
  call sign_define( 'LspDiagnosticsSignWarning',
    \ { 'text': "⚠", 'texthl': 'LspDiagnosticsSignWarning' } )
  call sign_define( 'LspDiagnosticsSignHint',
    \ { 'text': "➤", 'texthl': 'LspDiagnosticsSignHint' } )
  call sign_define( 'LspDiagnosticsSignInformation',
    \ { 'text': "ℹ", 'texthl': 'LspDiagnosticsSignInformation' } )

  lua << EOF
    local lsp = require'lspconfig'

    -- use lsp omni function when a language server is attached
    local function flotisableOnAttach( client, buffer )
      vim.api.nvim_buf_set_option( buffer, 'omnifunc', 'FlotisableBuildInLspOmniFunc' )
      vim.fn.FlotisableLspMaps( true )
    end

    lsp.util.default_config = vim.tbl_extend(
      "force",
      lsp.util.default_config,
      {
        on_attach = flotisableOnAttach
      }
    )
    -- end use lsp omni function when a language server is attached

    -- show diagnostics in quick fix list
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

    if nvimVersion.minor == 5 and nvimVersion.patch == 1 then
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
      bundle_path = '/home/flotisable/Applications/PowerShellEditorServices'
    }
EOF
"
elseif FlotisablePluginExistsAndInRtp( 'LanguageClient-neovim' )
"
  let g:LanguageClient_serverCommands = {
    \ 'cpp':  ['clangd'],
    \ 'sh':   ['bash-language-server','start'],
    \ 'vim':  ['vim-language-server','--stdio'],
    \ 'rust': ['rust-analyzer'],
    \ 'raku': ['efm-langserver']
    \ }
"
endif
" end LSP client settings
"}}}
" VCS diff plugin settings  版本控制差異插件設定{{{
if FlotisablePluginExistsAndInRtp( 'vim-signify' )
"
  set updatetime=100

  let g:signify_disable_by_default = 1
"
endif
" end VCS diff plugin settings
"}}}
" mark plugin settings  標記插件設定{{{
if FlotisablePluginExistsAndInRtp( 'vim-mark' )
"
  let g:mwAutoLoadMarks = 1
  let g:mw_no_mappings  = 1
"
endif
" end mark plugin settings
"}}}
" neoterm settings  neoterm 插件設定{{{
if FlotisablePluginExistsAndInRtp( 'neoterm' )
"
  let g:neoterm_autoinsert  = 1       " 開啟終端機後進入終端機模式  enter terminal mode after open the terminal
  let g:neoterm_default_mod = ":tab"  " 設定以 tab 開啟終端機  open terminal in a tab

  if has( 'win32' )
  "
    let g:neoterm_shell = &shell .. ' #'
  "
  endif
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
" code snippet settings  code snippet 設定{{{
if FlotisablePluginExistsAndInRtp( 'vim-snipmate' )
"
  let g:snips_author              = "Flotisable"
  let g:snipMate                  = {}
  let g:snipMate.snippet_version  = 1
"
endif
" end code snippet settings
"}}}
" tlib_vim settings  tlib_vim 設定{{{
if FlotisablePluginExistsAndInRtp( 'tlib_vim' )
"
  " use Ctrl+n, Ctrl+p to select multiple snippet  用 Ctrl+n, Ctrl+p 選擇程式片段
  let g:tlib_extend_keyagents_InputList_s = {
    \ 16: 'tlib#agent#Up',
    \ 14: 'tlib#agent#Down'
    \ }
"
endif
" end tlib_vim settings
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
" end plugin settings
"}}}
" highlight setup  高亮設定{{{
" setup colorscheme for terminal and gui  根據終端與圖形設置不同的顏色主題{{{
if has( 'gui_running' )
  colorscheme kalahari  " colorscheme in gui  圖形介面顏色主題
else
  colorscheme elflord   " colorscheme in terminal  終端機顏色主題
endif
" end setup colorscheme for terminal and gui
"}}}
call FlotisableCustomHighlight()

autocmd ColorScheme * call FlotisableCustomHighlight()
" end highlight setup
"}}}
" key mapping  快捷鍵設定{{{
" neoterm key mapping{{{
if FlotisablePluginExistsAndInRtp( 'neoterm' )
"
  noremap   <C-s> <Cmd>Ttoggle<Enter>| " set Ctrl+s key to toggle terminal  設定 Ctrl+s 鍵開闔終端機
  tnoremap  <C-s> <Cmd>Ttoggle<Enter>| " set Ctrl+s key to toggle terminal  設定 Ctrl+s 鍵開闔終端機
"
endif
" end neoterm key mapping
"}}}
" nerdtree key mapping{{{
if FlotisablePluginExists( 'nerdtree', 0 )
"
  noremap <C-x> <Cmd>NERDTreeToggle<Enter>| " set Ctrl+x key to toggle tree browser  設定 Ctrl+x 鍵開闔樹狀檢視器
"
endif
" end nerdtree key mapping
"}}}
" tagbar key mapping{{{
if FlotisablePluginExists( 'tagbar', 0 )
"
  noremap <Leader>t <Cmd>Tagbar<Enter>| " set \t key to toggle tagbar  設定 \t 鍵開闔 tagbar
"
endif
" end tagbar key mapping
"}}}
" vim-signify key mapping{{{
if FlotisablePluginExistsAndInRtp( 'vim-signify' )
"
  noremap <Leader>s <Cmd>SignifyToggle<Enter>|    " set \s key to toggle VCS diff  設定 \s 鍵開闔版本控制差異
  noremap <Leader>d <Cmd>SignifyHunkDiff<Enter>|  " set \d key to show hunk diff  設定 \d 鍵顯示片段差異
  noremap <Leader>u <Cmd>SignifyHunkUndo<Enter>|  " set \u key to undo hunk  設定 \u 鍵回復片段
  noremap <Leader>D <Cmd>SignifyDiff<Enter>|      " set \D key to show full diff  設定 \D 鍵顯示檔案差異
"
endif
" end vim-signify key mapping
"}}}
" lsp key mappings{{{
if FlotisablePluginExistsAndInRtp( 'nvim-lspconfig' )
"
  noremap <Leader>lo <Cmd>LspStart<Enter>|  " set \lo key to start language client  設定 \lo 鍵啟動 LSP 客戶端
  noremap <Leader>lc <Cmd>LspStop<Enter>|   " set \lc key to stop language client  設定 \lc 鍵關閉 LSP 客戶端

  " set gd key to go to definition  設定 gd 鍵跳至定義
  " set gr key to show reference  設定 gr 鍵顯示參照
  " set K key to showhover  設定 K 鍵顯示文檔
  let g:flotisable = {
    \   'keybindings': {
    \     'lsp': {
    \       'global': {
    \         'gd': '<Cmd>lua vim.lsp.buf.definition()<Enter>',
    \         'gr': '<Cmd>lua vim.lsp.buf.references()<Enter>',
    \         'K':  '<Cmd>lua vim.lsp.buf.hover()<Enter>'
    \       },
    \       'cpp': {
    \         '<Leader>a': '<Cmd>ClangdSwitchSourceHeader<Enter>'
    \       }
    \     }
    \   }
    \ }
"
elseif FlotisablePluginExistsAndInRtp( 'LanguageClient-neovim' )
"
  noremap <Leader>lo <Cmd>LanguageClientStart<Enter>| " set \lo key to statr language client  設定 \lo 鍵啟動 LSP 客戶端
  noremap <Leader>lc <Cmd>LanguageClientStop<Enter>|  " set \lc key to stop language client  設定 \lc 鍵關閉 LSP 客戶端


  " set gd key to go to definition  設定 gd 鍵跳至定義
  " set gr key to show reference  設定 gr 鍵顯示參照
  " set K key to showhover  設定 K 鍵顯示文檔
  let g:flotisable = {
    \   'keybindings': {
    \     'lsp': {
    \       'global': {
    \         'gd': '<Plug>(lcn-definition)',
    \         'gr': '<Plug>(lcn-references)',
    \         'K':  '<Plug>(lcn-hover)'
    \       },
    \       'cpp': {
    \         '<Leader>a': '<Cmd>call LanguageClient#Call( "textDocument/switchSourceHeader", { "uri": expand("%") }, v:null )<Enter>'
    \       }
    \     }
    \   }
    \ }

  autocmd Filetype * call FlotisableLspMaps( v:false )
"
endif
" end lsp key mappings
"}}}
" vim-mark key mappings{{{
if FlotisablePluginExistsAndInRtp( 'vim-mark' )
"
  nmap  <Leader>ms <Plug>MarkSet|   " set \ms key to set mark  設定 \ms 鍵設置標籤
  xmap  <Leader>ms <Plug>MarkSet|   " set \ms key to set mark  設定 \ms 鍵設置標籤
  nmap  <Leader>mr <Plug>MarkRegex| " set \mr key to set mark using regular expression  設定 \mr 鍵使用正規表示式設置標籤
  xmap  <Leader>mr <Plug>MarkRegex| " set \mr key to set mark using regular expression  設定 \mr 鍵使用正規表示式設置標籤
  map   <Leader>mc <Plug>MarkClear| " set \mc key to clear mark  設定 \mc 鍵清理標籤
"
endif
" end vim-mark key mappings
"}}}
" interactive finder key mappings{{{
if FlotisablePluginExistsAndInRtp( 'vim-clap' )
"
  noremap <Leader>fp <Cmd>Clap providers<Enter>|                              " set \fp key to open provider dispather  設定 \fp 鍵開啟模糊搜尋選單
  noremap <Leader>f/ <Cmd>Clap blines<Enter>|                                 " set \f/ key to search in file  設定 \f/ 鍵在檔案中搜尋
  noremap <Leader>fb <Cmd>Clap buffers<Enter>|                                " set \fb key to search buffer  設定 \fb 鍵搜尋 buffer
  noremap <Leader>fd <Cmd>call FlotisableToggleClapPreviewDirection()<Enter>| " set \fd to toggle preview direction  設定 \fd 切換預覽方向
  noremap <Leader>ff :Clap files |                                            " set \ff key to search file  設定 \ff 鍵搜尋檔案
  noremap <Leader>fg :Clap grep2 |                                            " set \fg key to search file content  設定 \fg 鍵搜尋檔案內容

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
" end interactive finder key mappings
"}}}
" vim-snipmate key mappings{{{
if FlotisablePluginExistsAndInRtp( 'vim-snipmate' )
"
  imap <C-s> <Plug>snipMateShow| " set C-s to show snip candidates  設定 C-s 顯示可用程式碼片段
"
endif
" end vim-snipmate key mappings
"}}}
" bufferize key mappings{{{
if FlotisablePluginExistsAndInRtp( 'bufferize.vim' )
"
  noremap <Leader>bb :Bufferize |       " set \bb to bufferize command  設定 \bb bufferize vim 命令
  noremap <Leader>bs :BufferizeSystem | " set \bs to bufferize system commad  設定 \bs bufferize 系統命令
  noremap <Leader>bn :Bufferize norm |  " set \bn to bufferize normal mode command  設定 \bn bufferize vim 一般模式命令
"
endif
" end bufferize key mappings
"}}}
" basic key mappings{{{
if has( 'nvim' ) || has( 'terminal' )
"
  tnoremap  <C-q> <C-\><C-n>| " set Ctrl+q key to exit terminal mode  設定 Ctrl+q 鍵離開 terminal 模式
"
endif

noremap   <Leader>r <Cmd>set relativenumber!<Enter>|            " 設定 \r 鍵開關相對行號設定
noremap   <Leader>c <Cmd>set cursorline! cursorcolumn!<Enter>|  " 設定 \c 鍵開關游標高亮

nnoremap  <Space>   <C-F>
nnoremap  <BS>      <C-B>
xnoremap  <Space>   <C-F>
xnoremap  <BS>      <C-B>
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
  nnoremap <C-_>s <Cmd>cscope find s <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-_>g <Cmd>cscope find g <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-_>c <Cmd>cscope find c <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-_>t <Cmd>cscope find t <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-_>e <Cmd>cscope find e <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-_>f <Cmd>cscope find f <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-_>i <Cmd>cscope find i <C-R>=expand("<cword>")<CR><CR>
  nnoremap <C-_>d <Cmd>cscope find d <C-R>=expand("<cword>")<CR><CR>
"
endif
" end basic key mappings}}}
" end key mapping
"}}}
" vim: foldmethod=marker foldmarker={{{,}}}
