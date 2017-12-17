#!/bin/sh

source ./settings

cp ${vimrcSourceFile} ${vimrcDir}/${vimrcTargetFile}
cp ${nvimrcSourceFile} ${nvimrcDir}/${nvimrcTargetFile}
