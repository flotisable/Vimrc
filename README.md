# Vimrc
  for backup and share my vimrc file

[Traditional Chinese README](README_zh-TW.md)

# Indexes
  - [Files](#files)
  - [To use vimrc](#to-use-vimrc)
  - [Install](#install)
    - [Settings](#settings)
    - [Using Install Script](#using-install-script)
    - [Using Makefile](#using-makefile)
  - [Getting Start](#getting-start)
  - [KeyBindings](#key-bindings)
  - [Self Defined Functions](#self-defined-functions)
  - [Plugins](#plugins)
    - [For ctags](#for-ctags)

# Files
  - **vim** and **neovim** setting files
    - **.vimrc**              : settings for [vim](https://github.com/vim/vim)
    - **init.vim**            : settings for [neovim](https://github.com/neovim/neovim)
    - **ginit.vim**           : settings for gui of **neovim**
  - repository usage settings
    - **settings.toml**       : settings for installation/uninstallation
    - **defaultPath.toml**    : settings for default paths in different os
  - repository usage scripts
    - unified UI
      - **makefile**          : makefile for **.vimrc** and **init.vim**
    - install scripts
      - **install.ps1**       : powershell install script for Windows
      - **install.sh**        : bash install script for Linux and MacOS
    - uninstall scripts
      - **uninstall.ps1**     : powershell uninstall script for Windows
      - **uninstall.sh**      : bash uninstall script for Linux and MacOS
    - copy scripts
      - **copy.ps1**          : powershell copy script for Windows
      - **copy.sh**           : bash copy script for Linux and MacOS
    - helper scripts
      - **readSettings.ps1**  : powershell helper script for Windows
      - **readSettings.sh**   : bash helper script for Linux and MacOS

# To Use Vimrc
  Open the vim and type `:help vimrc`,
  it will show the help file about where to put vimrc.
  If you don't use neovim,
  just ignore the `init.vim` and `ginit.vim` file.
  After putting vimrc in the right directory,
  you can type `:e $MYVIMRC` in vim to edit the vimrc file.

  I place my vimrc as shown in the table below,
  these are the default directories for vimrc
  | OS            | File      | Path                      |
  | ------------- | --------- | ------------------------- |
  | Linux, MacOS  | .vimrc    | `$HOME/`                  |
  |               | init.vim  | `$HOME/.config/nvim/`     |
  | Windows       | .vimrc    | `$HOME\`                  |
  |               | init.vim  | `$XDG_CONFIG_HOME\nvim\`  |

  I don't use vim on Windows,
  if you use neovim,
  you can just place ".vimrc" to a directory and modify the `source ~/.vimrc` line in "init.vim" to that directory.
  For example, if you put ".vimrc" at `D:\Vim\`,
  then modify the source line as below
  ```
  source D:\Vim\.vimrc
  ```
  else read the vim help file to know where to put the ".vimrc"

# Install
## Settings
   The install settings can be configured by modifying the **settings.toml** file,
   it is a normal [toml](https://toml.io/en/) file

   | Table          | Controled Setting                                                 |
   | -------------- | ----------------------------------------------------------------- |
   | dir            | the installed directory                                           |
   | source         | the files name in the repository                                  |
   | target         | the installed files name                                          |
   | pluginManager  | whether to install and the installed directory of plugin manager  |

## Using Install Script
   The scripts are written in **bash** and **powershell** script,
   so any shell support **bash** or **powershell** script should be able to be used

   To use the script

   1. `chmod u+x install.sh` to make the script executable if use bash script
   2. modify **settings.toml** if neccessary
   3. if you don't use neovim, just comment the **nvimrc** and **gnvimrc** line in **settings.toml** with `#` at the beginning of the line
   4. type `./install.sh` or `pwsh ./install.ps1` to install

## Using Makefile
   Makefile is written for those who want to use **make** to finish the tasks.
   It is also used to ease the update of source file from me.
   The makefile just wrap the scripts in the repository and use
   `make <target>` format command for unified UI,
   so make sure the install script is executable before using makefile.

   Currently, the makefile support the following target

   | Target     | Action                                                              |
   | ---------- | ------------------------------------------------------------------- |
   | default    | alias of copy target, this is `make` without target                 |
   | copy       | update the source file                                              |
   | install    | install vimrc files, make sure the install script is executable     |
   | uninstall  | uninstall vimrc files, make sure the uninstall script is executable |

# Getting Start
  For using the vimrc first time

  1. decide whether you want to use the plugin or not
     - don't want to use the plugins
       1. set the **install** key of **pluginManager** to **false** in **settings.toml** before installation
       2. delete the lines related to plugin settings in the vimrc

     - want to use the plugins,
       1. install plugin manager
          - automatically install plugin manager

            make sure the **install** key of **pluginManager** is **ture** in **settings.toml** before installation

          - manually install plugin manager

            1. follow the link in the [Plugins](#plugins)
            2. follow the readme file of **vim-plug** to download it

       2. type `:PlugInstall` in vim

          it will automatically download the plugins mentioned in the [Plugins](#plugins)
  2. have fun with this vimrc

# Key Bindings
  | Keybinding    | Required Plugin                         | Other Requirement | Action                                |
  | ------------- | --------------------------------------- | ----------------- | ------------------------------------- |
  | \<Leader> bb  | bufferize.vim                           |                   | bufferize command                     |
  | \<Leader> bs  | bufferize.vim                           |                   | bufferize system command              |
  | \<Leader> bn  | bufferize.vim                           |                   | bufferize normal mode command         |
  | \<Leader> m   | vim-quickhl                             |                   | set mark highlight                    |
  | \<Leader> M   | vim-quickhl                             |                   | clear mark highlight                  |
  | Ctrl + 0      | zoom.vim                                |                   | reset gui font                        |
  | gc            | nerdcommenter                           |                   | comment code                          |
  | \<Leader> C   | vim-venter                              |                   | center window text                    |
  | \<Leader> t   | tagbar                                  | ctags             | toggle tagbar, show the tags overview |
  | \<Leader> T   | tagbar                                  | ctags             | show tag in current cursor position   |
  | \<Leader> F   | vim-clap                                |                   | open fuzzy finder providers           |
  | g/            | vim-clap                                |                   | search in file                        |
  | gb            | vim-clap                                |                   | search buffer                         |
  | \<Leader> f   | vim-clap                                |                   | search file                           |
  | \<Leader> g   | vim-clap                                | ripgrep           | grep files                            |
  | Ctrl + s      | neoterm                                 | builtin terminal  | toggle builtin terminal               |
  | \<Leader> lo  | nvim-lspconfig or LanguageClient-neovim |                   | start language client                 |
  | \<Leader> lc  | nvim-lspconfig or LanguageClient-neovim |                   | stop language client                  |
  |  gd           | nvim-lspconfig or LanguageClient-neovim | language server   | go to definition                      |
  |  gr           | nvim-lspconfig or LanguageClient-neovim | language server   | find reference                        |
  |  K            | nvim-lspconfig or LanguageClient-neovim | language server   | show hover                            |
  |  gi           | nvim-lspconfig or LanguageClient-neovim | language server   | go to implementation                  |
  |  =            | nvim-lspconfig or LanguageClient-neovim | language server   | format range                          |
  | \<Leader> lr  | nvim-lspconfig or LanguageClient-neovim | language server   | rename symbol                         |
  | \<Leader> la  | nvim-lspconfig or LanguageClient-neovim | language server   | code action                           |
  | \<Leader> a   | nvim-lspconfig or LanguageClient-neovim | clangd            | switch c++ header, source file        |
  | \<Leader> s   | vim-signify                             |                   | toggle VCS diff                       |
  | \<Leader> d   | vim-signify                             | VCS               | show VCS hunk diff                    |
  | \<Leader> u   | vim-signify                             | VCS               | undo VCS hunk                         |
  | \<Leader> D   | vim-signify                             | VCS               | show VCS full diff                    |
  | Ctrl + s      | vim-snipmate                            | insert mode       | show available snippets               |
  | Ctrl + x      | netrw                                   |                   | toggle the tree browser               |
  | Ctrl + q      |                                         | builtin terminal  | exit terminal mode                    |
  | \<Leader> r   |                                         |                   | toggle relative line number           |
  | \<Leader> c   |                                         |                   | toggle cursor line, column highlight  |
  | \<Leader> L   |                                         |                   | toggle show special characters        |
  | \<Leader> er  |                                         |                   | edit vimrc                            |
  | \<Leader> el  |                                         |                   | edit local vimrc                      |
  | space         |                                         |                   | scroll forward                        |
  | backspace     |                                         |                   | scroll backward                       |
  | Ctrl + a      |                                         | insert mode       | home                                  |
  | Ctrl + e      |                                         | insert mode       | end                                   |
  | Ctrl + f      |                                         | insert mode       | right                                 |
  | Ctrl + b      |                                         | insert mode       | left                                  |
  | Ctrl + p      |                                         | insert mode       | up                                    |
  | Ctrl + n      |                                         | insert mode       | down                                  |
  | Ctrl + k      |                                         | insert mode       | delete to the end of line             |
  | Ctrl + d      |                                         | insert mode       | delete                                |
  | Ctrl + _ s    |                                         | cscope            | cscope find C symbol                  |
  | Ctrl + _ g    |                                         | cscope            | cscope find definition                |
  | Ctrl + _ c    |                                         | cscope            | cscope find function call             |
  | Ctrl + _ t    |                                         | cscope            | cscope find string                    |
  | Ctrl + _ e    |                                         | cscope            | cscope find egrep pattern             |
  | Ctrl + _ f    |                                         | cscope            | cscope find file                      |
  | Ctrl + _ i    |                                         | cscope            | cscope find includes                  |
  | Ctrl + _ d    |                                         | cscope            | cscope find function called           |

# Self Defined Functions
  | Function                                | Description                                             |
  | --------------------------------------- | ------------------------------------------------------- |
  | MyPluginExistsAndInRtp( name )          | test pluggin existence and in runtimepath               |
  | MyPluginExists( name, isCheckRtp )      | test pluggin existence                                  |
  | MyBuildInLspOmniFunc( findstart, base ) | wrapper of builtin lsp omnifunc                         |
  | MyLspMaps( isNvimBuiltin )              | setup buffer local keybinding for lsp                   |
  | MyCustomHighlight()                     | setup custom highlight to overwrite colorscheme         |
  | MyNetrwMaps()                           | setup buffer local keybinding for netrw                 |

# Plugins
  | Category          | Plugin                                                                            | Purpose                                                                     | Requirement                                                         |
  | ----------------- | --------------------------------------------------------------------------------- | --------------------------------------------------------------------------- | ------------------------------------------------------------------- |
  | Plugin Manager    | [vim-plug](https://github.com/junegunn/vim-plug)                                  | vim plugins manager                                                         |                                                                     |
  | Colorscheme       | [nord-vim](https://github.com/arcticicestudio/nord-vim)                           | dark, smooth colorscheme                                                    |                                                                     |
  | UI                | [tagbar](https://github.com/majutsushi/tagbar)                                    | to display tags                                                             | [ctags](#for-ctags)                                                 |
  |                   | [bufferize.vim](https://github.com/AndrewRadev/bufferize.vim)                     | make command output a buffer                                                |                                                                     |
  |                   | [vim-clap](https://github.com/liuchengxu/vim-clap)                                | plugin for interactive finder and dispatcher                                | nvim 0.4.2 or patch 8.1.2114                                        |
  |                   | [neoterm](https://github.com/kassio/neoterm)                                      | terminal plugin                                                             | builtin terminal                                                    |
  |                   | [zoom.vim](https://github.com/vim-scripts/zoom.vim)                               | zoom gui font                                                               | gui                                                                 |
  |                   | [vim-venter](https://github.com/JMcKiern/vim-venter)                              | center window text                                                          | nvim or vim 8.0                                                     |
  | Language Specific | [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)             | treesitter syntax highlight                                                 | nvim 0.5, c compiler                                                |
  |                   | [vim-cpp-enhanced-highlight](http://github.com/octol/vim-cpp-enhanced-highlight)  | to add some highlight feature of C++                                        |                                                                     |
  |                   | [vim-toml](https://github.com/cespare/vim-toml)                                   | syntax highlight of [toml](https://toml.io/en/)                             |                                                                     |
  |                   | [vim-perl](https://github.com/vim-perl/vim-perl)                                  | syntax highlight of [perl](https://www.perl.org/)                           |                                                                     |
  |                   | [vim-ps1](https://github.com/pprovost/vim-ps1)                                    | syntax highlgiht of [powershell](https://github.com/PowerShell/PowerShell)  |                                                                     |
  | Autocomplete      | [vim-mucomplete](https://github.com/lifepillar/vim-mucomplete)                    | autocomplete plugin, to replace neocomplcache                               | vim 7.2, has( insert_expand ), has( menu )                          |
  |                   | [neocomplcache](https://github.com/shougo/neocomplcache.vim)                      | autocomplete plugin                                                         |                                                                     |
  | LSP               | [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)                        | builtin language server client configuration                                | nvim 0.5                                                            |
  |                   | [LanguageClient-neovim](https://github.com/autozimu/LanguageClient-neovim)        | language server client                                                      |                                                                     |
  | VCS               | [vim-signify](https://github.com/mhinz/vim-signify)                               | VCS diff plugin                                                             |                                                                     |
  | Code Snippet      | [vim-snipmate](https://github.com/garbas/vim-snipmate)                            | code snippet plugin                                                         | vim-addon-mw-utils, tlibs                                           |
  |                   | [vim-addon-mw-utils](https://github.com/MarcWeber/vim-addon-mw-utils)             | dependency of vim-snipmate                                                  |                                                                     |
  |                   | [tlibs](https://github.com/tomtom/tlib_vim)                                       | dependency of vim-snipmate                                                  |                                                                     |
  | Mark              | [vim-quickhl](https://github.com/t9md/vim-quickhl)                                | mark highlight plugin                                                       |                                                                     |
  | Misc              | [vim-hugefile](https://github.com/mhinz/vim-hugefile)                             | disable some feature when edit large file                                   |                                                                     |
  |                   | [nerdcommenter](https://github.com/preservim/nerdcommenter)                       | comment code                                                                |                                                                     |
  | Self Used         | [FlotisableStatusLine](https://github.com/flotisable/FlotisableStatusLine)        | a self use plugin to set up the status line                                 |                                                                     |
  |                   | [FlotisableVimSnipets](https://github.com/flotisable/FlotisableVimSnippets)       | a self use code snippets                                                    | vim-snipmate                                                        |

## For ctags
   ctags only support c/c++ language, for other language you can try
   - [exuberant ctags](http://ctags.sourceforge.net/)            : a ctags support many language( seems not in maintenance now )
   - [universal ctags](https://github.com/universal-ctags/ctags) : the continuous of exuberant ctags
