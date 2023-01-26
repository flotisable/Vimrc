#!/bin/sh
settingFile="./settings.toml"

scriptDir="$(dirname $0)"

. ${scriptDir}/readSettings.sh ${settingFile}

removeFile()
{
  local file=$1

  echo "remove $file"
  rm $file
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

  removeFile $targetFile

done
