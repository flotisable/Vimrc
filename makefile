vimrcDir=$(HOME)
nvimrcDir=$(HOME)/.config/nvim

vimrcSourceFile=.vimrc
nvimrcSourceFile=init.vim

vimrcTargetFile=.vimrc
nvimrcTargetFile=init.vim

all: $(vimrcDir)/$(vimrcTargetFile) $(nvimrcDir)/$(nvimrcTargetFile)
	cp $^ .

install:
	./installVimrc.sh $(vimrcDir) $(vimrcTargetFile) $(nvimrcDir) $(nvimrcTargetFile) $(vimrcSourceFile) $(nvimrcSourceFile)

uninstall:
	rm $(vimrcDir)/$(vimrcTargetFile)
	rm $(nvimrcDir)/$(nvimrcTargetFile)
