#!/bin/sh

os=$1

case ${os} in

  linux   ) echo "${HOME}/.config/nvim";;
  windows ) echo "${LOCALAPPDATA}\\nvim";;
  macos   ) echo "${HOME}/.config/nvim";;

esac
