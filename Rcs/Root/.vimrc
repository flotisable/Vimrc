" option settings  選項設定{{{
set encoding        =utf-8  " set file encoding  設定編碼
set relativenumber          " display relative line number  顯示相對行號
set showcmd                 " show command in status bar  顯示指令在狀態列（知道自己輸入什麼）
set laststatus      =2      " show the status line  顯示狀態列
set autoindent              " automatic indent as last line  自動縮排（與上一行縮排相同
set smartindent             " smart indent based on {}  根據大括號縮排
set foldmethod      =manual " manual fold the code  手動折疊程式碼
set textwidth       =80     " set column num  設定行數
set tabstop         =2      " set spaces num of TAB key  設定 tab 鍵等於幾個空白鍵
set shiftwidth      =2      " use same spaces num for indent as tabstop  設定縮排時用 tabstop 的空白鍵數量
set expandtab               " expand TAB key to be spaces  將 tab 鍵展開為空白鍵
set hlsearch                " highlight searched pattern  高亮搜尋的 pattern
set incsearch               " enable incremental search  開啟遞增搜尋
set wildmenu

set listchars   =tab:>\ ,trail:-,nbsp:+
set errorformat ^=%D%*[^:]:\ Entering\ directory\ '%f',%X%*[^:]:\ Leaving\ directory\ '%f'
set viewoptions =folds,cursor

if has( 'nvim' )
  set jumpoptions=stack
elseif v:version >= 900
  set wildoptions=pum
endif

if has( 'patch-7.4.775' )
  set completeopt=menuone,noinsert
endif

if has( 'win32' )
"
  set guifont       =Consolas:h14
  set shell         =powershell
  let &shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;'
  let &shellredir   = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  let &shellpipe    = '2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode'
  set shellquote    =
  set shellxquote   =
"
else
  set guifont=DejaVu\ Sans\ Mono:h14
endif

if has( "cscope" )
"
  if filereadable( "cscope.out" )
    cscope add cscope.out
  endif
  set cscopeverbose
"
endif
" end option settings
"}}}
" self defined settings  自定義設定{{{
let g:my =
  \ {
  \   'keybindings':          { 'lsp': {} },
  \   'pluginRoot':           $HOME . '/.vim/plugged',
  \   'powershellBundlePath': $HOME . '/Applications/PowerShellEditorServices',
  \   'snippetAuthor':        'Flotisable',
  \   'localVimrc':           $HOME . '/.vim/localVimrc',
  \   'pluginConditions':
  \   {
  \     'ui':               !exists( 'g:vscode' ),
  \     'vim8':             v:version >= 800,
  \     'vim-clap':         has( 'nvim-0.4.2' ) || has( 'patch-8.1.2114' ),
  \     'tree-sitter':      has( 'nvim-0.5' ) && ( executable( 'gcc' ) || executable( 'clang' ) ),
  \     'vim-mucomplete':   v:version >= 702 && has( 'insert_expand' ) && has( 'menu' ),
  \     'lsp':              has( 'nvim' ) || v:version >= 800,
  \     'nvim-lsp':         has( 'nvim-0.5' ),
  \     'vim-signify-new':  has( 'nvim' ) || has( 'patch-8.0.902' ),
  \     'vim-vsnip':        has( 'nvim-0.4.4' ) || has( 'patch-8.0.1567' )
  \   },
  \   'tagAdded': {}
  \ }
" end self defined settings
"}}}
" self defined functions  自定義的函式{{{
" test pluggin existence  檢測插件是否存在{{{
" this function is added since old vim not support optional argument
function! MyPluginExistsAndInRtp( name )
  return MyPluginExists( a:name, 1 )
endfunction

function! MyPluginExists( name, isCheckRtp )
"
  let l:fullName = g:my.pluginRoot . '/' . a:name

  return exists( 'g:plugs["' . a:name . '"]' ) && isdirectory( l:fullName ) && ( !a:isCheckRtp || stridx( &runtimepath, a:name ) != -1 )
