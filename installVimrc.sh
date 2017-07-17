#!/bin/sh

vimrcDir=~
nvimrcDir=~/.config/nvim

vimrcSourceFile=".vimrc"
nvimrcSourceFile="init.vim"

vimrcTargetFile=".vimrc"
nvimrcTargetFile="init.vim"

cp ${vimrcSourceFile} ${vimrcDir}/${vimrcTargetFile}
cp ${nvimrcSourceFile} ${nvimrcDir}/${nvimrcTargetFile}
