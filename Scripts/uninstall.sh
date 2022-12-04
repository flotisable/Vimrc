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

targetTableName=$(mapFind "settings" "target")
dirTableName=$(mapFind "settings" "dir")
pluginManagerTableName=$(mapFind "settings" "pluginManager")

for target in $(mapKeys "$targetTableName"); do

  targetFile=$(mapFind "$targetTableName" "$target")

  case $target in

    'pluginManager')

      dirType='vimShare'
      if [ "$(mapFind "$pluginManagerTableName" "install")" != "1" ]; then
        continue
      fi
      ;;

    'ft')         dirType='vimShare';;
    'vimrcLocal') dirType='vimShare';;
    'vimrc')      dirType='vim';;
    *)            dirType='nvim';;

  esac

  dir=$(mapFind "$dirTableName" "$dirType")

  removeFile $dir/$targetFile

done