"
endfunction
" end test pluggin existence
"}}}
" customize highlight  設定介面的顏色{{{
function! MyCustomHighlight()
"
  highlight CursorColumn  cterm=NONE ctermbg=DarkGrey
  highlight CursorLine    cterm=NONE ctermbg=DarkGrey

  highlight DiffAdd     cterm=bold ctermfg=DarkYellow   ctermbg=DarkGreen   gui=bold guifg='DarkYellow'   guibg='DarkGreen'
  highlight DiffChange  cterm=bold ctermfg=DarkBlue     ctermbg=DarkYellow  gui=bold guifg='DarkBlue'     guibg='DarkYellow'
  highlight DiffText    cterm=bold ctermfg=DarkYellow   ctermbg=DarkRed     gui=bold guifg='DarkYellow'   guibg='DarkRed'
  highlight DiffDelete  cterm=bold ctermfg=Magenta      ctermbg=DarkRed     gui=bold guifg='Magenta'      guibg='DarkRed'

  highlight Pmenu gui=NONE guibg=Grey
"
endfunction
" end customize highlight
"}}}
" add plugin  新增插件{{{
function! MyAddPlugin( name, tags, options )
"
  let l:subTagDemiliter = ':'
  let l:tags            = a:tags + [ fnamemodify( a:name, ':t' ) ]

  for l:tag in l:tags
  "
    let l:splits = split( l:tag, l:subTagDemiliter )
    let l:rootTag = l:splits[0]
    let l:subTags = l:splits[1:]

    for l:subTag in l:subTags
      if l:subTag == 'single' && get( g:my.tagAdded, l:rootTag, 0 )
        return
      endif
      if l:subTag == 'depend' && !get( g:my.tagAdded, l:rootTag, 0 )
        return
      endif
    endfor

    if !get( g:my.pluginConditions, l:rootTag, 1 )
      return
    endif
  "
  endfor

  for l:tag in l:tags
    let l:rootTag                 = split( l:tag, l:subTagDemiliter )[0]
    let g:my.tagAdded[l:rootTag]  = 1
  endfor

  execute "Plug '" . a:name . "', " . string( a:options )
"
endfunction
" end add plugin
"}}}
" end self defined functions
"}}}
" auto commands{{{
augroup MyAutoCmds
autocmd!
" save and load view  自動讀取與儲存手動的折疊{{{
autocmd BufWinLeave * silent! mkview
autocmd BufWinEnter * silent! loadview
" end save and load view
"}}}
" minimal completion base on syntax  基於語法的補全{{{
autocmd FileType * if &omnifunc == "" | setlocal omnifunc=ft#asyncSyntaxComplete | endif
" end minimal completion base on syntax
"}}}
autocmd ColorScheme * call MyCustomHighlight()
augroup END
" end auto commands
"}}}
" key mapping  快捷鍵設定{{{
if has( 'nvim' ) || has( 'terminal' )
  tnoremap  <C-q> <C-\><C-n>| " set Ctrl+q key to exit terminal mode  設定 Ctrl+q 鍵離開 terminal 模式

  " set Ctrl+s key to toggle terminal  設定 Ctrl+s 鍵開闔終端機
  noremap   <silent> <C-s> :call ft#toggleTerminal()<Enter>
  tnoremap  <silent> <C-s> <C-\><C-n>:call ft#toggleTerminal()<Enter>
  " end set Ctrl+s key to toggle terminal
endif

noremap <silent> <Leader>r  :set relativenumber!<Enter>|            " 設定 \r 鍵切換相對行號設定
noremap <silent> <Leader>n  :set number!<Enter>|                    " 設定 \n 鍵切換行號設定
noremap <silent> <Leader>c  :set cursorline! cursorcolumn!<Enter>|  " 設定 \c 鍵切換游標高亮
noremap <silent> <Leader>L  :set list!<Enter>|                      " 設定 \L 切換特殊字元顯示
noremap <silent> <Leader>w  :set wrap!<Enter>|                      " 設定 \w 切換 wrap
noremap <silent> <Leader>zs :set spell!<Enter>|                     " 設定 \zs 切換拼字檢查
noremap <silent> <Leader>er :edit $HOME/.vimrc<Enter>|              " 設定 \er 編輯 vimrc
noremap <silent> <Leader>el :exec 'edit ' . g:my.localVimrc<Enter>| " 設定 \el 編輯本地端 vimrc

if has( 'nvim-0.7' )
  noremap <silent> <Leader>S :exec 'set laststatus=' . ( ( &laststatus == 2 )? 3: 2 )<Enter> | " 設定 \S 切換全域狀態列
endif

