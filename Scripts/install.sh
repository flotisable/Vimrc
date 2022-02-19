#!/bin/sh
settingFile="./settings.toml"

scriptDir="$(dirname $0)"

. ${scriptDir}/readSettings.sh ${settingFile}

installFile()
{
  local sourceFile=$1
  local targetFile=$2
  local fileMessage=$3

  echo "install $fileMessage"
  cp $sourceFile $targetFile 
}

targetTableName=$(mapFind "settings" "target")
sourceTableName=$(mapFind "settings" "source")
dirTableName=$(mapFind "settings" "dir")
pluginManagerTableName=$(mapFind "settings" "pluginManager")

for target in $(mapKeys "$targetTableName"); do

  targetFile=$(mapFind "$targetTableName" "$target")
  sourceFile=$(mapFind "$sourceTableName" "$target")

  case $target in

    'pluginManager')

      dirType='vimShare'
      if [ "$(mapFind "$pluginManagerTableName" "install")" != "1" ]; then
        continue
      fi
      ;;

    'vimrcLocal') dirType='vimShare';;
    'vimrc')      dirType='vim';;
    *)            dirType='nvim';;

  esac

  dir=$(mapFind "$dirTableName" "$dirType")

  installFile $sourceFile $dir/$targetFile $target

done
