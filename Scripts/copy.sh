#!/bin/sh
settingFile="./settings.toml"

scriptDir="$(dirname $0)"

. ${scriptDir}/readSettings.sh ${settingFile}

targetTableName=$(mapFind "settings" "target")
sourceTableName=$(mapFind "settings" "source")
dirTableName=$(mapFind "settings" "dir")

for target in $(mapKeys "$targetTableName"); do

  targetFile=$(mapFind "$targetTableName" "$target")
  sourceFile=$(mapFind "$sourceTableName" "$target")

  case $target in

    'vimrc')                        dirType='vim';;
    'pluginManager' | 'vimrcLocal') dirType='vimShare';;
    *)                              dirType='nvim';;

  esac

  dir=$(mapFind "$dirTableName" "$dirType")

  if [ -r "$dir/$targetFile" ]; then

    echo "copy $dir/$targetFile to $sourceFile"
    cp $dir/$targetFile $sourceFile

  fi

done
