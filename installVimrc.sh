#!/bin/sh

. ./settings

if [ \( ${installPluginManager} -eq 1 \) -a ! -e ${pluginManagerPath}/plug.vim ]; then
  curl -fLo ${pluginManagerPath}/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;
fi

cp ${vimrcSourceFile} ${vimrcDir}/${vimrcTargetFile}
cp ${nvimrcSourceFile} ${nvimrcDir}/${nvimrcTargetFile}