if !exists( 'g:vscode' )
"
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
"
endif

if has( "cscope" )
"
  nnoremap <C-_>s :execute 'cscope find s' expand("<cword>")<Enter>
  nnoremap <C-_>g :execute 'cscope find g' expand("<cword>")<Enter>
  nnoremap <C-_>c :execute 'cscope find c' expand("<cword>")<Enter>
  nnoremap <C-_>t :execute 'cscope find t' expand("<cword>")<Enter>
  nnoremap <C-_>e :execute 'cscope find e' expand("<cword>")<Enter>
  nnoremap <C-_>f :execute 'cscope find f' expand("<cword>")<Enter>
  nnoremap <C-_>i :execute 'cscope find i' expand("<cword>")<Enter>
  nnoremap <C-_>d :execute 'cscope find d' expand("<cword>")<Enter>
"
endif
" end key mapping
"}}}
if filereadable( g:my.localVimrc ) | exec 'source ' . g:my.localVimrc | endif
" plugin settings  插件設定{{{
" builtin plugin settings  內建插件設定{{{
if ( get( g:, 'loaded_netrw', 0 ) != 1 ) && !exists( 'g:vscode' )
"
  let g:netrw_banner    = 0
  let g:netrw_keepdir   = 0         | " make current directory the same as browsing directory
  let g:netrw_liststyle = 3         | " tree browser
  let g:netrw_list_hide = '^\.\w\+'
  let g:netrw_mousemaps = 0
  let g:netrw_sizestyle = 'H'       | " human readable size, e.g. 5K

  let g:netrw_use_errorwindow = 0 | " show error in message

  noremap <silent> <C-x> :25Lexplore<Enter>| " set Ctrl+x key to toggle tree browser  設定 Ctrl+x 鍵開闔樹狀檢視器

  " CD to make current directory the top directory
  let g:my.keybindings.netrw =
    \ {
    \   'o':  '<Plug>NetrwLocalBrowseCheck',
    \   'u':  '<Plug>NetrwBrowseUpDir',
    \   'CD': 'gn',
    \   '?':  ':help netrw-quickhelp<Enter>',
    \ }

  autocmd MyAutoCmds Filetype netrw call ft#bufferLocalMaps( 'netrw' )
