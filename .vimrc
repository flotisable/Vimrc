" option settings  選項設定
set encoding=utf-8    " 設定編碼  set file encoding
set number            " 顯示行號  display line number
set autoindent        " 自動縮排（與上一行縮排相同）  automatic indent as last line

set foldmethod=manual " 手動折疊程式碼  manual fold the code

set tabstop=2         " 設定 tab 鍵等於幾個空白鍵  set TAB key to be equivalent to how many spaces
set shiftwidth=2
set expandtab         " 將 tab 鍵展開為空白鍵  expand TAB key to be spaces

set showcmd           " 顯示指令在狀態攔（知道自己輸入什麼）  show the command at the status bar
" end option settings

" setup colorscheme for terminal and gui  根據終端與圖形設置不同的顏色主題
if has( 'gui_running' )
  colorscheme desert  " colorscheme in gui  圖形介面顏色主題
else
  colorscheme elflord " colorscheme in terminal  終端機顏色主題
endif
" end setup colorscheme for terminal and gui

" save and load view  自動讀取與儲存手動的折疊
au BufWinLeave * mkview
au BufWinEnter * silent! loadview
" end save and load view

" vim-plug settings  vim-plug 插件設定（用來管理其他插件的插件）  plugin for manage other plugins  https://github.com/junegunn/vim-plug
call plug#begin( '~/.vim/plugged' )

Plug 'scrooloose/nerdtree'      " 樹狀顯示資料夾的插件  plugin for display directory as tree view  https://github.com/scrooloose/nerdtree
Plug 'shougo/neocomplcache.vim' " 自動補全的插件（因為 vim 版本低）  plugin for autocomplete( since 'vim' version is old )  https://github.com/shougo/neocomplcache.vim
Plug 'majutsushi/tagbar'        " 顯示 tag 的插件（需搭配 ctags ）  plugin for display tags( depend on 'ctags' )  https://github.com/majutsushi/tagbar

call plug#end()
" end vim-plug settings

" neocomplcache settings  neocomplcache 插件設定
let g:neocomplcache_enable_at_startup = 1 " 開啟 vim 時啟用 neocomplcache  start 'neocomplcache' when open 'vim'
" end neocomplcache settings
