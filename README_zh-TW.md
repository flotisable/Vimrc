# Vimrc
  備份跟分享 vimrc 檔

# 索引
  - [檔案](#檔案)
  - [使用 vimrc](#使用-vimrc)
  - [安裝](#安裝)
    - [設定](#設定)
    - [使用安裝腳本](#使用安裝腳本)
    - [使用 makefile](#使用-makefile)
  - [初次使用](#初次使用)
  - [快捷鍵設定](#快捷鍵設定)
  - [自定義函式](#自定義函式)
  - [插件](#插件)
    - [關於 ctags](#關於-ctags)

# 檔案
  - **vim** 與 **neovim** 設定檔
    - **.vimrc**              : [vim](https://github.com/vim/vim) 設定
    - **init.vim**            : [neovim](https://github.com/neovim/neovim) 設定
    - **ginit.vim**           : **neovim** 圖形介面設定
  - 倉庫使用設定
    - **settings.toml**       : 安裝移除設定
    - **defaultPath.toml**    : 不同作業系統預設路徑設定
  - 倉庫使用腳本
    - 統一介面
      - **makefile**          : **.vimrc** 和 **init.vim** 的 makefile
    - 安裝腳本
      - **install.ps1**       : Windows 用的 powershell 安裝腳本
      - **install.sh**        : Linux 和 MacOS 用的 bash 安裝腳本
    - 移除腳本
      - **uninstall.ps1**     : Windows 用的 powershell 移除腳本
      - **uninstall.sh**      : Linux 和 MacOS 用的 bash 移除腳本
    - 複製腳本
      - **copy.ps1**          : Windows 用的 powershell 複製腳本
      - **copy.sh**           : Linux 和 MacOS 用的 bash 複製腳本
    - 輔助腳本
      - **readSettings.ps1**  : Windows 用的 powershell 輔助腳本
      - **readSettings.sh**   : Linux 和 MacOS 用的 bash 輔助腳本

# 使用 vimrc
  打開 vim 輸入 `:help vimrc` 就會打開關於放置 vimrc 的說明文件。
  如果你沒有使用 neovim 的話，可以直接忽略 "init.vim" 這個檔案。
  當你將 vimrc 放到正確的資料夾之後，只要在 vim 中輸入 `:e $MYVIMRC`，
  它就會打開 vimrc 檔，方便以後的修改

  下面表格是我放置 vimrc 檔的位置，可以作為參考，
  這些位置基本上是預設路徑
  | 作業系統      | 檔案      | 路徑                      |
  | ------------- | --------- | ------------------------- |
  | Linux, MacOS  | .vimrc    | `$HOME/`                  |
  |               | init.vim  | `$HOME/.config/nvim/`     |
  | Windows       | .vimrc    | `$HOME\`                  |
  |               | init.vim  | `$XDG_CONFIG_HOME\nvim\`  |

  因為我在 Windows 上沒有用 vim，
  所以如果你和我一樣使用 neovim 的話，
  隨便將它放到一個資料夾，
  然後修改 "init.vim" 中的 `source ~/.vimrc` 這一行。
  將它改成你放 ".vimrc" 的路徑。
  比方說你將 ".vimrc" 放在 `D:\Vim\` 這個資料夾，
  那麼就將 source 那一行改成如下
  ```
  source D:\Vim\.vimrc
  ```

  如果你不是用 neovim 的話，就讀一下說明文件看要將 ".vimrc" 檔放在哪

# 安裝
## 設定
   安裝設定可以藉由修改 **settings.toml** 檔案來完成，
   它基本上就是個一般的 [toml](https://toml.io/en/) 檔案

   | 表格           | 控制設定                        |
   | -------------- | ------------------------------- |
   | dir            | 安裝資料夾                      |
   | source         | 倉庫裡的檔案名稱                |
   | target         | 安裝後檔案名稱                  |
   | pluginManager  | 是否安裝插件管理員與其安裝位置  |

## 使用安裝腳本
   這些腳本是用 **bash** 和 **powershell** 寫的，
   所以可以支援 bash 或 poweshell 腳本的 shell 都可以使用

   以下說明如何使用這些腳本

   1. 如果使用 bash 的腳本請先跑 `chmod u+x install.sh` 來讓腳本可以被執行
   2. 視情況修改 **settings.toml**
   3. 如果你沒有使用 neovim，可以在 **settings.toml** 裡 **nvimrc** 和 **gnvimrc** 相關的那幾行開頭加上 # 將它注解掉
   4. 輸入 `./install.sh` 或 `pwsh ./install.ps1` 來安裝 **.vimrc** 和 **init.vim**

## 使用 makefile
   makefile 是為那些想用 **make** 來處理的人寫的。
   一個原因也是因為這會讓我在更新原始碼的時候較方便。
   它基本上是將倉庫裡的腳本多包一層來讓使用者可以用 `make <目標>` 的統一介面做事，
   所以在使用 makefile 之前要記得確保腳本是可以被執行的

   目前 makefile 提供下列的目標
   | 目標       | 執行的動作                                                      |
   | ---------- | --------------------------------------------------------------- |
   | default    | 這是 copy 目標的別名，當 make 沒有給目標時的目標                |
   | copy       | 更新原始碼                                                      |
   | install    | 安裝 **.vimrc** 與 **init.vim**，使用前要確認安裝腳本可以被執行 |
   | uninstall  | 移除 **.vimrc** 與 **init.vim**，使用前要確認安裝腳本可以被執行 |

# 初次使用
  在第一次使用這個 vimrc 時

  1. 決定要不要使用插件
     - 不想用插件
       1. 在安裝前將 **settings.toml** 裡 **pluginManager** 表格的 **install** 改成 **false**
       2. 刪掉 vimrc 裡插件相關的行數

     - 想要使用插件
       1. 安裝插件管理員
          - 自動安裝

            在安裝前確認 **settings.toml** 裡 **pluginManager** 表格的 **install** 設成 **true**

          - 手動安裝

            1. 從 [插件](#插件) 中的連結進到 vim-plug 的網站
            2. 依照 readme 的指示下載 vim-plug

       2. 進入 vim 中輸入 `:PlugInstall`

          這樣就會自動安裝我在 [插件](#插件) 中提到的插件

  2. 好好享受這個 vimrc 吧

# 快捷鍵設定
  | 快捷鍵        | 需要的插件                              | 其他需求        | 功能                      |
  | ------------- | --------------------------------------- | --------------- | ------------------------- |
  | \<Leader> bb  | bufferize.vim                           |                 | bufferize vim 命令        |
  | \<Leader> bs  | bufferize.vim                           |                 | bufferize 系統命令        |
  | \<Leader> bn  | bufferize.vim                           |                 | bufferize 一般模式命令    |
  | \<Leader> m   | vim-quickhl                             |                 | 設置標籤高亮              |
  | \<Leader> M   | vim-quickhl                             |                 | 清除標籤高亮              |
  | Ctrl + 0      | zoom.vim                                |                 | 重置圖形介面字型          |
  | \<Leader> C   | vim-venter                              |                 | 置中視窗文字              |
  | Ctrl + x      | nerdtree                                |                 | 開關樹狀檢視器            |
  | \<Leader> t   | tagbar                                  | ctags           | 開關 tag 顯示             |
  | \<Leader> T   | tagbar                                  | ctags           | 顯示當前游標所在的 tag    |
  | \<Leader> F   | vim-clap                                |                 | 開啟模糊搜尋選單          |
  | g/            | vim-clap                                |                 | 檔案內搜尋                |
  | gb            | vim-clap                                |                 | 搜尋 buffer               |
  | \<Leader> f   | vim-clap                                |                 | 搜尋檔案                  |
  | \<Leader> f   | vim-clap                                | ripgrep         | 搜尋檔案內容              |
  | Ctrl + s      | neoterm                                 | 內建終端機      | 開關內建終端機            |
  | \<Leader> lo  | nvim-lspconfig 或 LanguageClient-neovim |                 | 開啟 LSP 客戶端           |
  | \<Leader> lc  | nvim-lspconfig 或 LanguageClient-neovim |                 | 關閉 LSP 客戶端           |
  |  gd           | nvim-lspconfig 或 LanguageClient-neovim | language server | 尋找定義                  |
  |  gr           | nvim-lspconfig 或 LanguageClient-neovim | language server | 尋找參考                  |
  |  K            | nvim-lspconfig 或 LanguageClient-neovim | language server | 顯示文檔                  |
  | \<Leader> a   | nvim-lspconfig 或 LanguageClient-neovim | clangd          | 切換 c++ 標頭與原始碼     |
  | \<Leader> s   | vim-signify                             |                 | 開關版本控制差異插件      |
  | \<Leader> d   | vim-signify                             | 版本控制程式    | 顯示版本控制片段差異      |
  | \<Leader> u   | vim-signify                             | 版本控制程式    | 回復版本控制片段          |
  | \<Leader> D   | vim-signify                             | 版本控制程式    | 顯示版本控制差異          |
  | Ctrl + s      | vim-snipmate                            | 插入模式        | 顯示可用的程式碼片段      |
  | Ctrl + q      |                                         | 內建終端機      | 離開終端機模式            |
  | \<Leader> r   |                                         |                 | 切換相對行號顯示          |
  | \<Leader> c   |                                         |                 | 切換游標高亮              |
  | \<Leader> L   |                                         |                 | 切換顯示特殊字元          |
  | 空白鍵        |                                         |                 | 向下滾動                  |
  | backspace 鍵  |                                         |                 | 向上滾動                  |
  | Ctrl + a      |                                         | 插入模式        | home 鍵                   |
  | Ctrl + e      |                                         | 插入模式        | end 鍵                    |
  | Ctrl + f      |                                         | 插入模式        | 右方向鍵                  |
  | Ctrl + b      |                                         | 插入模式        | 左方向鍵                  |
  | Ctrl + p      |                                         | 插入模式        | 上方向鍵                  |
  | Ctrl + n      |                                         | 插入模式        | 下方向鍵                  |
  | Ctrl + k      |                                         | 插入模式        | 刪除到行尾                |
  | Ctrl + d      |                                         | 插入模式        | delete 鍵                 |
  | Ctrl + _ s    |                                         | cscope          | cscope 尋找 C symbol      |
  | Ctrl + _ g    |                                         | cscope          | cscope 尋找定義           |
  | Ctrl + _ c    |                                         | cscope          | cscope 尋找函數參考       |
  | Ctrl + _ t    |                                         | cscope          | cscope 尋找字串           |
  | Ctrl + _ e    |                                         | cscope          | cscope 尋找 egrep pattern |
  | Ctrl + _ f    |                                         | cscope          | cscope 尋找檔案           |
  | Ctrl + _ i    |                                         | cscope          | cscope 尋找 include 檔案  |
  | Ctrl + _ d    |                                         | cscope          | cscope 尋找函數呼叫       |

# 自定義函式
  | 函數                                    | 功能                                        |
  | --------------------------------------- | ------------------------------------------- |
  | MyPluginExistsAndInRtp( name )          | 檢測插件是否存在與在 runtimepath            |
  | MyPluginExists( name, isCheckRtp )      | 檢測插件是否存在                            |
  | MyBuildInLspOmniFunc( findstart, base ) | 內建 lsp omni 的 wrapper                    |
  | MyLspMaps( isNvimBuiltin )              | lsp 的按鍵設定                              |
  | MyCustomHighlight()                     | 自訂顏色                                    |

# 插件
  | 分類          | 插件                                                                              | 用途                                                            | 需求                                                                |
  | ------------- | --------------------------------------------------------------------------------- | --------------------------------------------------------------- | ------------------------------------------------------------------- |
  | 插件管理員    | [vim-plug](https://github.com/junegunn/vim-plug)                                  | vim 插件管理員                                                  |                                                                     |
  | 色彩方案      | [nord-vim](https://github.com/arcticicestudio/nord-vim)                           | 暗色柔和色彩方案                                                |                                                                     |
  | 介面          | [nerdtree](https://github.com/scrooloose/nerdtree)                                | 樹狀檢視器                                                      |                                                                     |
  |               | [tagbar](https://github.com/majutsushi/tagbar)                                    | 顯示 tags                                                       | [ctags](#for-ctags)                                                 |
  |               | [bufferize.vim](https://github.com/AndrewRadev/bufferize.vim)                     | 讓命令顯示在 buffer                                             |                                                                     |
  |               | [vim-clap](https://github.com/liuchengxu/vim-clap)                                | 互動式查詢                                                      | nvim 0.4.2 or patch 8.1.2114                                        |
  |               | [neoterm](https://github.com/kassio/neoterm)                                      | 終端機插件                                                      | 內建終端機                                                          |
  |               | [zoom.vim](https://github.com/vim-scripts/zoom.vim)                               | 縮放圖形介面字型                                                | gui                                                                 |
  |               | [vim-venter](https://github.com/JMcKiern/vim-venter)                              | 置中視窗文字                                                    | nvim or vim 8.0                                                     |
  | 語言限定插件  | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)             | treesitter 語法高亮                                             | nvim 0.5, c 編譯器                                                  |
  |               | [vim-cpp-enhanced-highlight](http://github.com/octol/vim-cpp-enhanced-highlight)  | 增強 C++ 語法高亮                                               |                                                                     |
  |               | [vim-toml](https://github.com/cespare/vim-toml)                                   | [toml](https://toml.io/en/) 語法高亮                            |                                                                     |
  |               | [vim-perl](https://github.com/vim-perl/vim-perl)                                  | [perl](https://www.perl.org/) 語法高亮                          |                                                                     |
  |               | [vim-ps1](https://github.com/pprovost/vim-ps1)                                    | [powershell](https://github.com/PowerShell/PowerShell) 語法高亮 |                                                                     |
  | 自動補全      | [vim-mucomplete](https://github.com/lifepillar/vim-mucomplete)                    | 自動補全插件，用來取代 neocomplcache                            | nvim 0.5                                                         |
  |               | [neocomplcache](https://github.com/shougo/neocomplcache.vim)                      | 自動補全插件                                                    |                                                                     |
  | LSP           | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                        | 內建 LSP 客戶端設定                                             | nvim 0.5                                                            |
  |               | [LanguageClient-neovim](https://github.com/autozimu/LanguageClient-neovim)        | LSP 客戶端                                                      |                                                                     |
  | 版本控制      | [vim-signify](https://github.com/mhinz/vim-signify)                               | 版本控制差異插件                                                |                                                                     |
  | 程式碼片段    | [vim-snipmate](https://github.com/garbas/vim-snipmate)                            | 程式碼片段插件                                                  | vim-addon-mw-utils, tlibs                                           |
  |               | [vim-addon-mw-utils](https://github.com/MarcWeber/vim-addon-mw-utils)             | vim-snipmate 的依賴                                             |                                                                     |
  |               | [tlibs](https://github.com/tomtom/tlib_vim)                                       | vim-snipmate 的依賴                                             |                                                                     |
  | 標籤高亮      | [vim-quickhl](https://github.com/t9md/vim-quickhl)                                | 標籤高亮插件                                                    | vim-ingo-library                                                    |
  | 自用插件      | [FlotisableStatusLine](https://github.com/flotisable/FlotisableStatusLine)        | 自用的狀態列設定                                                |                                                                     |
  |               | [FlotisableVimSnipets](https://github.com/flotisable/FlotisableVimSnippets)       | 自用的程式碼片段                                                | vim-snipmate                                                        |

## 關於 ctags
   ctags 只支援 c/c++ 語言，如果要支援其他語言，可以試試看這些
   - [exuberant ctags](http://ctags.sourceforge.net/)            : 支援多種語言的 ctags ( 現在好像沒在維護了 )
   - [universal ctags](https://github.com/universal-ctags/ctags) : 接續 exuberant ctags 開發的 ctags
