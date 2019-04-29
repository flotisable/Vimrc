OS ?= $(shell uname -s)

include settings

ifeq "${nvimrcDir}" ""
nvimrcDir := $(shell ./default.sh ${OS})
endif

targetFiles := \
	${vimrcDir}/${vimrcTargetFile} \
	${nvimrcDir}/${nvimrcTargetFile} \
	${nvimrcDir}/${ngvimrcTargetFile}

all: ${targetFiles}
	cp $^ .

install:
	./installVimrc.sh

uninstall:
	for file in ${targetFiles}; do \
		rm $${file}; \
	done
	if [ -e $(pluginManagerPath)/plug.vim ]; then rm $(pluginManagerPath)/plug.vim; fi
