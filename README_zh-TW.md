# Vimrc
備份跟分享 vimrc 檔
# 檔案
- **.vimrc**          : [vim](https://github.com/vim/vim) 的設定
- **init.vim**        : [neovim](https://github.com/neovim/neovim) 的設定
- **installVimrc.sh** : 安裝 **.vimrc** 和 **init.vim** 的 script
# 使用 vimrc
打開 vim 輸入 **:help vimrc** 就會打開關於放置 vimrc 的說明文件

如果你沒有使用 neovim 的話，可以直接忽略 "init.vim" 這個檔案

當你將 vimrc 放到正確的資料夾之後，只要在 vim 中輸入 **:e $MYVIMRC**，它就會打開 vimrc 檔，方便以後的修改

下面我會講我自己是將 vimrc 檔放在哪裡，可以作為參考
## 在 Linux 上
  我是將 ".vimrc" 放在 "$HOME/" 資料夾，而 "init.vim" 是放在 "$HOME/.config/nvim/" 這個資料夾
  
  這也是 Linux 上 vimrc 預設的資料夾
## 在 Windows 上
  我是將 "init.vim" 放在 "$XDG_CONFIG_HOME\nvim\\" 這個資料夾
  
  至於 ".vimrc" 檔，因為我在 Windows 上沒有用 vim，所以如果你和我一樣使用 neovim 的話，隨便將它放到一個資料夾，然後修改 "init.vim" 中的 **"source ~/.vimrc"** 這一行。將它改你放 ".vimrc" 的路徑
  
  比方說你將 ".vimrc" 放在 "D:\Vim\\" 這個資料夾，那麼就將 source 那一行改成如下
  ```
  source D:\Vim\.vimrc
  ```
  
  如果你不是用 neovim 的話，就讀一下說明文件看要將 ".vimrc" 檔放在哪
# 使用安裝 script
這個 script 是用 **bash** script 寫的，所以可以支援 bash script 的 shell 都可以使用

以下說明如何使用這個 script
- 首先用 ```chmod u+x installVimrc.sh``` 來讓 sciprt 檔可以被執行
- 視情況修改 sciprt 中的 **vimrcDir** 和 **nvimrcDir**，
  這兩個變數分別設定 **.vimrc** 和 **init.vim** 的安裝資料夾
- 視情況修改 script 中的 **vimrcTargetFile** 和 **nvimrcTargetFile**，
  這兩個變數分別設定 **.vimrc** 和 **init.vim** 安裝後的名稱
- 如果你沒有使用 neovim，可以在 ```cp ${nvimrcSourceFile} ...``` 這一行的開頭加上 # 將它注解掉
- 輸入 ```./installVimrc.sh``` 來安裝 **.vimrc** 和 **init.vim**
# 快捷鍵設定
- Ctrl+x      : 開闔樹狀檢視器
- \<Leader> r : 開關相對行號設定
## neovim 專用快捷鍵
- Ctrl+s : 開闔終端機
- Ctrl+q : 離開終端機模式
# 自定義函式
- Flotisabletogglerelativenumber() : 開關相對行號設定
# 插件
- [vim-plug](https://github.com/junegunn/vim-plug)              : vim 的插件管理器 
- [Nerdtree](https://github.com/scrooloose/nerdtree)            : 在 vim 中以樹狀檢視資料夾
- [neocomplcache](https://github.com/shougo/neocomplcache.vim)  : 自動補全插件( 我會用這個主要是因為我用的 vim 版本有點舊，如果你有新版本的話可以試試看 [YouCompleteMe](https://github.com/valloric/youcompleteme) 或 [neocomplete](https://github.com/shougo/neocomplete.vim) )
- [tagbar](https://github.com/majutsushi/tagbar)                : 顯示 tag 的插件( 需要 ctags )
# neovim 專用插件
- [neoterm](https://github.com/kassio/neoterm)                  : 終端機插件
## 關於 ctags
ctags 只支援 c/c++ 語言，如果要支援其他語言，可以試試看這些
- [exuberant ctags](http://ctags.sourceforge.net/)            : 支援多種語言的 ctags ( 現在好像沒在維護了 )
- [universal ctags](https://github.com/universal-ctags/ctags) : 接續 exuberant ctags 開發的 ctags
