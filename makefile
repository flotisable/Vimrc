OS ?= $(shell uname -s)

GIT := git

scriptDir := Scripts

mainBranch  := master
localBranch := local

.PHONY: default
default: copy

.PHONY: copy
copy:
ifeq "${OS}" "Windows_NT"
	powershell -NoProfile ./${scriptDir}/copy.ps1
else
	@./${scriptDir}/copy.sh
endif

.PHONY: install
install:
ifeq "${OS}" "Windows_NT"
	@powershell -NoProfile ./${scriptDir}/install.ps1
else
	@./${scriptDir}/install.sh
endif

.PHONY: uninstall
uninstall:
ifeq "${OS}" "Windows_NT"
	@powershell -NoProfile ./${scriptDir}/uninstall.ps1
else
	@./${scriptDir}/uninstall.sh
endif

.PHONY: sync
sync: sync-main-to-local sync-from-local sync-main-from-local sync-to-remote
	@${MAKE} sync-to-local

.PHONY: sync-init
sync-init:
	@${GIT} checkout ${mainBranch}
	@${GIT} checkout -B ${localBranch}

.PHONY: sync-main-to-local
sync-main-to-local: sync-init sync-from-remote
	@${GIT} checkout ${localBranch}
	@${GIT} merge ${mainBranch}
	@${GIT} mergetool
	@-${GIT} commit

.PHONY: sync-from-remote
sync-from-remote: sync-init
	@${GIT} checkout ${mainBranch}
	@${GIT} pull

.PHONY: sync-from-local
sync-from-local: sync-init
	@${GIT} checkout ${localBranch}
	@${MAKE} copy
	@${GIT} add -up
	@-${GIT} commit

.PHONY: sync-main-from-local
sync-main-from-local: sync-init
	@${GIT} checkout ${localBranch}
	@${MAKE} copy
	@${GIT} stash
	@${GIT} checkout ${mainBranch}
	@${GIT} stash apply
	@${GIT} mergetool
	@${GIT} add -up
	@-${GIT} commit
	@${GIT} stash drop

.PHONY: sync-to-remote
sync-to-remote:
	@${GIT} checkout ${mainBranch}
	@${GIT} push

.PHONY: sync-to-local
sync-to-local: sync-init sync-main-to-local
	@${GIT} checkout ${localBranch}
	@${MAKE} install
