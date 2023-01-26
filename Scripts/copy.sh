#!/bin/sh
settingFile="./settings.toml"

scriptDir="$(dirname $0)"

. ${scriptDir}/readSettings.sh ${settingFile}

dirTableName=$(mapFind "settings" "dir")

root=$(mapFind "$dirTableName" "root")

for file in $(find -L "Rcs/$os" -type f -printf '%P\n'); do

  targetFile="$root/$file"
  sourceFile="Rcs/$os/$file"

  if [ ! -r "$targetFile" ]; then
    continue
  fi

  echo "copy $targetFile to $sourceFile"
  cp $targetFile $sourceFile

done
