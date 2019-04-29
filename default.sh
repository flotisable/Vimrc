#!/bin/sh

os=$1

case ${os} in

  Linux       ) echo "${HOME}/.config/nvim";;
  Windows_NT  ) echo "${LOCALAPPDATA}\\nvim";;
  Darwin      ) echo "${HOME}/.config/nvim";;

esac
