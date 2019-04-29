#!/bin/sh

if [ -z ${OS} ]; then
  OS=$(uname -s);
fi

. ./settings

if [ -z ${nvimrcDir} ]; then
  nvimrcDir=$(./default.sh ${OS});
fi

if [ \( ${installPluginManager} -eq 1 \) -a ! -e ${pluginManagerPath}/plug.vim ]; then
  curl -fLo ${pluginManagerPath}/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;
fi

cp ${vimrcSourceFile} ${vimrcDir}/${vimrcTargetFile}
cp ${nvimrcSourceFile} ${nvimrcDir}/${nvimrcTargetFile}
cp ${ngvimrcSourceFile} ${nvimrcDir}/${ngvimrcTargetFile}