"
endif
" end builtin plugin settings
"}}}
" vim-plug settings  vim-plug 插件設定（用來管理其他插件的插件）  plugin for manage other plugins  https://github.com/junegunn/vim-plug{{{
if filereadable( $HOME . '/.vim/autoload/plug.vim' )
"
  call plug#begin( g:my.pluginRoot )

  call MyAddPlugin( 'arcticicestudio/nord-vim',   [], {} )
  call MyAddPlugin( 'AndrewRadev/bufferize.vim',  [], {} ) " make command output a buffer  將指令輸出變成 buffer
  call MyAddPlugin( 'mhinz/vim-hugefile',         [], {} ) " handle large file  處理大檔案
  call MyAddPlugin( 'tpope/vim-commentary',       [], {} ) " comment plugin  註解插件

  " mark plugin  標記插件
  call MyAddPlugin( 't9md/vim-quickhl',     [],
                  \ { 'on': [ '<Plug>(quickhl-manual-this)',
                  \           '<Plug>(quickhl-manual-reset)' ]  } )
  " display tags( depend on 'ctags' )  顯示 tag （需搭配 ctags ）
  call MyAddPlugin( 'majutsushi/tagbar',    [ 'ui' ],
                  \ { 'on': [ 'Tagbar',
                  \           'TagbarCurrentTag' ] } )
  " center the text in a window  將視窗文字置中
  call MyAddPlugin( 'JMcKiern/vim-venter',  [ 'ui', 'vim8' ], {} )
  " interactive finder and dispatcher  互動式查詢
  call MyAddPlugin( 'liuchengxu/vim-clap',  [ 'ui' ],
                  \ { 'do': { -> clap#installer#force_download() } } )

  call MyAddPlugin( 'nvim-treesitter/nvim-treesitter',
                  \ [ 'ui', 'language-cpp:single', 'language-toml:single', 'tree-sitter' ],
                  \ { 'do': ':TSUpdate' }  )
  call MyAddPlugin( 'octol/vim-cpp-enhanced-highlight', [ 'ui', 'language-cpp:single'   ], {} )
  call MyAddPlugin( 'cespare/vim-toml',                 [ 'ui', 'language-toml:single'  ], {} )
  call MyAddPlugin( 'vim-perl/vim-perl',                [ 'ui', 'language-perl:single'  ],
                  \ { 'do': 'make clean moose' } )

  call MyAddPlugin( 'lifepillar/vim-mucomplete',  [ 'ui', 'auto-complete:single' ], {} )
  call MyAddPlugin( 'shougo/neocomplcache.vim',   [ 'ui', 'auto-complete:single' ], {} )

  call MyAddPlugin( 'neovim/nvim-lspconfig',          [ 'ui', 'lsp:single', 'nvim-lsp'  ], {} )
  call MyAddPlugin( 'prabirshrestha/vim-lsp',         [ 'ui', 'lsp:single'              ], {} )
  call MyAddPlugin( 'mattn/vim-lsp-settings',         [ 'ui', 'vim-lsp:depend'          ], {} )
  call MyAddPlugin( 'autozimu/LanguageClient-neovim', [ 'ui', 'lsp:single'              ],
                  \ { 'branch': 'next', 'do': 'bash install.sh' } )

  call MyAddPlugin( 'mhinz/vim-signify', [ 'ui', 'vcs-diff:single', 'vim-signify-new' ], {}                     )
  call MyAddPlugin( 'mhinz/vim-signify', [ 'ui', 'vcs-diff:single'                    ], { 'branch': 'legacy' } )

  call MyAddPlugin( 'hrsh7th/vim-vsnip',            [ 'ui', 'code-snippet:single' ], { 'on': [] } )
  call MyAddPlugin( 'hrsh7th/vim-vsnip-integ',      [ 'ui', 'vim-vsnip:depend'    ], { 'on': [] } )
  call MyAddPlugin( 'garbas/vim-snipmate',          [ 'ui', 'code-snippet:single' ], { 'on': [] } )
  call MyAddPlugin( 'MarcWeber/vim-addon-mw-utils', [ 'ui', 'vim-snipmate:depend' ], { 'on': [] } )
  call MyAddPlugin( 'tomtom/tlib_vim',              [ 'ui', 'vim-snipmate:depend' ], { 'on': [] } )

  " self use statusline plugin  個人使用的狀態列設定插件
  call MyAddPlugin( 'flotisable/FlotisableStatusLine',  [ 'ui' ], {} )
  " self use code snippet  個人使用的程式碼片段
  call MyAddPlugin( 'flotisable/FlotisableVimSnippets', [ 'ui' ], {} )

  if exists( '*MyLocalPlugin' ) | call MyLocalPlugin() | endif
  call plug#end()
"
endif
" end vim-plug settings
"}}}
" bufferize settings  bufferize 插件設定{{{
if MyPluginExistsAndInRtp( 'bufferize.vim' )
"
  noremap <Leader>bb :Bufferize |       " set \bb to bufferize command  設定 \bb bufferize vim 命令
  noremap <Leader>bs :BufferizeSystem | " set \bs to bufferize system commad  設定 \bs bufferize 系統命令
  noremap <Leader>bn :Bufferize norm |  " set \bn to bufferize normal mode command  設定 \bn bufferize vim 一般模式命令
"
endif
" end bufferize settings
"}}}
" mark plugin settings  標記插件設定{{{
if MyPluginExists( 'vim-quickhl', 0 )
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
if MyPluginExistsAndInRtp( 'vim-venter' )
"
  " make venter window max( &columns / 2, &textwidth )
  let g:venter_width = min( [ &columns / 4, ( &columns - &textwidth ) / 2 ] )

  autocmd MyAutoCmds VimResized * let g:venter_width = min( [ &columns / 4, ( &columns - &textwidth ) / 2 ] )

  nmap <silent> <Leader>C :VenterToggle<Enter>| " set \C key to center window text  設定 \C 鍵置中視窗文字
"
endif
" end venter settings
"}}}
" tagbar settings  tagbar 插件設定{{{
if MyPluginExists( 'tagbar', 0 )
  noremap <silent> <Leader>t :Tagbar<Enter>|           " set \t key to toggle tagbar  設定 \t 鍵開闔 tagbar
  noremap <silent> <Leader>T :TagbarCurrentTag<Enter>| " set \T to show current tag  設定 \T 顯示現在的 tag
endif
" end tagbar settings
"}}}
" interactive finder plugin settings  互動式查詢插件設定{{{
if MyPluginExistsAndInRtp( 'vim-clap' )
"
  let g:clap_theme  = 'material_design_dark'
  let g:clap_layout = {
                    \   'relative': 'editor',
                    \   'col':      '5%',
                    \   'row':      '10%',
                    \   'width':    '45%',
                    \   'height':   '80%'
                    \ }

  noremap <silent> <Leader>F  :Clap providers<Enter>| " set \F key to open provider dispather  設定 \F 鍵開啟模糊搜尋選單
  noremap <silent> g/         :Clap blines<Enter>|    " set g/ key to search in file  設定 g/ 鍵在檔案中搜尋
  noremap <silent> gb         :Clap buffers<Enter>|   " set gb key to search buffer  設定 gb 鍵搜尋 buffer
  noremap <Leader>f           :Clap files |           " set \f key to search file  設定 \f 鍵搜尋檔案
  noremap <Leader>G           :Clap live_grep |       " set \G key to search file content    in real time  設定 \G 鍵即時搜尋檔案內容
  noremap <Leader>g           :Clap grep |            " set \g key to search file content with cache  設定 \g 鍵利用緩衝輔助搜尋檔案內容

  if has( 'nvim' )
  "
    augroup MyAutoCmds
    autocmd FileType clap_input inoremap <silent> <buffer> <C-n> <C-R>=clap#navigation#linewise_scroll( 'down' )<Enter>
    autocmd FileType clap_input inoremap <silent> <buffer> <C-p> <C-R>=clap#navigation#linewise_scroll( 'up'   )<Enter>
    augroup END
  "
  else
  "
    let g:clap_popup_move_manager = {
                                  \   "\<C-N>": "\<Down>",
                                  \   "\<C-P>": "\<Up>",
                                  \ }
  "
  endif
"
endif
" end interactive finder plugin settings
"}}}
" vim-cpp-enhanced-highlight settings  C++ 語法高亮插件設定{{{
if MyPluginExistsAndInRtp( 'vim-cpp-enhanced-highlight' )
"
  let g:cpp_class_scope_highlight     = 1
  let g:cpp_member_variable_highlight = 1
  let g:cpp_class_decl_highlight      = 1
"
endif
" end vim-cpp-enhanced-highlight settings
"}}}
" nvim-treesitter settings  nvim-treesitter 設定{{{
if MyPluginExistsAndInRtp( 'nvim-treesitter' )
"
  lua << EOF
    require'nvim-treesitter.configs'.setup
    {
      ensure_installed      = { 'cpp', 'rust', 'toml', 'make', 'bash' },
      highlight             = { enable = true },
      incremental_selection = { enable = true }
    }
EOF
"
endif
" end nvim-treesitter settings
"}}}
" completion plugin settings  補全插件設定{{{
if MyPluginExistsAndInRtp( 'vim-mucomplete' )
"
  let g:mucomplete#no_mappings  = 1
  let g:mucomplete#chains       =
    \ {
    \   'default': [ 'path', 'omni', 'keyn', 'dict', 'uspl' ],
    \ }

  if MyPluginExists( 'vim-vsnip-integ', 0 )
    let g:mucomplete#chains.default += [ 'vsnip' ]
  endif

  let g:mucomplete#chains.vim     = deepcopy( g:mucomplete#chains.default )
  let g:mucomplete#chains.vim[1]  = 'cmd'

  inoremap <silent> <plug>(MUcompleteFwdKey) <C-j>
  imap <C-j> <plug>(MUcompleteCycFwd)
  inoremap <silent> <plug>(MUcompleteBwdKey) <C-h>
  imap <C-h> <plug>(MUcompleteCycBwd)

  " to work with vim-clap
  augroup MyAutoCmds
  autocmd FileType    clap_input  MUcompleteAutoOff
  autocmd InsertEnter *           if &filetype != 'clap_input' | MUcompleteAutoOn | endif
  augroup END
"
elseif MyPluginExistsAndInRtp( 'neocomplcache.vim' )
"
  " the plugin has the issue that it can auto insert the completion when set
  " noselect in completeopt
  let g:neocomplcache_omni_patterns = { '_': '\w\+' }

  autocmd MyAutoCmds InsertEnter * NeoComplCacheEnable
"
endif
" end completion plugin settings
"}}}
" LSP client settings  LSP 客戶端設定{{{
if MyPluginExistsAndInRtp( 'nvim-lspconfig' )
"
  lua << EOF
    local lsp = require'lspconfig'

    -- sign setup  符號設定{{{
    local signs = {
                    DiagnosticSignError = "✖",
                    DiagnosticSignWarn  = "⚠",
                    DiagnosticSignHint  = "➤",
                    DiagnosticSignInfo  = "ℹ"
                  }

    for type, sign in pairs( signs ) do
      vim.fn.sign_define( type, { text = sign, texthl = type } )
    end
    -- end sign setup
    --}}}
    -- use lsp omni function when a language server is attached{{{
    local function mySetOmniFunc()
      vim.bo.omnifunc = 'ft#buildInLspOmniFunc'
    end

    local group = vim.api.nvim_create_augroup( 'MyAutoCmds', { clear = false } )

    local function myOnAttach( args )

      local client = vim.lsp.get_client_by_id( args.data.client_id )

      vim.fn['ft#lspMaps']( true )

      if not client.server_capabilities.completionProvider then
        return
      end

      mySetOmniFunc()
      vim.api.nvim_create_autocmd( 'FileChangedShellPost',
        {
          group     = group,
          buffer    = args.buf,
          callback  = mySetOmniFunc
        }
      )

    end

    vim.api.nvim_create_autocmd( 'LspAttach',
      {
        group     = group,
        callback  = myOnAttach
      }
    )
    -- end use lsp omni function when a language server is attached
    --}}}
    -- show diagnostics in quick fix list{{{
    local defaultHandler = vim.lsp.diagnostic.on_publish_diagnostics

    vim.lsp.diagnostic.on_publish_diagnostics = function( error, result, context, config )

      defaultHandler( error, result, context, config )
      vim.diagnostic.setqflist(
        {
          open  = false,
          title = 'LSP Diagnostic'
        }
      )
    end
    -- end show diagnostics in quick fix list
    --}}}
    -- language setup{{{
    local servers = {
                      'clangd',
                      'bashls',
                      'vimls',
                      'perlpls',
                      'rust_analyzer',
                      'pylsp'
                    }

    for _, server in ipairs( servers ) do
      lsp[server].setup{}
    end

    lsp.efm.setup
    {
      filetypes = { 'raku' }
    }
    lsp.powershell_es.setup
    {
      bundle_path = vim.g.my.powershellBundlePath
    }
    -- language setup
    --}}}
    -- key mappings{{{
    local function noremap( lhs, rhs )
      vim.keymap.set( '', lhs, rhs )
    end

    noremap( '<Leader>lo', '<Cmd>LspStart<Enter>' ) -- set \lo key to start language client  設定 \lo 鍵啟動 LSP 客戶端
    noremap( '<Leader>lc', '<Cmd>LspStop<Enter>'  ) -- set \lc key to stop language client  設定 \lc 鍵關閉 LSP 客戶端

    local my = vim.g.my

    my.keybindings.lsp =
    {
      global =
      {
        gd              = '<Cmd>lua vim.lsp.buf.definition()<Enter>',     -- set gd key to go to definition  設定 gd 鍵跳至定義
        gr              = '<Cmd>lua vim.lsp.buf.references()<Enter>',     -- set gr key to show reference  設定 gr 鍵顯示參照
        K               = '<Cmd>lua vim.lsp.buf.hover()<Enter>',          -- set K key to show hover  設定 K 鍵顯示文檔
        gi              = '<Cmd>lua vim.lsp.buf.implementation()<Enter>', -- set gi key to go to implementation  設定 gi 鍵跳至實作
        ['=']           = '<Cmd>lua vim.lsp.buf.format()<Enter>',         -- set = key to format range  設定 = 鍵排版程式碼

        ['<Leader>lr']  = '<Cmd>lua vim.lsp.buf.rename()<Enter>',         -- set \lr key to rename symbol  設定 \lr 鍵將符號改名
        ['<Leader>la']  = '<Cmd>lua vim.lsp.buf.code_action()<Enter>',    -- set \la key to run code action  設定 \la 鍵執行 code action
      },
      cpp =
      {
        ['<Leader>a'] = '<Cmd>ClangdSwitchSourceHeader<Enter>'
      }
    }
    vim.g.my = my
    -- end key mappings
    --}}}
EOF
"
elseif MyPluginExistsAndInRtp( 'vim-lsp' )
"
  let g:lsp_settings =
    \ {
    \   'efm-langserver':
    \   {
    \     'disabled':   0
    \   }
    \ }
    " \     'allowlist':  [ 'raku' ],

  let g:lsp_diagnostics_signs_error       = { 'text': "✖" }
  let g:lsp_diagnostics_signs_warning     = { 'text': "⚠" }
  let g:lsp_diagnostics_signs_hint        = { 'text': "➤" }
  let g:lsp_diagnostics_signs_information = { 'text': "ℹ" }

  noremap <silent> <Leader>lo :call lsp#enable()<Enter>|   " set \lo key to start language client  設定 \lo 鍵啟動 LSP 客戶端
  noremap <silent> <Leader>lc :call lsp#disalbe()<Enter>|  " set \lc key to stop language client  設定 \lc 鍵關閉 LSP 客戶端

  " set gd key to go to definition  設定 gd 鍵跳至定義
  " set gr key to show reference  設定 gr 鍵顯示參照
  " set K key to show hover  設定 K 鍵顯示文檔
  " set gi key to go to implementation  設定 gi 鍵跳至實作
  " set = key to format range  設定 = 鍵排版程式碼
  " set \lr key to rename symbol  設定 \lr 鍵將符號改名
  " set \la key to run code action  設定 \la 鍵執行 code action
  let g:my.keybindings.lsp =
    \ {
    \   'global':
    \   {
    \     'gd':         '<plug>(lsp-definition)',
    \     'gr':         '<plug>(lsp-references)',
    \     'K':          '<plug>(lsp-hover)',
    \     'gi':         '<plug>(lsp-implementation)',
    \     '=':          '<plug>(lsp-document-range-format)',
    \     '<Leader>lr': '<plug>(lsp-rename)',
    \     '<Leader>la': '<plug>(lsp-code-action)',
    \   },
    \   'cpp':
    \   {
    \     '<Leader>a': ':call lsp#send_request( "clangd", { "method": "textDocument/switchSourceHeader", "params": { "uri": lsp#utils#get_buffer_uri() }, "on_notification": function( "ft#vimLspSwitchSourceHeader" ) } )<Enter>'
    \   }
    \ }

  " autocmd MyAutoCmds User lsp_buffer_enabled call ft#lspMaps( v:false )
  autocmd User lsp_buffer_enabled call ft#lspMaps( v:true )
"
elseif MyPluginExistsAndInRtp( 'LanguageClient-neovim' )
"
  let g:LanguageClient_serverCommands =
    \ {
    \   'cpp':    ['clangd'],
    \   'sh':     ['bash-language-server','start'],
    \   'vim':    ['vim-language-server','--stdio'],
    \   'perl':   ['pls'],
    \   'rust':   ['rust-analyzer'],
    \   'raku':   ['efm-langserver'],
    \   'python': ['pylsp']
    \ }

  noremap <silent> <Leader>lo :LanguageClientStart<Enter>|  " set \lo key to statr language client  設定 \lo 鍵啟動 LSP 客戶端
  noremap <silent> <Leader>lc :LanguageClientStop<Enter>|   " set \lc key to stop language client  設定 \lc 鍵關閉 LSP 客戶端

  " set gd key to go to definition  設定 gd 鍵跳至定義
  " set gr key to show reference  設定 gr 鍵顯示參照
  " set K key to show hover  設定 K 鍵顯示文檔
  " set gi key to go to implementation  設定 gi 鍵跳至實作
  " set = key to format range  設定 = 鍵排版程式碼
  " set \lr key to rename symbol  設定 \lr 鍵將符號改名
  " set \la key to run code action  設定 \la 鍵執行 code action
  let g:my.keybindings.lsp =
    \ {
    \   'global':
    \   {
    \     'gd':         '<Plug>(lcn-definition)',
    \     'gr':         '<Plug>(lcn-references)',
    \     'K':          '<Plug>(lcn-hover)',
    \     'gi':         '<Plug>(lcn-implementaion)',
    \     '=':          ':call LanguageClient#textDocument_rangeFormatting()<Enter>',
    \     '<Leader>lr': '<Plug>(lcn-rename)',
    \     '<Leader>la': '<Plug>(lcn-code-action)',
    \   },
    \   'cpp':
    \   {
    \     '<Leader>a': ':call LanguageClient#textDocument_switchSourceHeader()<Enter>'
    \   }
    \ }

  autocmd MyAutoCmds Filetype * call ft#lspMaps( v:false )
"
endif
" end LSP client settings
"}}}
" VCS diff plugin settings  版本控制差異插件設定{{{
if MyPluginExistsAndInRtp( 'vim-signify' )
"
  set updatetime=100

  let g:signify_disable_by_default = 1

  noremap <silent> <Leader>s :SignifyToggle<Enter>|   " set \s key to toggle VCS diff  設定 \s 鍵開闔版本控制差異
  noremap <silent> <Leader>d :SignifyHunkDiff<Enter>| " set \d key to show hunk diff  設定 \d 鍵顯示片段差異
  noremap <silent> <Leader>u :SignifyHunkUndo<Enter>| " set \u key to undo hunk  設定 \u 鍵回復片段
  noremap <silent> <Leader>D :SignifyDiff<Enter>|     " set \D key to show full diff  設定 \D 鍵顯示檔案差異
"
endif
" end VCS diff plugin settings
"}}}
" code snippet settings  code snippet 設定{{{
if MyPluginExists( 'vim-vsnip', 0 )
"
  let g:snips_author        = g:my.snippetAuthor
  let g:vsnip_snippet_dirs  = []

  function MyAddVsnipDir( dir )
  "
    let g:vsnip_snippet_dirs += [ a:dir ]

    for dir in readdir( a:dir )
    "
      let l:fullDir = a:dir . '/' . dir

      if !isdirectory( l:fullDir ) | continue | endif

      call insert( g:vsnip_snippet_dirs, l:fullDir )
    "
    endfor
  "
  endfunction

  call MyAddVsnipDir( g:my.pluginRoot . "/FlotisableVimSnippets/vsnip" )

  augroup MyAutoCmds
  autocmd InsertEnter * call plug#load( 'vim-vsnip', 'vim-vsnip-integ' )
  autocmd SourcePost * if stridx( expand( "<afile>" ), 'vsnip' ) != -1 | call vsnip#variable#register( 'VISUAL', function( 'ft#vsnipVisual' ) ) | endif
  augroup END

  imap    <expr> <TAB>        vsnip#available( 1 )? '<Plug>(vsnip-expand-or-jump)' :'<TAB>'
  smap    <expr> <TAB>        vsnip#available( 1 )? '<Plug>(vsnip-expand-or-jump)' :'<TAB>'
  xmap    <TAB>               <Plug>(vsnip-cut-text)
  noremap <silent> <Leader>es :VsnipOpenEdit -format snipmate<Enter>| " set \es to open snippet files  設定 \es 開啟 snipprt 檔案
"
elseif MyPluginExists( 'vim-snipmate', 0 )
"
  let g:snips_author  = g:my.snippetAuthor
  let g:snipMate      = { 'snippet_version': 1 }

  imap    <C-s>               <Plug>snipMateShow|               " set C-s to show snip candidates  設定 C-s 顯示可用程式碼片段
  noremap <silent> <Leader>es :SnipMateOpenSnippetFiles<Enter>| " set \es to open snippet files  設定 \es 開啟 snippet 檔案

  " use Ctrl+n, Ctrl+p to select multiple snippet  用 Ctrl+n, Ctrl+p 選擇程式片段
  let g:tlib_extend_keyagents_InputList_s =
    \ {
    \   16: 'tlib#agent#Up',
    \   14: 'tlib#agent#Down'
    \ }

  autocmd MyAutoCmds InsertEnter * call plug#load( 'vim-addon-mw-utils', 'tlib_vim', 'vim-snipmate' )
"
endif
" end code snippet settings
"}}}
" end plugin settings
"}}}
" highlight setup  高亮設定{{{
if MyPluginExistsAndInRtp( 'nord-vim' )
  colorscheme nord
else
  colorscheme elflord
endif

call MyCustomHighlight()
" end highlight setup
"}}}
if exists( '*MyLocalPostPluginSettings' ) | call MyLocalPostPluginSettings() | endif
" vim: foldmethod=marker foldmarker={{{,}}}
