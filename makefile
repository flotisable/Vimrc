include settings

all: $(vimrcDir)/$(vimrcTargetFile) $(nvimrcDir)/$(nvimrcTargetFile)
	cp $^ .

install:
	./installVimrc.sh

uninstall:
	rm $(vimrcDir)/$(vimrcTargetFile)
	rm $(nvimrcDir)/$(nvimrcTargetFile)
