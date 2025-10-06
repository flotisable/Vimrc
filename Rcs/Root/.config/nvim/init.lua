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
-- load local init file {{{
local my            = vim.g.my
local localInitFile = vim.fs.joinpath( vim.fn.stdpath( 'config' ), '/localInit.lua' )

my.localVimrc = localInitFile
vim.g.my      = my

loadfile( localInitFile )
-- end load local init file
-- }}}
-- vim: foldmethod=marker foldmarker={{{,}}}
