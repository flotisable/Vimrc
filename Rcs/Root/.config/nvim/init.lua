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
-- LSP client settings  LSP 客戶端設定{{{
if vim.fn.MyPluginExistsAndInRtp( 'nvim-lspconfig' ) == 1 then

  local lsp = require'lspconfig'

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
  local servers = {
                    'clangd',
                    'bashls',
                    'vimls',
                    'perlpls',
                    'rust_analyzer',
                    'pylsp',
                  }

  for _, server in ipairs( servers ) do
    if vim.fn.executable( lsp[server].config_def.default_config.cmd[1] ) ~= 0 then
      lsp[server].setup{}
    end
  end

  if vim.fn.executable( lsp.efm.config_def.default_config.cmd[1] ) ~= 0 then
    lsp.efm.setup
    {
      filetypes = { 'raku' }
    }
  end

  if  vim.fn.executable( lsp.powershell_es.config_def.default_config.shell ) ~= 0 and
      vim.fm.isdirectory( vim.g.my.powershellBundlePath ) then
    lsp.powershell_es.setup
    {
      bundle_path = vim.g.my.powershellBundlePath
    }
  end
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

end
-- end LSP client settings
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
