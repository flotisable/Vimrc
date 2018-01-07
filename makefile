include settings

all: $(vimrcDir)/$(vimrcTargetFile) $(nvimrcDir)/$(nvimrcTargetFile)
	cp $^ .

install:
	./installVimrc.sh

uninstall:
	rm $(vimrcDir)/$(vimrcTargetFile)
	rm $(nvimrcDir)/$(nvimrcTargetFile)
	if [ -e $(pluginManagerPath)/plug.vim ]; then rm $(pluginManagerPath)/plug.vim; fi
