" include vim resource  引入 vim 的資源
set runtimepath+=~/.vim,~/.vim/after
set packpath+=~/.vim
source ~/.vimrc
" end include vim resource

" vscode specific settings
if exists( 'g:vscode' )
"
  noremap <Space>     <Cmd>call VSCodeCall( 'vscode-neovim.ctrl-f'                    )<Enter>
  noremap <BS>        <Cmd>call VSCodeCall( 'vscode-neovim.ctrl-b'                    )<Enter>
  noremap <Leader>p   <Cmd>call VSCodeCall( 'markdown.showPreviewToSide'              )<Enter>
  noremap <Leader>er  <Cmd>call VSCodeCall( 'workbench.action.openSettings'           )<Enter>
  noremap <Leader>ek  <Cmd>call VSCodeCall( 'workbench.action.openGlobalKeybindings'  )<Enter>

"
endif
" end vscode specific settings
