#!/bin/sh

set -e

echo '@edge-community http://nl.alpinelinux.org/alpine/edge/community' | sudo tee -a /etc/apk/repositories > /dev/null
sudo apk add --update --no-cache git go ctags glide@edge-community curl jq

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
$SCRIPT_DIR/common.sh

