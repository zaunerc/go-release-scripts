#!/bin/sh

set -e

export GOPATH=$HOME/gowork
export PATH=$PATH:~/gowork/bin

# Go debugger
go get github.com/derekparker/delve/cmd/dlv

# Need to add .vimrc before trying to install plugins.
if [ ! -f ~/.vimrc ]; then
	mkdir -p ~/repos/configs
        git clone https://github.com/zaunerc/configs.git ~/repos/configs
        bash ~/repos/configs/install.sh
fi

if grep -q "GOPATH" ~/.bashrc
then
        echo "Found string \"GOPATH\" in user\'s bashrc file. Skipping Go configuration."
else
        echo "Adding GOPATH to user\'s bashrc file."
        echo "export GOPATH=$HOME/gowork" >> ~/.bashrc
        echo "Adding Go binaries to PATH environmental variable using user\'s bashrc file."
        echo "export PATH=$PATH:~/gowork/bin" >> ~/.bashrc
fi

if [ ! -d ~/.vim/bundle/Vundle.vim ]; then
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi

vim +PluginInstall +GoInstallBinaries +qall

cat << EOF

Do not forget to set your git name and email. E.g.:
---------------------------------------------------

git config --global user.email "christoph.zauner@NLLK.net"
git config --global user.name "Christoph Zauner"


You will have to run the following command before
being able to use e.g. the new env vars in the
current shell:
-------------------------------------------------

source ~/.bashrc

Projects you might want to get:
-------------------------------------------------

$ go get github.com/zaunerc/cntrbrowserd

# Go 1.6 does not work with docker libs > 1.12.
# Therefore run go get, glide up and finally 
# go get one more time. Go 1.7 has problems if
# glibc is present under Alpine.
#
$ go get github.com/zaunerc/cntrinfod

EOF

