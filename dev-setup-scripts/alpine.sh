#!/bin/sh

set -e

echo '@edge-community http://nl.alpinelinux.org/alpine/edge/community' | sudo tee -a /etc/apk/repositories > /dev/null
sudo apk add --update --no-cache git go ctags glide@edge-community curl jq

export GOPATH=~/gowork
export PATH=$PATH:~/gowork/bin

# Go debugger
go get github.com/derekparker/delve/cmd/dlv

# Need to add .vimrc before trying to install plugins.
if [ ! -d ~/configs ]; then
        git clone https://github.com/zaunerc/configs.git ~/configs
        bash ~/configs/install.sh
fi

if grep -q "GOPATH" ~/.bashrc
then
        echo "Found string \"GOPATH\" in user\'s bashrc file. Skipping Go configuration."
else
        echo "Adding GOPATH to user\'s bashrc file."
        echo "export GOPATH=~/gowork" >> ~/.bashrc
        echo "Adding Go binaries to PATH environmental variable using user\'s bashrc file."
        echo "export PATH=$PATH:~/gowork/bin" >> ~/.bashrc
fi


git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim +PluginInstall +GoInstallBinaries +qall

source ~/.bashrc

cat << EOF

Do not forget to set your git name and email. E.g.:
---------------------------------------------------

git config --global user.email "christoph.zauner@NLLK.net"
git config --global user.name "Christoph Zauner"


You will have to run the following command before
being able to use the new e.g. env vars in the
current shell:
-------------------------------------------------

source ~/.bashrc

Projects you might want to get:
-------------------------------------------------

$ go get github.com/zaunerc/cntrbrowserd

# Go 1.6 does not work with docker libs > 1.12.
# Therefore run go get, glide up and finally 
# go get one more. Go 1.7 has problems if
# glibc is present under Alpine.
#
$ go get github.com/zaunerc/cntrinfod

EOF

