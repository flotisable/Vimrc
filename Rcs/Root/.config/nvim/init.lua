-- include vim resource  引入 vim 的資源 {{{
vim.opt.runtimepath:append{ '~/.vim', '~/.vim/after'  }
vim.opt.packpath:append   { '~/.vim' }
vim.cmd.source( '~/.vimrc' )
-- end include vim resource
-- }}}
-- vscode specific settings {{{
if vim.g.vscode then

  vim.keymap.set( '', '<Space>',      [[<Cmd>call VSCodeCall( 'vscode-neovim.ctrl-f'                    )<Enter>]] )
  vim.keymap.set( '', '<BS>',         [[<Cmd>call VSCodeCall( 'vscode-neovim.ctrl-b'                    )<Enter>]] )
  vim.keymap.set( '', '<Leader>p',    [[<Cmd>call VSCodeCall( 'markdown.showPreviewToSide'              )<Enter>]] )
  vim.keymap.set( '', '<Leader>er',   [[<Cmd>call VSCodeCall( 'workbench.action.openSettings'           )<Enter>]] )
  vim.keymap.set( '', '<Leader>ek',   [[<Cmd>call VSCodeCall( 'workbench.action.openGlobalKeybindings'  )<Enter>]] )

end
-- end vscode specific settings
-- }}}
-- option settings  選項設定{{{
vim.go.jumpoptions = 'stack'
-- end option settings
-- }}}
-- sign setup  符號設定 {{{
vim.diagnostic.config
{
  signs =
  {
    text =
    {
      [vim.diagnostic.severity.ERROR] = "✖",
      [vim.diagnostic.severity.WARN ] = "⚠",
      [vim.diagnostic.severity.HINT ] = "➤",
      [vim.diagnostic.severity.INFO ] = "ℹ",
    }
  }
}
-- end sign setup
-- }}}
-- key mapping  快捷鍵設定{{{
if vim.version().major >= 0 and vim.version().minor >= 7 then
  -- 設定 \S 切換全域狀態列
  vim.keymap.set( '',
    '<Leader>S',
    [[<Cmd>exec 'set laststatus=' . ( ( &laststatus == 2 )? 3: 2 )<Enter>]],
    {
      silent = true,
    }
  )
end
-- end key mapping
-- }}}
-- LSP client settings  LSP 客戶端設定{{{
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
  vim.api.nvim_create_autocmd( 'FileType',
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
vim.lsp.config( '*',
  {
    root_markers = { '.git' },
  }
)
vim.lsp.config( 'bashls',
  {
    cmd       = { 'bash-language-server', 'start' },
    filetypes = { 'bash', 'sh' },
  }
)
vim.lsp.config( 'clangd',
  {
    cmd           = { 'clangd' },
    filetypes     = { 'c', 'cpp' },
    root_markers  = { '.clangd', 'compile_commands.json', 'compile_flags.txt', '.git' },
  }
)
vim.lsp.config( 'efm',
  {
    cmd       = { 'efm-langserver' },
    filetypes = { 'raku' },
  }
)
vim.lsp.config( 'perlpls',
  {
    cmd       = { 'pls' },
    filetypes = { 'perl' },
    settings  =
    {
      perl =
      {
        syntax =
        {
          enabled = true
        }
      }
    },
  }
)
vim.lsp.config( 'pylsp',
  {
    cmd       = { 'pylsp' },
    filetypes = { 'python' },
  }
)
vim.lsp.config( 'rust_analyzer',
  {
    cmd           = { 'rust-analyzer' },
    filetypes     = { 'rust' },
    root_markers  = { 'Cargo.toml', '.git' },
  }
)
if vim.fn.isdirectory( vim.g.my.powershellBundlePath ) then
  vim.lsp.config( 'powershell_es',
    {
      cmd       = { 'pwsh', '-NoLogo', '-NoProfile', '-Command', vim.g.my.powershellBundlePath .. '/PowerShellEditorServices/Start-EditorServices.ps1', '-SessionDetailsPath', vim.g.my.powershellBundlePath, '/session.json' },
      filetypes = { 'ps1' },
    }
  )
end
vim.lsp.config( 'vimls',
  {
    cmd           = { 'vim-language-server', '--stdio' },
    filetypes     = { 'vim' },
    init_options  =
    {
      diagnostic =
      {
        enable = true
      },
      indexes =
      {
        count               = 3,
        gap                 = 100,
        projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
        runtimepath         = true
      },
      isNeovim    = true,
      iskeyword   = "@,48-57,_,192-255,-#",
      runtimepath = "",
      suggest =
      {
        fromRuntimepath = true,
        fromVimruntime  = true,
      },
      vimruntime = ""
    }
  }
)

function myEnableLsp( isDisable )
  for server, _ in pairs( vim.lsp.config._configs ) do
    if vim.lsp.config[server].cmd and vim.fn.executable( vim.lsp.config[server].cmd[1] ) ~= 0 then
      vim.lsp.enable( server, isDisable )
    end
  end
end

myEnableLsp( true )
-- language setup
--}}}
-- key mappings{{{
vim.keymap.set( '', '<Leader>lo', '<Cmd>lua myEnableLsp( true  )<Enter>' ) -- set \lo key to start language client  設定 \lo 鍵啟動 LSP 客戶端
vim.keymap.set( '', '<Leader>lc', '<Cmd>lua myEnableLsp( false )<Enter>' ) -- set \lc key to stop language client  設定 \lc 鍵關閉 LSP 客戶端

function myLspSwitchSourceHeader()

  vim.lsp.buf_request_all( 0, 'textDocument/switchSourceHeader',
    {
      uri = vim.uri_from_bufnr( vim.api.nvim_get_current_buf() )
    },
    function( result, context )
      if result[1].result then
        vim.cmd( 'edit ' .. vim.uri_to_fname( result[1].result ) )
      else
        print 'Can not found corresponding header or source file'
      end
    end
  )

end

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
    ['<Leader>a'] = '<Cmd>lua myLspSwitchSourceHeader()<Enter>'
  }
}
vim.g.my = my
-- end key mappings
--}}}
-- end LSP client settings
-- }}}
-- plugin settings  插件設定 {{{
-- nvim-treesitter settings  nvim-treesitter 設定{{{
if vim.fn.MyPluginExistsAndInRtp( 'nvim-treesitter' ) == 1 then

  require'nvim-treesitter.configs'.setup
  {
    ensure_installed      = { 'cpp', 'rust', 'toml', 'make', 'bash' },
    highlight             = { enable = true },
    incremental_selection = { enable = true }
  }

end
-- end nvim-treesitter settings
-- }}}
-- end plugin settings
-- }}}
-- load local init file {{{
local my            = vim.g.my
local localInitFile = vim.fs.joinpath( vim.fn.stdpath( 'config' ), '/localInit.lua' )

my.localVimrc = localInitFile
vim.g.my      = my

loadfile( localInitFile )
-- end load local init file
-- }}}
-- vim: foldmethod=marker foldmarker={{{,}}}
