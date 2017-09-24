# Vimrc
for backup and share my vimrc file

[Traditional Chinese README](README_zh-TW.md)
# Files
- **.vimrc**          : settings for [vim](https://github.com/vim/vim)
- **init.vim**        : settings for [neovim](https://github.com/neovim/neovim)
- **installVimrc.sh** : install script for **.vimrc** and **init.vim**
- **makefile**        : makefile for **.vimrc** and **init.vim**
# To use vimrc
open the vim and type **:help vimrc**, then it will show the help file about where to put vimrc

if you don't use neovim, just ignore the "init.vim" file

after you put vimrc in the right directory, you can type **:e $MYVIMRC** in vim to edit the vimrc file

I will talk about where I place my vimrc below as an example
## For Linux and Mac
I place the ".vimrc" at "$HOME/" and "init.vim" at "$HOME/.config/nvim/"

this is the default directory of vimrc
## For Windows
I place the "init.vim" at "$XDG_CONFIG_HOME\nvim\\"

as for ".vimrc", I don't use vim on Windows, so if you use neovim just place it to a directory and modify the **"source ~/.vimrc"** line in "init.vim" with the path you place ".vimrc"

for example, if you put ".vimrc" at "D:\Vim\\", then modify the source line as below
```
source D:\Vim\.vimrc
```

else read the vim help file to know where to put the ".vimrc"
# Install
## Using Install Script
the script is written in **bash** script, so any shell support bash script can be used

to use the script

- first ```chmod u+x installVimrc.sh``` to make the script executable
- modify the variables in script if neccessary
- if you don't use neovim, just comment the line ```cp ${nvimrcSourceFile} ...``` with '#' at the beginning of the line
- type ```./installVimrc.sh``` to install **.vimrc** and **init.vim** file

there are two ways to set the variables in the script
### Modify The Script
- the directory path **vimrcDir** and **nvimrcDir**

  this is the installed directory of **.vimrc** and **init.vim** respectively
- the target file name **vimrcTargetFile** and **nvimrcTargetFile**

  this is the installed file name of **.vimrc** and **init.vim** respectively
### Using Arguments
there are six arguments of the script, if not being specified, the default will be used

1. vimrcDir         : the installed directory of **.vimrc**
2. vimrcTargetFile  : the installed file name of **.vimrc**
3. nvimrcDir        : the installed directory of **init.vim**
4. nvimrcTargetFile : the installed file name of **init.vim**
5. vimSourceFile    : the source file name of **.vimrc**
6. nvimSourceFile   : the source file name of **init.vim**
## Using Makefile
makefile is written for those who want to use **make** to finish the task

it is also used to ease the update of source file from me

currently, the makefile support the following options
- default   : update the source file

  this is **make** with no option
- install   : install **.vimrc** and **init.vim**

  actually this option use the install script, so make sure the install script is executable
- uninstall : uninstall **.vimrc** and **init.vim**

to change the path and file name of **.vimrc** and **init.vim**, just modify the variables of makefile

the variables is the same as the install script
# Key Bindings
- Ctrl+x      : toggle the tree browser
- \<Leader> r : toggle relativenumber setting
## Neovim Specific Key Mappings
- Ctrl+s : toggle the terminal
- Ctrl+q : exit teminal mode in neovim
# Self Defined Functions
- FlotisableToggleRelativeNumber() : toggle relativenumber setting
# Plugins
- [vim-plug](https://github.com/junegunn/vim-plug)                                  : vim plugins manager
- [nerdtree](https://github.com/scrooloose/nerdtree)                                : to browse the directory in a tree view
- [neocomplcache](https://github.com/shougo/neocomplcache.vim)                      : autocomplete plugin( I use this because my vim version is old, for newer version you can try [YouCompleteMe](https://github.com/valloric/youcompleteme) or [neocomplete](https://github.com/shougo/neocomplete.vim) )
- [tagbar](https://github.com/majutsushi/tagbar)                                    : to display tags( depend on ctags )
- [vim-cpp-enhanced-highlight](http://github.com/octol/vim-cpp-enhanced-highlight)  : to add some highlight feature of C++
## Neovim Specific Plugins
- [neoterm](https://github.com/kassio/neoterm)                  : terminal plugin
## For ctags
ctags only support c/c++ language, for other language you can try
- [exuberant ctags](http://ctags.sourceforge.net/)            : a ctags support many language( seems not in maintenance now )
- [universal ctags](https://github.com/universal-ctags/ctags) : the continuous of exuberant ctags
