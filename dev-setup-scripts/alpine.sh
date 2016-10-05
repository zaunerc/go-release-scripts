#!/bin/sh

set -e

echo '@edge-community http://nl.alpinelinux.org/alpine/edge/community' | sudo tee -a /etc/apk/repositories > /dev/null
sudo apk add --update --no-cache \
	# Required by GoRename
	gcc \
	musl-dev \
	# Required by https://github.com/zaunerc/go-scripts/tree/master/release-scripts 
	curl \
	jq \
	# Misc
	ctags \
	git \
	glide@edge-community \
	go 

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
$SCRIPT_DIR/common.sh

