#!/bin/sh

set -e

sudo aptitude update
sudo aptitude install git golang-any exuberant-ctags glide curl jq

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
$SCRIPT_DIR/common.sh

