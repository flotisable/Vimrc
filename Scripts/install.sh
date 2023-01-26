#!/bin/sh
settingFile="./settings.toml"

scriptDir="$(dirname $0)"

. ${scriptDir}/readSettings.sh ${settingFile}

installFile()
{
  local sourceFile=$1
  local targetFile=$2
  local fileMessage=$3

  local dir
  dir="$(dirname $targetFile)"

  mkdir -vp $dir  
  echo "install $fileMessage"
  cp $sourceFile $targetFile 
}

dirTableName=$(mapFind "settings" "dir")
pluginManagerTableName=$(mapFind "settings" "pluginManager")

root=$(mapFind "$dirTableName" "root")

for file in $(find -L "Rcs/$os" -type f -printf '%P\n'); do

  targetFile="$root/$file"
  sourceFile="Rcs/$os/$file"

  if echo $file | grep -q 'plug' && [ "$(mapFind "$pluginManagerTableName" "install")" != "1" ]; then
    continue
  fi

  installFile $sourceFile $targetFile $file

done
