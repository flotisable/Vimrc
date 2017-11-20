#!/bin/sh

vimrcDir=~
nvimrcDir=~/.config/nvim

vimrcSourceFile=".vimrc"
nvimrcSourceFile="init.vim"

vimrcTargetFile=".vimrc"
nvimrcTargetFile="init.vim"

if [ $# -eq 1 -a -n $1 ]; then vimrcDir=$1;         fi
if [ $# -eq 2 -a -n $2 ]; then vimrcTargetFile=$2;  fi
if [ $# -eq 3 -a -n $3 ]; then nvimrcDir=$3;        fi
if [ $# -eq 4 -a -n $4 ]; then nvimrcTargetFile=$4; fi
if [ $# -eq 5 -a -n $5 ]; then vimrcSourceFile=$5;  fi
if [ $# -eq 6 -a -n $6 ]; then nvimrcSourceFile=$6; fi

cp ${vimrcSourceFile} ${vimrcDir}/${vimrcTargetFile}
cp ${nvimrcSourceFile} ${nvimrcDir}/${nvimrcTargetFile}
