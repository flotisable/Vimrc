OS ?= $(shell uname -s)

GIT := git

scriptDir := Scripts

mainBranch  := master
localBranch := local

.PHONY: default copy install uninstall sync sync-from-remote sync-to-remote
default: copy

copy:
ifeq "${OS}" "Windows_NT"
	powershell -NoProfile ./${scriptDir}/copy.ps1
else
	@./${scriptDir}/copy.sh
endif

install:
ifeq "${OS}" "Windows_NT"
	@powershell -NoProfile ./${scriptDir}/install.ps1
else
	@./${scriptDir}/install.sh
endif

uninstall:
ifeq "${OS}" "Windows_NT"
	@powershell -NoProfile ./${scriptDir}/uninstall.ps1
else
	@./${scriptDir}/uninstall.sh
endif

sync: sync-from-remote sync-from-local sync-main-and-local sync-to-remote sync-from-remote
	@${MAKE} install

sync-init:
	@${GIT} checkout ${mainBranch}
	@${GIT} checkout -B ${localBranch}

sync-from-remote: sync-init
	@${GIT} checkout ${mainBranch}
	@${GIT} pull
	@${GIT} checkout ${localBranch}
	@${GIT} merge ${mainBranch}

sync-from-local: sync-init
	@${GIT} checkout ${localBranch}
	@${MAKE} copy
	@${GIT} add -up
	@-${GIT} commit

sync-main-and-local: sync-init
	@${GIT} checkout ${localBranch}
	@${MAKE} copy
	@${GIT} stash
	@${GIT} checkout ${mainBranch}
	@${GIT} stash apply
	@${GIT} mergetool
	@${GIT} add -up
	@${GIT} commit
	@${GIT} stash drop

sync-to-remote:
	@${GIT} checkout ${mainBranch}
	@${GIT} push
