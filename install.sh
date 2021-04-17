#!/bin/sh

if [ -z ${OS} ]; then
  OS=$(uname -s);
fi

echo "detected OS: ${OS}"

. ./settings

if [ -z ${nvimrcDir} ]; then
  nvimrcDir=$(./default.sh ${OS});
fi

if [ \( ${installPluginManager} -eq 1 \) -a ! -e ${pluginManagerPath}/plug.vim ]; then
  echo "install vim-plug";
  curl -fLo ${pluginManagerPath}/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim;
fi

echo "install vimrc"
cp ${vimrcSourceFile} ${vimrcDir}/${vimrcTargetFile}
echo "install nvim init file"
cp ${nvimrcSourceFile} ${nvimrcDir}/${nvimrcTargetFile}
echo "install nvim ginit file"
cp ${ngvimrcSourceFile} ${nvimrcDir}/${ngvimrcTargetFile}
