" option settings
set number
set autoindent

set foldmethod=manual

set tabstop=2
set sw=2
set expandtab

set sc
" end option settings

" save and load view
au BufWinLeave *.cpp,*.h,*.v,*.sp,*.m mkview
au BufWinEnter *.cpp,*.h,*.v,*.sp,*.m silent loadview
" end save and load view

" vim-plug settings
call plug#begin( '~/.vim/plugged' )

Plug 'scrooloose/nerdtree'
Plug 'shougo/neocomplcache.vim'
Plug 'majutsushi/tagbar'

call plug#end()
" end vim-plug settings

" neocomplecache settings
let g:neocomplcache_enable_at_startup = 1
" end neocomplecache settings
