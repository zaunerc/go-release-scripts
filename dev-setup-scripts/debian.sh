#!/bin/sh

set -e

sudo aptitude update

# The Vim neocomplete plugin requires Lua support.
# The vim-nox package provides Vim with Lua support
# compiled in.
#
sudo aptitude install git golang-any exuberant-ctags glide curl jq vim-nox

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
$SCRIPT_DIR/common.sh

