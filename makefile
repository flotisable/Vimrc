OS ?= $(shell uname -s)

include settings

empty :=
comma := ,

ifeq "${OS}" "Windows_NT"
	defaultScript := powershell -NoProfile ./default.ps1
else
	defaultScript := ./default.sh
endif

ifeq "${nvimrcDir}" ""
nvimrcDir := $(shell ${defaultScript} ${OS})
endif

targetFiles := \
	${vimrcDir}/${vimrcTargetFile} \
	${nvimrcDir}/${nvimrcTargetFile} \
	${nvimrcDir}/${ngvimrcTargetFile}

all: ${targetFiles}
ifeq "${OS}" "Windows_NT"
	powershell -NoProfile -Command "Copy-Item $(subst ${empty} ${empty},${comma},$^) ."
else
	@./copy.sh
endif

install:
ifeq "${OS}" "Windows_NT"
	@powershell -NoProfile ./install.ps1
else
	@./install.sh
endif

uninstall:
ifeq "${OS}" "Windows_NT"
	@powershell -NoProfile ./uninstall.ps1
else
	@./uninstall.sh
endif
