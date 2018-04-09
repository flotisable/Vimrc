" include vim resource  引入 vim 的資源
set runtimepath+=~/.vim,~/.vim/after
set packpath+=~/.vim
source ~/.vimrc
" end include vim resource

" neoterm settings  neoterm 插件設定
let g:neoterm_autoinsert  = 1       " 開啟終端機後進入終端機模式  enter terminal mode after open the terminal 
let g:neoterm_default_mod = ":tab"  " 設定以 tab 開啟終端機  open terminal in a tab
" end neoterm settings

" key mapping  快捷鍵設定
tnoremap  <C-q> <C-\><C-n>|                 " 設定 Ctrl+q 鍵離開 terminal 模式  set Ctrl+q key to exit terminal mode
noremap   <C-s> :Ttoggle<Enter>|            " 設定 Ctrl+s 鍵開闔終端機  set Ctrl+s key to toggle terminal
tnoremap  <C-s> <C-\><C-n>:Ttoggle<Enter>|  " 設定 Ctrl+s 鍵開闔終端機  set Ctrl+s key to toggle terminal
" end key mapping
