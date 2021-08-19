OS ?= $(shell uname -s)

.PHONY: default copy install uninstall
default: copy

copy:
ifeq "${OS}" "Windows_NT"
	powershell -NoProfile ./copy.ps1
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
