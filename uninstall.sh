#!/bin/sh
. ./settings

if [ -z ${OS} ]; then
  OS=$(uname -s);
fi

echo "detected OS: ${OS}"

if [ -z "${nvimrcDir}" ]; then
  nvimrcDir=$(./default.sh ${OS})
fi

targetFiles="
${vimrcDir}/${vimrcTargetFile}
${nvimrcDir}/${nvimrcTargetFile}
${nvimrcDir}/${ngvimrcTargetFile}
"

echo "uninstall rc files"
for file in ${targetFiles}; do \
  rm ${file}; \
done

if [ -e ${pluginManagerPath}/plug.vim ]; then
  rm ${pluginManagerPath}/plug.vim
fi
