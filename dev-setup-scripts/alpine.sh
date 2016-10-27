#!/bin/sh

set -e

echo '@edge-community http://nl.alpinelinux.org/alpine/edge/community' | sudo tee -a /etc/apk/repositories > /dev/null

# Required by GoRename
sudo apk add --update --no-cache \
	gcc \
	musl-dev 

# Required by https://github.com/zaunerc/go-scripts/tree/master/release-scripts 
sudo apk add --no-cache \
	curl \
	jq 

# Misc
sudo apk add --no-cache \
	ctags \
	git \
	glide@edge-community \
	go@edge-community 

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
$SCRIPT_DIR/common.sh

