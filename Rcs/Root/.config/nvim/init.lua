-- include vim resource  引入 vim 的資源
vim.opt.runtimepath:append{ '~/.vim', '~/.vim/after'  }
vim.opt.packpath:append   { '~/.vim' }
vim.cmd.source( '~/.vimrc' )
-- end include vim resource

-- vscode specific settings
if vim.g.vscode then

  vim.keymap.set( '', '<Space>',      [[<Cmd>call VSCodeCall( 'vscode-neovim.ctrl-f'                    )<Enter>]] )
  vim.keymap.set( '', '<BS>',         [[<Cmd>call VSCodeCall( 'vscode-neovim.ctrl-b'                    )<Enter>]] )
  vim.keymap.set( '', '<Leader>p',    [[<Cmd>call VSCodeCall( 'markdown.showPreviewToSide'              )<Enter>]] )
  vim.keymap.set( '', '<Leader>er',   [[<Cmd>call VSCodeCall( 'workbench.action.openSettings'           )<Enter>]] )
  vim.keymap.set( '', '<Leader>ek',   [[<Cmd>call VSCodeCall( 'workbench.action.openGlobalKeybindings'  )<Enter>]] )

end
-- end vscode specific settings
